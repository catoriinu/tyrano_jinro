/**
 * @classdec 役職の基底クラス。個別の役職クラスに継承され、コンストラクタから呼び出される。
 * @prop {string} roleId 役職ID
 * @prop {String} roleName 役職名
 * @prop {String} faction 陣営。どの陣営が勝利したときに、自身の役職が勝利になるのか（※勝利陣営判定とは別）
 * @prop {Boolean} isWerewolves 人狼か。勝利陣営判定時に人狼陣営として扱うか。また、占い・霊能結果で人狼判定が出るかにも利用する。
 * @prop {Array} allowCORoles 村役職COすることができる役職か。false=ない場合、CO候補者判定の対象外にする。
 * @prop {Object} rolePerspective その役職の視点オブジェクト。本人の思考はこちらを元にする。ただし騙り時、fakeRole.rolePerspectiveは利用しないので空オブジェクトのままとなる。
 */
(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};

  function Role(roleId, roleName, isWerewolves, allowCORoles) {
    this.roleId = roleId;
    this.roleName = roleName;
    this.faction = ROLE_ID_TO_FACTION[roleId];
    this.isWerewolves = isWerewolves;
    this.allowCORoles = allowCORoles;
    this.rolePerspective = {};
  }

  namespace.Role = Role;
})(typeof window !== "undefined" ? window : this);