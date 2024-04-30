[cm  ]
[clearfix]
[start_keyconfig]


[bg storage="living_day_nc238325.jpg" time="300"]

;メッセージウィンドウの設定、文字が表示される領域を調整
[position layer="message0" left="53" top="484" width="1174" height="235" margint="65" marginl="75" marginr="80" marginb="65" opacity="220" page="fore"]

;メッセージウィンドウの表示
[layopt layer="message0" visible="true"]

;キャラクターの名前が表示される文字領域
[ptext name="chara_name_area" layer="message0" face="にくまるフォント" color="0x28332a" size=36 x=175 y=505]

;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
[chara_config ptext="chara_name_area"]
; pos_mode:キャラの初期位置はキャラ宣言時に全指定するのでfalse
[chara_config pos_mode="false" memory="true" time="200"]

;このシナリオで登場する全キャラクターを宣言、表情登録
[call target="*registerTheaterParticipants"]
[call storage="./chara/common.ks" target="*registerAllCharacters"]


; バックログボタン表示
;[j_displayFixButton backlog="true"]

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
そういえば僕のぶんのずんだもち、[r]
まだ食べてなかったのでずんだもんにあげますよ。[p]

食べたいのはやまやまですが、[r]
どうせ僕は夜勤明けだから早く寝ないとなので…！[p]

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

#

; 視聴済みに更新する
[t_watchOutroProgress pageKey="1" situationKey="1"]

[eval exp="f.quickShowEpisodeWindow = true"]

[j_clearFixButton]
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[layopt layer="message0" visible="false"]
[jump storage="theater/main.ks" target="*start"]
[s]


*registerTheaterParticipants
[iscript]
    f.participantsIdList = [
        CHARACTER_ID_ZUNDAMON,
        CHARACTER_ID_METAN,
        CHARACTER_ID_TSUMUGI,
        CHARACTER_ID_HAU,
        CHARACTER_ID_RITSU,
        //'mochiko'),
    ];
[endscript]
[return]
[s]
