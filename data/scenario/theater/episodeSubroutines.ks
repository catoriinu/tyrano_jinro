; 次に解放できるエピソードを解放するサブルーチン
*unlockNextEpisode
[iscript]
  if (f.pageId === 'p01') {
    if (f.episodeId === 'e01') {
      if (f.chapterId === 'c02') {
        // 「誰がずんだもちを食べたのだ？（解決編）」視聴後にe02-e07を「1：導入編未解放かつ解放可」にする
        if (getTheaterProgress('p01', 'e01') === EPISODE_STATUS.OUTRO_UNLOCKED) {
          const episodeList = ['e02', 'e03', 'e04', 'e05', 'e06', 'e07'];
          for (const episodeId of episodeList) {
            sf.theaterProgress['p01'][episodeId] = advanceEpisodeStatus('p01', episodeId, EPISODE_STATUS.INTRO_LOCKED_AVAILABLE);
          }
        }
      }
    } else if (['e02', 'e03', 'e04', 'e05', 'e06', 'e07'].includes(f.episodeId)) {
      if (f.chapterId === 'c02') {
        // e02-e07の解決編の視聴後に、e02-e07がすべて「3：解決編まで解放済み」なら、e08を「1：導入編未解放かつ解放可」にする
        if (everyProgressMatch(EPISODE_STATUS.OUTRO_UNLOCKED,
          ['p01'],
          ['e02', 'e03', 'e04', 'e05', 'e06', 'e07'],
        )) {
          sf.theaterProgress['p01']['e08'] = advanceEpisodeStatus('p01', 'e08', EPISODE_STATUS.INTRO_LOCKED_AVAILABLE);
        }
      }
    }
  }
[endscript]

[return]
[s]


; シチュエーション完遂チェックサブルーチン
; このマクロ内で更新するゲーム変数
; 関連マクロ：[t_setStartingSituation]
*checkOutroUnlockCondition
[iscript]
  console.log('★checkOutroUnlockCondition start');

  // ゲーム開始時に、シチュエーション開始条件に合致したエピソードがあったか
  const pageId = f.startingSituation.pageId;
  const episodeId = f.startingSituation.episodeId;
  if (pageId && episodeId) {

    const episode = episodeData(pageId, episodeId);
    console.log('★episode');
    console.log(episode);

    // そのエピソードに解決編の解放条件が設定されているか
    if (episode.outroUnlockCondition !== null) {

      // 実際のゲーム終了時の状況をもとに、ResultConditionオブジェクトを生成、格納する
      const resultCondition = new ResultCondition(
        isResultPlayersWin(f.winnerFaction, f.characterObjects[f.playerCharacterId].role.faction),
        f.winnerFaction,
        convertCharacterObjectsToCharacterConditions(f.characterObjects),
      );
      console.log('★resultCondition');
      console.log(resultCondition);

      // シチュエーション完遂チェックで完遂したか
      if (isOutroUnlockConditionMet(episode.outroUnlockCondition, resultCondition)) {
        console.log('★check OK checkOutroUnlockCondition');

        // 完遂したら、基本的には解放編を自動再生する
        // 例外として、視聴済みエピソードをスキップする設定、かつエピソード進捗ステータスが既に「3：解決編まで解放済み」の場合は再生しない
        if (!(sf.doSkipWatchedEpisode && getTheaterProgress(pageId, episodeId) === EPISODE_STATUS.OUTRO_UNLOCKED)) {
          f.chapterList.outroChapter.needPlay = true;
        }
      }
    }
  }
[endscript]
[return]
[s]
