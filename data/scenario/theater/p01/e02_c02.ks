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
    storage: "living_day_nc238325.jpg",
}

// 初期BGM用パラメータ
tf.playbgmParams = {
    storage: "honwakapuppu.ogg",
    volume: "12",
}
[endscript]
[t_setupChapter titleText="&f.titleText" actorsList="&tf.actorsList" bgParams="&tf.bgParams" playbgmParams="&tf.playbgmParams"]

; ここからチャプター視聴開始

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/028.ogg"]
これで否が応でも信じるしかなくなったわね！[r]
さあ、わたくしの力のお陰で勝てたと言いなさい！[p]

[m_changeCharacterFrameName name="ずんだもん"]
[playse storage="theater/p01/e02/029.ogg"]
ゲームはゲームなのだ。[r]
占い師の能力と千里眼は関係ないのだ。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/030.ogg"]
なっ…！[r]
あんた、味方だったのに裏切るつもり！？[p]

[playse storage="theater/p01/e02/031.ogg"]
それなら、はうさんの件はどうなの？[r]
部屋に来るタイミングを完璧に言い当てたじゃない！[p]

[m_changeCharacterFrameName name="ずんだもん"]
[playse storage="theater/p01/e02/032.ogg"]
そもそも、はうが起きてくる時間は毎週大体この時間なのだ。[r]
千里眼なんて使わなくたって、僕でも知ってるのだ。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/033.ogg"]
ぐ…ぐぬぬ…！[p]

[m_changeCharacterFrameName name="雨晴はう"]
[playse storage="theater/p01/e02/034.ogg"]
まあまあ、落ち着いてください。[r]
ずんだもんもあんまり否定するのは良くないですよ。[p]

[playse storage="theater/p01/e02/035.ogg"]
それじゃあめたんさん。[r]
今日の僕が何時に帰って来られるか、見てもらってもいいですか？[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/036.ogg"]
ふ、ふふっ。そのくらいなら造作もないわ。[r]
さあ、全てを見通す千里眼よ、わたくしに時の壁を超える力を…！[p]

[m_changeCharacterFrameName name="ずんだもん"]
……。[p]

[m_changeCharacterFrameName name="雨晴はう"]
……。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/039.ogg"]
ぐ…！[r]
ぐぬぬぬぬ…！[p]

[playse storage="theater/p01/e02/040.ogg"]
くっ…どうして…？はうさんの帰宅時間が見えない…！[r]
わたくしにはまだまだ力不足だとでも言うの…！？[p]

[m_changeCharacterFrameName name="雨晴はう"]
[playse storage="theater/p01/e02/041.ogg"]
はうう…やっぱり…。[r]
めたんさんの千里眼…本物かもしれません…！[p]


[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/042.ogg"]
ど、どういうこと？だってわたくしには何も…。[p]

[m_changeCharacterFrameName name="ずんだもん"]
[playse storage="theater/p01/e02/043.ogg"]
「今日の帰宅時間」が見えないのが正解ってこともあるのだ。[p]

[playse storage="theater/p01/e02/044.ogg"]
はう、いつもお疲れ様なのだ。今日もお仕事頑張れなのだ…。[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]
[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]
