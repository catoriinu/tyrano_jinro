; 春日部つむぎのmessageサブルーチン

; 呼び方サブルーチン
; 事前準備：tf.targetId = キャラクターID
; このmessageサブルーチンのキャラクターが、tf.targetIdのキャラクターを呼ぶ際の二人称をtf.targetNameに格納する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [iscript]
    tf.targetName = (function(characterId) {
      const calledCharacterNameObject = {
        [CHARACTER_ID_ZUNDAMON]: 'ずんだもん先輩',
        [CHARACTER_ID_METAN]:    'めたん先輩',
        [CHARACTER_ID_TSUMUGI]:  'あーし',
        [CHARACTER_ID_HAU]:      'はうちゃん',
        [CHARACTER_ID_RITSU]:    'りっちゃん',
      }
      return calledCharacterNameObject[characterId];
    }(tf.targetId));
  [endscript]
[return]



; COFortuneTelling_voice_{result}_{feeling}
; COFortuneTellingのボイス用サブルーチン
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_voice_true_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_true_positive_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_true_positive_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_true_positive_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_true_positive_04.ogg"]
[endif]
[return]


*COFortuneTelling_voice_true_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_true_negative_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_true_negative_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_true_negative_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_true_negative_04.ogg"]
[endif]
[return]


; COFortuneTelling_{result}_{feeling}_{isAlive}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true_neutral_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_true_neutral_alive_01.ogg"]
[playselist]

あーしの占いだと、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったんだよねー。[r]
隠し通せると思った？残念だったね。[p]
[return]


*COFortuneTelling_true_love_alive
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_true_love_alive_01.ogg"]
[playselist]

あーしの占いだと、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったんだよねー。[r]
友達だと思ってたのはあーしだけだったんだね。[p]
[return]


*COFortuneTelling_true_hate_alive
[eval exp="tf.face = 'ガッカリ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_true_hate_alive_01.ogg"]
[playselist]

あーしの占いだと、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったんだよねー。[r]
ぶっちゃけ、やっぱりそっか、って感じかな。[p]
[return]


*COFortuneTelling_voice_false_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_false_positive_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_false_positive_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_false_positive_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_false_positive_04.ogg"]
[endif]
[return]


*COFortuneTelling_voice_false_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_false_negative_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_false_negative_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_false_negative_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_voice_false_negative_04.ogg"]
[endif]
[return]


*COFortuneTelling_false_neutral_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_false_neutral_alive_01.ogg"]
[playselist]

あーしの占いだと、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったよ。[r]
友達になってくれるかな？[p]
[return]


*COFortuneTelling_false_love_alive
[eval exp="tf.face = 'ワクワク'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_false_love_alive_01.ogg"]
[playselist]

あーしの占いだと、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったよ。[r]
みんなにもきみのこと、信じてもらえるように頑張るね！[p]
[return]


*COFortuneTelling_false_hate_alive
[eval exp="tf.face = 'ガッカリ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_false_hate_alie_01.ogg"]
[playselist]

あーしの占いだと、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったよ。[r]
ごめんね、ちょっと疑っちゃってたかも…。[p]
[return]


*COFortuneTelling_false_neutral_died
[eval exp="tf.face = 'ガッカリ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_false_neutral_died_01.ogg"]
[playselist]

あーしの占いだと、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったよ。[r]
って言っても、ちょっと遅かったけどね…。[p]
[return]


*COFortuneTelling_false_love_died
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_false_love_died_01.ogg"]
[playselist]

あーしの占いだと、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったよ。[r]
こんなのウソだよね？ねえ、早く戻ってきてよ…。[p]
[return]


*COFortuneTelling_false_hate_died
[eval exp="tf.face = 'ガッカリ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/tsumugi/tsumugi_COFortuneTelling_false_hate_died_01.ogg"]
[playselist]

あーしの占いだと、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったよ。[r]
こんなことになるなら、もっと仲良くすればよかったかな。[p]
[return]


; doAction_{actionId}_{decision}
; シーン：「疑う」アクション実行時
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
*doAction_suspect_logical
[eval exp="tf.face = 'テンアゲ'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_suspect_logical_01.ogg"]

[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_suspect_logical_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_suspect_logical_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_suspect_logical_04.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_suspect_logical_05.ogg"]
[endif]
[playselist]

あーし、全部分かっちゃった。[r]
[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]が人狼なんでしょ？[p]
[return]


*doAction_suspect_emotional
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_suspect_emotional_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_suspect_emotional_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_suspect_emotional_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_suspect_emotional_04.ogg"]
[endif]

[add_playselist storage="chara/tsumugi/tsumugi_doAction_suspect_emotional_05.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]ってもしかして人狼？[r]
ちょっとヤバい感じするし。[p]
[return]


; シーン：「信じる」アクション実行時
*doAction_trust_logical
[eval exp="tf.face = 'テンアゲ'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_trust_logical_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_trust_logical_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_trust_logical_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_trust_logical_04.ogg"]
[endif]

[add_playselist storage="chara/tsumugi/tsumugi_doAction_trust_logical_05.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]とあーしは最強の友達だよね。[r]
これから先も、ずっと！[p]
[return]


*doAction_trust_emotional
[eval exp="tf.face = 'ワクワク'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_trust_emotional_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_trust_emotional_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_trust_emotional_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_trust_emotional_04.ogg"]
[endif]

[add_playselist storage="chara/tsumugi/tsumugi_doAction_trust_emotional_05.ogg"]
[playselist]

あーしは[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]を味方だと思ってるよ。[r]
できたらきみもあーしのこと、信じてほしいな。[p]
[return]


; シーン：「聞き出す」アクション実行時
*doAction_ask
[eval exp="tf.targetId = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

あのさ、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]の考えも聞いてみたいなー。[p]
[return]


; doAction_reaction_{actionId}_{feeling}
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
; ※targetIdの方がこのサブルーチンのキャラクターであること
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect_neutral
[eval exp="tf.face = '苦笑'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/tsumugi_doAction_reaction_suspect_neutral_01.ogg"]
[playselist]

そんな風に思われてたんだ…。[r]
ちょっとショックかも。[p]
[return]


*doAction_reaction_suspect_love
[eval exp="tf.face = 'ガッカリ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/tsumugi_doAction_reaction_suspect_love_01.ogg"]
[playselist]

あ…うん、今まで馴れ馴れしくしてごめんね。[p]
[return]


*doAction_reaction_suspect_hate
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/tsumugi_doAction_reaction_suspect_hate_01.ogg"]
[playselist]

そっか、分かった。しばらく距離置こっか。[p]
[return]


; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust_neutral
[eval exp="tf.face = 'ニコニコ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/tsumugi_doAction_reaction_trust_neutral_01.ogg"]
[playselist]

マジ？なんか嬉しいかも！[p]
[return]


*doAction_reaction_trust_love
[eval exp="tf.face = 'テンアゲ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/tsumugi_doAction_reaction_trust_love_01.ogg"]
[playselist]

やった！きみに信じてもらえるなんて、最高！[p]
[return]


*doAction_reaction_trust_hate
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/tsumugi_doAction_reaction_trust_hate_01.ogg"]
[playselist]

えー？[r]
もしきみが激辛カレーを食べ切れたら、本気だって信じてあげるけど。[p]
[return]


; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
そんなの聞かれても、あーしには分かんないよ…。[p]
[return]


; シーン：「喋りすぎ」アクション実行時
*doAction_talkToMuch
[eval exp="tf.face = 'ガッカリ'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[add_playselist storage="chara/tsumugi/tsumugi_doAction_talkToMuch_01.ogg"]
[playselist]

もう！あーしも言いたいことあったのに！[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[add_playselist storage="chara/tsumugi/tsumugi_executed_01.ogg"]
[playselist]

うそ。あーし選ばれちゃったの？[r]
そんなに怪しかったのかな……[p]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
（未作成）[p]
[return]



; このサブルーチンのボイスファイルを全てpreloadするためのサブルーチン
*preloadVoice
  [iscript]
    tf.preloadList.push(
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_true_positive_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_true_positive_02.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_true_positive_03.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_true_positive_04.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_true_negative_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_true_negative_02.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_true_negative_03.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_true_negative_04.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_true_neutral_alive_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_true_love_alive_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_true_hate_alive_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_false_positive_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_false_positive_02.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_false_positive_03.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_false_positive_04.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_false_negative_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_false_negative_02.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_false_negative_03.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_voice_false_negative_04.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_false_neutral_alive_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_false_love_alive_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_false_hate_alie_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_false_neutral_died_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_false_love_died_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_COFortuneTelling_false_hate_died_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_suspect_logical_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_suspect_logical_02.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_suspect_logical_03.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_suspect_logical_04.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_suspect_logical_05.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_suspect_emotional_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_suspect_emotional_02.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_suspect_emotional_03.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_suspect_emotional_04.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_suspect_emotional_05.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_trust_logical_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_trust_logical_02.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_trust_logical_03.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_trust_logical_04.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_trust_logical_05.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_trust_emotional_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_trust_emotional_02.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_trust_emotional_03.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_trust_emotional_04.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_trust_emotional_05.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_ask_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_reaction_suspect_neutral_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_reaction_suspect_love_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_reaction_suspect_hate_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_reaction_trust_neutral_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_reaction_trust_love_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_reaction_trust_hate_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_reaction_ask_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_doAction_talkToMuch_01.ogg",
      "data/sound/chara/tsumugi/tsumugi_executed_01.ogg",
    );
  [endscript]
[return]
