(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};

  function assignFortuneTellerDecisions(roleObject) {
    /**
     * 占い先を決定する（NPC用）
     * TODO もし占い候補がいなければ（全員占い済みなら）占わないことができるようにする。翌朝COもしないようにする。
     * @param {Object} fortuneTellerObject 占い実行者（真占い師または騙りの占い師）のキャラクターオブジェクト
     * @param {Number} day 占い実行日（過去の日付で占ったことにしたいときに指定）
     * @return {Array} [占い先のキャラクターID, ※偽装占い結果] ※偽装占い結果は偽占い師の場合にboolean(t:●/f:○)で返却する。真占い師の場合null固定。
     */
    roleObject.determineFortuneTellingTargetId = function(fortuneTellerObject, day) {
      // 占い候補になるキャラクターID配列を取得する。
      const candidateIdList = this.getCandidateCharacterIds(fortuneTellerObject.characterId, day);

      // 現在の視点からCO可能な、合法報告生成
      // 真占い師、騙り占い師のどちらであってもキャラクターオブジェクト直下のperspectiveを元にしてよい
      // TODO:「昨夜襲撃されたキャラを●と報告する」という破綻があり得る。（キャラの論理力によって）破綻するCOをしないようにしてもいいかも。
      const regalAnnouncements = generateRegalAnnouncements(candidateIdList, fortuneTellerObject.perspective);

      // 合法報告の生成結果から、占い先を考慮し返却する
      return this.considerFortuneTellingTarget(regalAnnouncements, fortuneTellerObject);
    };

    /**
     * 占い候補取得メソッド
     * 指定日の夜開始時点のキャラクターオブジェクト配列から、以下をすべて満たすキャラクターID配列を取得する。
     * ・自分の占い履歴にない　・自分ではない　・生存している
     * @param {String} fortuneTellerId 占い師のキャラクターID（真偽併用）
     * @param {Number} day 占い実行日（過去の日付で占ったことにしたいときに指定）
     * @returns {Array} 占い対象候補となったキャラクターIDの配列
     */
    roleObject.getCandidateCharacterIds = function(fortuneTellerId, day = TYRANO.kag.stat.f.day) {
      // 占い対象外のキャラクターIDを配列化する
      // そのキャラの占い履歴内のアクションオブジェクトの中からtargetIdキーの値を抽出して配列化
      const notTargetIds = Object.values(this.fortuneTellingHistory)
        .map(actionObject => actionObject.targetId)
        .filter(Boolean);

      // そこに占い実行者自身も追加
      notTargetIds.push(fortuneTellerId);

      // 占い対象外ではない（＝占い候補の）キャラクターオブジェクトを取得し、その中から生存者のみを返却する
      // 占い対象は、指定された日の夜時間開始時の生存者から選ばれる（騙り占い師が過去の日付の占い履歴を作ることがあるためこうしている）
      // NOTE：生存者の中から占い候補を探すのが正しい順番では？AND判定なので現状でも問題はなさそうだけど。
      return getValuesFromObjectArray(
        getSurvivorObjects(
          getCharacterObjectsFromCharacterIds(TYRANO.kag.stat.f.characterObjectsHistory[day], notTargetIds, false),
          true
        ),
        'characterId'
      );
    };

    /**
     * 合法報告の中から、今回の占い対象（騙り占い師の場合、占い結果も）を判断して返却する
     * @param {Array} regalAnnouncements 合法報告オブジェクトの配列
     * @param {Object} fortuneTellerObject 占い実行者（真占い師または騙りの占い師）のキャラクターオブジェクト
     * @returns {Array} [占い先のキャラクターID, ※偽装占い結果] ※偽装占い結果は偽占い師の場合にboolean(t:●/f:○)で返却する。真占い師の場合null固定。
     */
    roleObject.considerFortuneTellingTarget = function(regalAnnouncements, fortuneTellerObject) {
      // TODO 合法報告が0の場合はCOなしとする
      // TODO ランダムではなく、一定の基準（どれを選んだほうが有利になるかを各キャラが判断する）で結果を決められるようにする
      // 一旦、候補の中からランダムで返却する
      const announcementObject = getRandomElement(regalAnnouncements);
      if (fortuneTellerObject.role.roleId == ROLE_ID_FORTUNE_TELLER) {
        return [announcementObject.characterId, null];
      } else {
        return [announcementObject.characterId, announcementObject.result];
      }
      /*
      メモ：占い先の選び方検討（生存人数が少ない場合）
      ・占い師（論理的な判断）：候補の中で、自分視点で仲間度が最も低いキャラを占う（●狙い）
      ・占い師（感情的な判断）：候補の中で、自分視点で仲間度が最も高いキャラを占う（○狙い）
      ・狂人（論理的な判断）　：候補の中で、騙り占い師視点で仲間度が最も低いキャラを占う
      　　　　　　　　　　　　　ただしそれが自分視点で必ず人狼の場合、必ず○として報告する
      　　　　　　　　　　　　　ただしそれが現在までに襲撃死済みの場合、必ず○として報告する
      　　　　　　　　　　　　　ただし自分が既に●を人狼数分以上報告している場合、必ず○として報告する
      ・人狼（論理的な判断）　：候補の中で、騙り占い師視点で仲間度が最も低いキャラを占う
      　　　　　　　　　　　　　ただしそれが自分視点で必ず人狼の場合、必ず○として報告する
      　　　　　　　　　　　　　ただしそれが現在までに襲撃死済みの場合、必ず○として報告する
      　　　　　　　　　　　　　ただし自分が既に●を人狼数分以上報告している場合、必ず○として報告する
      論理的と感情的のどちらで判断するかは、論理力(%)で毎回判定する？
      */
    };
  }

  namespace.assignFortuneTellerDecisions = assignFortuneTellerDecisions;
})(typeof window !== "undefined" ? window : this);