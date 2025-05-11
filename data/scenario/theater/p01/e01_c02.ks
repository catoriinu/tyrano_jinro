*start
; チャプターごとに設定が必要な項目
[iscript]
// チャプターのタイトル（カットイン表示用。改行が必要なら<br>を入れる）
f.titleText = '誰がずんだもちを食べたのだ？<br>（解決編）';
// このチャプターを表す通し番号
f.pageId    = 'p01';
f.episodeId = 'e01';
f.chapterId = 'c02';

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
    storage: "gudagudana_kanji_1loop.ogg",
    volume: "12",
}
[endscript]
[t_setupChapter titleText="&f.titleText" actorsList="&tf.actorsList" bgParams="&tf.bgParams" playbgmParams="&tf.playbgmParams"]

; ここからチャプター視聴開始


[m_changeCharacterFrameName name="ずんだもん" face="ドヤ顔" side="left"]
[playse storage="theater/p01/e01/040.ogg" buf="1"]
か、勝ったのだ…。[p]

[m_changeCharacterFrameName face="大喜び" name="四国めたん"]
[playse storage="theater/p01/e01/041.ogg" buf="1"]
わたくしたちの勝利ね、ずんだもん。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="悲しみ"]
[playse storage="theater/p01/e01/042.ogg" buf="1"]
あーあ、もう少しだったのになー。[r]
あそこでずんだもん先輩をもっと疑ってれば…。[p]

[m_changeCharacterFrameName name="雨晴はう" face="苦笑" side="left"]
[playse storage="theater/p01/e01/043.ogg" buf="1"]
ですが負けは負けです。[r]
ちゃんと認めましょう、つむぎさん。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="アピール"]
[playse storage="se/shogeru.ogg" buf="0" volume="70"]
[playse storage="theater/p01/e01/044.ogg" buf="1"]
うん、分かってるよ。[r]
ごめんね、ずんだもん先輩。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="theater/p01/e01/045.ogg" buf="1"]
ということは、つむぎが僕のずんだもちを食べたのだ？[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="通常"]
[playse storage="se/hatena01-1.ogg" buf="0" volume="60"]
[playse storage="theater/p01/e01/046.ogg" buf="1"]
え？ううん、違うけど？[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/047.ogg" buf="1"]
じゃ、じゃあどうして謝るのだ？[p]

[m_changeCharacterFrameName name="波音リツ" face="ため息"]
[playse storage="theater/p01/e01/048.ogg" buf="1"]
それが人狼ゲームの結果だからよ。[r]
ずんだもんは勝ち、あたしたちは負けた。[p]

[m_changeCharacterFrameName name="波音リツ" face="通常"]
[playse storage="theater/p01/e01/049.ogg" buf="1"]
つまり、ずんだもんが持っていた不満は、あたしたち敗者陣営に解消する責任があるというわけ。[p]

[m_changeCharacterFrameName name="雨晴はう" face="安心"]
[playse storage="theater/p01/e01/050.ogg" buf="1"]
そういえば僕のぶんのずんだもち、まだ食べてなかったのでずんだもんにあげますよ。[p]

[m_changeCharacterFrameName name="雨晴はう" face="げっそり"]
[playse storage="se/shogeru.ogg" buf="0" volume="70"]
[playse storage="theater/p01/e01/051.ogg" buf="1"]
食べたいのはやまやまですが、どうせ僕は夜勤明けだから早く寝ないとなので…！[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="theater/p01/e01/052.ogg" buf="1"]
だったらはうは絶対犯人じゃないのだ！[r]
もらえるのは嬉しいけど…こんなのおかしいのだ！[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="テンアゲ"]
[playse storage="theater/p01/e01/053.ogg" buf="1"]
ずんだもん先輩、ずんだもち以外にも不満があるの？[r]
だったらちゃんと教えてほしいな。あーしたち、頑張るから。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/054.ogg" buf="1"]
そういうわけじゃないのだ。でも…。[p]

[m_changeCharacterFrameName name="四国めたん" face="真剣"]
[playse storage="theater/p01/e01/055.ogg" buf="1"]
人狼ゲームに負けたはうさんたちはその掟に従って、ずんだもんにずんだもちを食べさせてくれると言っているのよ。[p]

[playse storage="theater/p01/e01/056.ogg" buf="1"]
わたくしたちボイボ寮生は寮内でトラブルが起きたら、ずっとこうして対処してきたじゃない。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/057.ogg" buf="1"]
ずっと…？[p]

[playse storage="theater/p01/e01/058.ogg" buf="1"]
そう…だったのだ…？[r]
おかしいのは僕の方…なのだ？[p]

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="theater/p01/e01/059.ogg" buf="1"]
で、でも、結局何も解決してないのだ！[r]
僕のずんだもちを食べたのは、誰なのだー！[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]
[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]
