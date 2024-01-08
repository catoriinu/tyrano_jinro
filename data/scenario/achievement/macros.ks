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
    f.achievedSituations = [];

    for (let pageKey of Object.keys(sf.theater)) {
      for (let situationKey of Object.keys(sf.theater[pageKey])) {
        const situation = sf.theater[pageKey][situationKey];

        console.log('★★★situation');
        console.log(situation);

        // 達成チェック不要ならcontinue
        if (!needCheckAchievementCondition(situation)) {
          console.log('★false needCheckAchievementCondition');
          continue;
        }
        // 達成チェックを行う。未達成ならcontinue
        if (!isAchievedCondition(situation.achievementCondition, f.resultCondition)) {
          console.log('★false isAchievedCondition');
          continue;
        }
        
        // 条件を達成した場合
        // システム変数のシチュエーションのoutroProgressをUNLOCKEDに更新する
        sf.theater[pageKey][situationKey] = updateOutroProgress(situation, THEATER_UNLOCKED);
        // 達成済みシチュエーション配列に追加する
        f.achievedSituations.push(situation);
      }
    }
  [endscript]
[endmacro]


; 達成済みシチュエーションを画面上に表示する
[macro name="a_displayAchievedSituations"]

  ; 達成済みシチュエーションがない場合、なにもせず終了する
  [if exp="f.achievedSituations.length < 1"]
    [jump target="*end_a_displayAchievedSituations"]
  [endif]

  ; 表示開始前の準備
  [layopt layer="message0" visible="false"]
  [filter layer="0" blur="10"]
  [filter layer="base" blur="5"]

  [eval exp="tf.cnt = 0"]
  *loopstart
    ; 表示する
    [eval exp="f.detailSituation = f.achievedSituations[tf.cnt]"]
    [call storage="achievement/achieveSituation.ks"]

    ; 達成済みシチュエーションがまだある場合のみループ継続
    [eval exp="tf.cnt++"]
    [jump target="*loopstart" cond="tf.cnt < f.achievedSituations.length"]
    [jump target="*loopend"]
  *loopend

  ; 表示終了後の後片付け
  [free_filter layer="0"]
  [free_filter layer="base"]
  [layopt layer="message0" visible="true"]

  *end_a_displayAchievedSituations
[endmacro]
