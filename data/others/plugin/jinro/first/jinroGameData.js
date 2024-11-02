function JinroGameData(roleData = {}, participantList = []) {
  this.roleData = roleData;
  this.participantList = participantList;
  this.ruleData = {};
}


function getParticipantWithIndexFromJinroGameData(jinroGameData, index) {
  return jinroGameData.participantList[index];
}
