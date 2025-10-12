/**
 * @module jinroPersonalities/factory
 * 性格レジストリに登録されたクラスからインスタンスを生成するユーティリティ。
 * MEMO: personalityBase.js 内で registerPersonality を呼び出す想定なので、このファイルはその後に loadjs すること。
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};

  /**
   * @function applyAdjustments
   * getPersonality 経由で与えられた調整パラメータを性格インスタンスへ上書きマージする。
   * 既存挙動互換のため浅い代入のみ行い、利用側が参照するプロパティを直接置き換える。
   * @param {Object} personality 性格インスタンス
   * @param {Object} adjustParameters 追加・調整用パラメータ
   */
  function applyAdjustments(personality, adjustParameters) {
    Object.keys(adjustParameters).forEach(function(key) {
      personality[key] = adjustParameters[key];
    });
  }

  /**
   * @function resolveConstructor
   * レジストリから性格クラスのコンストラクタを取得する。未登録の場合は tester へフォールバック。
   * @param {String} name 性格名
   * @returns {Function} Personality を継承したコンストラクタ
   */
  function resolveConstructor(name) {
    const lookup = namespace.getRegisteredPersonality || function() { return undefined; };
    const constructorFunction = lookup(name);
    if (typeof constructorFunction === 'function') {
      return constructorFunction;
    }

    console.warn('[jinroPersonalities] unknown personality name: ' + name + '. fallback to tester.');
    const fallback = lookup('tester');
    if (typeof fallback === 'function') {
      console.error('[jinroPersonalities] resolver fallback: using tester personality for "' + name + '".');
      return fallback;
    }

    throw new Error('[jinroPersonalities] tester personality is not registered. abort personality resolution.');
  }

  /**
   * @function buildPersonality
   * コンストラクタを安全にインスタンス化する。エラー時は空オブジェクトを返しログを残す。
   * @param {Function} constructorFunction Personality を継承したコンストラクタ
   * @returns {Object} 性格インスタンス
   */
  function buildPersonality(constructorFunction) {
    try {
      return new constructorFunction();
    } catch (error) {
      console.error('[jinroPersonalities] personality instantiation failed.', error);
      return {};
    }
  }

  /**
   * @function getPersonality
   * キャラクター生成処理などから呼び出され、指定名の性格インスタンスを返す。
   * 返り値は Personality サブクラスのインスタンスだが、従来どおり mutable オブジェクトとして扱える。
   * @param {String} [name='tester'] 性格名
   * @param {Object} [adjustParameters={}] 調整用パラメータ
   * @returns {Object} 性格インスタンス
   */
  global.getPersonality = function(name = 'tester', adjustParameters = {}) {
    const constructorFunction = resolveConstructor(name);
    const personality = buildPersonality(constructorFunction);
    applyAdjustments(personality, adjustParameters);
    return personality;
  };

  namespace.getPersonality = global.getPersonality;
})(typeof window !== 'undefined' ? window : this);
