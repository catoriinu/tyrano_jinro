/**
 * @classdesc 人狼の役職定義。
 */
(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};
  const Role = namespace.Role;

  class WerewolfRole extends Role {
    constructor() {
      super(ROLE_ID_WEREWOLF, '人狼', true, [ROLE_ID_FORTUNE_TELLER]);
    }

    /**
     * 襲撃を実行する。
     * @param {string} biterId 襲撃実行者のキャラクターID
     * @param {string} targetId 襲撃対象者のキャラクターID
     * @returns {Object} 襲撃のアクションオブジェクト{biterId, ACTION_BITE, targetId, result(t:襲撃成功/f:襲撃失敗)}
     */
    biting(biterId = '', targetId = '') {
      // 噛み先が未決定の場合、決める（NPC専用。プレイヤーなら噛み先を先に決めているため）
      if (!targetId) {
        targetId = this.determineBitingTargetId(biterId);
      }

      // 襲撃のアクションオブジェクトを生成
      let actionObject = new Action(
        biterId,
        ACTION_BITE,
        targetId
      );
      actionObject = causeDeathToCharacter(actionObject);

      // （キャラクターオブジェクトで管理する必要がないので）ゲーム変数にその日の噛み結果を保存する
      TYRANO.kag.stat.f.bitingHistory[TYRANO.kag.stat.f.day] = actionObject;
      return actionObject;
    }

    /**
     * 噛み先を決定する（NPC用）
     * @returns {string} 襲撃対象のキャラクターID
     */
    determineBitingTargetId() {
      // 人狼ではない、かつ生存者のキャラクターオブジェクトを抽出する
      const candidateCharacterObjects = getSurvivorObjects(
        getIsWerewolvesObjects(TYRANO.kag.stat.f.characterObjects, false),
        true
      );
      
      // とりあえずランダムで返す。TODO ランダムではなく、一定の基準で噛み先を決められるようにする
      const resultObject = getRandomElement(candidateCharacterObjects);
      return resultObject.characterId;
    }
  }

  namespace.registerRole(ROLE_ID_WEREWOLF, WerewolfRole);
})(typeof window !== 'undefined' ? window : this);
