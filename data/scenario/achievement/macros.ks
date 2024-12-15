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


; @param String|null pageId シチュエーション開始条件に合致したエピソードのページID。合致したエピソードがなければnull
; @param String|null episodeId シチュエーション開始条件に合致したエピソードのエピソードID。合致したエピソードがなければnull
; 関連マクロ：[t_setStartingEpisodeSituation]
; TODO：「シチュエーション完遂チェック」に名前変えたい
[macro name="a_checkAchievedConditions"]
  [iscript]
    f.isAchievedConditions = false;

    // シチュエーション開始条件に合致したエピソードがある場合のみ
    if (mp.pageId && mp.episodeId) {
      const episode = episodeData(mp.pageId, mp.episodeId);
      console.log('★episode');
      console.log(episode);

      // シチュエーション完遂チェックで完遂した場合のみ
      if (
        episode.achievementCondition !== null && // 達成条件が設定されていなければチェック不要
        isAchievedCondition(episode.achievementCondition, f.resultCondition) // 完遂チェックを満たすか
      ) {
        console.log('★check ok isAchievedCondition');

        // 現在のエピソード進捗ステータスが「2：導入編解放済みで解決編未解放」ならtrueにする
        // （実際にステータスを書き換えるのはシアターの視聴終了後）
        // TODO：「視聴済みの導入編は自動再生しない」が自動再生する設定なら、ステータスにかかわらずtrueにする
        if (sf.theaterProgress[mp.pageId][mp.episodeId] === EPISODE_STATUS.INTRO_UNLOCKED_OUTRO_LOCKED) {
          f.isAchievedConditions = true;
        }
      }
    }
  [endscript]
[endmacro]


; TODO：「解決編を自動再生する」マクロに変える
; 達成したエピソードを画面上に表示する
[macro name="a_displayAchievedEpisodes"]

  ; 達成したエピソードがない場合、なにもせず終了する
  [jump target="*end_a_displayAchievedEpisodes" cond="f.achievedEpisodes.length < 1"]

  ; 表示開始前の準備
  [j_saveFixButton buf="achieved"]
  [j_clearFixButton]
  [layopt layer="message0" visible="false"]
  [eval exp="f.currentFrame = null"]
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
