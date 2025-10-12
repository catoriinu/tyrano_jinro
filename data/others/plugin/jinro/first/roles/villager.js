/**
 * @classdesc 村人の役職定義。
 */
(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};
  const Role = namespace.Role;

  class VillagerRole extends Role {
    constructor() {
      super(ROLE_ID_VILLAGER, '村人', false, []);
    }
  }

  namespace.registerRole(ROLE_ID_VILLAGER, VillagerRole);
})(typeof window !== 'undefined' ? window : this);
