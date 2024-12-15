/**
 * 終了状況オブジェクト
 * 人狼ゲーム終了時の状況を抽象化する
 * シチュエーション完遂チェック用に生成する際は、完遂チェックが不要な条件はnullを格納すること
 * @param {Boolean|null} isPlayerWin プレイヤー陣営が勝利したか
 * @param {String|null} winnerFaction 勝利した陣営の陣営ID
 * @param {Object|null} characterConditions {characterId: CharacterConditionオブジェクト, ...}形式のオブジェクト
 */
function ResultCondition(
    isPlayerWin = null,
    winnerFaction = null,
    characterConditions = null,
) {
    this.isPlayerWin = isPlayerWin;
    this.winnerFaction = winnerFaction;
    this.characterConditions = characterConditions;
}


/**
 * キャラクターオブジェクト配列から、ResultConditionのcharacterConditionsに格納するためのオブジェクトに変換する
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


/**
 * 今回のゲームの終了状況が、シチュエーション完遂チェック用の終了状況を達成したかを判定する
 * @param {ResultCondition} outroUnlockCondition シチュエーション完遂チェック用の終了状況オブジェクト
 * @param {ResultCondition} resultCondition 実際の人狼ゲームの終了状況オブジェクト
 * @returns true:条件達成 / false:条件不達成
 */
function isOutroUnlockConditionMet(outroUnlockCondition, resultCondition) {
    // isPlayerWin条件のチェック
    if (outroUnlockCondition.isPlayerWin !== null) {
        if (outroUnlockCondition.isPlayerWin !== resultCondition.isPlayerWin) {
            console.log('★false isPlayerWin');
            return false;
        }
    }

    // winnerFaction条件のチェック
    if (outroUnlockCondition.winnerFaction !== null) {
        if (outroUnlockCondition.winnerFaction !== resultCondition.winnerFaction) {
            console.log('★false winnerFaction');
            return false;
        }
    }

    // characterConditions条件のチェック
    if (outroUnlockCondition.characterConditions !== null) {
        for (let characterId of Object.keys(outroUnlockCondition.characterConditions)) {
            // チェック対象のキャラクターがゲームに参加していなければ未達成とする
            if (!(characterId in resultCondition.characterConditions)) {
                return false;
            }

            if (!isCharacterConditionMet(
                outroUnlockCondition.characterConditions[characterId],
                resultCondition.characterConditions[characterId]
            )) {
                console.log('★false isCharacterConditionMet:' + characterId);
                return false;
            }
        }
    }

    // 全てのチェックをパスしたら条件達成
    return true;
}
