function JinroGameData(roleData = {}, participantList = []) {
  this.roleData = roleData;
  this.participantList = participantList;
  this.ruleData = {};
}


function getParticipantWithIndexFromJinroGameData(jinroGameData, index) {
  return jinroGameData.participantList[index];
}

function replaceParticipantInJinroGameData(jinroGameData, index, participant) {
  jinroGameData.participantList[index] = participant;
}

function getParticipantWithIndexFromJinroGameData(jinroGameData, index) {
  return jinroGameData.participantList[index];
}

function getRoleDataWithRemainingCapacity(jinroGameData) {
  console.log('★getRoleDataWithRemainingCapacity');
  // 現在のroleDataをコピーする
  const roleDataWithRemainingCapacity = Object.assign({}, jinroGameData.roleData);

  // participantListを回して、現在確定済みの役職の分の人数を減らしていく
  for (const participant of jinroGameData.participantList) {
    // 役職未定のnullである場合は何もしない
    if (participant.roleId === null) continue;

    roleDataWithRemainingCapacity[participant.roleId]--;
  }

  // 役職の残り人数を表したroleDataを返却する
  console.log('★roleDataWithRemainingCapacity');
  console.log(roleDataWithRemainingCapacity);
  return roleDataWithRemainingCapacity;
}
