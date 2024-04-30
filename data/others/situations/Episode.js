/**
 * エピソード
 * @param {String} id エピソードID（例:'e01'）
 * @param {String} title シチュエーションのタイトル名（シアター画面表示用）
 * @param {String} thumbnail シチュエーションのサムネイル画像パス（シアター画面表示用）。fgimageフォルダからの相対パス
 * @param {String} unlockCondition シチュエーション解放条件テキスト（シアター画面表示用）
 * @param {String|null} cantPlayReason 「このシチュエーションでプレイする」ボタンを表示できない理由（シアター画面表示用）。表示してよいならnullを渡すこと
 * @param {Chapter} introChapter 導入編のチャプターオブジェクト
 * @param {Chapter} outroChapter 解決編のチャプターオブジェクト
 * @param {Situation_new} situation シチュエーションオブジェクト TODO
*/
function Episode(
    id,
    title,
    thumbnail,
    unlockCondition,
    cantPlayReason,
    introChapter,
    outroChapter,
    situation,
) {
    this.id = id;
    this.title = title;
    this.thumbnail = thumbnail;
    this.unlockCondition = unlockCondition;
    this.cantPlayReason = cantPlayReason;
    this.introChapter = introChapter;
    this.outroChapter = outroChapter;
    this.situation = situation;
}
