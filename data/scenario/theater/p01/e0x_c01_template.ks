*start
; チャプターごとに設定が必要な項目
[iscript]
// チャプターのタイトル（カットイン表示用。改行が必要なら<br>を入れる）
f.titleText = 'テンプレート<br>（導入編）';
// このチャプターを表す通し番号
f.pageId    = 'p01';
f.episodeId = 'e01';
f.chapterId = 'c01';

// 出演キャラリスト
tf.actorsList = [
    CHARACTER_ID_ZUNDAMON,
    CHARACTER_ID_METAN,
    CHARACTER_ID_TSUMUGI,
    CHARACTER_ID_HAU,
    CHARACTER_ID_RITSU,
];

// 初期背景用パラメータ
tf.bgParams = {
    storage: "living_day.jpg",
}

// 初期BGM用パラメータ
tf.playbgmParams = {
    storage: "honwakapuppu.ogg",
    volume: "12",
}
[endscript]
[t_setupChapter titleText="&f.titleText" actorsList="&tf.actorsList" bgParams="&tf.bgParams" playbgmParams="&tf.playbgmParams"]

; ここからチャプター再生開始


; セリフ例
;[m_changeCharacterFrameName name="ずんだもん" face="否定"]
;[playse storage="chara/zundamon/01-01/001_ずんだもん（なみだめ）_うわあ！？ない！な….ogg" sprite_time="50-20000"]
;うわあああ！？ない！ないのだ！[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]
[jump storage="theater/main.ks" target="*start"]
[s]



; チャプター内で使うファイルをプリロードするサブルーチン
*preloadFiles
  [iscript]
    tf.preloadList = {
      singleUse: [
      ],
      multiUse: [
      ]
    };
  [endscript]
  [preload storage="&tf.preloadList.singleUse" single_use="true"  name="chapterFilesSingleUse" cond="tf.preloadList.singleUse.length > 0"]
  [preload storage="&tf.preloadList.multiUse"  single_use="false" name="chapterFilesMultiUse" cond="tf.preloadList.multiUse.length > 0"]

  [return]
[s]