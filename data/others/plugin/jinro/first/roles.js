/**
 * @classdec 役職の基底クラス。個別の役職クラスに継承され、コンストラクタから呼び出される。
 * @prop {stirng} roleId 役職ID
 * @prop {String} roleName 役職名
 * @prop {String} faction 陣営。どの陣営が勝利したときに、自身の役職が勝利になるのか（※勝利陣営判定とは別）
 * @prop {Boolean} isWerewolves 人狼か。勝利陣営判定時に人狼陣営として扱うか。また、占い・霊能結果で人狼判定が出るかにも利用する。
 * @prop {Boolean} allowCO 村役職COすることができる役職か。false=ない場合、CO候補者判定の対象外にする。
 * @prop {Object} rolePerspective その役職の視点オブジェクト。本人の思考はこちらを元にする。ただし騙り時、fakeRole.rolePerspectiveは利用しないので空オブジェクトのままとなる。
 */
function Role(roleId, roleName, isWerewolves, allowCO) {
  this.roleId = roleId;
  this.roleName = roleName;
  this.faction = ROLE_ID_TO_FACTION[roleId];
  this.isWerewolves = isWerewolves;
  this.allowCO = allowCO;
  this.rolePerspective = {};
}


/**
 * @classdec 村人クラス（個別の役職クラス）
 */
function Villager() {
  return new Role (ROLE_ID_VILLAGER, '村人', false, false);
}


/**
 * @classdec 占い師クラス（個別の役職クラス）
 */
function FortuneTeller() {
  
  // 基底クラスのインスタンス取得
  const roleObject = new Role (ROLE_ID_FORTUNE_TELLER, '占い師', false, true);

  // 個別の役職クラスに必要なプロパティ、関数を取得
  roleObject.fortuneTellingHistory = {}; 
  
  /**
   * 占い実行メソッド
   * @param {String} fortuneTellerId 占い師のキャラクターID（真偽併用） 
   * @param {Number} day 占い実行日（過去の日付で占ったことにしたいときに指定）
   * @param {String} targetCharacterId 占い対象のキャラクターID
   * @param {Object} result PCの騙り占い師による結果騙り入力(t:●/f:○) デフォルト（PCの真占い師、またはNPCの場合）はnull
   * @returns {Object} 占いCOする結果オブジェクト{characterId, result(t:●/f:○)}
   */
  roleObject.fortuneTelling = function (fortuneTellerId, day = TYRANO.kag.stat.f.day, targetCharacterId = '', result = null) {
    
    // 占い先が未決定の場合、決める（NPC専用。プレイヤーなら占い先を先に決めているため）
    if (!targetCharacterId) {
      [targetCharacterId, result] = this.determineFortuneTellingTargetId(
        TYRANO.kag.stat.f.characterObjects[fortuneTellerId],
        day,
      );
    }
    
    // 占い結果が未決定の場合、占い先のisWerewolvesプロパティを格納する（真占い師専用）
    if (typeof result != "boolean") {
      result = TYRANO.kag.stat.f.characterObjects[targetCharacterId].role.isWerewolves;
      // NOTE:真占い師かつターゲットが妖狐の場合、妖狐を呪殺する
    }
    
    console.log(fortuneTellerId + ' fortuneTelled ' + targetCharacterId);
    console.log('result : ' + result);
    
    // 指定された日（デフォルトは今日）の占い結果をアクションオブジェクトに保存＆返却する
    const todayResult = new Action(
      fortuneTellerId,
      ACTION_FORTUNE_TELLING,
      targetCharacterId,
      result,
      false
    )

    this.fortuneTellingHistory[day] = todayResult;
    
    return todayResult;
  }
  
  /**
   * 占い先を決定する（NPC用）
   * TODO もし占い候補がいなければ（全員占い済みなら）占わないことができるようにする。翌朝COもしないようにする。
   * @param {Object} fortuneTellerOjbect 占い実行者（真占い師または騙りの占い師）のキャラクターオブジェクト
   * @param {Number} day 占い実行日（過去の日付で占ったことにしたいときに指定）
   * @return {Array} [占い先のキャラクターID, ※偽装占い結果] ※偽装占い結果は偽占い師の場合にboolean(t:●/f:○)で返却する。真占い師の場合null固定。
   */
  roleObject.determineFortuneTellingTargetId = function (fortuneTellerObject, day) {
    
    // 占い候補になるキャラクターID配列を取得する。
    const candidateIdList = this.getCandidateCharacterIds(fortuneTellerObject.characterId, day);
    
    // 現在の視点からCO可能な、合法報告生成
    // 真占い師、騙り占い師のどちらであってもキャラクターオブジェクト直下のperspectiveを元にしてよい
    // TODO:「昨夜襲撃されたキャラを●と報告する」という破綻があり得る。（キャラの論理力によって）破綻するCOをしないようにしてもいいかも。
    const regalAnnouncements = generateRegalAnnouncements(candidateIdList, fortuneTellerObject.perspective);
    
    // 合法報告の生成結果から、占い先を考慮し返却する
    return this.considerFortuneTellingTarget(regalAnnouncements, fortuneTellerObject);
  }
  
  /**
   * 占い候補取得メソッド
   * 指定日の夜開始時点のキャラクターオブジェクト配列から、以下をすべて満たすキャラクターID配列を取得する。
   * ・自分の占い履歴にない　・自分ではない　・生存している
   * @param {String} fortuneTellerId 占い師のキャラクターID（真偽併用）
   * @param {Number} day 占い実行日（過去の日付で占ったことにしたいときに指定）
   * @returns {Array} 占い対象候補となったキャラクターIDの配列
   */
  roleObject.getCandidateCharacterIds = function (fortuneTellerId, day = TYRANO.kag.stat.f.day) {
    
    // 占い対象外のキャラクターIDを配列化する
    // そのキャラの占い履歴内のアクションオブジェクトの中からtargetIdキーの値を抽出して配列化
    const notTargetIds = Object.values(this.fortuneTellingHistory).map(actionObject => actionObject.targetId).filter(Boolean);

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
  }
  
  /**
   * 合法報告の中から、今回の占い対象（騙り占い師の場合、占い結果も）を判断して返却する
   * @param {Array} regalAnnouncements 合法報告オブジェクトの配列
   * @param {Object} fortuneTellerObject 占い実行者（真占い師または騙りの占い師）のキャラクターオブジェクト
   * @returns {Array} [占い先のキャラクターID, ※偽装占い結果] ※偽装占い結果は偽占い師の場合にboolean(t:●/f:○)で返却する。真占い師の場合null固定。
   */
  roleObject.considerFortuneTellingTarget = function (regalAnnouncements, fortuneTellerObject) {
    
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
  }
   
  return roleObject;
}


/**
 * @classdec 人狼クラス（個別の役職クラス）
 */
function Werewolf() {
  // 基底クラスのインスタンス取得
  const roleObject = new Role (ROLE_ID_WEREWOLF, '人狼', true, true);

  // 個別の役職クラスに必要なプロパティ、関数を取得
  /**
   * 襲撃する
   * @param {String} biterId 襲撃実行者（狼）のキャラクターID
   * @param {String} targetId 襲撃対象者のキャラクターID
   * @returns {Object} 襲撃のアクションオブジェクト{biterId, ACTION_BITE, targetId, result(t:襲撃成功/f:襲撃失敗)}
   */
  roleObject.biting = function (biterId = "", targetId = "") {

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

    // 襲撃する
    actionObject = causeDeathToCharacter(actionObject);

    // （キャラクターオブジェクトで管理する必要がないので）ゲーム変数にその日の噛み結果を保存する
    TYRANO.kag.stat.f.bitingHistory[TYRANO.kag.stat.f.day] = actionObject;
    return actionObject;
  }

  /**
   * 噛み先を決定する（NPC用）
   * @return {String} 噛み先のキャラクターID
   */
  roleObject.determineBitingTargetId = function () {
    // 人狼ではない、かつ生存者のキャラクターオブジェクトを抽出する
    const candidateCharacterObjects = getSurvivorObjects(
      getIsWerewolvesObjects(TYRANO.kag.stat.f.characterObjects, false),
      true
    );
    
    // とりあえずランダムで返す。TODO ランダムではなく、一定の基準で噛み先を決められるようにする
    const resultObject = getRandomElement(candidateCharacterObjects);
    return resultObject.characterId;
  } 

  return roleObject;
}

/**
 * @classdec 狂人クラス（個別の役職クラス）
 */
function Madman() {
  return new Role (ROLE_ID_MADMAN, '狂人', false, true);
}
