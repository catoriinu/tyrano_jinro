/**
 * チャプター
 * @param {String} id チャプターID（例:'c01'） NOTE:今のところ参照箇所なし
 * @param {String} storage 「導入編を見る」「解決編を見る」ボタンからジャンプするシナリオファイル（シアター画面表示用）。scenarioフォルダからの相対パス
 * @param {AchievementCondition|null} achievementCondition 解放条件オブジェクト。このチャプターを解放するための条件を格納する。無条件ならnullを渡すこと（例：初めから解放されている）
 */
function Chapter(
    id,
    storage,
    achievementCondition = null,
) {
    this.id = id;
    this.storage = storage;
    this.achievementCondition = (achievementCondition == null) ? new AchievementCondition() : achievementCondition;
}
