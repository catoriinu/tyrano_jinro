/**
 * 解放条件オブジェクト
 * 達成チェックが不要な条件はnullを格納すること
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


/**
 * 今回のゲームにおいて、解放条件オブジェクトの条件を達成したかを判定する
 * @param {AchievementCondition} achievementCondition 達成チェック対象の解放条件オブジェクト
 * @param {AchievementCondition} resultCondition 実際のゲーム終了時の状況をもとに生成した解放条件オブジェクト
 * @returns true:条件達成 / false:条件不達成
 */
function isAchievedCondition(achievementCondition, resultCondition) {
    // isPlayerWin条件のチェック
    if (achievementCondition.isPlayerWin !== null) {
        if (achievementCondition.isPlayerWin !== resultCondition.isPlayerWin) {
            console.log('★false isPlayerWin');
            return false;
        }
    }

    // winnerFaction条件のチェック
    if (achievementCondition.winnerFaction !== null) {
        if (achievementCondition.winnerFaction !== resultCondition.winnerFaction) {
            console.log('★false winnerFaction');
            return false;
        }
    }

    // characterConditions条件のチェック
    if (achievementCondition.characterConditions !== null) {
        for (let characterId of Object.keys(achievementCondition.characterConditions)) {
            // チェック対象のキャラクターがゲームに参加していなければ未達成とする
            if (!(characterId in resultCondition.characterConditions)) {
                return false;
            }

            if (!isAchievedCharacterCondition(
                achievementCondition.characterConditions[characterId],
                resultCondition.characterConditions[characterId]
            )) {
                console.log('★false isAchievedCharacterCondition:' + characterId);
                return false;
            }
        }
    }

    // 全てのチェックをパスしたら条件達成
    return true;
}
