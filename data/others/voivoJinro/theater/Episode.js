/**
 * エピソード
 * @param {String} pageId ページID（そのエピソードが属するページ）（例:'p01'）
 * @param {String} episodeId エピソードID（例:'e01'）
 * @param {String} title エピソードのタイトル名（シアター画面表示用）
 * @param {String} thumbnail エピソードのサムネイル画像パス（シアター画面表示用）。fgimageフォルダからの相対パス
 * @param {String} startConditionText エピソード開始条件テキスト（シアター画面表示用）
 * @param {String} unlockConditionText エピソード解放条件テキスト（シアター画面表示用）
 * @param {Chapter} introChapter 導入編のチャプターオブジェクト
 * @param {Chapter} outroChapter 解決編のチャプターオブジェクト
 * @param {JinroGameData|null} situationJinroGameData このエピソードのシチュエーションに合致する人狼ゲームデータ。特定のシチュエーションがないならnullを渡すこと
 * @param {ResultCondition|null} outroUnlockCondition シチュエーション完遂チェック用の終了状況オブジェクト。解決編を解放するための条件を格納する。
 * 解決編がないならnullを渡す。必ず解決編を解放していいならnew ResultCondition()のまま渡すこと
 */
function Episode(
    pageId,
    episodeId,
    title,
    thumbnail,
    startConditionText,
    unlockConditionText,
    introChapter,
    outroChapter,
    situationJinroGameData,
    resultCondition,
) {
    this.pageId = pageId;
    this.episodeId = episodeId;
    this.title = title;
    this.thumbnail = thumbnail;
    this.startConditionText = startConditionText;
    this.unlockConditionText = unlockConditionText;
    this.introChapter = introChapter;
    this.outroChapter = outroChapter;
    this.situationJinroGameData = situationJinroGameData;
    this.outroUnlockCondition = resultCondition;
}
