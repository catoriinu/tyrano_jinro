/**
 * @classdec キャラクター情報を格納するクラス
 * @param {String} characterId キャラクターID
 * @param {String} roleId 役職ID
 * @prop {String} characterId キャラクターID（正当性担保のため、キャラクターオブジェクトのプロパティから読み込む）
 * @prop {String} name キャラクターの名前
 * @prop {Object} role 役職オブジェクト
 * @prop {Object} fakeRole 騙りの役職オブジェクト。騙りCOするときに格納する。
 * @prop {String} CORoleId 自身がCOしている役職ID。空文字は未CO（役職なし＝村人と同義）
 * @prop {*} personality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 * @prop {Boolean} isAlive 生存者か
 * @prop {Boolean} isPlayer プレイヤーか
 * @prop {Boolean} isDoneTodaysCO 今日の役職COが済んでいるか
 * @prop {Boolean} isContradicted 自分のCO状況が破綻済みか
 * @prop {Object} perspective 現在CO中の視点オブジェクト（未COなら村人として振る舞う）
 * @prop {Object} reliability 信頼度オブジェクト {characterId:0以上1以下かつ小数点第二位までの数値,...}
 * @prop {Object} voteHistory 投票履歴オブジェクト {day:[1回目の投票先characterId,2回目(再投票)の投票先characterId,...],...}
 */
function Character(characterId, roleId) {
  const characterData = createCharacterData(characterId);
  this.characterId = characterData.characterId;
  this.name = characterData.myName;
  this.personality = characterData.myPersonality;
  this.role = roleAssignment(roleId);
  this.fakeRole = {};
  this.CORoleId = '';
  this.isAlive = true;
  this.isPlayer = false;
  this.isDoneTodaysCO = false;
  this.isContradicted = false;
  this.perspective = {};
  this.reliability = {};
  this.voteHistory = {};
  
  // /**
  //  * キャラクターが自己紹介する
  //  * @return {String} 自己紹介文
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
 * @prop {String} characterId キャラクターID
 * @prop {String} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function AiData() {
  this.characterId = CHARACTER_ID_AI;
  this.myName = 'アイ';
  this.myPersonality = new Tester();
}


/**
 * @classdec ヒヨリクラス（個別のキャラクターデータを定義する）
 * @prop {String} characterId キャラクターID
 * @prop {String} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function HiyoriData() {
  this.characterId = CHARACTER_ID_HIYORI;
  this.myName = 'ヒヨリ';
  this.myPersonality = new Tester();
}

/**
 * @classdec フタバクラス（個別のキャラクターデータを定義する）
 * @prop {String} characterId キャラクターID
 * @prop {String} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function FutabaData() {
  this.characterId = CHARACTER_ID_FUTABA;
  this.myName = 'フタバ';
  this.myPersonality = new Tester();
}

/**
 * @classdec ミキクラス（個別のキャラクターデータを定義する）
 * @prop {String} characterId キャラクターID
 * @prop {String} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function MikiData() {
  this.characterId = CHARACTER_ID_MIKI;
  this.myName = 'ミキ';
  this.myPersonality = new Tester();
}

/**
 * @classdec ダミークラス（個別のキャラクターデータを定義する）
 * @prop {String} characterId キャラクターID
 * @prop {String} myName キャラクターの名前
 * @prop {*} myPersonality 性格 性格オブジェクトを入れるようにする
 */
function DummyData() {
  this.characterId = CHARACTER_ID_DUMMY;
  this.myName = 'ダミー';
  this.myPersonality = new Tester();
}

/**
 * @classdec ずんだもんクラス（個別のキャラクターデータを定義する）
 * @prop {String} characterId キャラクターID
 * @prop {String} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
 function ZundamonData() {
  this.characterId = CHARACTER_ID_ZUNDAMON;
  this.myName = 'ずんだもん';
  this.myPersonality = new Tester();
}

/**
 * @classdec 四国めたんクラス（個別のキャラクターデータを定義する）
 * @prop {String} characterId キャラクターID
 * @prop {String} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function MetanData() {
  this.characterId = CHARACTER_ID_METAN;
  this.myName = '四国めたん';
  this.myPersonality = new Tester();
}

/**
 * @classdec 春日部つむぎクラス（個別のキャラクターデータを定義する）
 * @prop {String} characterId キャラクターID
 * @prop {String} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function TsumugiData() {
  this.characterId = CHARACTER_ID_TSUMUGI;
  this.myName = '春日部つむぎ';
  this.myPersonality = new Tester();
}

/**
 * @classdec 雨晴はうクラス（個別のキャラクターデータを定義する）
 * @prop {String} characterId キャラクターID
 * @prop {String} myName キャラクターの名前
 * @prop {*} myPersonality 性格 TODO 現在は性格の文字列。性格オブジェクトを入れるようにする
 */
function HauData() {
  this.characterId = CHARACTER_ID_HAU;
  this.myName = '雨晴はう';
  this.myPersonality = new Tester();
}

/**
 * @classdec 波音リツクラス（個別のキャラクターデータを定義する）
 * @prop {String} characterId キャラクターID
 * @prop {String} myName キャラクターの名前
 * @prop {*} myPersonality 性格 性格オブジェクトを入れるようにする
 */
function RitsuData() {
  this.characterId = CHARACTER_ID_RITSU;
  this.myName = '波音リツ';
  this.myPersonality = new Tester();
}
