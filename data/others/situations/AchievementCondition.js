/**
 * 解放条件オブジェクト
 * @param {Boolean|null} isPlayerWin
 * @param {String|null} winnerFaction 
 * @param {Object|null} characterConditions {characterId: CharacterConditionオブジェクト, ...}形式のオブジェクト
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


/**
 * キャラクターオブジェクト配列から、AchievementConditionのcharacterConditionsに格納するためのオブジェクトに変換する
 * @param {Array} characterObjects キャラクターオブジェクト配列
 * @returns {characterId: CharacterConditionオブジェクト, ...}形式のオブジェクト
 */
function convertCharacterObjectsToCharacterConditions(characterObjects) {
    const characterConditions = {};
    for (let characterId of Object.keys(characterObjects)) {
        characterConditions[characterId] = createCharacterConditionFromCharacterObject(characterObjects[characterId]);
    }
    return characterConditions;
}
