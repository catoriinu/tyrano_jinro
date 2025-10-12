/**
 * @classdesc 人狼プラグインにおける「性格」定義の基底クラス。
 * 各キャラクターの意思決定に影響する係数やしきい値（影響力・抵抗力・主張性・感情境界、
 * 役職COの確率など）を保持します。派生の性格実装は本クラスに値を渡して初期化します。
 * @param {String} name 性格名。
 * @param {Number} logical 論理性パラメータ値。
 * @param {Number} influenceMultiplier 影響力の基本係数。
 * @param {Object} adjustmentInfluenceMultiplier 影響力係数の調整マップ。
 * @param {Number} registanceMultiplier 抵抗力の基本係数。
 * @param {Object} adjustmentRegistanceMultiplier 抵抗力係数の調整マップ。
 * @param {Object} assertiveness 主張性の設定。{original, current, decrease} を持つオブジェクト。
 * @param {Number} limitFrustration フラストレーションのしきい値。
 * @param {Object} roleCOProbability 役職CO（カミングアウト）の確率マップ。
 * @param {Object} feelingBorder 感情の境界値定義。
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};

  function Personality(
    name,
    logical,
    influenceMultiplier,
    adjustmentInfluenceMultiplier,
    registanceMultiplier,
    adjustmentRegistanceMultiplier,
    assertiveness,
    limitFrustration,
    roleCOProbability,
    feelingBorder
  ) {
    this.name = name;
    this.influenceMultiplier = influenceMultiplier;
    this.adjustmentInfluenceMultiplier = adjustmentInfluenceMultiplier;
    this.registanceMultiplier = registanceMultiplier;
    this.adjustmentRegistanceMultiplier = adjustmentRegistanceMultiplier;
    this.logical = logical;
    this.assertiveness = assertiveness;
    this.limitFrustration = limitFrustration;
    this.roleCOProbability = roleCOProbability;
    this.feelingBorder = feelingBorder;
  }

  namespace.Personality = Personality;
})(typeof window !== "undefined" ? window : this);
