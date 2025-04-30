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
    storage: "living_day.jpg",
}

// 初期BGM用パラメータ
tf.playbgmParams = {
    storage: "nichiyouno_gogo_1loop.ogg",
    volume: "12",
}
[endscript]
[t_setupChapter titleText="&f.titleText" actorsList="&tf.actorsList" bgParams="&tf.bgParams" playbgmParams="&tf.playbgmParams"]

; ここからチャプター視聴開始

[m_changeCharacterFrameName name="四国めたん" face="クスクス" side="left"]
[playse storage="theater/p01/e02/001.ogg"]
ふふ…うふふ…！[r]
…チラッ。[p]

[stopse buf="0"]
[m_changeCharacterFrameName name="ずんだもん" face="無"]
[playse storage="se/mokugyo.ogg" buf="1" volume="60"]
……。[p]

[stopse buf="1"]
[m_changeCharacterFrameName name="四国めたん" face="クスクス" side="left"]
[playse storage="theater/p01/e02/003.ogg"]
ああ、ついに手に入れてしまったわ…！[r]
…チラッ。[p]

[stopse buf="0"]
[m_changeCharacterFrameName name="ずんだもん" face="無"]
[playse storage="se/mokugyo.ogg" buf="1" volume="60"]
……。[p]

[stopse buf="1"]
[m_changeCharacterFrameName name="四国めたん" face="真剣" side="left"]
[playse storage="theater/p01/e02/005.ogg"]
ちょっと、ずんだもん！[r]
今、わたくしに気付いたのに無視したでしょう？[p]

[m_changeCharacterFrameName name="ずんだもん" face="呆れ"]
[playse storage="theater/p01/e02/006.ogg"]
そんなことないのだ。[r]
リビングで独り言呟いてるめたんなんて見てないのだ。[p]

[m_changeCharacterFrameName name="四国めたん" face="興奮" side="left"]
[playse storage="se/tsukkomi2.ogg" buf="1" volume="50"]
[playse storage="theater/p01/e02/007.ogg"]
しっかりはっきりばっちり見てるじゃない！[r]
だったら「何を手に入れたのだ？」って聞きなさいよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="無"]
[playse storage="theater/p01/e02/008.ogg"]
今日のめたんはいつになく構ってちゃんモードなのだ…。[p]

[m_changeCharacterFrameName name="四国めたん" face="目閉じ" side="left"]
[playse storage="theater/p01/e02/009.ogg"]
何か言ったかしら？[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常"]
[playse storage="theater/p01/e02/010.ogg"]
なんでもないのだ。[r]
それで、何を手に入れたのだ？[p]

[m_changeCharacterFrameName name="四国めたん" face="クスクス" side="left"]
[playse storage="theater/p01/e02/011.ogg"]
ふっふっふ。聞いて驚きなさい。[r]
わたくしが手に入れたのは千里眼…そう、サウザンドアイ！[p]

[m_changeCharacterFrameName name="ずんだもん" face="呆れ"]
[playse storage="theater/p01/e02/012.ogg"]
何のひねりもないのだ。[p]

[m_changeCharacterFrameName name="四国めたん" face="真剣" side="left"]
[playse storage="se/wadaiko_don.ogg" buf="1" volume="60"]
[playse storage="theater/p01/e02/013.ogg"]
お黙り！[p]

[m_changeCharacterFrameName name="四国めたん" face="通常" side="left"]
[playse storage="theater/p01/e02/014.ogg"]
まあいいわ。わたくしの[ruby text="サウ"]千[ruby text="ザンド"]里[ruby text="アイ"]眼の力を思い知れば、そんな減らず口は叩けなくなるのだから。[p]

[m_changeCharacterFrameName name="四国めたん" face="目閉じ" side="left"]
[playse storage="shakiin1.ogg" volume="35" buf="1"]
[playse storage="theater/p01/e02/015.ogg"]
むむむ…見える。見えるわ。[r]
まもなくはうさんがここにやってくる姿が。[p]

[stopse buf="0"]
#
[m_changeFrameWithId frameId="none"]
[playse storage="se/open_door1.ogg" buf="1" volume="60"]
[wse]

[m_changeCharacterFrameName name="雨晴はう" face="通常"]
[playse storage="theater/p01/e02/016.ogg"]
おはようございます、めたんさん、ずんだもん。[r]
二人とも今日もお元気そうですね。[p]

[m_changeCharacterFrameName name="四国めたん" face="クスクス" side="left"]
[playse storage="se/kira1.ogg" buf="1" volume="50"]
[playse storage="theater/p01/e02/017.ogg"]
ほーら！見たでしょう！[r]
どうかしらわたくしの[ruby text="サウ"]千[ruby text="ザンド"]里[ruby text="アイ"]眼の実力は！[p]

[m_changeCharacterFrameName name="雨晴はう" face="考える"]
[playse storage="se/hatena01-1.ogg" buf="1" volume="60"]
[playse storage="theater/p01/e02/018.ogg"]
ええっと…いったい何の話ですか？[p]

[m_changeCharacterFrameName name="ずんだもん" face="呆れ" side="left"]
[playse storage="theater/p01/e02/019.ogg"]
…実はかくかくしかじかというわけなのだ。[p]

[playse storage="theater/p01/e02/020.ogg"]
めたんがさっきからこの調子なのだ。[r]
めたんのことを診てやってほしいのだ。[p]

[m_changeCharacterFrameName name="雨晴はう" face="考える"]
[playse storage="theater/p01/e02/021.ogg"]
と言われても、本当は看護師は診察できないんですけど…。[p]

[m_changeCharacterFrameName name="雨晴はう" face="苦笑"]
[playse storage="theater/p01/e02/022.ogg"]
でもこの症状は間違いないですね。厨二病です。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e02/023.ogg"]
そんなぁ…治す方法はないのだ？[p]

[m_changeCharacterFrameName name="雨晴はう" face="苦笑"]
[playse storage="theater/p01/e02/024.ogg"]
唯一の薬が手に入るのは数年後になりますね。[r]
黒歴史という名前の特効薬です。[p]

[m_changeCharacterFrameName name="四国めたん" face="悲しみ" side="left"]
[playse storage="se/gogogogo_fadeout4s.ogg" buf="1" volume="40"]
[playse storage="theater/p01/e02/025.ogg"]
二人とも好き放題言ってくれるじゃない…！[p]

[m_changeCharacterFrameName name="四国めたん" face="興奮" side="left"]
[playse storage="theater/p01/e02/026.ogg"]
いいわ！そんなに言うなら証明してみせるわよ！[r]
わたくしの[ruby text="サウ"]千[ruby text="ザンド"]里[ruby text="アイ"]眼の真の力を！[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]
[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]
