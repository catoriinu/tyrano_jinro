/**
 * 人狼ゲームデータオブジェクト
 * 人狼ゲームを開始するにあたって必要なデータをまとめておく
 * @param {Object} 役職データ {役職ID: 人数, ...}
 * @param {Array<Participant>} 参加者リスト [Paticipantオブジェクト, ...]
 * @param {String} プレイヤーとなるキャラクターID
 */
function JinroGameData(roleData = {}, participantList = [], playerCharacterId = null) {
  this.roleData = roleData;
  this.participantList = participantList;
  this.playerCharacterId = playerCharacterId;
  this.ruleData = {}; // TBD
}


/**
 * シアターのページIDごとに、基本となる人狼ゲームデータオブジェクトを返却する
 * そのページIDのエピソードの全ての開始条件の最大公約数となるデータを設定しておくこと
 * @param {String} pageId 
 * @returns {JinroGameData|null} 人狼ゲームデータオブジェクト
 */
function getJinroGameDataForTheater(pageId) {
  switch (pageId) {
    case 'p01':
      return new JinroGameData(
        {
            [ROLE_ID_VILLAGER]: 2,
            [ROLE_ID_FORTUNE_TELLER]: 1,
            [ROLE_ID_WEREWOLF]: 1,
            [ROLE_ID_MADMAN]: 1
        },
        [
            new Participant(CHARACTER_ID_ZUNDAMON),
            new Participant(CHARACTER_ID_METAN),
            new Participant(CHARACTER_ID_TSUMUGI),
            new Participant(CHARACTER_ID_HAU),
            new Participant(CHARACTER_ID_RITSU),
        ],
        CHARACTER_ID_ZUNDAMON
      );
    default:
      return null;
  }
}


/**
 * 人狼ゲームデータと現在の人狼ゲームデータキーを初期化する
 */
function resetJinroGameDataObjectsToDefault() {
  TYRANO.kag.variable.sf.jinroGameDataObjects = {
    current: getJinroGameDataForTheater('p01')
  };
  TYRANO.kag.variable.sf.currentJinroGameDataKey = 'current';
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
 * 人狼ゲームデータから、指定されたキャラクターIDの参加者オブジェクトを取得、返却する
 * ※キャラクターIDが重複しているケースは考えない。最初に見つかったオブジェクトのみ返却する
 * @param {JinroGameData} jinroGameData 人狼ゲームデータ
 * @param {String} characterId 取得したい参加者オブジェクトのキャラクターID
 * @returns {Participant|undefined} 参加者オブジェクト。見つからなければundefined
 */
function findParticipantWithCharacterIdFromJinroGameData(jinroGameData, characterId) {
  return jinroGameData.participantList.find((participant) => participant.characterId === characterId);
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
