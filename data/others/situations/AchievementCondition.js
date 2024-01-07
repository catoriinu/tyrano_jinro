/**
 * 解放条件オブジェクト
 * @param {Boolean|null} isPlayerWin
 * @param {String|null} winnerFaction 
 * @param {Object|null} characterConditions {characterId: {roleIds: [役職ID配列], isAlive: true(生存)/false(脱落)}, ...}
 */
function AchievementCondition(
    isPlayerWin,
    winnerFaction,
    characterConditions,
) {
    this.isPlayerWin = isPlayerWin;
    this.winnerFaction = winnerFaction;
    this.characterConditions = characterConditions;
}
