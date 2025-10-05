/**
 * @classdec 占い師クラス（個別の役職クラス）
 */
(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};

  function FortuneTeller() {
    const roleObject = new namespace.Role(ROLE_ID_FORTUNE_TELLER, '占い師', false, [ROLE_ID_FORTUNE_TELLER]);

    roleObject.fortuneTellingHistory = {};

    namespace.assignFortuneTellerDecisions(roleObject);
    namespace.assignFortuneTellerActions(roleObject);

    return roleObject;
  }

  namespace.FortuneTeller = FortuneTeller;
})(typeof window !== "undefined" ? window : this);