/**
 * チャプター
 * @param {String} id チャプターID（例:'c01'） NOTE:今のところ参照箇所なし
 * @param {String} storage 「導入編を見る」「解決編を見る」ボタンからジャンプするシナリオファイル（シアター画面表示用）。scenarioフォルダからの相対パス
 */
function Chapter(
    id,
    storage,
) {
    this.id = id;
    this.storage = storage;
}
