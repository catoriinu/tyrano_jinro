; 実際のゲーム終了時の状況をもとに、AchievementConditionオブジェクトを生成、格納する
[macro name="a_convertResultToAchievementCondition"]
  [iscript]
    f.resultCondition = new AchievementCondition(
      isResultPlayersWin(f.winnerFaction, f.characterObjects[f.playerCharacterId].role.faction),
      f.winnerFaction,
      convertCharacterObjectsToCharacterConditions(f.characterObjects),
    );
  [endscript]
[endmacro]
