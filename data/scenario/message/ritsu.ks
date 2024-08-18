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



; COFortuneTelling_{result}_{feeling}_{isAlive}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true_neutral_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/ritsu/009_波音リツ（ノーマル）_さあ、祭りを始めま….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]。アンタ人狼ね？[r]
さあ、祭りを始めましょうか。[p]
[stopse]
[return]


*COFortuneTelling_true_love_alive
[eval exp="tf.face = 'troubled'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/ritsu/010_波音リツ（ノーマル）_釣られていたのはあ….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]。アンタ人狼ね？[r]
釣られていたのはあたしの方だったようね。[p]
[stopse]
[return]


*COFortuneTelling_true_hate_alive
[eval exp="tf.face = 'scorn'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/ritsu/011_波音リツ（ノーマル）_NGリストにぶち込….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]。アンタ人狼ね？[r]
NGリストにぶち込んでやるわ。[p]
[stopse]
[return]


*COFortuneTelling_false_neutral_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/ritsu/020_波音リツ（ノーマル）_住民としてこの村を….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
住民としてこの村を盛り上げてちょうだい。[p]
[stopse]
[return]


*COFortuneTelling_false_love_alive
[eval exp="tf.face = 'laughing'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/ritsu/021_波音リツ（ノーマル）_アンタの意見は貴重….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
アンタの意見は貴重なソースになるわ。[p]
[stopse]
[return]


*COFortuneTelling_false_hate_alive
[eval exp="tf.face = 'scorn'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/ritsu/022_波音リツ（ノーマル）_…人狼のエサになる….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
…人狼のエサになる準備はOK？[p]
[stopse]
[return]


*COFortuneTelling_false_neutral_died
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/ritsu/023_波音リツ（ノーマル）_惜しい人をなくした….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
惜しい人をなくしたわね。[p]
[stopse]
[return]


*COFortuneTelling_false_love_died
[eval exp="tf.face = 'angry'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/ritsu/024_波音リツ（ノーマル）_くっ…絶対に許さん….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
くっ…絶対に許さんぞ人狼め！[p]
[stopse]
[return]


*COFortuneTelling_false_hate_died
[eval exp="tf.face = 'astonished'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/ritsu/025_波音リツ（ノーマル）_まああれだけ怪しか….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼じゃなかったわ。[r]
まああれだけ怪しかったし、残念だけど当然ね。[p]
[stopse]
[return]


; COFortuneTelling_voice_{result}_{feeling}
; COFortuneTellingのボイス用サブルーチン
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_voice_true_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/001_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/002_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/003_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/004_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[return]


*COFortuneTelling_voice_true_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/005_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/006_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/007_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/008_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[return]


*COFortuneTelling_voice_false_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/012_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/013_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/014_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/015_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[return]


*COFortuneTelling_voice_false_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/016_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/017_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/018_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/019_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[return]



; doAction_{actionId}_{decision}
; シーン：「疑う」アクション実行時
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
*doAction_suspect_logical
[eval exp="tf.face = 'scorn'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/030_波音リツ（ノーマル）_X、人狼はアンタよ！.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/031_波音リツ（ノーマル）_X、人狼はアンタよ！.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/032_波音リツ（ノーマル）_X、人狼はアンタよ！.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/033_波音リツ（ノーマル）_X、人狼はアンタよ！.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[add_playselist storage="chara/ritsu/034_波音リツ（ノーマル）_ねえねえ、言い当て….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]、人狼はアンタよ！[r]
ねえねえ、言い当てられて今どんな気持ち？[p]
[stopse]
[return]


*doAction_suspect_emotional
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/026_波音リツ（ノーマル）_Xはどうせ人狼でし….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/027_波音リツ（ノーマル）_Xはどうせ人狼でし….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/028_波音リツ（ノーマル）_Xはどうせ人狼でし….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/029_波音リツ（ノーマル）_Xはどうせ人狼でし….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]はどうせ人狼でしょうね。[r]
まあ根拠はないけれど。[p]
[stopse]
[return]


; シーン：「信じる」アクション実行時
*doAction_trust_logical
[eval exp="tf.face = 'laughing'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/039_波音リツ（ノーマル）_Xはあたしの仲間よ。.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/040_波音リツ（ノーマル）_Xはあたしの仲間よ。.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/041_波音リツ（ノーマル）_Xはあたしの仲間よ。.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/042_波音リツ（ノーマル）_Xはあたしの仲間よ。.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[add_playselist storage="chara/ritsu/043_波音リツ（ノーマル）_あたしが決めた。今….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]はあたしの仲間よ。[r]
あたしが決めた。今決めた。[p]
[stopse]
[return]


*doAction_trust_emotional
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/ritsu/035_波音リツ（ノーマル）_こう見えてもあたし….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/ritsu/036_波音リツ（ノーマル）_こう見えてもあたし….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/ritsu/037_波音リツ（ノーマル）_こう見えてもあたし….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/ritsu/038_波音リツ（ノーマル）_こう見えてもあたし….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
[playselist]

こう見えてもあたしは[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]に期待してるの。[r]
だからがっかりさせないでほしいわね。[p]
[stopse]
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
[eval exp="tf.face = 'astonished'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/045_波音リツ（ノーマル）_アンタがそう思うな….mp3"]
[playselist]

アンタがそう思うならそうなんでしょう。[r]
アンタの中ではね。[p]
[stopse]
[return]


*doAction_reaction_suspect_love
[eval exp="tf.face = 'troubled'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/046_波音リツ（ノーマル）_ふう、なんとか致命….mp3"]
[playselist]

ふう、なんとか致命傷で済んだわ。[p]
[stopse]
[return]


*doAction_reaction_suspect_hate
[eval exp="tf.face = 'scorn'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/047_波音リツ（ノーマル）_あたしを疑うの？も….mp3"]
[playselist]

あたしを疑うの？もうね、アボカド。バナナかと。[p]
[stopse]
[return]


; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust_neutral
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/048_波音リツ（ノーマル）_ふふ、嬉しいことを….mp3"]
[playselist]

ふふ、嬉しいことを言ってくれるじゃない。[p]
[stopse]
[return]


*doAction_reaction_trust_love
[eval exp="tf.face = 'laughing'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/049_波音リツ（ノーマル）_なんだ、ただの神か。.mp3"]
[playselist]

なんだ、ただの神か。[p]
[stopse]
[return]


*doAction_reaction_trust_hate
[eval exp="tf.face = 'blank'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/ritsu/050_波音リツ（ノーマル）_あっそう。華麗にス….mp3"]
[playselist]

あっそう。華麗にスルーさせてもらうわね。[p]
[stopse]
[return]


; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
アンタに教えることなんて何もないわ。[p]
[return]


; シーン：「喋りすぎ」アクション実行時
*doAction_talkToMuch
[call storage="./message/utility.ks" target="prepareMessage"]
半年ROMってなさい。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[eval exp="tf.face = 'astonished'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[add_playselist storage="chara/ritsu/052_波音リツ（ノーマル）_安価は絶対……。あ….mp3"]
[playselist]

安価は絶対…。あたしは潔く去るわ。[p]
[stopse]
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
      "data/sound/chara/ritsu/001_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3",
      "data/sound/chara/ritsu/002_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3",
      "data/sound/chara/ritsu/003_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3",
      "data/sound/chara/ritsu/004_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3",
      "data/sound/chara/ritsu/005_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3",
      "data/sound/chara/ritsu/006_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3",
      "data/sound/chara/ritsu/007_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3",
      "data/sound/chara/ritsu/008_波音リツ（ノーマル）_X。アンタ人狼ね？.mp3",
      "data/sound/chara/ritsu/009_波音リツ（ノーマル）_さあ、祭りを始めま….mp3",
      "data/sound/chara/ritsu/010_波音リツ（ノーマル）_釣られていたのはあ….mp3",
      "data/sound/chara/ritsu/011_波音リツ（ノーマル）_NGリストにぶち込….mp3",
      "data/sound/chara/ritsu/012_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/ritsu/013_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/ritsu/014_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/ritsu/015_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/ritsu/016_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/ritsu/017_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/ritsu/018_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/ritsu/019_波音リツ（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/ritsu/020_波音リツ（ノーマル）_住民としてこの村を….mp3",
      "data/sound/chara/ritsu/021_波音リツ（ノーマル）_アンタの意見は貴重….mp3",
      "data/sound/chara/ritsu/022_波音リツ（ノーマル）_…人狼のエサになる….mp3",
      "data/sound/chara/ritsu/023_波音リツ（ノーマル）_惜しい人をなくした….mp3",
      "data/sound/chara/ritsu/024_波音リツ（ノーマル）_くっ…絶対に許さん….mp3",
      "data/sound/chara/ritsu/025_波音リツ（ノーマル）_まああれだけ怪しか….mp3",
      "data/sound/chara/ritsu/026_波音リツ（ノーマル）_Xはどうせ人狼でし….mp3",
      "data/sound/chara/ritsu/027_波音リツ（ノーマル）_Xはどうせ人狼でし….mp3",
      "data/sound/chara/ritsu/028_波音リツ（ノーマル）_Xはどうせ人狼でし….mp3",
      "data/sound/chara/ritsu/029_波音リツ（ノーマル）_Xはどうせ人狼でし….mp3",
      "data/sound/chara/ritsu/030_波音リツ（ノーマル）_X、人狼はアンタよ！.mp3",
      "data/sound/chara/ritsu/031_波音リツ（ノーマル）_X、人狼はアンタよ！.mp3",
      "data/sound/chara/ritsu/032_波音リツ（ノーマル）_X、人狼はアンタよ！.mp3",
      "data/sound/chara/ritsu/033_波音リツ（ノーマル）_X、人狼はアンタよ！.mp3",
      "data/sound/chara/ritsu/034_波音リツ（ノーマル）_ねえねえ、言い当て….mp3",
      "data/sound/chara/ritsu/035_波音リツ（ノーマル）_こう見えてもあたし….mp3",
      "data/sound/chara/ritsu/036_波音リツ（ノーマル）_こう見えてもあたし….mp3",
      "data/sound/chara/ritsu/037_波音リツ（ノーマル）_こう見えてもあたし….mp3",
      "data/sound/chara/ritsu/038_波音リツ（ノーマル）_こう見えてもあたし….mp3",
      "data/sound/chara/ritsu/039_波音リツ（ノーマル）_Xはあたしの仲間よ。.mp3",
      "data/sound/chara/ritsu/040_波音リツ（ノーマル）_Xはあたしの仲間よ。.mp3",
      "data/sound/chara/ritsu/041_波音リツ（ノーマル）_Xはあたしの仲間よ。.mp3",
      "data/sound/chara/ritsu/042_波音リツ（ノーマル）_Xはあたしの仲間よ。.mp3",
      "data/sound/chara/ritsu/043_波音リツ（ノーマル）_あたしが決めた。今….mp3",
      "data/sound/chara/ritsu/044_波音リツ（ノーマル）_X、三行で説明よろ….mp3",
      "data/sound/chara/ritsu/045_波音リツ（ノーマル）_アンタがそう思うな….mp3",
      "data/sound/chara/ritsu/046_波音リツ（ノーマル）_ふう、なんとか致命….mp3",
      "data/sound/chara/ritsu/047_波音リツ（ノーマル）_あたしを疑うの？も….mp3",
      "data/sound/chara/ritsu/048_波音リツ（ノーマル）_ふふ、嬉しいことを….mp3",
      "data/sound/chara/ritsu/049_波音リツ（ノーマル）_なんだ、ただの神か。.mp3",
      "data/sound/chara/ritsu/050_波音リツ（ノーマル）_あっそう。華麗にス….mp3",
      "data/sound/chara/ritsu/051_波音リツ（ノーマル）_アンタに教えること….mp3",
      "data/sound/chara/ritsu/052_波音リツ（ノーマル）_安価は絶対……。あ….mp3",
    );
  [endscript]
[return]
