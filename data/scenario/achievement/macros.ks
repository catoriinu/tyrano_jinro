; 実際のゲーム終了時の状況をもとに、AchievementConditionオブジェクトを生成、格納する
[macro name="a_convertResultToAchievementCondition"]
  [iscript]
    f.resultCondition = new AchievementCondition(
      isResultPlayersWin(f.winnerFaction, f.characterObjects[f.playerCharacterId].role.faction),
      f.winnerFaction,
      convertCharacterObjectsToCharacterConditions(f.characterObjects),
    );
    console.log('★★★f.resultCondition');
    console.log(f.resultCondition);
  [endscript]
[endmacro]


[macro name="a_checkAchievedConditions"]
  [iscript]
    f.achievedEpisodes = [];

    for (let pageId of Object.keys(sf.theaterProgress)) {
      for (let episodeId of Object.keys(sf.theaterProgress[pageId])) {
        const introProgress = getTheaterProgress(pageId, episodeId, 'c01');
        const outroProgress = getTheaterProgress(pageId, episodeId, 'c02');

        // 達成チェックすべき条件（導入編が解放済み、かつ解決編がロック中である）を満たしていないならcontinue
        if (!(introProgress !== THEATER_LOCKED && outroProgress === THEATER_LOCKED)) {
          console.log('★false 達成チェックすべき条件（導入編が解放済み、かつ解決編がロック中である）を満たしていない');
          continue;
        }

        const episode = episodeData(pageId, episodeId);
        console.log('★★★episode');
        console.log(episode);

        // 解決編の解放条件の達成チェックを行う。未達成ならcontinue
        if (!isAchievedCondition(episode.outroChapter.achievementCondition, f.resultCondition)) {
          console.log('★false isAchievedCondition');
          continue;
        }
        
        // 解放条件を達成した場合
        // 解決編のシアター進捗を「解放済みだが未視聴」に更新する
        sf.theaterProgress[pageId][episodeId].c02 = THEATER_UNLOCKED;
        // 達成済みエピソード配列に追加する
        f.achievedEpisodes.push(episode);
      }
    }
  [endscript]
[endmacro]


; 達成したエピソードを画面上に表示する
[macro name="a_displayAchievedEpisodes"]

  ; 達成したエピソードがない場合、なにもせず終了する
  [jump target="*end_a_displayAchievedEpisodes" cond="f.achievedEpisodes.length < 1"]

  ; 表示開始前の準備
  [j_saveFixButton buf="achieved"]
  [j_clearFixButton]
  [layopt layer="message0" visible="false"]
  [filter layer="0" blur="10"]
  [filter layer="base" blur="5"]

  [eval exp="tf.cnt = 0"]
  *loopstart
    ; 表示する
    [eval exp="f.displayEpisode = f.achievedEpisodes[tf.cnt]"]
    [call storage="achievement/achieveSituation.ks"]

    ; 達成したエピソードがまだある場合のみループ継続
    [eval exp="tf.cnt++"]
    [jump target="*loopstart" cond="tf.cnt < f.achievedEpisodes.length"]
    [jump target="*loopend"]
  *loopend

  ; 表示終了後の後片付け
  [free_filter layer="0"]
  [free_filter layer="base"]
  [layopt layer="message0" visible="true"]
  [j_loadFixButton buf="achieved"]

  *end_a_displayAchievedEpisodes
[endmacro]
