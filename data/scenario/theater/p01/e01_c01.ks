*start
; チャプターごとに設定が必要な項目
[iscript]
// チャプターのタイトル（カットイン表示用。改行が必要なら<br>を入れる）
f.titleText = '誰がずんだもちを食べたのだ？<br>（導入編）';
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
    volume: "13",
}
[endscript]

[t_setupChapter titleText="&f.titleText" actorsList="&tf.actorsList" bgParams="&tf.bgParams" playbgmParams="&tf.playbgmParams"]

; ここからチャプター視聴開始

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="theater/p01/e01/001.ogg" buf="1"]
うわあああ！？ない！ないのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="通常"]
[playse storage="theater/p01/e01/002.ogg" buf="1"]
どうしたのよずんだもん、朝から騒々しいわね。[p]

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="theater/p01/e01/003.ogg" buf="1"]
どうもこうもないのだ！[r]
僕のずんだもちがないのだ！[p]

[playse storage="theater/p01/e01/004.ogg" buf="1"]
朝ごはんに食べようと思って冷蔵庫に入れてたのに、起きたら綺麗さっぱりなくなってたのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="クスクス"]
[playse storage="se/kira1.ogg" buf="2" volume="50"]
[playse storage="theater/p01/e01/005.ogg" buf="1"]
ああ、昨日遊びに来たずん子たちのおみやげよね。[r]
まさに[ruby text="エ"]翠[ruby text="メラ"]緑[ruby text="ルド"]の[ruby text="オー"]宝[ruby text="ブ"]珠…頬が落ちるくらい美味しかったわ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="悲しみ" side="left"]
[playse storage="theater/p01/e01/006.ogg" buf="1"]
…もしかしてめたんが犯人なのだ？[r]
めたんならやりかねないのだ…！[p]

[m_changeCharacterFrameName name="四国めたん" face="恥ずかしい"]
[playse storage="se/shogeru.ogg" buf="2" volume="70"]
[playse storage="theater/p01/e01/007.ogg" buf="1"]
ご、誤解しないでちょうだい。[r]
今のはわたくしの分を食べたときの感想よ。[p]

[playse storage="theater/p01/e01/008.ogg" buf="1"]
こうしてボイボ寮に住んでいる今、そんな食い意地の張ったことしないわよ。[r]
テント暮らしだったあの頃ならともかくね。[p]

[m_changeCharacterFrameName name="四国めたん" face="目閉じ"]
[playse storage="theater/p01/e01/009.ogg" buf="1"]
…たぶん。[p]

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="se/surprised.ogg" buf="2" volume="60"]
[playse storage="theater/p01/e01/010.ogg" buf="1"]
のだ！？[p]

[m_changeCharacterFrameName name="四国めたん" face="通常"]
[playse storage="theater/p01/e01/011.ogg" buf="1"]
そもそも、ちゃんと名前は書いておいたの？[r]
書いてなければ文句は言えないわよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/012.ogg" buf="1"]
…あ。[p]

[m_changeCharacterFrameName name="四国めたん" face="真剣"]
[playse storage="theater/p01/e01/013.ogg" buf="1"]
はあ…いつも言ってるじゃない。[r]
「自分の物には名前を書くこと。書いてない物はみんなの物」[p]

[playse storage="theater/p01/e01/014.ogg" buf="1"]
ボイボ寮ではそういうルールなのよ。[p]

[playse storage="theater/p01/e01/015.ogg" buf="1"]
わたくしたちはここで共同生活をしてるの。[r]
これだけの人数が一緒に暮らすには、一人ひとりがルールを守る意識が必要だわ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="theater/p01/e01/016.ogg" buf="1"]
だけど、だったら余計に誰のかも分からない物を食べるのはよくないのだ！[p]

[playse storage="theater/p01/e01/017.ogg" buf="1"]
犯人は誰なのだ…！？[r]
こたろう？ミコ？はう？それとも――[p]

; ノイズ演出
[e_noiseDisplay]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/018.ogg" buf="1"]
な、なんなのだ…？[r]
一瞬、目の前がグニャってしたような…。[p]

[playse storage="theater/p01/e01/019.ogg" buf="1"]
それに、誰かの名前を言おうとしてたはずなのだ。[r]
だけど変なのだ。誰のことなのか、全然思い出せないのだ。[p]

[m_changeCharacterFrameName name="四国めたん" face="困惑"]
[playse storage="theater/p01/e01/020.ogg" buf="1"]
何よ、急にブツブツ言い始めて。要領を得ないわね。[p]

[stopse buf="1"]
#
[m_changeFrameWithId frameId="none"]
[playse storage="se/open_door1.ogg" buf="2" volume="60"]
[wse]

[m_changeCharacterFrameName name="春日部つむぎ" face="テンアゲ"]
[playse storage="theater/p01/e01/021.ogg" buf="1"]
おはよう、ずんだもん先輩、めたん先輩。[r]
今日は早いね！[p]

[m_changeCharacterFrameName name="雨晴はう" face="通常" side="left"]
[playse storage="theater/p01/e01/022.ogg" buf="1"]
今、僕たちの名前を呼びましたか？[p]

[m_changeCharacterFrameName name="波音リツ" face="通常"]
[playse storage="theater/p01/e01/023.ogg" buf="1"]
こんな朝から元気に炎上中とは。[r]
ちょっと三行で説明を頼む。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="theater/p01/e01/024.ogg" buf="1"]
そ、そうなのだ！[r]
つむぎ、はう、リツ！聞いてほしいのだ！[p]

[playse storage="theater/p01/e01/025.ogg" buf="1"]
僕のずんだもちが誰かに食べられたのだ！[r]
確かに名前は書き忘れたけど、勝手に食べるのは良くないのだ！[p]

[playse storage="theater/p01/e01/026.ogg" buf="1"]
誰か、犯人を知らないのだ？[p]

[m_changeCharacterFrameName name="雨晴はう" face="考える"]
[playse storage="theater/p01/e01/027.ogg" buf="1"]
なるほど、事情は分かりました。[r]
ですが、僕には心当たりないですね…。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="通常" side="left"]
[playse storage="theater/p01/e01/028.ogg" buf="1"]
あーしも違うよ。[r]
ただこうなると、犯人が名乗り出てくれることはなさそうだよね。[p]

[m_changeCharacterFrameName name="波音リツ" face="通常"]
[playse storage="theater/p01/e01/029.ogg" buf="1"]
ああ、それなら私にいい考えがある。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
[playse storage="theater/p01/e01/030.ogg" buf="1"]
もしかして犯人を探す方法があるのだ？[p]

[m_changeCharacterFrameName name="波音リツ" face="煽り"]
[playse storage="se/wadaiko_dodon.ogg" buf="2" volume="60"]
[playse storage="theater/p01/e01/031.ogg" buf="1"]
人狼ゲームで犯人を決めようじゃないか。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/032.ogg" buf="1"]
えっ？[p]

[m_changeCharacterFrameName name="四国めたん" face="通常"]
[playse storage="theater/p01/e01/033.ogg" buf="1"]
それがいいわ。[r]
「揉め事は人狼ゲームで決すべし」。ボイボ寮の掟よね。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="ワクワク"]
[playse storage="theater/p01/e01/034.ogg" buf="1"]
さんせーい！[r]
みんなで人狼するの久しぶりだね。[p]

[m_changeCharacterFrameName name="雨晴はう" face="安心"]
[playse storage="theater/p01/e01/035.ogg" buf="1"]
人狼ゲームなら平等ですね。[r]
誰が犯人でも恨みっこなしです。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="se/surprised.ogg" buf="2" volume="60"]
[playse storage="theater/p01/e01/036.ogg" buf="1"]
ちょ、ちょっと待つのだ！[r]
そんなルールは初耳なのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="真剣"]
[playse storage="theater/p01/e01/037.ogg" buf="1"]
あなたもボイボ寮の住人なら覚悟を決めなさい！[p]

[m_changeCharacterFrameName name="波音リツ" face="笑顔"]
[playse storage="theater/p01/e01/038.ogg" buf="1"]
さあ、配役を決めてゲームスタートだ！[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]

[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]
