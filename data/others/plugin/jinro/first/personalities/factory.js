/**
 * @module jinroPersonalities/factory
 * @description 性格取得用のファクトリ関数をまとめたモジュール。namespace に登録済みの性格定義からインスタンス生成を仲介する。
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};

  /**
   * @function applyAdjustments
   * @description getPersonality 経由で指定された調整パラメータを性格オブジェクトへ反映するヘルパーです。
   * キャラクター固有の調整値を後付けする場面で利用されます。
   * @param {Object} personality 性格インスタンス
   * @param {Object} adjustParameters 調整用パラメータの連想配列
   */
  function applyAdjustments(personality, adjustParameters) {
    Object.keys(adjustParameters).forEach(function(key) {
      personality[key] = adjustParameters[key];
    });
  }

  /**
   * @function resolveFactory
   * @description 指定された名前に対応するファクトリ関数を namespace から検索します。
   * シナリオやキャラクターデータで性格名が指定されたときに呼び出されます。
   * @param {String} name 性格名
   * @returns {Function} 生成用ファクトリ
   */
  function resolveFactory(name) {
    if (typeof namespace[name] === 'function') {
      return namespace[name];
    }
    console.warn('[jinroPersonalities] unknown personality name: ' + name + '. fallback to tester.');
    return namespace.tester;
  }

  /**
   * @function buildPersonality
   * @description ファクトリ関数を安全に実行して性格インスタンスを作成します。
   * 予期せぬ未定義ファクトリに備えて呼び出し元をフォールバックさせる想定です。
   * @param {Function} factory 性格生成ファクトリ
   * @returns {Object} 性格インスタンス
   */
  function buildPersonality(factory) {
    if (typeof factory === 'function') {
      return factory();
    }
    console.error('[jinroPersonalities] personality factory is not available. return empty object.');
    return {};
  }

  /**
   * @function getPersonality
   * @description キャラクター生成処理（characters.js など）から呼び出され、性格インスタンスを取得します。
   * 指定名の性格が存在しない場合はテスト用性格へフォールバックし、必要があれば調整値を適用します。
   * @param {String} [name='tester'] 性格名
   * @param {Object} [adjustParameters={}] 調整用パラメータ
   * @returns {Object} 性格インスタンス
   */
  global.getPersonality = function(name = 'tester', adjustParameters = {}) {
    const factory = resolveFactory(name);
    const personality = buildPersonality(factory);
    applyAdjustments(personality, adjustParameters);
    return personality;
  };

  namespace.getPersonality = global.getPersonality;
})(typeof window !== "undefined" ? window : this);

