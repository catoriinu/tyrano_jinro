; 波音リツのmessageサブルーチン

; 呼び方サブルーチン
; 事前準備：tf.targetId = キャラクターID
; このmessageサブルーチンのキャラクターが、tf.targetIdのキャラクターを呼ぶ際の二人称をtf.targetNameに格納する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [iscript]
    tf.targetName = (function(characterId) {
      const calledCharacterNameObject = {
        [CHARACTER_ID_ZUNDAMON]: 'ずんだもん',
        [CHARACTER_ID_METAN]:    'めたん',
        [CHARACTER_ID_TSUMUGI]:  'つむぎ',
        [CHARACTER_ID_HAU]:      'はう',
        [CHARACTER_ID_RITSU]:    'あたし',
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
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_true_positive_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_true_positive_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_true_positive_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_true_positive_04.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[return]


*COFortuneTelling_voice_true_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_true_negative_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_true_negative_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_true_negative_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_true_negative_04.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[return]


; COFortuneTelling_{result}_{feeling}_{isAlive}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true_neutral_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_true_neutral_alive_01.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]。アンタ人狼ね？[r]
さあ、祭りを始めましょうか。[p]
[return]


*COFortuneTelling_true_love_alive
[eval exp="tf.face = '困惑'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_true_love_alive_01.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]。アンタ人狼ね？[r]
釣られていたのはあたしの方だったようね。[p]
[return]


*COFortuneTelling_true_hate_alive
[eval exp="tf.face = '煽り'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_true_hate_alive_01.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]。アンタ人狼ね？[r]
NGリストにぶち込んでやるわ。[p]
[return]


*COFortuneTelling_voice_false_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_false_positive_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_false_positive_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_false_positive_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_false_positive_04.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[return]


*COFortuneTelling_voice_false_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_false_negative_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_false_negative_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_false_negative_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_voice_false_negative_04.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[return]


*COFortuneTelling_false_neutral_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_false_neutral_alive_01.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
住民としてこの村を盛り上げてちょうだい。[p]
[return]


*COFortuneTelling_false_love_alive
[eval exp="tf.face = '笑顔'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_false_love_alive_01.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
アンタの意見は貴重なソースになるわ。[p]
[return]


*COFortuneTelling_false_hate_alive
[eval exp="tf.face = '煽り'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_false_hate_alie_01.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
…人狼のエサになる準備はOK？[p]
[return]


*COFortuneTelling_false_neutral_died
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_false_neutral_died_01.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
惜しい人をなくしたわね。[p]
[return]


*COFortuneTelling_false_love_died
[eval exp="tf.face = '怒り'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_false_love_died_01.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
くっ…絶対に許さんぞ人狼め！[p]
[return]


*COFortuneTelling_false_hate_died
[eval exp="tf.face = 'ため息'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/ritsu/ritsu_COFortuneTelling_false_hate_died_01.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
まああれだけ怪しかったし、残念だけど当然ね。[p]
[return]


; doAction_{actionId}_{decision}
; シーン：「疑う」アクション実行時
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
*doAction_suspect_logical
[eval exp="tf.face = '煽り'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/ritsu_doAction_suspect_logical_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/ritsu_doAction_suspect_logical_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/ritsu_doAction_suspect_logical_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/ritsu_doAction_suspect_logical_04.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]

[add_playselist storage="chara/ritsu/ritsu_doAction_suspect_logical_05.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]、人狼はアンタよ！[r]
ねえねえ、言い当てられて今どんな気持ち？[p]
[return]


*doAction_suspect_emotional
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/ritsu_doAction_suspect_emotional_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/ritsu_doAction_suspect_emotional_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/ritsu_doAction_suspect_emotional_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/ritsu_doAction_suspect_emotional_04.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]はどうせ人狼でしょうね。[r]
まあ根拠はないけれど。[p]
[return]


; シーン：「信じる」アクション実行時
*doAction_trust_logical
[eval exp="tf.face = '笑顔'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/ritsu_doAction_trust_logical_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/ritsu_doAction_trust_logical_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/ritsu_doAction_trust_logical_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/ritsu_doAction_trust_logical_04.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]

[add_playselist storage="chara/ritsu/ritsu_doAction_trust_logical_05.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]はあたしの仲間よ。[r]
あたしが決めた。今決めた。[p]
[return]


*doAction_trust_emotional
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/ritsu_doAction_trust_emotional_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/ritsu_doAction_trust_emotional_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/ritsu_doAction_trust_emotional_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/ritsu_doAction_trust_emotional_04.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[playselist]

こう見えてもあたしは[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]に期待してるの。[r]
だからがっかりさせないでほしいわね。[p]
[return]


; シーン：「聞き出す」アクション実行時
*doAction_ask
[eval exp="tf.targetId = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]、三行で説明よろしく。[p]
[return]


; doAction_reaction_{actionId}_{feeling}
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
; ※targetIdの方がこのサブルーチンのキャラクターであること
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect_neutral
[eval exp="tf.face = 'ため息'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/ritsu_doAction_reaction_suspect_neutral_01.ogg"]
[playselist]

アンタがそう思うならそうなんでしょう。[r]
アンタの中ではね。[p]
[return]


*doAction_reaction_suspect_love
[eval exp="tf.face = '困惑'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/ritsu_doAction_reaction_suspect_love_01.ogg"]
[playselist]

ふう、なんとか致命傷で済んだわ。[p]
[return]


*doAction_reaction_suspect_hate
[eval exp="tf.face = '煽り'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/ritsu_doAction_reaction_suspect_hate_01.ogg"]
[playselist]

あたしを疑うの？もうね、アボカド。バナナかと。[p]
[return]


; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust_neutral
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/ritsu_doAction_reaction_trust_neutral_01.ogg"]
[playselist]

ふふ、嬉しいことを言ってくれるじゃない。[p]
[return]


*doAction_reaction_trust_love
[eval exp="tf.face = '笑顔'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/ritsu_doAction_reaction_trust_love_01.ogg"]
[playselist]

なんだ、ただの神か。[p]
[return]


*doAction_reaction_trust_hate
[eval exp="tf.face = '真顔'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/ritsu_doAction_reaction_trust_hate_01.ogg"]
[playselist]

あっそう。華麗にスルーさせてもらうわね。[p]
[return]


; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
アンタに教えることなんて何もないわ。[p]
[return]


; シーン：「喋りすぎ」アクション実行時
*doAction_talkToMuch
[eval exp="tf.face = '怒り'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/ritsu_doAction_talkToMuch_01.ogg"]
[playselist]

連投はネチケット違反よ。半年ROMってなさい。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[eval exp="tf.face = 'ため息'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/ritsu_executed_01.ogg"]
[playselist]

安価は絶対…。あたしは潔く去るわ。[p]
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
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_true_positive_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_true_positive_02.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_true_positive_03.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_true_positive_04.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_true_negative_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_true_negative_02.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_true_negative_03.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_true_negative_04.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_true_neutral_alive_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_true_love_alive_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_true_hate_alive_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_false_positive_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_false_positive_02.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_false_positive_03.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_false_positive_04.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_false_negative_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_false_negative_02.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_false_negative_03.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_voice_false_negative_04.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_false_neutral_alive_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_false_love_alive_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_false_hate_alie_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_false_neutral_died_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_false_love_died_01.ogg",
      "data/sound/chara/ritsu/ritsu_COFortuneTelling_false_hate_died_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_suspect_logical_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_suspect_logical_02.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_suspect_logical_03.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_suspect_logical_04.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_suspect_logical_05.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_suspect_emotional_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_suspect_emotional_02.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_suspect_emotional_03.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_suspect_emotional_04.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_suspect_emotional_05.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_trust_logical_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_trust_logical_02.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_trust_logical_03.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_trust_logical_04.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_trust_logical_05.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_trust_emotional_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_trust_emotional_02.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_trust_emotional_03.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_trust_emotional_04.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_trust_emotional_05.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_ask_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_reaction_suspect_neutral_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_reaction_suspect_love_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_reaction_suspect_hate_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_reaction_trust_neutral_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_reaction_trust_love_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_reaction_trust_hate_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_reaction_ask_01.ogg",
      "data/sound/chara/ritsu/ritsu_doAction_talkToMuch_01.ogg",
      "data/sound/chara/ritsu/ritsu_executed_01.ogg",
    );
  [endscript]
[return]
