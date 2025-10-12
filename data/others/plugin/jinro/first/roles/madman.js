/**
 * @classdesc 狂人の役職定義。
 */
(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};
  const Role = namespace.Role;

  class MadmanRole extends Role {
    constructor() {
      super(ROLE_ID_MADMAN, '狂人', false, [ROLE_ID_FORTUNE_TELLER]);
    }
  }

  namespace.registerRole(ROLE_ID_MADMAN, MadmanRole);
})(typeof window !== 'undefined' ? window : this);
