/**
 * @classdec 役職の基底クラス。個別の役職クラスに継承され、コンストラクタから呼び出される。
 * @prop {stirng} roleId 役職ID
 * @prop {string} roleName 役職名
 * @prop {number} camp 陣営。どの陣営が勝利したときに、自身の役職が勝利になるのか（※勝利陣営判定とは別） 0:村人陣営 1:人狼陣営
 * @prop {boolean} isWerewolves 人狼か。勝利陣営判定時に人狼陣営として扱うか。また、占い・霊能結果で人狼判定が出るかにも利用する。
 * @prop {boolean} willCO 村役職CO（結果COも含む）する意思（可能性）が現在少しでもあるか。false=ない場合、CO候補者判定の対象外にする。
 * @prop {object} rolePerspective その役職の視点オブジェクト。本人の思考はこちらを元にする。ただし騙り時、fakeRole.rolePerspectiveは利用しないので空オブジェクトのままとなる。
 */
function Role (roleId, roleName, camp, isWerewolves, willCO) {
    this.roleId = roleId;
    this.roleName = roleName;
    this.camp = camp;
    this.isWerewolves = isWerewolves;
    this.willCO = willCO
    this.rolePerspective = {};
}

/**
 * @classdec 村人クラス（個別の役職クラス）
 */
function Villager () {
    return new Role (ROLE_ID_VILLAGER, '村人', 0, false, false);
}

/**
 * @classdec 占い師クラス（個別の役職クラス）
 */
function FortuneTeller () {

    // 基底クラスのインスタンス取得
    const roleObject = new Role (ROLE_ID_FORTUNE_TELLER, '占い師', 0, false, true);
    // 個別の役職クラスに必要なプロパティ、関数を取得
    roleObject.fortuneTellingHistory = {}; 
    roleObject.fortuneTelling = function (fortuneTellerId, day = TYRANO_VAR_F.day, targetCharacterId = "", result = null) {

        // 占い先が未決定の場合、決める（NPC専用。プレイヤーなら占い先を先に決めているため）
        if (!targetCharacterId){
            /*
            targetCharacterId = this.determineFortuneTellingTargetId(fortuneTellerId, day);

            // 真占い師でない場合
            if (TYRANO_VAR_F.characterObjects[fortuneTellerId].role.roleId != ROLE_ID_FORTUNE_TELLER) {
                // 占い結果を偽装する
                result = this.getFakeFortuneTellingResult(targetCharacterId);
            }
            */
            
            const isTrueFortuneTeller = TYRANO_VAR_F.characterObjects[fortuneTellerId].role.roleId == ROLE_ID_FORTUNE_TELLER ? true : false;
            [targetCharacterId, result] = this.determineFortuneTellingTargetId(
                fortuneTellerId,
                day,
                TYRANO_VAR_F.characterObjects[fortuneTellerId].perspective, // 真占い師、騙り占い師のどちらであってもキャラクターオブジェクト直下のperspectiveを元にしてよい
                isTrueFortuneTeller
            );
        }

        // 占い結果が未決定の場合、占い先のisWerewolvesプロパティを格納する（真占い師専用）
        if (typeof result != "boolean") {
            result = TYRANO_VAR_F.characterObjects[targetCharacterId].role.isWerewolves;
            // NOTE:真占い師かつターゲットが妖狐の場合、妖狐を呪殺する
        }

        console.log(fortuneTellerId + ' fortuneTelled ' + targetCharacterId);
        console.log('result : ' + result);

        // 指定された日（デフォルトは今日）の占い結果を保存＆返却する
        const todayResult = {
            characterId: targetCharacterId,
            result: result,
        }
        this.fortuneTellingHistory[day] = todayResult;

        return todayResult;
    }

    /**
     * 占い先を決定する（NPC用）
     * TODO もし占い候補がいなければ（全員占い済みなら）、自分以外の生存者からランダムで選ぶ。
     * @param {string} fortuneTellerId 実行者のキャラクターID（真占い師または騙りの占い師）
     * @param {number} day 占い実行日
     * @param {Object} perspective 占い師自身の視点オブジェクト
     * @param {boolean} isTrueFortuneTeller 真占い師か(t:真/f:偽)。偽装占い結果を返却するかに関わる。
     * @return {Array} [占い先のキャラクターID, ※偽装占い結果] ※偽装占い結果は偽占い師の場合にboolean(t:●/f:○)で返却する。真占い師の場合null固定。
     */
    roleObject.determineFortuneTellingTargetId = function (fortuneTellerId, day, perspective, isTrueFortuneTeller) {

        // 占い候補になるキャラクターID配列を取得する。
        const candidateIdList = getValuesFromObjectArray(
            this.getCandidateObjects(fortuneTellerId, day, this.fortuneTellingHistory),
            'characterId'
        );
        
        // 現在の視点からCO可能な、合法報告生成
        const regalAnnouncements = generateRegalAnnouncements(candidateIdList, perspective);

        // 合法報告の生成結果から、占い先を考慮し返却する
        return this.considerFortuneTellingTarget(regalAnnouncements, isTrueFortuneTeller);


        // とりあえずランダムで返す。TODO ランダムではなく、一定の基準で占い先を決められるようにする
        const resultObject = getRandomElement(
            this.getCandidateObjects(fortuneTellerId, day, Object.values(this.fortuneTellingHistory))
        );
        return resultObject.characterId;
    }

    // 占い候補取得メソッド
    // 指定日の夜開始時点のキャラクターオブジェクト配列から、以下をすべて満たすキャラクターオブジェクト配列を取得する。
    // ・自分の占い履歴にない　・自分ではない　・生存している
    roleObject.getCandidateObjects = function (fortuneTellerId, day = TYRANO_VAR_F.day, fortuneTellingHistory = Object.values(this.fortuneTellingHistory)) {

        console.log(fortuneTellerId);
        console.log(fortuneTellingHistory);
        // 占い対象外として、占い履歴からcharacterId配列を抽出したものに、実行者のIDを追加する
        const notTargetIds = getValuesFromObjectArray(fortuneTellingHistory, 'characterId');
        notTargetIds.push(fortuneTellerId);

        // 占い対象外ではない（＝占い候補の）キャラクターオブジェクトを取得し、その中から生存者のみを返却する
        // 占い対象は、指定された日の夜時間開始時の生存者から選ばれる（騙り占い師が過去の日付の占い履歴を作ることがあるためこうしている）
        return getSurvivorObjects(
            getCharacterObjectsFromCharacterIds(TYRANO_VAR_F.characterObjectsHistory[day], notTargetIds, false),
            true
        );
    }

    // 合法報告の中から、
    // TODO ランダムではなく、一定の基準（どれを選んだほうが有利になるか）で結果を決められるようにする
    roleObject.considerFortuneTellingTarget = function (regalAnnouncements, isTrueFortuneTeller) {

        // TODO 合法報告が0の場合はCOなしとする
        // TODO 一旦、候補の中からランダムで返却する
        const announcementObject = getRandomElement(regalAnnouncements);
        if (isTrueFortuneTeller) {
            return [announcementObject.characterId, null];
        } else {
            return [announcementObject.characterId, announcementObject.result];
        }
    }

    // 占い結果を偽装する。とりあえずランダムで返す。TODO ランダムではなく、一定の基準で結果を決められるようにする
    roleObject.getFakeFortuneTellingResult = function (targetCharacterId) {
        return getRandomElement([true, false]);
    }

    return roleObject;
}

/**
 * @classdec 人狼クラス（個別の役職クラス）
 */
function Werewolf () {
    // 基底クラスのインスタンス取得
    const roleObject = new Role (ROLE_ID_WEREWOLF, '人狼', 1, true, true);
    // 個別の役職クラスに必要なプロパティ、関数を取得
    roleObject.biting = function (biterId = "", targetCharacterId = "") {
        // 噛み先が未決定の場合、決める（NPC専用。プレイヤーなら噛み先を先に決めているため）
        if (!targetCharacterId){
            targetCharacterId = this.determineBitingTargetId(biterId);
        }

        // 襲撃する。（fixme:狩人や妖狐による襲撃失敗に気をつける。
        // 妖狐実装後のように、死亡原因が重なるようになったときには処理順に依らないよう、夜の前に判定用キャラクターオブジェクトをコピーしておく）
        let result = causeDeathToCharacter(TYRANO_VAR_F.characterObjects[targetCharacterId], DEATH_BY_ATTACK);

        // （キャラクターオブジェクトで管理する必要がないので）ゲーム変数にその日の噛み結果を保存する
        const todayResult = {
            characterId: targetCharacterId,
            result: result,
        }
        TYRANO_VAR_F.bitingHistory[TYRANO_VAR_F.day] = todayResult;

        return todayResult;
    }

    /**
     * 噛み先を決定する（NPC用）
     * @return {string} 噛み先のキャラクターID
     */
    roleObject.determineBitingTargetId = function () {
        // 人狼ではない、かつ生存者のキャラクターオブジェクトを抽出する
        const candidateObjects = getSurvivorObjects(
            getIsWerewolvesObjects(TYRANO_VAR_F.characterObjects, false),
            true
        );
        
        // とりあえずランダムで返す。TODO ランダムではなく、一定の基準で噛み先を決められるようにする
        const resultObject = getRandomElement(candidateObjects);
        return resultObject.characterId;
    } 

    return roleObject;
}

/**
 * @classdec 狂人クラス（個別の役職クラス）
 */
function Madman () {
    return new Role (ROLE_ID_MADMAN, '狂人', 1, false, true);
}