; 雨晴はうのmessageサブルーチン

; 呼び方サブルーチン
; 事前準備：tf.targetId = キャラクターID
; このmessageサブルーチンのキャラクターが、tf.targetIdのキャラクターを呼ぶ際の二人称をtf.targetNameに格納する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [iscript]
    tf.targetName = (function(characterId) {
      const calledCharacterNameObject = {
        [CHARACTER_ID_ZUNDAMON]: 'ずんだもん',
        [CHARACTER_ID_METAN]:    'めたんさん',
        [CHARACTER_ID_TSUMUGI]:  'つむぎさん',
        [CHARACTER_ID_HAU]:      '僕',
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
[playse storage="chara/hau/hau_noticeRole_villager_01.ogg"]

僕は村人ですね。[r]
どこまで村に貢献できるか分かりませんが、努力します。[p]
[return]


*noticeRole_fortuneTeller
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/hau/hau_noticeRole_fortuneTeller_01.ogg"]

僕が占い師ですか。[r]
はうぅ、責任重大ですね…。[p]
[return]


*noticeRole_werewolf
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/hau/hau_noticeRole_werewolf_01.ogg"]

僕は人狼なんですね。[r]
こんなときまで夜勤しないといけないなんて…。[p]
[return]


*noticeRole_madman
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/hau/hau_noticeRole_madman_01.ogg"]

僕が狂人ですか。[r]
つまり、好き放題やっていいってことですよね！？[p]
[return]


; announcedFortuneTellingResult_{result}
; シーン：真占い師で、占い実行結果を知ったときの反応
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
; 備考：PCのみ想定
*announcedFortuneTellingResult_true
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/hau/hau_announcedFortuneTellingResult_true_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/hau/hau_announcedFortuneTellingResult_true_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/hau/hau_announcedFortuneTellingResult_true_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/hau/hau_announcedFortuneTellingResult_true_04.ogg"]
[endif]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]が人狼だったなんて…！[r]
早くみんなに知らせないと！[p]
[return]


*announcedFortuneTellingResult_false
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/hau/hau_announcedFortuneTellingResult_false_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/hau/hau_announcedFortuneTellingResult_false_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/hau/hau_announcedFortuneTellingResult_false_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/hau/hau_announcedFortuneTellingResult_false_04.ogg"]
[endif]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったようですね。[p]
[return]


; COFortuneTelling_voice_{result}_{feeling}
; COFortuneTellingのボイス用サブルーチン
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_voice_true_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_true_positive_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_true_positive_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_true_positive_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_true_positive_04.ogg"]
[endif]
[return]


*COFortuneTelling_voice_true_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_true_negative_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_true_negative_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_true_negative_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_true_negative_04.ogg"]
[endif]
[return]


; COFortuneTelling_{result}_{feeling}_{isAlive}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true_neutral_alive
[eval exp="tf.face = '考える'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_true_neutral_alive_01.ogg"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼でした…！[r]
潔く認めていただけると嬉しいのですが…。[p]
[return]


*COFortuneTelling_true_love_alive
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_true_love_alive_01.ogg"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼でした…！[r]
こんな結果、未だに信じられません…！[p]
[return]


*COFortuneTelling_true_hate_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_true_hate_alive_01.ogg"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼でした…！[r]
人狼さん、もう隠れても無駄ですよ？[p]
[return]


*COFortuneTelling_voice_false_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_false_positive_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_false_positive_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_false_positive_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_false_positive_04.ogg"]
[endif]
[return]


*COFortuneTelling_voice_false_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_false_negative_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_false_negative_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_false_negative_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_voice_false_negative_04.ogg"]
[endif]
[return]


*COFortuneTelling_false_neutral_alive
[eval exp="tf.face = '安心'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_false_neutral_alive_01.ogg"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
みなさん、安心して大丈夫ですよ。[p]
[return]


*COFortuneTelling_false_love_alive
[eval exp="tf.face = '笑顔'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_false_love_alive_01.ogg"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
もし人狼ならどうしようって思ってました…！[p]
[return]


*COFortuneTelling_false_hate_alive
[eval exp="tf.face = '苦笑'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_false_hate_alie_01.ogg"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
もう怪しまれるようなことしないでくださいね。[p]
[return]


*COFortuneTelling_false_neutral_died
[eval exp="tf.face = 'ため息'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_false_neutral_died_01.ogg"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
ああ、間に合いませんでしたか…！[p]
[return]


*COFortuneTelling_false_love_died
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_false_love_died_01.ogg"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
僕が力不足なばっかりに、すみません…！[p]
[return]


*COFortuneTelling_false_hate_died
[eval exp="tf.face = '苦笑'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/hau/hau_COFortuneTelling_false_hate_died_01.ogg"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
…いえ、僕がやったんじゃないですからね？[p]
[return]


; doAction_{actionId}_{decision}
; シーン：「疑う」アクション実行時
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
*doAction_suspect_logical
[eval exp="tf.face = '考える'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/hau_doAction_suspect_logical_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/hau_doAction_suspect_logical_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/hau_doAction_suspect_logical_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/hau_doAction_suspect_logical_04.ogg"]
[endif]

[add_playselist storage="chara/hau/hau_doAction_suspect_logical_05.ogg"]
[playselist]

人狼は[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]ですよね？[r]
どう考えてもそうとしか思えないのですが…。[p]
[return]


*doAction_suspect_emotional
[eval exp="tf.face = 'ため息'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/hau_doAction_suspect_emotional_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/hau_doAction_suspect_emotional_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/hau_doAction_suspect_emotional_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/hau_doAction_suspect_emotional_04.ogg"]
[endif]
[playselist]

僕は[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]が怪しいと思います。[r]
か、勘違いだったらすみません…！[p]
[return]


; シーン：「信じる」アクション実行時
*doAction_trust_logical
[eval exp="tf.face = '笑顔'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/hau_doAction_trust_logical_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/hau_doAction_trust_logical_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/hau_doAction_trust_logical_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/hau_doAction_trust_logical_04.ogg"]
[endif]
[add_playselist storage="chara/hau/hau_doAction_trust_logical_05.ogg"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は信頼に値する方です。[r]
少なくとも、僕にとっては確実に。[p]
[return]


*doAction_trust_emotional
[eval exp="tf.face = '安心'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/hau_doAction_trust_emotional_01.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/hau_doAction_trust_emotional_02.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/hau_doAction_trust_emotional_03.ogg"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/hau_doAction_trust_emotional_04.ogg"]
[endif]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]はきっと大丈夫です。[r]
僕はそう信じてます。[p]
[return]


; シーン：「聞き出す」アクション実行時
*doAction_ask
[eval exp="tf.targetId = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

えっと、[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]はどう思いますか？[p]
[return]


; doAction_reaction_{actionId}_{feeling}
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
; ※targetIdの方がこのサブルーチンのキャラクターであること
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect_neutral
[eval exp="tf.face = 'ため息'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/hau_doAction_reaction_suspect_neutral_01.ogg"]
[playselist]

どうせ僕なんて、疑われても仕方ないですよね…。[p]
[return]


*doAction_reaction_suspect_love
[eval exp="tf.face = '悲しみ'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/hau_doAction_reaction_suspect_love_01.ogg"]
[playselist]

…僕がどんなに頑張っても、報われることなんてないんですね。[p]
[return]


*doAction_reaction_suspect_hate
[eval exp="tf.face = '苦笑'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/hau_doAction_reaction_suspect_hate_01.ogg"]
[playselist]

はいはい、分かりました。お薬出しておきますね。[p]
[return]


; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust_neutral
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/hau_doAction_reaction_trust_neutral_01.ogg"]
[playselist]

ありがとうございます。僕も精一杯サポートしますね！[p]
[return]


*doAction_reaction_trust_love
[eval exp="tf.face = '安心'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/hau_doAction_reaction_trust_love_01.ogg"]
[playselist]

あなたと一緒だと心強いです。最後まで頑張りましょう！[p]
[return]


*doAction_reaction_trust_hate
[eval exp="tf.face = '考える'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/hau_doAction_reaction_trust_hate_01.ogg"]
[playselist]

…まあ、あなたのことも見捨てはしませんよ。[r]
僕は看護師ですから。[p]
[return]


; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
ぼ、僕ではお役に立てなさそうです。ごめんなさい。[p]
[return]


; シーン：「喋りすぎ」アクション実行時
*doAction_talkToMuch
[eval exp="tf.face = '苦笑'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/hau_doAction_talkToMuch_01.ogg"]
[playselist]

あの…そろそろお口にチャックお願いします。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[eval exp="tf.face = 'げっそり'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/hau_executed_01.ogg"]
[playselist]

これ以上、頑張らなくてもいいんですね。[r]
それじゃあ、おやすみなさい…。[p]
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
[playse storage="chara/hau/hau_chooseWhoToBite_01.ogg"]

ちょっとチクッとしますよ。[r]
大丈夫です、ほら、力を抜いて…。[p]
[return]


; このサブルーチンのボイスファイルを全てpreloadするためのサブルーチン
*preloadVoice
  [iscript]
    tf.preloadList.push(
      "data/sound/chara/hau/hau_noticeRole_villager_01.ogg",
      "data/sound/chara/hau/hau_noticeRole_fortuneTeller_01.ogg",
      "data/sound/chara/hau/hau_noticeRole_werewolf_01.ogg",
      "data/sound/chara/hau/hau_noticeRole_madman_01.ogg",
      "data/sound/chara/hau/hau_announcedFortuneTellingResult_true_01.ogg",
      "data/sound/chara/hau/hau_announcedFortuneTellingResult_true_02.ogg",
      "data/sound/chara/hau/hau_announcedFortuneTellingResult_true_03.ogg",
      "data/sound/chara/hau/hau_announcedFortuneTellingResult_true_04.ogg",
      "data/sound/chara/hau/hau_announcedFortuneTellingResult_false_01.ogg",
      "data/sound/chara/hau/hau_announcedFortuneTellingResult_false_02.ogg",
      "data/sound/chara/hau/hau_announcedFortuneTellingResult_false_03.ogg",
      "data/sound/chara/hau/hau_announcedFortuneTellingResult_false_04.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_true_positive_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_true_positive_02.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_true_positive_03.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_true_positive_04.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_true_negative_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_true_negative_02.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_true_negative_03.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_true_negative_04.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_true_neutral_alive_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_true_love_alive_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_true_hate_alive_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_false_positive_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_false_positive_02.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_false_positive_03.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_false_positive_04.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_false_negative_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_false_negative_02.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_false_negative_03.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_voice_false_negative_04.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_false_neutral_alive_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_false_love_alive_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_false_hate_alie_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_false_neutral_died_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_false_love_died_01.ogg",
      "data/sound/chara/hau/hau_COFortuneTelling_false_hate_died_01.ogg",
      "data/sound/chara/hau/hau_doAction_suspect_logical_01.ogg",
      "data/sound/chara/hau/hau_doAction_suspect_logical_02.ogg",
      "data/sound/chara/hau/hau_doAction_suspect_logical_03.ogg",
      "data/sound/chara/hau/hau_doAction_suspect_logical_04.ogg",
      "data/sound/chara/hau/hau_doAction_suspect_logical_05.ogg",
      "data/sound/chara/hau/hau_doAction_suspect_emotional_01.ogg",
      "data/sound/chara/hau/hau_doAction_suspect_emotional_02.ogg",
      "data/sound/chara/hau/hau_doAction_suspect_emotional_03.ogg",
      "data/sound/chara/hau/hau_doAction_suspect_emotional_04.ogg",
      "data/sound/chara/hau/hau_doAction_suspect_emotional_05.ogg",
      "data/sound/chara/hau/hau_doAction_trust_logical_01.ogg",
      "data/sound/chara/hau/hau_doAction_trust_logical_02.ogg",
      "data/sound/chara/hau/hau_doAction_trust_logical_03.ogg",
      "data/sound/chara/hau/hau_doAction_trust_logical_04.ogg",
      "data/sound/chara/hau/hau_doAction_trust_logical_05.ogg",
      "data/sound/chara/hau/hau_doAction_trust_emotional_01.ogg",
      "data/sound/chara/hau/hau_doAction_trust_emotional_02.ogg",
      "data/sound/chara/hau/hau_doAction_trust_emotional_03.ogg",
      "data/sound/chara/hau/hau_doAction_trust_emotional_04.ogg",
      "data/sound/chara/hau/hau_doAction_trust_emotional_05.ogg",
      "data/sound/chara/hau/hau_doAction_ask_01.ogg",
      "data/sound/chara/hau/hau_doAction_reaction_suspect_neutral_01.ogg",
      "data/sound/chara/hau/hau_doAction_reaction_suspect_love_01.ogg",
      "data/sound/chara/hau/hau_doAction_reaction_suspect_hate_01.ogg",
      "data/sound/chara/hau/hau_doAction_reaction_trust_neutral_01.ogg",
      "data/sound/chara/hau/hau_doAction_reaction_trust_love_01.ogg",
      "data/sound/chara/hau/hau_doAction_reaction_trust_hate_01.ogg",
      "data/sound/chara/hau/hau_doAction_reaction_ask_01.ogg",
      "data/sound/chara/hau/hau_doAction_talkToMuch_01.ogg",
      "data/sound/chara/hau/hau_executed_01.ogg",
      "data/sound/chara/hau/hau_chooseWhoToBite_01.ogg",
    );
  [endscript]
[return]
