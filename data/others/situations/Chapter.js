/**
 * チャプター
 * @param {String} id チャプターID（例:'c01'）
 * @param {String} storage 「導入編を見る」「解決編を見る」ボタンからジャンプするシナリオファイル（シアター画面表示用）。scenarioフォルダからの相対パス
 * @param {AchievementCondition} achievementCondition 解放条件オブジェクト。このシチュエーションの解決編を解放するための条件を格納する。
 */
function Chapter(
    id,
    storage,
    achievementCondition,
) {
    this.id = id;
    this.storage = storage;
    this.achievementCondition = achievementCondition;
}
