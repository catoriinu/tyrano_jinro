/**
 * @classdec 村人クラス（個別の役職クラス）
 */
(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};

  function Villager() {
    return new namespace.Role(ROLE_ID_VILLAGER, '村人', false, []);
  }

  namespace.Villager = Villager;
})(typeof window !== "undefined" ? window : this);