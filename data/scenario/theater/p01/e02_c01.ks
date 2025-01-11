; タイトル：わたくしの千里眼―サウザンドアイ―に死角なし！（導入編）

*start
; ここからチャプターごとに設定が必要な項目
[iscript]
// チャプターのタイトル（カットイン表示用。改行が必要なら<br>を入れる）
f.titleText = 'わたくしの千里眼―サウザンドアイ―に死角なし！<br>（導入編）';
// このチャプターを表す通し番号
f.pageId    = 'p01';
f.episodeId = 'e02';
f.chapterId = 'c01';

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
[playse storage="theater/p01/e02/001.ogg"]
ふふ…うふふ…！[p]

[m_changeCharacterFrameName name="ずんだもん"]
……。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/003.ogg"]
ああ、ついに手に入れてしまったわ…チラッ。[p]

[m_changeCharacterFrameName name="ずんだもん"]
……。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/005.ogg"]
ちょっと、ずんだもん！[r]
今、わたくしに気付いたのに無視したでしょう？[p]

[m_changeCharacterFrameName name="ずんだもん"]
[playse storage="theater/p01/e02/006.ogg"]
そんなことないのだ。[r]
リビングで独り言呟いてるめたんなんて見てないのだ。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/007.ogg"]
しっかりはっきりばっちり見てるじゃない！[r]
だったら『何を手に入れたのだ？』って聞きなさいよ。[p]

[m_changeCharacterFrameName name="ずんだもん"]
[playse storage="theater/p01/e02/008.ogg"]
今日のめたんはいつになく構ってちゃんモードなのだ…。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/009.ogg"]
何か言ったかしら？[p]

[m_changeCharacterFrameName name="ずんだもん"]
[playse storage="theater/p01/e02/010.ogg"]
なんでもないのだ。[r]
それで、何を手に入れたのだ？[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/011.ogg"]
ふっふっふ。聞いて驚きなさい。[r]
わたくしが手に入れたのは千里眼…そう、サウザンドアイ！[p]

[m_changeCharacterFrameName name="ずんだもん"]
[playse storage="theater/p01/e02/012.ogg"]
何のひねりもないのだ。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/013.ogg"]
お黙り！[p]

[playse storage="theater/p01/e02/014.ogg"]
まあいいわ。わたくしの千里眼の力を思い知れば、そんな減らず口は叩けなくなるのだから。[p]

[playse storage="theater/p01/e02/015.ogg"]
むむむ…見える。見えるわ。[r]
まもなくはうさんがここにやってくる姿が。[p]

[m_changeCharacterFrameName name="雨晴はう"]
[playse storage="theater/p01/e02/016.ogg"]
おはようございます、めたんさん、ずんだもん。[r]
二人とも今日もお元気そうですね。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/017.ogg"]
ほーら！見たでしょう！[r]
どうかしらわたくしの千里眼の実力は！[p]

[m_changeCharacterFrameName name="雨晴はう"]
[playse storage="theater/p01/e02/018.ogg"]
ええっと…いったい何の話ですか？[p]

[m_changeCharacterFrameName name="ずんだもん"]
[playse storage="theater/p01/e02/019.ogg"]
…実はかくかくしかじかというわけなのだ。[p]

[playse storage="theater/p01/e02/020.ogg"]
めたんがさっきからこの調子なのだ。[r]
めたんのことを診てやってほしいのだ。[p]

[m_changeCharacterFrameName name="雨晴はう"]
[playse storage="theater/p01/e02/021.ogg"]
と言われても、本当は看護師は診察できないんですけど…。[p]

[playse storage="theater/p01/e02/022.ogg"]
でもこの症状は間違いないですね。厨二病です。[p]

[m_changeCharacterFrameName name="ずんだもん"]
[playse storage="theater/p01/e02/023.ogg"]
そんなぁ…治す方法はないのだ？[p]

[m_changeCharacterFrameName name="雨晴はう"]
[playse storage="theater/p01/e02/024.ogg"]
唯一の薬が手に入るのは数年後になりますね。[r]
黒歴史という名前の特効薬です。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="theater/p01/e02/025.ogg"]
二人とも好き放題言ってくれるじゃない…！[p]

[playse storage="theater/p01/e02/026.ogg"]
いいわ！そんなに言うなら証明してみせるわよ！[r]
わたくしの千里眼の真の力を！[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]
[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]
