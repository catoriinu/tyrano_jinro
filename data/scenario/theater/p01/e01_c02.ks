; タイトル：誰がずんだもちを食べたのだ？（解決編）

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


[m_changeCharacterFrameName name="ずんだもん"]
か、勝ったのだ…。[p]

[m_changeCharacterFrameName name="四国めたん"]
わたくしたちの勝利ね、ずんだもん。[p]

[m_changeCharacterFrameName name="春日部つむぎ"]
あーあ、もう少しだったのになー。[r]
あそこでずんだもん先輩をもっと疑ってれば…。[p]

[m_changeCharacterFrameName name="雨晴はう"]
ですが負けは負けです。[r]
ちゃんと認めましょう、つむぎさん。[p]

[m_changeCharacterFrameName name="春日部つむぎ"]
うん、分かってるよ。[r]
ごめんね、ずんだもん先輩。[p]

[m_changeCharacterFrameName name="ずんだもん"]
ということは、つむぎが僕のずんだもちを食べたのだ？[p]

[m_changeCharacterFrameName name="春日部つむぎ"]
え？ううん、違うけど？[p]

[m_changeCharacterFrameName name="ずんだもん"]
じゃ、じゃあどうして謝るのだ？[p]

[m_changeCharacterFrameName name="波音リツ"]
それが人狼ゲームの結果だからよ。[r]
ずんだもんは勝ち、あたしたちは負けた。[p]

つまり、ずんだもんが持っていた不満は、あたしたち敗者陣営に解消する責任があるというわけ。[p]

[m_changeCharacterFrameName name="雨晴はう"]
そういえば僕のぶんのずんだもち、まだ食べてなかったのでずんだもんにあげますよ。[p]

食べたいのはやまやまですが、どうせ僕は夜勤明けだから早く寝ないとなので…！[p]

[m_changeCharacterFrameName name="ずんだもん"]
だったらはうは絶対犯人じゃないのだ！[r]
もらえるのは嬉しいけど…こんなのおかしいのだ！[p]

[m_changeCharacterFrameName name="春日部つむぎ"]
ずんだもん先輩、ずんだもち以外にも不満があるの？[r]
だったらちゃんと教えてほしいな。あーしたち、頑張るから。[p]

[m_changeCharacterFrameName name="ずんだもん"]
そういうわけじゃないのだ。でも…。[p]

[m_changeCharacterFrameName name="四国めたん"]
人狼ゲームに負けたはうさんたちはその掟に従って、ずんだもんにずんだもちを食べさせてくれると言っているのよ。[p]

わたくしたちボイボ寮生は寮内でトラブルが起きたら、ずっとこうして対処してきたじゃない。[p]

[m_changeCharacterFrameName name="ずんだもん"]
ずっと…？[p]

そう…だったのだ…？[r]
おかしいのは僕の方…なのだ？[p]

で、でも、結局何も解決してないのだ！[r]
僕のずんだもちを食べたのは、誰なのだー！[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]
[jump storage="theater/main.ks" target="*start"]
[s]
