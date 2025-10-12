/**
 * @classdesc 人狼プラグインにおける役職定義の基底クラス。
 * すべての個別役職クラスはこのクラスを継承し、super() 経由で共通プロパティを初期化する。
 */
(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};
  const registry = namespace.registry || (namespace.registry = {});

  class Role {
    /**
     * @param {string} roleId 役職ID（必須）
     * @param {string} roleName 役職名
     * @param {boolean} isWerewolves 人狼陣営として扱うか
     * @param {Array<string>} allowCORoles CO可能な役職IDリスト
     */
    constructor(roleId, roleName, isWerewolves, allowCORoles = []) {
      if (typeof roleId !== 'string' || roleId.length === 0) {
        throw new Error('[jinroRoles] Role requires non-empty string roleId.');
      }

      this.roleId = roleId;
      this.roleName = roleName || roleId;
      this.faction = ROLE_ID_TO_FACTION[roleId] || null;
      if (!this.faction) {
        console.warn('[jinroRoles] ROLE_ID_TO_FACTION does not define faction for roleId: ' + roleId);
      }
      this.isWerewolves = Boolean(isWerewolves);
      this.allowCORoles = Array.isArray(allowCORoles) ? allowCORoles : [];
      this.rolePerspective = {};
    }
  }

  /**
   * 役職クラスをレジストリへ登録する。
   * @param {string} roleId 役職ID
   * @param {Function} constructorFunction Role を継承したコンストラクタ
   */
  function registerRole(roleId, constructorFunction) {
    if (typeof roleId !== 'string' || roleId.length === 0) {
      console.error('[jinroRoles] registerRole requires non-empty string roleId.');
      return;
    }
    if (typeof constructorFunction !== 'function') {
      console.error('[jinroRoles] registerRole requires constructor function.');
      return;
    }
    if (registry[roleId]) {
      console.warn('[jinroRoles] role "' + roleId + '" is already registered. Overwriting.');
    }

    registry[roleId] = constructorFunction;
  }

  namespace.Role = Role;
  namespace.registerRole = registerRole;
  namespace.getRegisteredRole = function(roleId) {
    return registry[roleId];
  };
  namespace.listRegisteredRoles = function() {
    return Object.keys(registry);
  };
})(typeof window !== 'undefined' ? window : this);
