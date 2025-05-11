; 四国めたんのmessageサブルーチン

; 呼び方サブルーチン
; 事前準備：tf.targetId = キャラクターID
; このmessageサブルーチンのキャラクターが、tf.targetIdのキャラクターを呼ぶ際の二人称をtf.targetNameに格納する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [iscript]
    tf.targetName = (function(characterId) {
      const calledCharacterNameObject = {
        [CHARACTER_ID_ZUNDAMON]: 'ずんだもん',
        [CHARACTER_ID_METAN]:    'わたくし',
        [CHARACTER_ID_TSUMUGI]:  'つむぎさん',
        [CHARACTER_ID_HAU]:      'はうさん',
        [CHARACTER_ID_RITSU]:    'リツさん',
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
[playse storage="chara/metan/metan_noticeRole_villager_01.ogg" buf="1"]

わたくしは村人なのね。[r]
無能力者に紛れるのもまた一興かしら。[p]
[return]


*noticeRole_fortuneTeller
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/metan/metan_noticeRole_fortuneTeller_01.ogg" buf="1"]

わたくしは占い師。[r]
この千里眼で真実を見通してみせるわ！[p]
[return]


*noticeRole_werewolf
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/metan/metan_noticeRole_werewolf_01.ogg" buf="1"]

わたくしは人狼。[r]
脆弱な人間どもよ、この漆黒のめたんの前に慄きなさい！[p]
[return]


*noticeRole_madman
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/metan/metan_noticeRole_madman_01.ogg" buf="1"]

わたくしは狂人。[r]
人狼様の仰せのままに、村を闇で支配してみせましょう。[p]
[return]


; announcedFortuneTellingResult_{result}
; シーン：真占い師で、占い実行結果を知ったときの反応
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
; 備考：PCのみ想定
*announcedFortuneTellingResult_true
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/metan/metan_announcedFortuneTellingResult_true_01.ogg" buf="1"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/metan/metan_announcedFortuneTellingResult_true_02.ogg" buf="1"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/metan/metan_announcedFortuneTellingResult_true_03.ogg" buf="1"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/metan/metan_announcedFortuneTellingResult_true_04.ogg" buf="1"]
[endif]

漆黒の気配…。[r]
[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]が人狼だったのね。[p]
[return]


*announcedFortuneTellingResult_false
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/metan/metan_announcedFortuneTellingResult_false_01.ogg" buf="1"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/metan/metan_announcedFortuneTellingResult_false_02.ogg" buf="1"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/metan/metan_announcedFortuneTellingResult_false_03.ogg" buf="1"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/metan/metan_announcedFortuneTellingResult_false_04.ogg" buf="1"]
[endif]

純白の気配…。[r]
[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではないようね。[p]
[return]


; COFortuneTelling_voice_{result}_{feeling}
; COFortuneTellingのボイス用サブルーチン
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_voice_true_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_true_positive_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_true_positive_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_true_positive_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_true_positive_04.ogg"]
[endif]
[return]


*COFortuneTelling_voice_true_negative
利用するセリフなし
[return]


; COFortuneTelling_{result}_{feeling}_{isAlive}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true_neutral_alive
[eval exp="tf.face = 'クスクス'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_true_neutral_alive_01.ogg"]
[playselist buf="1"]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったわ！[r]
ふふっ、わたくしの千里眼に見抜けぬものはないわ。[p]
[return]


*COFortuneTelling_true_love_alive
[eval exp="tf.face = '真剣'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_true_love_alive_01.ogg"]
[playselist buf="1"]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったわ！[r]
わたくしの心を弄んだこと、後悔させてやるわ。[p]
[return]


*COFortuneTelling_true_hate_alive
[eval exp="tf.face = '目閉じ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_true_hate_alive_01.ogg"]
[playselist buf="1"]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったわ！[r]
まあ、千里眼を使う前から視えていたけれど。[p]
[return]


*COFortuneTelling_voice_false_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_false_positive_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_false_positive_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_false_positive_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_false_positive_04.ogg"]
[endif]
[return]


*COFortuneTelling_voice_false_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_false_negative_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_false_negative_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_false_negative_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_voice_false_negative_04.ogg"]
[endif]
[return]


*COFortuneTelling_false_neutral_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_false_neutral_alive_01.ogg"]
[playselist buf="1"]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
信頼の証に、同盟を結ばせてもらえるかしら。[p]
[return]


*COFortuneTelling_false_love_alive
[eval exp="tf.face = 'クスクス'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_false_love_alive_01.ogg"]
[playselist buf="1"]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
これ以上疑いの眼を向けることは、わたくしが許さないわ。[p]
[return]


*COFortuneTelling_false_hate_alive
[eval exp="tf.face = '困惑'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_false_hate_alie_01.ogg"]
[playselist buf="1"]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
この千里眼の力、わたくしにも制御できないというの…?[p]
[return]


*COFortuneTelling_false_neutral_died
[eval exp="tf.face = '目閉じ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_false_neutral_died_01.ogg"]
[playselist buf="1"]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
わたくしたちが共に手を取り合えた未来もあったのかしら。[p]
[return]


*COFortuneTelling_false_love_died
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_false_love_died_01.ogg"]
[playselist buf="1"]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
仇は必ずとるわ。どうかわたくしを見守ってちょうだい…！[p]
[return]


*COFortuneTelling_false_hate_died
[eval exp="tf.face = '目閉じ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist buf="1" storage="chara/metan/metan_COFortuneTelling_false_hate_died_01.ogg"]
[playselist buf="1"]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
どうやら人狼はわたくしを陥れるつもりのようね。[p]
[return]


; doAction_{actionId}_{decision}
; シーン：「疑う」アクション実行時
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
*doAction_suspect_logical
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_suspect_logical_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_suspect_logical_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_suspect_logical_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_suspect_logical_04.ogg"]
[endif]
[add_playselist buf="1" storage="chara/metan/metan_doAction_suspect_logical_05.ogg"]
[playselist buf="1"]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]、足掻いても無駄よ。[r]
あなたの犯した罪は決して消えないわ。[p]
[return]


*doAction_suspect_emotional
[eval exp="tf.face = '真剣'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_suspect_emotional_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_suspect_emotional_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_suspect_emotional_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_suspect_emotional_04.ogg"]
[endif]
[playselist buf="1"]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]、そろそろ認めたらどうかしら？[r]
自分が人狼だということを。[p]
[return]


; シーン：「信じる」アクション実行時
*doAction_trust_logical
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_trust_logical_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_trust_logical_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_trust_logical_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_trust_logical_04.ogg"]
[endif]
[add_playselist buf="1" storage="chara/metan/metan_doAction_trust_logical_05.ogg"]
[playselist buf="1"]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]とわたくしが手を携えることは、[r]
運命の女神によって定められているわ。[p]
[return]


*doAction_trust_emotional
[eval exp="tf.face = 'クスクス'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_trust_emotional_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_trust_emotional_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_trust_emotional_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_trust_emotional_04.ogg"]
[endif]
[playselist buf="1"]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]、わたくしと共にこの苦難を乗り越えましょう。[p]
[return]


; シーン：「聞き出す」アクション実行時
*doAction_ask
[eval exp="tf.targetId = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

状況が混沌としてきたわね……。[r]
[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]の考えを聞かせてくれるかしら？[p]
[return]


; doAction_reaction_{actionId}_{feeling}
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
; ※targetIdの方がこのサブルーチンのキャラクターであること
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect_neutral
[eval exp="tf.face = '目閉じ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist buf="1" storage="chara/metan/metan_doAction_reaction_suspect_neutral_01.ogg"]
[playselist buf="1"]

心外ね。あなたはもう少し賢いと思っていたのだけど。[p]
[return]


*doAction_reaction_suspect_love
[eval exp="tf.face = '困惑'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist buf="1" storage="chara/metan/metan_doAction_reaction_suspect_love_01.ogg"]
[playselist buf="1"]

わ、わたくしを裏切るというのね！[r]
この代償は高くつくわよ…！[p]
[return]


*doAction_reaction_suspect_hate
[eval exp="tf.face = '目閉じ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist buf="1" storage="chara/metan/metan_doAction_reaction_suspect_hate_01.ogg"]
[playselist buf="1"]

そう、わたくしたちは光と闇の両極。[r]
決して相容れない存在よ。[p]
[return]


; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust_neutral
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist buf="1" storage="chara/metan/metan_doAction_reaction_trust_neutral_01.ogg"]
[playselist buf="1"]

ふふ。わたくしがあなたを勝利に導いてあげるわ。[p]
[return]


*doAction_reaction_trust_love
[eval exp="tf.face = '恥ずかしい'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist buf="1" storage="chara/metan/metan_doAction_reaction_trust_love_01.ogg"]
[playselist buf="1"]

べ、別に嬉しくなんてないわ…！[p]
[return]


*doAction_reaction_trust_hate
[eval exp="tf.face = '困惑'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist buf="1" storage="chara/metan/metan_doAction_reaction_trust_hate_01.ogg"]
[playselist buf="1"]

まさか、あなたの口からそんな言葉が聞けるとはね。[p]
[return]


; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
わたくしに聞かないでちょうだい！[p]
[return]


; シーン：「喋りすぎ」アクション実行時
*doAction_talkToMuch
[eval exp="tf.face = '真剣'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[add_playselist buf="1" storage="chara/metan/metan_doAction_talkToMuch_01.ogg"]
[playselist buf="1"]

そのよく回る口を封印できる魔導書はどこかしら？[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[add_playselist buf="1" storage="chara/metan/metan_executed_01.ogg"]
[playselist buf="1"]

これがわたくしの運命なら、受け入れるしかないのでしょうね。[p]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
（未作成）[p]
[return]


; chooseWhoToBite
; シーン：人狼で、誰を噛むか選ぶときのセリフ
*chooseWhoToBite
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/metan/metan_chooseWhoToBite_01.ogg" buf="1"]

わたくしは血に飢えた獣…。[r]
さあ、今宵の生贄は誰かしら？[p]
[return]


; このサブルーチンのボイスファイルを全てpreloadするためのサブルーチン
*preloadVoice
  [iscript]
    tf.preloadList.push(
      "data/sound/chara/metan/metan_noticeRole_villager_01.ogg",
      "data/sound/chara/metan/metan_noticeRole_fortuneTeller_01.ogg",
      "data/sound/chara/metan/metan_noticeRole_werewolf_01.ogg",
      "data/sound/chara/metan/metan_noticeRole_madman_01.ogg",
      "data/sound/chara/metan/metan_announcedFortuneTellingResult_true_01.ogg",
      "data/sound/chara/metan/metan_announcedFortuneTellingResult_true_02.ogg",
      "data/sound/chara/metan/metan_announcedFortuneTellingResult_true_03.ogg",
      "data/sound/chara/metan/metan_announcedFortuneTellingResult_true_04.ogg",
      "data/sound/chara/metan/metan_announcedFortuneTellingResult_false_01.ogg",
      "data/sound/chara/metan/metan_announcedFortuneTellingResult_false_02.ogg",
      "data/sound/chara/metan/metan_announcedFortuneTellingResult_false_03.ogg",
      "data/sound/chara/metan/metan_announcedFortuneTellingResult_false_04.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_true_positive_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_true_positive_02.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_true_positive_03.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_true_positive_04.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_true_neutral_alive_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_true_love_alive_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_true_hate_alive_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_false_positive_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_false_positive_02.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_false_positive_03.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_false_positive_04.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_false_negative_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_false_negative_02.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_false_negative_03.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_voice_false_negative_04.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_false_neutral_alive_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_false_love_alive_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_false_hate_alie_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_false_neutral_died_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_false_love_died_01.ogg",
      "data/sound/chara/metan/metan_COFortuneTelling_false_hate_died_01.ogg",
      "data/sound/chara/metan/metan_doAction_suspect_logical_01.ogg",
      "data/sound/chara/metan/metan_doAction_suspect_logical_02.ogg",
      "data/sound/chara/metan/metan_doAction_suspect_logical_03.ogg",
      "data/sound/chara/metan/metan_doAction_suspect_logical_04.ogg",
      "data/sound/chara/metan/metan_doAction_suspect_logical_05.ogg",
      "data/sound/chara/metan/metan_doAction_suspect_emotional_01.ogg",
      "data/sound/chara/metan/metan_doAction_suspect_emotional_02.ogg",
      "data/sound/chara/metan/metan_doAction_suspect_emotional_03.ogg",
      "data/sound/chara/metan/metan_doAction_suspect_emotional_04.ogg",
      "data/sound/chara/metan/metan_doAction_suspect_emotional_05.ogg",
      "data/sound/chara/metan/metan_doAction_trust_logical_01.ogg",
      "data/sound/chara/metan/metan_doAction_trust_logical_02.ogg",
      "data/sound/chara/metan/metan_doAction_trust_logical_03.ogg",
      "data/sound/chara/metan/metan_doAction_trust_logical_04.ogg",
      "data/sound/chara/metan/metan_doAction_trust_logical_05.ogg",
      "data/sound/chara/metan/metan_doAction_trust_emotional_01.ogg",
      "data/sound/chara/metan/metan_doAction_trust_emotional_02.ogg",
      "data/sound/chara/metan/metan_doAction_trust_emotional_03.ogg",
      "data/sound/chara/metan/metan_doAction_trust_emotional_04.ogg",
      "data/sound/chara/metan/metan_doAction_trust_emotional_05.ogg",
      "data/sound/chara/metan/metan_doAction_ask_01.ogg",
      "data/sound/chara/metan/metan_doAction_reaction_suspect_neutral_01.ogg",
      "data/sound/chara/metan/metan_doAction_reaction_suspect_love_01.ogg",
      "data/sound/chara/metan/metan_doAction_reaction_suspect_hate_01.ogg",
      "data/sound/chara/metan/metan_doAction_reaction_trust_neutral_01.ogg",
      "data/sound/chara/metan/metan_doAction_reaction_trust_love_01.ogg",
      "data/sound/chara/metan/metan_doAction_reaction_trust_hate_01.ogg",
      "data/sound/chara/metan/metan_doAction_reaction_ask_01.ogg",
      "data/sound/chara/metan/metan_doAction_talkToMuch_01.ogg",
      "data/sound/chara/metan/metan_executed_01.ogg",
      "data/sound/chara/metan/metan_chooseWhoToBite_01.ogg",
    );
  [endscript]
[return]
