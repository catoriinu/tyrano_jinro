/**
 * 人狼ゲームの準備をするマクロ
 * 人狼ゲーム開始前に呼び出す 
 */

function prepareGameMain () {

    // 今回の参加者のキャラクターIDと、配役される役職IDを取得する
    const participantsIdList = getParticipantsIdList();
    const VillagersRoleIdList = getVillagersRoleIdList();

    // 参加者数と役職数が等しいことをチェックしてから先に進む
    if (participantsIdList.length != VillagersRoleIdList.length){
        alert('参加者数(' + participantsIdList.length + ')と役職数(' + VillagersRoleIdList.length +')が合っていません！');
    }

    // キャラクターに役職を割り当てた状態の、キャラクターオブジェクト配列を取得する
    const characterObjects = {};
    for (let i = 0; i < participantsIdList.length; i++){
        const characterId = participantsIdList[i];
        characterObjects[characterId] = new Character(characterId, VillagersRoleIdList[i]);

        // 配列先頭のキャラは、プレイヤーキャラとする
        if(i == 0) {
            characterObjects[characterId].isPlayer = true;
            TYRANO_VAR_F.playerCharacterId = characterId
        }
    }
    // 共通の視点オブジェクトをティラノ変数に、各キャラの視点オブジェクトを各自のcharacterObject.perspectiveに格納する
    setDefaultPerspective(characterObjects, participantsIdList, VillagersRoleIdList);

    // 以下のデータは、ティラノの変数にも格納しておく
    // 参加者のキャラクターID配列
    TYRANO_VAR_F.participantsIdList = participantsIdList;
    // 参加している役職ID配列
    TYRANO_VAR_F.VillagersRoleIdList = VillagersRoleIdList;
    // キャラクターオブジェクト配列をティラノのキャラクターオブジェクト変数に格納する
    TYRANO_VAR_F.characterObjects = characterObjects;
    // 噛み先履歴オブジェクトの初期化
    TYRANO_VAR_F.bitingHistory = {};


    // 発話者の名前オブジェクト。ksファイル内で、# &f.speaker['名前'] の形式で使う。
    TYRANO_VAR_F.speaker = setSpeakersName(characterObjects);

    // 日時の初期化（初日の夜から始める）
    // ※いわゆる初日占いや初日襲撃ありにする場合は、夜から始めるようにした上でシナリオを修正すること）
    TYRANO_VAR_F.day = 0;
    TYRANO_VAR_F.isDaytime = false;

    // 変数テスト用
    TYRANO_VAR_F.hogeObject = new TestObj();
    TYRANO_VAR_F.piyoArray = ['pika','chu'];
}

function TestObj () {
    this.string = "majide?"
    this.propaty = {key:true};
    this.funcTest = function () {
       return 'funcTest';
    }
}

/**
 * 発話者の名前オブジェクトに、表示名を格納していく
 * @param {Array} characterObjects キャラクターオブジェクト配列
 * @return {Array} 発話者の名前オブジェクト keyがname、valueが表示名（開発モードかヒントモードの場合、後ろに役職名を追加する）
 */
function setSpeakersName (characterObjects) {
    const speaker = {}
    for (let k of Object.keys(characterObjects)) {
        let tmpName = characterObjects[k].name;
        console.log(tmpName);
        if (TYRANO_VAR_F.developmentMode || TYRANO_VAR_F.hintMode) {
            tmpName += '（' + ROLE_ID_TO_NAME[characterObjects[k].role.roleId] + '）';
        }
        speaker[characterObjects[k].name] = tmpName;
    }
    return speaker;
}

/**
 * 初期状態の、共通の視点オブジェクト、各キャラの視点オブジェクト（自分の役職分を考慮する）を生成する
 * @param {Array} characterObjects キャラクターオブジェクト配列。このメソッド内でperspectiveを更新する。
 * @param {Array} participantsIdList 参加者のキャラクターID配列
 * @param {Array} VillagersRoleIdList この村の役職のID配列
 */
function setDefaultPerspective (characterObjects, participantsIdList, VillagersRoleIdList) {
    // 役職数をカウントしてオブジェクトに入れる
    let roleCountObject = {};
    for (let i = 0; i < VillagersRoleIdList.length; i++) {
        let key = VillagersRoleIdList[i];
        roleCountObject[key] = roleCountObject[key] ? roleCountObject[key] + 1 : 1;
    }
    // 重複のない、村の役職ID配列をティラノ変数に入れておく
    TYRANO_VAR_F.uniqueRoleIdList = Object.keys(roleCountObject);

    // 役職の割合をオブジェクトに入れる
    let roleRatioObject = {};
    for (let rId of Object.keys(roleCountObject)) {
        roleRatioObject[rId] = roleCountObject[rId] / VillagersRoleIdList.length;
    }

    // 共通視点オブジェクトを生成する
    // このとき格納するオブジェクトは必ずcloneでディープコピーすること。単に格納してしまうと、参照渡しなので中身がorganizePerspectiveで書き換えられてしまう
    let commonPerspective = {};
    for (let i = 0; i < participantsIdList.length; i++) {
        commonPerspective[participantsIdList[i]] = clone(roleRatioObject);
    }
    commonPerspective.uncertified = clone(roleCountObject);
    // 共通視点オブジェクトはティラノ変数に格納する
    TYRANO_VAR_F.commonPerspective = commonPerspective;

    // 各キャラクターの自分視点オブジェクトを生成し、更新する
    for (let characterId of Object.keys(characterObjects)) {
        // 役職ごとに処理を分ける。
        // perspectiveはCO状態に合わせた視点
        characterObjects[characterId].perspective = organizePerspective (
            commonPerspective,
            characterId,
            TYRANO_VAR_F.uniqueRoleIdList.filter(rId => (rId != ROLE_ID_VILLAGER)) // TODO：COなしなら村人を入れておくが、それで破綻する可能性もあるかもしれない。その場合共通視点を入れるようにしたほうがいいかも
        );

        characterObjects[characterId].role.rolePerspective = organizePerspective (
            commonPerspective,
            characterId,
            TYRANO_VAR_F.uniqueRoleIdList.filter(rId => (rId != characterObjects[characterId].role.roleId)) // roleCountObjectのキーはroleIdで一意なので利用する。そこから自身のroleId以外を0確定させる。
        );

        console.log(characterObjects[characterId].role.rolePerspective);
    }
}




// メイン関数実行
prepareGameMain();
