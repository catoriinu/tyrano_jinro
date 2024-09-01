; タイトル：誰がずんだもちを食べたのだ？（解決編）

*start
; ここからチャプターごとに設定が必要な項目
[iscript]
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


[m_changeCharacterFrameName name="ずんだもん" face="ドヤ顔" side="left"]
[playse storage="theater/p01/e01/040.ogg"]
か、勝ったのだ…。[p]

[m_changeCharacterFrameName face="大喜び" name="四国めたん"]
[playse storage="theater/p01/e01/041.ogg"]
わたくしたちの勝利ね、ずんだもん。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="ガッカリ"]
[playse storage="theater/p01/e01/042.ogg"]
あーあ、もう少しだったのになー。[r]
あそこでずんだもん先輩をもっと疑ってれば…。[p]

[m_changeCharacterFrameName name="雨晴はう" face="苦笑"]
[playse storage="theater/p01/e01/043.ogg"]
ですが負けは負けです。[r]
ちゃんと認めましょう、つむぎさん。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="悲しみ"]
[playse storage="theater/p01/e01/044.ogg"]
うん、分かってるよ。[r]
ごめんね、ずんだもん先輩。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="theater/p01/e01/045.ogg"]
ということは、つむぎが僕のずんだもちを食べたのだ？[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="通常"]
[playse storage="theater/p01/e01/046.ogg"]
え？ううん、違うけど？[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/047.ogg"]
じゃ、じゃあどうして謝るのだ？[p]

[m_changeCharacterFrameName name="波音リツ" face="ため息"]
[playse storage="theater/p01/e01/048.ogg"]
それが人狼ゲームの結果だからよ。[r]
ずんだもんは勝ち、あたしたちは負けた。[p]

[m_changeCharacterFrameName name="波音リツ" face="通常"]
[playse storage="theater/p01/e01/049.ogg"]
つまり、ずんだもんが持っていた不満は、あたしたち敗者陣営に解消する責任があるというわけ。[p]

[m_changeCharacterFrameName name="雨晴はう" face="安心"]
[playse storage="theater/p01/e01/050.ogg"]
そういえば僕のぶんのずんだもち、まだ食べてなかったのでずんだもんにあげますよ。[p]

[m_changeCharacterFrameName name="雨晴はう" face="げっそり"]
[playse storage="theater/p01/e01/051.ogg"]
食べたいのはやまやまですが、どうせ僕は夜勤明けだから早く寝ないとなので…！[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="theater/p01/e01/052.ogg"]
だったらはうは絶対犯人じゃないのだ！[r]
もらえるのは嬉しいけど…こんなのおかしいのだ！[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="テンアゲ"]
[playse storage="theater/p01/e01/053.ogg"]
ずんだもん先輩、ずんだもち以外にも不満があるの？[r]
だったらちゃんと教えてほしいな。あーしたち、頑張るから。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/054.ogg"]
そういうわけじゃないのだ。でも…。[p]

[m_changeCharacterFrameName name="四国めたん" face="真剣"]
[playse storage="theater/p01/e01/055.ogg"]
人狼ゲームに負けたはうさんたちはその掟に従って、ずんだもんにずんだもちを食べさせてくれると言っているのよ。[p]

[playse storage="theater/p01/e01/056.ogg"]
わたくしたちボイボ寮生は寮内でトラブルが起きたら、ずっとこうして対処してきたじゃない。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/057.ogg"]
ずっと…？[p]

[playse storage="theater/p01/e01/058.ogg"]
そう…だったのだ…？[r]
おかしいのは僕の方…なのだ？[p]

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="theater/p01/e01/059.ogg"]
で、でも、結局何も解決してないのだ！[r]
僕のずんだもちを食べたのは、誰なのだー！[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]
[jump storage="theater/main.ks" target="*start"]
[s]
