/**
 * 
 * @param {String} title シチュエーションのタイトル名（シアター画面表示用）
 * @param {String} thumbnail シチュエーションのサムネイル画像パス（シアター画面表示用）。fgimageフォルダからの相対パス
 * @param {String} unlockCondition シチュエーション解放条件テキスト（シアター画面表示用）
 * @param {String|null} cantSituationPlay 「このシチュエーションでプレイする」ボタンを表示できない理由（シアター画面表示用）。表示してよいならnullを渡すこと
 * @param {String} introStorage 「導入編を見る」ボタンからジャンプするシナリオファイル（シアター画面表示用）。scenarioフォルダからの相対パス
 * @param {String} outroStorage 「解決編を見る」ボタンからジャンプするシナリオファイル（シアター画面表示用）。scenarioフォルダからの相対パス
 * @param {AchievementCondition} achievementCondition 解放条件オブジェクト。このシチュエーションの解決編を解放するための条件を格納する。
 * @param {Number} situationParticipantsNumber このシチュエーションでプレイするときの参加者の人数
 * @param {Array} situationParticipants このシチュエーションでプレイするとき固定で参加する参加者とその役職。Participantオブジェクトを格納した配列形式
*/
function Situation(
    title,
    thumbnail,
    unlockCondition,
    cantSituationPlay,
    introStorage,
    outroStorage,
    achievementCondition,
    situationParticipantsNumber,
    situationParticipants,
    
) {
    this.title = title;
    this.thumbnail = thumbnail;
    this.unlockCondition = unlockCondition;
    this.cantSituationPlay = cantSituationPlay;
    this.introStorage = introStorage;
    this.outroStorage = outroStorage;
    this.achievementCondition = achievementCondition;
    this.situationParticipantsNumber = situationParticipantsNumber;
    this.situationParticipants = situationParticipants;
    this.introProgress = THEATER_LOCKED; // 導入編の解放状況
    this.outroProgress = THEATER_LOCKED; // 解決編の解放状況
}


function updateIntroProgress(situation, progress) {
    situation.introProgress = progress;
    return situation;
}

function updateOutroProgress(situation, progress) {
    situation.outroProgress = progress;
    return situation;
}

function updateTitle(situation, title) {
    situation.title = title;
    return situation;
}

function updateThumbnail(situation, thumbnail) {
    situation.thumbnail = thumbnail;
    return situation;
}

function isIntroProgressLocked(situation) {
    return (situation.introProgress === THEATER_LOCKED);
}

function isOutroProgressLocked(situation) {
    return (situation.outroProgress === THEATER_LOCKED);
}


function needCheckAchievementCondition(situation) {
    // 導入編が解放済み、かつ解決編がロック中である
    return (!isIntroProgressLocked(situation) && isOutroProgressLocked(situation));
}
