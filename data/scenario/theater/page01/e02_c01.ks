; タイトル：わたくしの千里眼―サウザンドアイ―に死角なし！（導入編）

; ここからチャプターごとに設定が必要な項目
[iscript]
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
[t_setupChapter actorsList="&tf.actorsList" bgParams="&tf.bgParams" playbgmParams="&tf.playbgmParams"]

; ここからチャプター視聴開始

[m_changeCharacterFrameName name="四国めたん"]
ふふ…うふふ…！[p]

[m_changeCharacterFrameName name="ずんだもん"]
……。[p]

[m_changeCharacterFrameName name="四国めたん"]
ああ、ついに手に入れてしまったわ…チラッ。[p]

[m_changeCharacterFrameName name="ずんだもん"]
……。[p]

[m_changeCharacterFrameName name="四国めたん"]
ちょっと、今わたくしに気付いたのに無視したでしょう？[p]

[m_changeCharacterFrameName name="ずんだもん"]
そんなことないのだ。[r]
リビングで独り言呟いてるめたんなんて見てないのだ。[p]

[m_changeCharacterFrameName name="四国めたん"]
しっかりはっきりばっちり見てるじゃない！[r]
だったら『何を手に入れたのだ？』って聞きなさいよ。[p]

[m_changeCharacterFrameName name="ずんだもん"]
今日のめたんはいつになく構ってちゃんモードなのだ…。[p]

[m_changeCharacterFrameName name="四国めたん"]
何か言ったかしら？[p]

[m_changeCharacterFrameName name="ずんだもん"]
なんでもないのだ。[r]
それで、何を手に入れたのだ？[p]

[m_changeCharacterFrameName name="四国めたん"]
ふふふ、聞いて驚きなさい。[r]
わたくしが手に入れたのは千里眼…そう、サウザンドアイ！[p]

[m_changeCharacterFrameName name="ずんだもん"]
何のひねりもないのだ。[p]

[m_changeCharacterFrameName name="四国めたん"]
お黙り！[p]

まあいいわ。わたくしの千里眼の力を思い知れば、そんな減らず口は叩けなくなるのだから。[p]

むむむ…見える。見えるわ。[r]
まもなくはうさんがここにやってくる姿が。[p]

[m_changeCharacterFrameName name="雨晴はう"]
おはようございます、めたんさん、ずんだもん。[r]
二人とも今日もお元気そうですね。[p]

[m_changeCharacterFrameName name="四国めたん"]
ほーら！見たでしょう！[r]
どうかしらわたくしの千里眼の実力は！[p]

[m_changeCharacterFrameName name="雨晴はう"]
ええと…いったい何の話ですか？[p]

[m_changeCharacterFrameName name="ずんだもん"]
…実はかくかくしかじかというわけなのだ。[p]

めたんがさっきからこの調子なのだ。[r]
めたんのことを診てやってほしいのだ。[p]

[m_changeCharacterFrameName name="雨晴はう"]
と言われても、本当は看護師は診察できないんですけど…。[p]

でもこの症状は間違いないですね。厨二病です。[p]

[m_changeCharacterFrameName name="ずんだもん"]
そんなぁ…治す方法はないのだ？[p]

[m_changeCharacterFrameName name="雨晴はう"]
唯一の薬が手に入るのは数年後になりますね。[r]
黒歴史という名前の特効薬です。[p]

[m_changeCharacterFrameName name="四国めたん"]
二人とも好き放題言ってくれるじゃない…！[p]

いいわ！そんなに言うなら証明してみせるわよ！[r]
わたくしの千里眼の真の力を！[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]
[jump storage="theater/main.ks" target="*start"]
[s]
