/**
 * @classdesc 占い師クラス（個別の役職クラス）
 */
(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};
  const Role = namespace.Role;

  class FortuneTellerRole extends Role {
    constructor() {
      super(ROLE_ID_FORTUNE_TELLER, '占い師', false, [ROLE_ID_FORTUNE_TELLER]);
      this.fortuneTellingHistory = {};
    }

    /**
     * 占い実行メソッド
     * @param {string} fortuneTellerId 占い師のキャラクターID（真偽併用）
     * @param {number} day 占い実行日（過去の日付で占ったことにしたいときに指定）
     * @param {string} targetCharacterId 占い対象のキャラクターID
     * @param {?boolean} result PCの騙り占い師による結果騙り入力(t:●/f:○)。デフォルト（PCの真占い師、またはNPCの場合）はnull
     * @returns {Action} 占いCOする結果アクションオブジェクト
     */
    fortuneTelling(fortuneTellerId, day = TYRANO.kag.stat.f.day, targetCharacterId = '', result = null) {
      if (!targetCharacterId) {
        [targetCharacterId, result] = this.determineFortuneTellingTargetId(
          TYRANO.kag.stat.f.characterObjects[fortuneTellerId],
          day
        );
      }

      if (typeof result !== 'boolean') {
        result = TYRANO.kag.stat.f.characterObjects[targetCharacterId].role.isWerewolves;
        // NOTE:真占い師かつターゲットが妖狐の場合、妖狐を呪殺する
      }

      console.debug(fortuneTellerId + ' fortuneTelled ' + targetCharacterId);
      console.debug('result : ' + result);

      const todayResult = new Action(
        fortuneTellerId,
        ACTION_FORTUNE_TELLING,
        targetCharacterId,
        result,
        false
      );

      this.fortuneTellingHistory[day] = todayResult;
      return todayResult;
    }

    /**
     * 占い先を決定する（NPC用）
     * TODO もし占い候補がいなければ（全員占い済みなら）占わないことができるようにする。翌朝COもしないようにする。
     * @param {Object} fortuneTellerObject 占い実行者（真占い師または騙りの占い師）のキャラクターオブジェクト
     * @param {number} day 占い実行日（過去の日付で占ったことにしたいときに指定）
     * @returns {[string, (boolean|null)]} [占い先のキャラクターID, ※偽装占い結果] ※偽装占い結果は偽占い師の場合にboolean(t:●/f:○)で返却する。真占い師の場合null固定。
     */
    determineFortuneTellingTargetId(fortuneTellerObject, day) {
      const candidateIdList = this.getCandidateCharacterIds(fortuneTellerObject.characterId, day);
      const regalAnnouncements = generateRegalAnnouncements(candidateIdList, fortuneTellerObject.perspective);
      return this.considerFortuneTellingTarget(regalAnnouncements, fortuneTellerObject);
    }

    /**
     * 占い候補取得メソッド
     * 指定日の夜開始時点のキャラクターオブジェクト配列から、以下をすべて満たすキャラクターID配列を取得する。
     * ・自分の占い履歴にない　・自分ではない　・生存している
     * @param {string} fortuneTellerId 占い師のキャラクターID（真偽併用）
     * @param {number} day 占い実行日（過去の日付で占ったことにしたいときに指定）
     * @returns {string[]} 占い対象候補となったキャラクターIDの配列
     */
    getCandidateCharacterIds(fortuneTellerId, day = TYRANO.kag.stat.f.day) {
      const notTargetIds = Object.values(this.fortuneTellingHistory)
        .map(function(actionObject) { return actionObject.targetId; })
        .filter(Boolean);

      notTargetIds.push(fortuneTellerId);

      return getValuesFromObjectArray(
        getSurvivorObjects(
          getCharacterObjectsFromCharacterIds(TYRANO.kag.stat.f.characterObjectsHistory[day], notTargetIds, false),
          true
        ),
        'characterId'
      );
    }

    /**
     * 合法報告の中から、今回の占い対象（騙り占い師の場合、占い結果も）を判断して返却する
     * @param {{characterId:string,result:?boolean}[]} regalAnnouncements 合法報告オブジェクトの配列
     * @param {Object} fortuneTellerObject 占い実行者（真占い師または騙りの占い師）のキャラクターオブジェクト
     * @returns {[string, (boolean|null)]} [占い先のキャラクターID, ※偽装占い結果] ※偽装占い結果は偽占い師の場合にboolean(t:●/f:○)で返却する。真占い師の場合null固定。
     */
    considerFortuneTellingTarget(regalAnnouncements, fortuneTellerObject) {
      const announcementObject = getRandomElement(regalAnnouncements);
      if (fortuneTellerObject.role.roleId === ROLE_ID_FORTUNE_TELLER) {
        return [announcementObject.characterId, null];
      }
      return [announcementObject.characterId, announcementObject.result];
    }
  }

  namespace.registerRole(ROLE_ID_FORTUNE_TELLER, FortuneTellerRole);
})(typeof window !== 'undefined' ? window : this);
