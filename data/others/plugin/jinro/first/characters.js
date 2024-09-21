/**
 * @classdec キャラクター情報を格納するクラス
 * @param {String} characterId キャラクターID
 * @param {String} roleId 役職ID
 * @param {String} personalityName 性格クラス名（指定がなければキャラクターIDが性格クラス名になる）
 * @param {Object} adjustParameters 性格調整用のパラメータオブジェクト。なければ無調整。
 * @prop {String} characterId キャラクターID
 * @prop {String} name キャラクターの名前
 * @prop {Object} role 役職オブジェクト
 * @prop {Object} fakeRole 騙りの役職オブジェクト。騙りCOするときに格納する。
 * @prop {String} CORoleId 自身がCOしている役職ID。空文字は未CO（役職なし＝村人と同義）
 * @prop {Object} personality 性格オブジェクト。性格クラス名を元に取得してくる。
 * @prop {Boolean} isAlive 生存者か
 * @prop {Boolean} isPlayer プレイヤーか
 * @prop {Boolean} isDoneTodaysCO 今日の役職COが済んでいるか
 * @prop {Boolean} isContradicted 自分のCO状況が破綻済みか
 * @prop {Object} perspective 現在CO中の視点オブジェクト（未COなら村人として振る舞う）
 * @prop {Object} reliability 信頼度オブジェクト {characterId:0以上1以下かつ小数点第二位までの数値,...}
 * @prop {Object} voteHistory 投票履歴オブジェクト {day:[1回目の投票先characterId,2回目(再投票)の投票先characterId,...],...}
 * @prop {Object} currentFrustration 現在のフラストレーションオブジェクト {characterId:デフォルト0から上限なし,...}
 */
function Character(characterId, roleId, personalityName = null, adjustParameters = {}) {
  this.characterId = characterId;
  this.name = PARTICIPANTS_LIST.find(participant => participant.characterId === characterId).name;
  this.personality = (function(){
    const name = personalityName ? personalityName : characterId;
    return getPersonality(name, adjustParameters);
  })();
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
  this.currentFrustration = {};
}
