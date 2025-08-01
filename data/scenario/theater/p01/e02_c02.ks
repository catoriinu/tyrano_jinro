*start
; チャプターごとに設定が必要な項目
[iscript]
// チャプターのタイトル（カットイン表示用。改行が必要なら<br>を入れる）
f.titleText = 'わたくしの千里眼―サウザンドアイ―に死角なし！<br>（解決編）';
// このチャプターを表す通し番号
f.pageId    = 'p01';
f.episodeId = 'e02';
f.chapterId = 'c02';

// 出演キャラリスト
tf.actorsList = [
    CHARACTER_ID_ZUNDAMON,
    CHARACTER_ID_METAN,
    CHARACTER_ID_HAU,
];

// 初期背景用パラメータ
tf.bgParams = {
    storage: "living_day.jpg",
}

// 初期BGM用パラメータ
tf.playbgmParams = {
    storage: "hirusagari_kibun.ogg",
    volume: "20",
}
[endscript]
[t_setupChapter titleText="&f.titleText" actorsList="&tf.actorsList" bgParams="&tf.bgParams" playbgmParams="&tf.playbgmParams"]

; ここからチャプター再生開始

[m_changeCharacterFrameName name="四国めたん" face="クスクス" side="left"]
[playse storage="theater/p01/e02/028.ogg" buf="1"]
これで否が応でも信じるしかなくなったわね！[r]
さあ、わたくしの力のお陰で勝てたと言いなさい！[p]

[m_changeCharacterFrameName name="ずんだもん" face="呆れ"]
[playse storage="theater/p01/e02/029.ogg" buf="1"]
ゲームはゲームなのだ。[r]
占い師の能力と千里眼は関係ないのだ。[p]

[m_changeCharacterFrameName name="四国めたん" face="困惑" side="left"]
[playse storage="se/shock3.ogg" buf="2" volume="40"]
[playse storage="theater/p01/e02/030.ogg" buf="1"]
なっ…！[r]
あんた、味方だったのに裏切るつもり！？[p]

[playse storage="theater/p01/e02/031.ogg" buf="1"]
それなら、はうさんの件はどうなの？[r]
部屋に来るタイミングを完璧に言い当てたじゃない！[p]

[m_changeCharacterFrameName name="ずんだもん" face="自惚れ"]
[playse storage="theater/p01/e02/032.ogg" buf="1"]
そもそも、はうが起きてくる時間は毎週大体この時間なのだ。[r]
千里眼なんて使わなくたって、僕でも知ってるのだ。[p]

[m_changeCharacterFrameName name="四国めたん" face="悲しみ" side="left"]
[playse storage="theater/p01/e02/033.ogg" buf="1"]
ぐ…ぐぬぬ…！[p]

[m_changeCharacterFrameName name="雨晴はう" face="通常"]
[playse storage="theater/p01/e02/034.ogg" buf="1"]
まあまあ、落ち着いてください。[r]
ずんだもんもあんまり否定するのは良くないですよ。[p]

[m_changeCharacterFrameName name="雨晴はう" face="安心"]
[playse storage="theater/p01/e02/035.ogg" buf="1"]
それじゃあめたんさん。[r]
今日の僕が何時に帰って来られるか、見てもらってもいいですか？[p]

[m_changeCharacterFrameName name="四国めたん" face="クスクス" side="left"]
[playse storage="se/shakiin1.ogg" volume="35" buf="2"]
[playse storage="theater/p01/e02/036.ogg" buf="1"]
ふ、ふふっ。そのくらいなら造作もないわ。[r]
さあ、全てを見通す[ruby text="サウ"]千[ruby text="ザンド"]里[ruby text="アイ"]眼よ、わたくしに時の壁を超える力を…！[p]

[stopse buf="2"]
[playse storage="se/mokugyo.ogg" buf="2" volume="60"]
[m_changeCharacterFrameName name="ずんだもん" face="考える"]
……。[p]

[m_changeCharacterFrameName name="雨晴はう" face="通常"]
……。[p]

[stopse buf="2"]
[m_changeCharacterFrameName name="四国めたん" face="興奮" side="left"]
[playse storage="theater/p01/e02/039.ogg" buf="1"]
ぐ…！[r]
ぐぬぬぬぬ…！[p]

[m_changeCharacterFrameName name="四国めたん" face="悲しみ" side="left"]
[playse storage="theater/p01/e02/040.ogg" buf="1"]
くっ…どうして…？はうさんの帰宅時間が見えない…！[r]
わたくしにはまだまだ力不足だとでも言うの…！？[p]

[m_changeCharacterFrameName name="雨晴はう" face="ため息"]
[playse storage="se/shogeru.ogg" buf="2" volume="70"]
[playse storage="theater/p01/e02/041.ogg" buf="1"]
はうう…やっぱり…。[r]
めたんさんの千里眼…本物かもしれません…！[p]

[m_changeCharacterFrameName name="四国めたん" face="恥ずかしい" side="left"]
[playse storage="theater/p01/e02/042.ogg" buf="1"]
ど、どういうこと？だってわたくしには何も…。[p]

[m_changeCharacterFrameName name="ずんだもん" face="呆れ" side="left"]
[playse storage="theater/p01/e02/043.ogg" buf="1"]
「今日の帰宅時間」が見えないのが正解ってこともあるのだ。[p]

[playse storage="theater/p01/e02/044.ogg" buf="1"]
はう、いつもお疲れ様なのだ。今日もお仕事頑張れなのだ…。[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]
[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]



; チャプター内で使うファイルをプリロードするサブルーチン
*preloadFiles
  [iscript]
    tf.preloadList = {
      singleUse: [
        "data/bgm/hirusagari_kibun.ogg",
        "data/sound/se/mokugyo.ogg",
        "data/sound/se/shakiin1.ogg",
        "data/sound/se/shock3.ogg",
        "data/sound/se/shogeru.ogg",
        "data/sound/theater/p01/e02/028.ogg",
        "data/sound/theater/p01/e02/029.ogg",
        "data/sound/theater/p01/e02/030.ogg",
        "data/sound/theater/p01/e02/031.ogg",
        "data/sound/theater/p01/e02/032.ogg",
        "data/sound/theater/p01/e02/033.ogg",
        "data/sound/theater/p01/e02/034.ogg",
        "data/sound/theater/p01/e02/035.ogg",
        "data/sound/theater/p01/e02/036.ogg",
        "data/sound/theater/p01/e02/039.ogg",
        "data/sound/theater/p01/e02/040.ogg",
        "data/sound/theater/p01/e02/041.ogg",
        "data/sound/theater/p01/e02/042.ogg",
        "data/sound/theater/p01/e02/043.ogg",
        "data/sound/theater/p01/e02/044.ogg",
        "data/bgimage/living_day.jpg",
      ],
      multiUse: [
      ]
    };
  [endscript]
  [preload storage="&tf.preloadList.singleUse" single_use="true"  name="chapterFilesSingleUse" cond="tf.preloadList.singleUse.length > 0"]
  [preload storage="&tf.preloadList.multiUse"  single_use="false" name="chapterFilesMultiUse" cond="tf.preloadList.multiUse.length > 0"]

  [return]
[s]
