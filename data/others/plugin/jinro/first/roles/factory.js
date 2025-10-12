/**
 * @module jinroRoles/factory
 * 役職レジストリに登録されたクラスからインスタンスを生成するユーティリティ。
 * MEMO: roleBase.js で registerRole を呼び出す想定なので、このファイルはその後に loadjs すること。
 */
(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};

  /**
   * getRole 経由で与えられた調整パラメータを役職インスタンスへ上書きマージする。
   * Personality 側と同様、既存互換のため単純な代入で置き換える。
   * @param {Object} role 役職インスタンス
   * @param {Object} adjustParameters 追加・調整用パラメータ
   */
  function applyAdjustments(role, adjustParameters) {
    Object.keys(adjustParameters).forEach(function(key) {
      role[key] = adjustParameters[key];
    });
  }

  /**
   * レジストリから役職クラスのコンストラクタを取得する。
   * 未登録の場合は例外を投げて処理を停止する。
   * @param {string} roleId 役職ID
   * @returns {Function} Role を継承したコンストラクタ
   */
  function resolveConstructor(roleId) {
    const lookup = namespace.getRegisteredRole || function() { return undefined; };
    const constructorFunction = lookup(roleId);
    if (typeof constructorFunction === 'function') {
      return constructorFunction;
    }

    throw new Error('[jinroRoles] unknown role id: ' + roleId + '. abort role resolution.');
  }

  /**
   * コンストラクタを安全にインスタンス化する。
   * エラー時はログを出しつつ例外を再送出する。
   * @param {Function} constructorFunction Role を継承したコンストラクタ
   * @returns {Object} 役職インスタンス
   */
  function buildRole(constructorFunction) {
    try {
      return new constructorFunction();
    } catch (error) {
      console.error('[jinroRoles] role instantiation failed.', error);
      throw error;
    }
  }

  /**
   * キャラクター生成処理などから呼び出され、指定 ID の役職インスタンスを返す。
   * @param {string} roleId 役職ID
   * @param {Object} [adjustParameters={}] 調整用パラメータ
   * @returns {Object} Role サブクラスのインスタンス
   */
  global.getRole = function(roleId, adjustParameters = {}) {
    if (typeof roleId !== 'string' || roleId.length === 0) {
      throw new Error('[jinroRoles] getRole requires non-empty string roleId.');
    }
    const constructorFunction = resolveConstructor(roleId);
    const role = buildRole(constructorFunction);
    applyAdjustments(role, adjustParameters);
    return role;
  };

  namespace.getRole = global.getRole;
})(typeof window !== 'undefined' ? window : this);
