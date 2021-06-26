/**
 * @classdec キャラクター情報を格納するクラス
 * @param {string} characterId キャラクターID
 * @param {string} roleId 役職ID
 * @prop {string} characterId キャラクターID（正当性担保のため、キャラクターオブジェクトのプロパティから読み込む）
 * @prop {string} name キャラクターの名前
 * @prop {object} role 役職オブジェクト
 * @prop {object} fakeRole 騙りの役職オブジェクト。騙りCOするときに格納する。
 * @prop {*} personality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 * @prop {boolean} isAlive 生存者か
 * @prop {boolean} isPlayer プレイヤーか
 * @prop {boolean} isDoneCO 役職COが済んでいるか
 * @prop {boolean} isDoneTodaysCO 今日の役職COが済んでいるか
 * @prop {object} perspective 現在CO中の視点オブジェクト（未COなら村人として振る舞う）
 */
function Character (characterId, roleId) {
    const characterData = createCharacterData(characterId);
    this.characterId = characterData.characterId;
    this.name = characterData.myName;
    this.personality = characterData.myPersonality;
    this.role = roleAssignment(roleId);
    this.fakeRole = {};
    this.isAlive = true;
    this.isPlayer = false;
    this.isDoneCO = false;
    this.isDoneTodaysCO = false;
    this.perspective = {};

    // /**
    //  * キャラクターが自己紹介する
    //  * @return {string} 自己紹介文
    //  */
    // this.selfIntroduction = function () {
    //     const campMessage = this.role.camp == 0 ? '村人陣営' : '人狼陣営'; // TODO 第三陣営が入ったら直しましょう
    //     return "私の名前は" + this.name
    //         + "、役職は" + this.role.roleName
    //         + "、性格は" + this.personality.name
    //         + "です。私の陣営は、" + campMessage
    //         + "です。";   
    // }
}


/**
 * @classdec アイクラス（個別のキャラクターデータを定義する）
 * @prop {string} characterId キャラクターID
 * @prop {string} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function AiData () {
    this.characterId = CHARACTER_ID_AI;
    this.myName = 'アイ';
    this.myPersonality = new Tester();
}


/**
 * @classdec ヒヨリクラス（個別のキャラクターデータを定義する）
 * @prop {string} characterId キャラクターID
 * @prop {string} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function HiyoriData () {
    this.characterId = CHARACTER_ID_HIYORI;
    this.myName = 'ヒヨリ';
    this.myPersonality = new Tester();
}

/**
 * @classdec フタバクラス（個別のキャラクターデータを定義する）
 * @prop {string} characterId キャラクターID
 * @prop {string} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function FutabaData () {
    this.characterId = CHARACTER_ID_FUTABA;
    this.myName = 'フタバ';
    this.myPersonality = new Tester();
}

/**
 * @classdec ミキクラス（個別のキャラクターデータを定義する）
 * @prop {string} characterId キャラクターID
 * @prop {string} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function MikiData () {
    this.characterId = CHARACTER_ID_MIKI;
    this.myName = 'ミキ';
    this.myPersonality = new Tester();
}

/**
 * @classdec ダミークラス（個別のキャラクターデータを定義する）
 * @prop {string} characterId キャラクターID
 * @prop {string} myName キャラクターの名前
 * @prop {*} myPersonality 性格 性格オブジェクトを入れるようにする
 */
function DummyData () {
    this.characterId = CHARACTER_ID_DUMMY;
    this.myName = 'ダミー';
    this.myPersonality = new Tester();
}
