/**
 * @classdec キャラクター情報を格納するクラス
 * @param {Participant} 参加者オブジェクト {characterId: キャラクターID, roleId: 役職ID, personalityName?: 性格クラス名, adjustParameters?: 性格調整用のパラメータオブジェクト}
 * @prop {String} characterId キャラクターID
 * @prop {String} name キャラクターの名前
 * @prop {Object} role 役職オブジェクト
 * @prop {Object} fakeRole 騙りの役職オブジェクト。騙りCOするときに格納する。
 * @prop {String} CORoleId 自身がCOしている役職ID。空文字は未CO（役職なし＝村人と同義）
 * @prop {Object} personality 性格オブジェクト。性格クラス名を元に取得してくる。（指定がなければキャラクターIDが性格クラス名になる）
 * @prop {Boolean} isAlive 生存者か
 * @prop {Boolean} isPlayer プレイヤーか
 * @prop {Boolean} isDoneTodaysCO 今日の役職COが済んでいるか
 * @prop {Boolean} isContradicted 自分のCO状況が破綻済みか
 * @prop {Object} perspective 現在CO中の視点オブジェクト（未COなら村人として振る舞う）
 * @prop {Object} reliability 信頼度オブジェクト {characterId:0以上1以下かつ小数点第二位までの数値,...}
 * @prop {Object} voteHistory 投票履歴オブジェクト {day:[1回目の投票先characterId,2回目(再投票)の投票先characterId,...],...}
 * @prop {Object} currentFrustration 現在のフラストレーションオブジェクト {characterId:デフォルト0から上限なし,...}
 */
function Character(participant) {
  this.characterId = participant.characterId;
  this.name = PARTICIPANTS_LIST.find(ptp => ptp.characterId === this.characterId).name;
  this.personality = (function(){
    const name = participant.personalityName || this.characterId;
    return getPersonality(name, participant.adjustParameters);
  })();
  this.role = roleAssignment(participant.roleId);
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
