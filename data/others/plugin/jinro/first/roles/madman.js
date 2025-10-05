/**
 * @classdec 狂人クラス（個別の役職クラス）
 */
(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};

  function Madman() {
    return new namespace.Role(ROLE_ID_MADMAN, '狂人', false, [ROLE_ID_FORTUNE_TELLER]);
  }

  namespace.Madman = Madman;
})(typeof window !== "undefined" ? window : this);