/**
 * キャラクターの条件オブジェクト
 * 解放条件オブジェクトに格納するためのオブジェクト。「この条件を満たしている場合に解放条件を満たす」や、「ゲーム終了時の実際のキャラクターの条件」を表すために用いる。
 * @param {Array|null} roleIds 役職ID配列
 * @param {Boolean|null} isAlive true:生存 / false:脱落
 */
function CharacterCondition(
    roleIds,
    isAlive,
) {
    this.roleIds = roleIds;
    this.isAlive = isAlive;
}


/**
 * キャラクターオブジェクトをもとに、CharacterConditionオブジェクトを生成する
 * @param {Object} characterObject キャラクターオブジェクト
 * @returns CharacterConditionオブジェクト
 */
function createCharacterConditionFromCharacterObject(characterObject) {
    return new CharacterCondition(
        [characterObject.role.roleId],
        characterObject.isAlive,
    );
}
