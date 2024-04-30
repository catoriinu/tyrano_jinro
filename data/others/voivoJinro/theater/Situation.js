/**
 * シチュエーション
 * @param {Number} participantsNumber このシチュエーションでプレイするときの参加者の人数
 * @param {Array} participantsList このシチュエーションでプレイするとき固定で参加する参加者とその役職。Participantオブジェクトを格納した配列形式
 */
function Situation(
    participantsNumber,
    participantsList,
) {
    this.participantsNumber = participantsNumber;
    this.participantsList = participantsList;
}
