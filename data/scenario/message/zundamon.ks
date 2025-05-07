; ずんだもんのmessageサブルーチン

; 呼び方サブルーチン
; 事前準備：tf.targetId = キャラクターID
; このmessageサブルーチンのキャラクターが、tf.targetIdのキャラクターを呼ぶ際の二人称をtf.targetNameに格納する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [iscript]
    tf.targetName = (function(characterId) {
      const calledCharacterNameObject = {
        [CHARACTER_ID_ZUNDAMON]: '僕',
        [CHARACTER_ID_METAN]:    'めたん',
        [CHARACTER_ID_TSUMUGI]:  'つむぎ',
        [CHARACTER_ID_HAU]:      'はう',
        [CHARACTER_ID_RITSU]:    'リツ',
      }
      return calledCharacterNameObject[characterId];
    }(tf.targetId));
  [endscript]
[return]


; noticeRole_{roleId}
; シーン：初日、役職を告知されたときの反応
; 備考：PCのみ想定
*noticeRole_villager
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/zundamon/zundamon_noticeRole_villager_01.ogg"]

僕は村人なのだ。[r]
悪い人狼を見つけて平和な村にするのだ。[p]
[return]


*noticeRole_fortuneTeller
[eval exp="tf.face = '大喜び'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/zundamon/zundamon_noticeRole_fortuneTeller_01.ogg"]

僕は占い師なのだ。[r]
さっそく誰か占ってみるのだ！[p]
[return]


*noticeRole_werewolf
[eval exp="tf.face = 'ドヤ顔'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/zundamon/zundamon_noticeRole_werewolf_01.ogg"]

僕は人狼……。[r]
みんな僕がおいしく食べてやるのだ！[p]
[return]


*noticeRole_madman
[eval exp="tf.face = '自惚れ'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/zundamon/zundamon_noticeRole_madman_01.ogg"]

僕は狂人なのだ……。[r]
僕がご主人の野望を手助けするのだ！[p]
[return]


; announcedFortuneTellingResult_{result}
; シーン：真占い師で、占い実行結果を知ったときの反応
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
; 備考：PCのみ想定
*announcedFortuneTellingResult_true
[eval exp="tf.face = '驚き'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/zundamon_announcedFortuneTellingResult_true_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/zundamon_announcedFortuneTellingResult_true_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/zundamon_announcedFortuneTellingResult_true_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/zundamon_announcedFortuneTellingResult_true_04.ogg"]
[endif]

発見なのだ！[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]が人狼だったのだ！[p]
[return]


*announcedFortuneTellingResult_false
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/zundamon_announcedFortuneTellingResult_false_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/zundamon_announcedFortuneTellingResult_false_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/zundamon_announcedFortuneTellingResult_false_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/zundamon_announcedFortuneTellingResult_false_04.ogg"]
[endif]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったのだ。[p]
[return]


; COFortuneTelling_voice_{result}_{feeling}
; COFortuneTellingのボイス用サブルーチン
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_voice_true_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_true_positive_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_true_positive_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_true_positive_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_true_positive_04.ogg"]
[endif]
[return]


*COFortuneTelling_voice_true_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_true_negative_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_true_negative_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_true_negative_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_true_negative_04.ogg"]
[endif]
[return]


; COFortuneTelling_{result}_{feeling}_{isAlive}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true_neutral_alive
[eval exp="tf.face = 'ドヤ顔'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_true_neutral_alive_01.ogg"]
[playselist buf="1"]

みんな、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったのだ！[r]
力を合わせてやっつけるのだ！[p]
[return]


*COFortuneTelling_true_love_alive
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_true_love_alive_01.ogg"]
[playselist buf="1"]

みんな、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったのだ。[r]
僕も今まで騙されてたのだ…。[p]
[return]


*COFortuneTelling_true_hate_alive
[eval exp="tf.face = 'ドヤ顔'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_true_hate_alive_01.ogg"]
[playselist buf="1"]

みんな、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったのだ！[r]
ふふん！僕にはお見通しなのだ！[p]
[return]


*COFortuneTelling_voice_false_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_false_positive_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_false_positive_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_false_positive_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_false_positive_04.ogg"]
[endif]
[return]


*COFortuneTelling_voice_false_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_false_negative_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_false_negative_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_false_negative_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_voice_false_negative_04.ogg"]
[endif]
[return]


*COFortuneTelling_false_neutral_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_false_neutral_alive_01.ogg"]
[playselist buf="1"]

みんな、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったのだ。[r]
つまり人狼は他にいるってことなのだ。[p]
[return]


*COFortuneTelling_false_love_alive
[eval exp="tf.face = '大喜び'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_false_love_alive_01.ogg"]
[playselist buf="1"]

みんな、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったのだ！[r]
無実が証明できてよかったのだ！[p]
[return]


*COFortuneTelling_false_hate_alive
[eval exp="tf.face = '呆れ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_false_hate_alie_01.ogg"]
[playselist buf="1"]

みんな、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったのだ。[r]
自分の占い結果が信じられないのだ。[p]
[return]


*COFortuneTelling_false_neutral_died
[eval exp="tf.face = '呆れ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_false_neutral_died_01.ogg"]
[playselist buf="1"]

みんな、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったのだ。[r]
けど、残念ながら手遅れだったのだ。[p]
[return]


*COFortuneTelling_false_love_died
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_false_love_died_01.ogg"]
[playselist buf="1"]

みんな、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったのだ。[r]
ひどいのだ…誰がこんなことをしたのだ…！[p]
[return]


*COFortuneTelling_false_hate_died
[eval exp="tf.face = '呆れ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist buf="1" storage="chara/zundamon/zundamon_COFortuneTelling_false_hate_died_01.ogg"]
[playselist buf="1"]

みんな、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったのだ。[r]
これじゃあ占った意味がないのだ。[p]
[return]


; doAction_{actionId}_{decision}
; シーン：「疑う」アクション実行時
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
*doAction_suspect_logical
[eval exp="tf.face = '自惚れ'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/zundamon_doAction_suspect_logical_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/zundamon_doAction_suspect_logical_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/zundamon_doAction_suspect_logical_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/zundamon_doAction_suspect_logical_04.ogg"]
[endif]

僕のずんだ色の脳みそが告げているのだ。[r]
[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼に違いないのだ！[p]
[return]


*doAction_suspect_emotional
[eval exp="tf.face = '困惑'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/zundamon_doAction_suspect_emotional_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/zundamon_doAction_suspect_emotional_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/zundamon_doAction_suspect_emotional_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/zundamon_doAction_suspect_emotional_04.ogg"]
[endif]

もしかして[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]が人狼なのだ……？[r]
そんな気がするのだ。[p]
[return]


; シーン：「信じる」アクション実行時
*doAction_trust_logical
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/zundamon_doAction_trust_logical_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/zundamon_doAction_trust_logical_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/zundamon_doAction_trust_logical_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/zundamon_doAction_trust_logical_04.ogg"]
[endif]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は絶対絶対人狼じゃないのだ。[r]
僕でも分かるのだ！[p]
[return]


*doAction_trust_emotional
[eval exp="tf.face = '大喜び'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/zundamon_doAction_trust_emotional_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/zundamon_doAction_trust_emotional_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/zundamon_doAction_trust_emotional_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/zundamon_doAction_trust_emotional_04.ogg"]
[endif]

僕は[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]を信じてるのだ。[r]
きっと人狼じゃないのだ！[p]
[return]


; シーン：「聞き出す」アクション実行時
*doAction_ask
[eval exp="tf.targetId = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

[playse storage="chara/zundamon/zundamon_doAction_ask_01.ogg"]
[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]にちょっと質問なのだ。[r]
今の状況をどう思うのだ？[p]
[return]


; doAction_reaction_{actionId}_{feeling}
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
; ※targetIdの方がこのサブルーチンのキャラクターであること
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect_neutral
[eval exp="tf.face = '驚き'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/zundamon_doAction_reaction_suspect_neutral_01.ogg"]
ぼ、僕は人狼じゃないのだっ！[p]
[return]


*doAction_reaction_suspect_love
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/zundamon_doAction_reaction_suspect_love_01.ogg"]
違うのだ！僕じゃないのだ！信じて欲しいのだ…！[p]
[return]


*doAction_reaction_suspect_hate
[eval exp="tf.face = '呆れ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/zundamon_doAction_reaction_suspect_hate_01.ogg"]
そう言うオマエこそ人狼じゃないのだ？[p]
[return]


; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust_neutral
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/zundamon_doAction_reaction_trust_neutral_01.ogg"]
信じてくれてありがとうなのだ！[p]
[return]


*doAction_reaction_trust_love
[eval exp="tf.face = '大喜び'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/zundamon_doAction_reaction_trust_love_01.ogg"]
嬉しいのだ！そう言ってくれるって信じてたのだ！[p]
[return]


*doAction_reaction_trust_hate
[eval exp="tf.face = '呆れ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/zundamon_doAction_reaction_trust_hate_01.ogg"]
…本当にそう思ってるのだ？[r]
口先では何とでも言えるのだ。[p]
[return]


; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
もうなんにも分からないのだ……！[p]
[return]


; シーン：「喋りすぎ」アクション実行時
*doAction_talkToMuch
[eval exp="tf.face = '驚き'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/zundamon_doAction_talkToMuch_01.ogg"]
オマエばっかりズルいのだ！僕にも喋らせるのだ！ [p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[eval exp="tf.face = '驚き'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/zundamon/zundamon_executed_01.ogg"]

なんでなのだ！僕は悪くないのだ！[p]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
この決断が、間違ってないといいのだ……。[p]
[return]


; chooseWhoToBite
; シーン：人狼で、誰を噛むか選ぶときのセリフ
*chooseWhoToBite
[eval exp="tf.face = 'ドヤ顔'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/zundamon/zundamon_chooseWhoToBite_01.ogg"]

くくく、今夜は誰を食べちゃおうかな……。[r]
いただきまーすなのだ！[p]
[return]


; このサブルーチンのボイスファイルを全てpreloadするためのサブルーチン
*preloadVoice
  [iscript]
    tf.preloadList.push(
      "data/sound/chara/zundamon/zundamon_noticeRole_villager_01.ogg",
      "data/sound/chara/zundamon/zundamon_noticeRole_fortuneTeller_01.ogg",
      "data/sound/chara/zundamon/zundamon_noticeRole_werewolf_01.ogg",
      "data/sound/chara/zundamon/zundamon_noticeRole_madman_01.ogg",
      "data/sound/chara/zundamon/zundamon_announcedFortuneTellingResult_true_01.ogg",
      "data/sound/chara/zundamon/zundamon_announcedFortuneTellingResult_true_02.ogg",
      "data/sound/chara/zundamon/zundamon_announcedFortuneTellingResult_true_03.ogg",
      "data/sound/chara/zundamon/zundamon_announcedFortuneTellingResult_true_04.ogg",
      "data/sound/chara/zundamon/zundamon_announcedFortuneTellingResult_false_01.ogg",
      "data/sound/chara/zundamon/zundamon_announcedFortuneTellingResult_false_02.ogg",
      "data/sound/chara/zundamon/zundamon_announcedFortuneTellingResult_false_03.ogg",
      "data/sound/chara/zundamon/zundamon_announcedFortuneTellingResult_false_04.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_true_positive_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_true_positive_02.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_true_positive_03.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_true_positive_04.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_true_negative_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_true_negative_02.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_true_negative_03.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_true_negative_04.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_true_neutral_alive_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_true_love_alive_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_true_hate_alive_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_false_positive_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_false_positive_02.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_false_positive_03.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_false_positive_04.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_false_negative_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_false_negative_02.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_false_negative_03.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_voice_false_negative_04.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_false_neutral_alive_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_false_love_alive_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_false_hate_alie_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_false_neutral_died_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_false_love_died_01.ogg",
      "data/sound/chara/zundamon/zundamon_COFortuneTelling_false_hate_died_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_suspect_logical_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_suspect_logical_02.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_suspect_logical_03.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_suspect_logical_04.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_suspect_logical_05.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_suspect_emotional_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_suspect_emotional_02.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_suspect_emotional_03.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_suspect_emotional_04.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_suspect_emotional_05.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_trust_logical_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_trust_logical_02.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_trust_logical_03.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_trust_logical_04.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_trust_logical_05.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_trust_emotional_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_trust_emotional_02.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_trust_emotional_03.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_trust_emotional_04.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_trust_emotional_05.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_ask_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_reaction_suspect_neutral_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_reaction_suspect_love_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_reaction_suspect_hate_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_reaction_trust_neutral_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_reaction_trust_love_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_reaction_trust_hate_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_reaction_ask_01.ogg",
      "data/sound/chara/zundamon/zundamon_doAction_talkToMuch_01.ogg",
      "data/sound/chara/zundamon/zundamon_executed_01.ogg",
      "data/sound/chara/zundamon/zundamon_afterExecution_01.ogg",
      "data/sound/chara/zundamon/zundamon_chooseWhoToBite_01.ogg",
    );
  [endscript]
[return]
