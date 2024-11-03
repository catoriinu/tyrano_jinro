/**
 * 人狼ゲームデータオブジェクト
 * 人狼ゲームを開始するにあたって必要なデータをまとめておく
 * @param {Object} 役職データ {役職ID: 人数, ...}
 * @param {Array<Participant>} 参加者リスト [Paticipantオブジェクト, ...]
 */
function JinroGameData(roleData = {}, participantList = []) {
  this.roleData = roleData;
  this.participantList = participantList;
  this.ruleData = {}; // TBD
}


/**
 * 人狼ゲームデータから、指定された要素数番目の参加者オブジェクトを取得、返却する
 * @param {JinroGameData} jinroGameData 人狼ゲームデータ
 * @param {Number} index 取得したい参加者オブジェクトの要素数番目
 * @returns {Participant} 参加者オブジェクト
 */
function getParticipantWithIndexFromJinroGameData(jinroGameData, index) {
  return jinroGameData.participantList[index];
}


/**
 * 人狼ゲームデータの指定された要素数番目の参加者オブジェクトを、新しい参加者オブジェクトで置き換える
 * @param {JinroGameData} jinroGameData 人狼ゲームデータ
 * @param {Number} index 置き換えたい参加者オブジェクトの要素数番目
 * @param {Participant} 新しい参加者オブジェクト
 */
function replaceParticipantInJinroGameData(jinroGameData, index, participant) {
  jinroGameData.participantList[index] = participant;
}


/**
 * 人狼ゲームデータ内の役職データと参加者リストの情報をもとに、役職の残り人数を表した役職データを返却する
 * @param {JinroGameData} jinroGameData 人狼ゲームデータ
 * @returns 役職の残り人数を表したroleData
 */
function getRoleDataWithRemainingCapacity(jinroGameData) {
  // 現在のroleDataをコピーする
  const roleDataWithRemainingCapacity = Object.assign({}, jinroGameData.roleData);

  // participantListを回して、現在確定済みの役職の分の人数を減らしていく
  for (const participant of jinroGameData.participantList) {
    // 役職未定のnullである場合は何もしない
    if (participant.roleId === null) continue;

    roleDataWithRemainingCapacity[participant.roleId]--;
  }

  // 役職の残り人数を表したroleDataを返却する
  return roleDataWithRemainingCapacity;
}
