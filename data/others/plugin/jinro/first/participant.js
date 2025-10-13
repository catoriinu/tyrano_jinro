const PARTICIPATION = {
  CONFIRMED: 0, // 参加確定
  CANDIDATE: 1, // 参加候補
  DECLINED: 2,  // 不参加
}

/**
 * 参加者オブジェクト
 * 人狼ゲームの準備段階で生成する、参加者としての最低限の情報のみを格納できるオブジェクト。人狼ゲーム内では用いない
 * @param {String} characterId キャラクターID。必須
 * @param {String|Array|null} roleId 文字列の場合、役職ID。配列の場合、候補となる役職ID。指定しない場合、役職はランダムに決定される
 * @param {String} personalityName 性格名。指定しない場合、キャラクターのデフォルトの性格になる
 * @param {Object} adjustParameters 性格調整用のパラメータオブジェクト。なければ無調整。
 */
function Participant(characterId, roleIdParam = null, personalityName = null, adjustParameters = {}) {
  this.characterId = characterId;
  this.roleId = Array.isArray(roleIdParam) ? null : roleIdParam; // roleIdParamが配列でなければ、役職IDをいれる
  this.candidateRoleIds = Array.isArray(roleIdParam) ? roleIdParam : []; // roleIdParamが配列なら、候補となる役職ID配列にいれる
  this.participationStatus = PARTICIPATION.CONFIRMED // PARTICIPATION.DECLINED、PARTICIPATION.CANDIDATE
  this.personalityName = personalityName;
  this.adjustParameters = adjustParameters;
}
