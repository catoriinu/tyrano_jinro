/**
 * キャラクターの条件オブジェクト
 * 解放条件オブジェクトに格納するためのオブジェクト。「この条件を満たしている場合に解放条件を満たす」や、「ゲーム終了時の実際のキャラクターの条件」を表すために用いる。
 * 達成チェックが不要な条件はnullを格納すること
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


/**
 * 今回のゲームにおいて、このキャラクターの条件を達成したかを判定する
 * メソッド内でキャラクターID配列は判定しないので、同じキャラクターのオブジェクトであることは、メソッドの利用元で担保しておくこと
 * @param {CharacterCondition} characterCondition 達成チェック対象のキャラクターの条件オブジェクト
 * @param {CharacterCondition} resultCharacterCondition 実際のゲーム終了時のキャラクターの条件オブジェクト
 * @returns true:条件達成 / false:条件不達成
 */
function isAchievedCharacterCondition(characterCondition, resultCharacterCondition) {
    // roleIds条件のチェック
    if (characterCondition.roleIds !== null) {
        // characterCondition.roleIdsには複数のroleIdが格納されていることがありうるが、
        // resultCharacterCondition.roleIdsの要素数は1つしかありえないので、[0]で決め打てる。
        if (!characterCondition.roleIds.includes(resultCharacterCondition.roleIds[0])) {
            return false;
        }
    }

    // isAlive条件のチェック
    if (characterCondition.isAlive !== null) {
        if (characterCondition.isAlive !== resultCharacterCondition.isAlive) {
            return false;
        }
    }

    // 全てのチェックをパスしたら条件達成
    return true;
}
