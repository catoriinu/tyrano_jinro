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


[macro name="a_displayAchievedSituations"]
  [iscript]
    console.log('★★★f.achievedSituations');
    console.log(f.achievedSituations);
    for (let i = 0; i < f.achievedSituations.length; i++) {
      const situation = f.achievedSituations[i];
      console.log(situation);
      alert('『' + situation.title + '』の解決編が解放されました！');
    }
  [endscript]
[endmacro]
