/**
 * 信頼度計算ユーティリティモデル
 * 信頼度の計算を始める際にインスタンス生成すること
 * @param {Object} character 信頼度を更新したいキャラクターオブジェクト
 * @param {Object} action アクションオブジェクト
 * @param {Number} influenceMultiplier アクションの実行者の影響力倍率
 */
function calcReliabilityUtility(character, action, influenceMultiplier) {
    this.character = character;
    this.action = action;
    this.influenceMultiplier = influenceMultiplier;
    this.sameFactionPossivility = {}; // インスタンス生成処理の最後でthis.setLatestSameFactionPossivilityを呼ぶ

    this.updateReliability = function (influenceBaseValue, updateTargetId) {
        console.debug(this);

        // 更新後の信頼度の差分を計算する
        const differenceReliability = calcDifferenceReliability(
            influenceBaseValue,
            this.sameFactionPossivility[updateTargetId],
            this.character,
            this.action,
            this.influenceMultiplier
        );
        let tmpUpdatedReliability = this.character.reliability[updateTargetId] + differenceReliability;

        // 更新後の値が1より大きくなる場合は1に、0より小さくなる場合は0にする。信頼度が取りうる値は0～1のため
        if (tmpUpdatedReliability > 1) {
            tmpUpdatedReliability = 1;
        } else if (tmpUpdatedReliability < 0) {
            tmpUpdatedReliability = 0;
        }

        // 自身の相手への信頼度を更新（これでf.characterObjects内の信頼度も更新できている）
        this.character.reliability[updateTargetId] = tmpUpdatedReliability;

        // 仲間度も改めて更新する
        this.setLatestSameFactionPossivility([updateTargetId]);
    }

    this.setLatestSameFactionPossivility = function(characterIdList) {
        const latestSameFactionPossivility = calcSameFactionPossivility(
            this.character,
            this.character.perspective,
            characterIdList
        );
        this.sameFactionPossivility = Object.assign(this.sameFactionPossivility, latestSameFactionPossivility);
    }
    // 初回は即実行
    this.setLatestSameFactionPossivility([action.characterId, action.targetId]);
}


/**
 * そのアクションで増減する信頼度の差分を計算する
 * @param {Number} influenceBaseValue そのアクションの基本影響力（信頼度を減少させたいときは負の値を渡すこと）
 * @param {Number} sameFactionPossivility 自身の「誰への」信頼度を更新するか、の「誰」への仲間度（オブジェクトではなく値自体）
 * @param {Object} character 信頼度を更新したいキャラクターオブジェクト（以下「自身」）
 * @param {Object} action 実行されたアクションオブジェクト
 * @param {Number} influenceMultiplier アクションの実行者の影響力倍率
 * @returns 算出された信頼度の差分（呼び出し元で、自身の相手への現在の信頼度に加算すること）
 */
function calcDifferenceReliability(influenceBaseValue, sameFactionPossivility, character, action, influenceMultiplier) {
    console.debug('influenceBaseValue:' + influenceBaseValue + ' sameFactionPossivility:' + sameFactionPossivility);

    // 自身の抵抗力
    const resistanceMultiplier = calcResistanceMultiplier(character, action);

    // 自身から相手への仲間度倍率
    const sameFactionMultiplier = calcSameFactionMultiplier(sameFactionPossivility);

    // 信頼度の差分を計算する
    const differenceReliability = influenceBaseValue * (1 + influenceMultiplier - resistanceMultiplier) * sameFactionMultiplier;

    console.debug('calcDifferenceReliability:' + differenceReliability);
    return differenceReliability;
}


/**
 * アクションの実行者の影響力倍率を計算する
 * @param {Object} characterObject 実行者のキャラクターオブジェクト
 * @param {Object} actionObject アクションオブジェクト
 * @returns 実行者の影響力倍率
 */
function calcInfluenceMultiplier(characterObject, actionObject) {
    const actionId = actionObject.actionId;
    const influenceMultiplier = characterObject.personality.influenceMultiplier;
    const actionAdjustmentInfluenceMultiplier = (actionId in characterObject.personality.adjustmentInfluenceMultiplier.action) ? characterObject.personality.adjustmentInfluenceMultiplier.action[actionId] : 1;

    const resultInfluence = influenceMultiplier * actionAdjustmentInfluenceMultiplier;

    console.debug('influenceM:' +  influenceMultiplier + ' actionARM:' + actionAdjustmentInfluenceMultiplier);
    console.debug('resultInfluence:' + resultInfluence);
    return resultInfluence;
}


/**
 * そのキャラクターの以下の要素を元に、抵抗力倍率を計算する
 * ・自身の抵抗力
 * ・実行者への「自身の感情力に基づく信頼度」
 * 　・実行者への信頼度をどれだけ重視するかを感情力（論理力の逆）から算出した値のこと
 * ・そのアクションへの抵抗力調整倍率
 * ・その実行者への抵抗力調整倍率
 * @param {Object} characterObject 抵抗力倍率を計算するキャラクターオブジェクト
 * @param {Object} actionObject アクションオブジェクト
 * @returns 抵抗力倍率
 */
function calcResistanceMultiplier(characterObject, actionObject) {
    const actionId = actionObject.actionId;
    const actorId = actionObject.characterId;
    const registanceMultiplier = characterObject.personality.registanceMultiplier;

    // 自身の実行者への信頼度
    const reliability = characterObject.reliability[actorId];
    // 感情力。すなわち自身の論理力を1から引いた値
    const emotional = 1 - characterObject.personality.logical;

    // 自身の感情力に基づく信頼度（感情力が0のとき結果は0となり、感情力が1のとき結果は信頼度になる）
    const reliabilityBasedOnEmotional = emotional * reliability;
    console.debug(
        'reliability:' + reliability +
        ' emotional:' + emotional +
        ' reliabilityBasedOnEmotional:' + reliabilityBasedOnEmotional
    );

    // 実行者への「自身の感情力に基づく信頼度」が高いほど、抵抗力が低くなるようにする、負の一次関数
    const max = 1.2;
    const min = 0.8;
    const reliabilityAdjustmentRegistanceMultiplier = (min - max) * reliabilityBasedOnEmotional + max;

    const actionAdjustmentRegistanceMultiplier = (actionId in characterObject.personality.adjustmentRegistanceMultiplier.action)
        ? characterObject.personality.adjustmentRegistanceMultiplier.action[actionId]
        : 1;
    const actorAdjustmentRegistanceMultiplier = (actorId in characterObject.personality.adjustmentRegistanceMultiplier.actor)
        ? characterObject.personality.adjustmentRegistanceMultiplier.actor[actorId]
        : 1;

    // 全てを掛け合わせて抵抗力倍率を計算する
    const resultResistiance = registanceMultiplier * reliabilityAdjustmentRegistanceMultiplier * actionAdjustmentRegistanceMultiplier * actorAdjustmentRegistanceMultiplier;
    console.debug(
        'registanceM:' + registanceMultiplier +
        ' reliabilityARM:' + reliabilityAdjustmentRegistanceMultiplier +
        ' actionARM:' + actionAdjustmentRegistanceMultiplier +
        ' actorARM:' + actorAdjustmentRegistanceMultiplier
    );
    console.debug('resultResistiance:' + resultResistiance);
    return resultResistiance;
}


/**
 * 仲間度倍率を計算する
 * 仲間度倍率とは、相手への現在の仲間度が0または1に近いほど変動しにくくするよう調整するための倍率のこと
 * @param {Number} sameFactionPossivility 自身の相手への現在の仲間度（オブジェクトではなく値自体）
 * @returns 仲間度倍率
 */
function calcSameFactionMultiplier(sameFactionPossivility) {

    const max = 1; // 仲間度倍率の最大値
    const min = 0.2; // 仲間度倍率の最小値
    const vertex = 0.5; // 仲間度(0~1)の中央値。仲間度がこの値のときに仲間度倍率が最大値をとる。すなわちグラフの頂点。

    // 仲間度倍率の計算。vertexが0.5なので、仲間度が0または1のときに仲間度倍率は最小値をとる
    const resultSameFactionMultiplier = 4 * (min - max) * ((sameFactionPossivility - vertex) ** 2) + max;

    console.debug('sameFactionPossivility:' + sameFactionPossivility);
    console.debug('resultSameFactionMultiplier:' + resultSameFactionMultiplier);
    return resultSameFactionMultiplier;
}
