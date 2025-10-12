/**
 * @classdesc 人狼プラグインにおける「性格」定義の基底クラス。
 * すべての個別性格クラスはこのクラスを継承し、super() 経由で共通プロパティを初期化する。
 * MEMO: init.ks では personalityBase.js → 各 personality 定義 → factory.js の順で loadjs すること。
 * class 構文を使用しているため、ES2015 以降に対応した TyranoPlayer/Chromium を前提とする。
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};
  const registry = namespace.registry || (namespace.registry = {});

  class Personality {
    /**
     * @param {string} name 性格の表示名。デバッグログやUI表示に利用される。
     * @param {number} logical 視点（論理）と信頼度（感情）の混合比。0〜1の範囲で高いほど論理寄り。
     * @param {number} influenceMultiplier 信頼度を他者へ伝播させる際の基本倍率。基準値は1。
     * @param {Object} adjustmentInfluenceMultiplier 行動別などで影響力倍率を調整するマップ。通常は {action, actor} を持つ。
     * @param {number} registanceMultiplier 他者から信頼度を受け取る際の抵抗力倍率。基準値は1。
     * @param {Object} adjustmentRegistanceMultiplier 抵抗力の調整マップ。action/actor ごとの係数を定義する。
     * @param {{original:number,current:number,decrease:number}} assertiveness 主張力の状態管理オブジェクト。
     * @param {number} limitFrustration フラストレーション閾値。発言過多などで限界に達するライン。
     * @param {Object<string, Object<string, number>>} roleCOProbability 役職ごとのCO確率マップ。
     * @param {{hate:number,love:number}} feelingBorder 感情境界値。hate/love の判定しきい値を定義する。
     */
    constructor(
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
      this.logical = logical;
      this.influenceMultiplier = influenceMultiplier;
      this.adjustmentInfluenceMultiplier = adjustmentInfluenceMultiplier;
      this.registanceMultiplier = registanceMultiplier;
      this.adjustmentRegistanceMultiplier = adjustmentRegistanceMultiplier;
      this.assertiveness = assertiveness;
      this.limitFrustration = limitFrustration;
      this.roleCOProbability = roleCOProbability;
      this.feelingBorder = feelingBorder;
    }
  }

  /**
   * 性格クラスをレジストリへ登録する。
   * @param {String} name シナリオ定義で参照される性格名。
   * @param {Function} constructorFunction Personality を継承したコンストラクタ。
   */
  function registerPersonality(name, constructorFunction) {
    if (typeof name !== 'string' || name.length === 0) {
      console.error('[jinroPersonalities] registerPersonality requires non-empty string name.');
      return;
    }
    if (typeof constructorFunction !== 'function') {
      console.error('[jinroPersonalities] registerPersonality requires constructor function.');
      return;
    }
    if (registry[name]) {
      console.warn('[jinroPersonalities] personality "' + name + '" is already registered. Overwriting.');
    }

    registry[name] = constructorFunction;
  }

  namespace.Personality = Personality;
  namespace.registerPersonality = registerPersonality;
  namespace.getRegisteredPersonality = function(name) {
    return registry[name];
  };
  namespace.listRegisteredPersonalities = function() {
    return Object.keys(registry);
  };
})(typeof window !== 'undefined' ? window : this);
