/**
 * キャラクターの状況オブジェクト
 * 終了状況オブジェクトに格納するためのオブジェクト。「この条件を満たしている場合に解放条件を満たす」や、「ゲーム終了時の実際のキャラクターの条件」を表すために用いる。
 * 完遂チェックが不要な条件はnullを格納すること
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
 * 今回のゲームの終了状況においてのこのキャラクターの終了状況が、完遂チェックを達成したかを判定する
 * メソッド内でキャラクターID配列は判定しないので、同じキャラクターのオブジェクトであることは、メソッドの利用元で担保しておくこと
 * @param {CharacterCondition} outroUnlockCharacterCondition シチュエーション完遂チェック用のキャラクターの条件オブジェクト
 * @param {CharacterCondition} resultCharacterCondition 実際の人狼ゲームの終了状況のキャラクターの条件オブジェクト
 * @returns true:条件達成 / false:条件不達成
 */
function isCharacterConditionMet(outroUnlockCharacterCondition, resultCharacterCondition) {
    // roleIds条件のチェック
    if (outroUnlockCharacterCondition.roleIds !== null) {
        // outroUnlockCharacterCondition.roleIdsには複数のroleIdが格納されていることがありうるが、
        // resultCharacterCondition.roleIdsの要素数は1つしかありえないので、[0]で決め打てる。
        if (!outroUnlockCharacterCondition.roleIds.includes(resultCharacterCondition.roleIds[0])) {
            return false;
        }
    }

    // isAlive条件のチェック
    if (outroUnlockCharacterCondition.isAlive !== null) {
        if (outroUnlockCharacterCondition.isAlive !== resultCharacterCondition.isAlive) {
            return false;
        }
    }

    // 全てのチェックをパスしたら条件達成
    return true;
}
