; ずんだもんのmessageサブルーチン

; 呼び方サブルーチン
; 事前準備：tf.characterIdToCall = キャラクターID
; このmessageサブルーチンのキャラクターが、tf.characterIdToCallのキャラクターを呼ぶ際の二人称をtf.calledCharacterNameに格納する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [iscript]
    tf.calledCharacterName = (function(characterId) {
      const calledCharacterNameObject = {
        [CHARACTER_ID_ZUNDAMON]: '僕',
        [CHARACTER_ID_METAN]:    'めたん',
        [CHARACTER_ID_TSUMUGI]:  'つむぎ',
        [CHARACTER_ID_HAU]:      'はう',
        [CHARACTER_ID_RITSU]:    'リツ',
      }
      return calledCharacterNameObject[characterId];
    }(tf.characterIdToCall));
  [endscript]
[return]


; noticeRole_{roleId}
; シーン：初日、役職を告知されたときの反応
; 備考：PCのみ想定
*noticeRole_villager
[playse storage="chara/zundamon/001_ずんだもん（ノーマル）_僕は村人なのだ。悪….mp3"]

僕は村人なのだ。[r]
悪い人狼を見つけて平和な村にするのだ。[p]
[stopse]
[return]


*noticeRole_fortuneTeller
[playse storage="chara/zundamon/002_ずんだもん（ノーマル）_僕は占い師なのだ。….mp3"]

僕は占い師なのだ。[r]
さっそく誰か占ってみるのだ！[p]
[stopse]
[return]


*noticeRole_werewolf
[playse storage="chara/zundamon/003_ずんだもん（ノーマル）_僕は人狼……。みん….mp3"]

僕は人狼……。[r]
みんな僕がおいしく食べてやるのだ！[p]
[stopse]
[return]


*noticeRole_madman
[playse storage="chara/zundamon/004_ずんだもん（ノーマル）_僕は狂人なのだ……….mp3"]

僕は狂人なのだ……。[r]
僕がご主人の野望を手助けするのだ！[p]
[stopse]
[return]



; announcedFortuneTellingResult_{result}
; シーン：真占い師で、占い実行結果を知ったときの反応
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
; 備考：PCのみ想定
*announcedFortuneTellingResult_true
[call storage="./message/utility.ks" target="prepareMessage"]

[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/005_ずんだもん（ノーマル）_発見なのだ！Xが人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/006_ずんだもん（ノーマル）_発見なのだ！Xが人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/007_ずんだもん（ノーマル）_発見なのだ！Xが人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/008_ずんだもん（ノーマル）_発見なのだ！Xが人….mp3"]
[endif]

発見なのだ！[emb exp="tf.calledCharacterName"]が人狼だったのだ！[p]
[stopse]
[return]


*announcedFortuneTellingResult_false
[call storage="./message/utility.ks" target="prepareMessage"]

[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/009_ずんだもん（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/010_ずんだもん（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/011_ずんだもん（ノーマル）_Xは人狼じゃなかっ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/012_ずんだもん（ノーマル）_Xは人狼じゃなかっ….mp3"]
[endif]

[emb exp="tf.calledCharacterName"]は人狼じゃなかったのだ。[p]
[stopse]
[return]



; COFortuneTelling_{result}_{feeling}_{isAlive}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true_neutral_alive
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/zundamon/021_ずんだもん（ノーマル）_力を合わせてやっつ….mp3"]
[playselist]

みんな、[emb exp="tf.calledCharacterName"]は人狼だったのだ！[r]
力を合わせてやっつけるのだ！[p]
[stopse]
[return]


*COFortuneTelling_true_love_alive
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/zundamon/022_ずんだもん（ノーマル）_僕も今まで騙されて….mp3"]
[playselist]

みんな、[emb exp="tf.calledCharacterName"]は人狼だったのだ。[r]
僕も今まで騙されてたのだ…。[p]
[stopse]
[return]


*COFortuneTelling_true_hate_alive
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/zundamon/023_ずんだもん（ノーマル）_ふふん！僕にはお見….mp3"]
[playselist]

みんな、[emb exp="tf.calledCharacterName"]は人狼だったのだ！[r]
ふふん！僕にはお見通しなのだ！[p]
[stopse]
[return]


*COFortuneTelling_false_neutral_alive
[eval exp="tf.face = 'deny'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/zundamon/032_ずんだもん（ノーマル）_つまり人狼は他にい….mp3"]
[playselist]

みんな、[emb exp="tf.calledCharacterName"]は人狼じゃなかったのだ。[r]
つまり人狼は他にいるってことなのだ。[p]
[stopse]
[return]


*COFortuneTelling_false_love_alive
[eval exp="tf.face = 'deny'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/zundamon/033_ずんだもん（ノーマル）_無実が証明できてよ….mp3"]
[playselist]

みんな、[emb exp="tf.calledCharacterName"]は人狼じゃなかったのだ！[r]
無実が証明できてよかったのだ！[p]
[stopse]
[return]


*COFortuneTelling_false_hate_alive
[eval exp="tf.face = 'deny'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/zundamon/034_ずんだもん（ノーマル）_自分の占い結果が信….mp3"]
[playselist]

みんな、[emb exp="tf.calledCharacterName"]は人狼じゃなかったのだ。[r]
自分の占い結果が信じられないのだ。[p]
[stopse]
[return]


*COFortuneTelling_false_neutral_died
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/zundamon/035_ずんだもん（ノーマル）_けど、残念ながら手….mp3"]
[playselist]

みんな、[emb exp="tf.calledCharacterName"]は人狼じゃなかったのだ。[r]
けど、残念ながら手遅れだったのだ。[p]
[stopse]
[return]


*COFortuneTelling_false_love_died
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/zundamon/036_ずんだもん（ノーマル）_ひどいのだ…誰がこ….mp3"]
[playselist]

みんな、[emb exp="tf.calledCharacterName"]は人狼じゃなかったのだ。[r]
ひどいのだ…誰がこんなことをしたのだ…！[p]
[stopse]
[return]


*COFortuneTelling_false_hate_died
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/zundamon/037_ずんだもん（ノーマル）_これじゃあ占った意….mp3"]
[playselist]

みんな、[emb exp="tf.calledCharacterName"]は人狼じゃなかったのだ。[r]
これじゃあ占った意味がないのだ。[p]
[stopse]
[return]


; COFortuneTelling_voice_{result}_{feeling}
; COFortuneTellingのボイス用サブルーチン
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_voice_true_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/zundamon/013_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/zundamon/014_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/zundamon/015_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/zundamon/016_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3"]
[endif]
[return]


*COFortuneTelling_voice_true_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/zundamon/017_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/zundamon/018_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/zundamon/019_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/zundamon/020_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3"]
[endif]
[return]


*COFortuneTelling_voice_false_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/zundamon/024_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/zundamon/025_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/zundamon/026_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/zundamon/027_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3"]
[endif]
[return]


*COFortuneTelling_voice_false_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/zundamon/028_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/zundamon/029_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/zundamon/030_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/zundamon/031_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3"]
[endif]
[return]



; doAction_{actionId}_{decision}
; シーン：「疑う」アクション実行時
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
*doAction_suspect_logical
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/053_ずんだもん（ノーマル）_僕のずんだ色の脳み….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/054_ずんだもん（ノーマル）_僕のずんだ色の脳み….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/055_ずんだもん（ノーマル）_僕のずんだ色の脳み….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/056_ずんだもん（ノーマル）_僕のずんだ色の脳み….mp3"]
[endif]

僕のずんだ色の脳みそが告げているのだ。[r]
[emb exp="tf.calledCharacterName"]は人狼に違いないのだ！[p]
[stopse]
[return]


*doAction_suspect_emotional
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/049_ずんだもん（ノーマル）_もしかしてXが人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/050_ずんだもん（ノーマル）_もしかしてXが人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/051_ずんだもん（ノーマル）_もしかしてXが人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/052_ずんだもん（ノーマル）_もしかしてXが人狼….mp3"]
[endif]

もしかして[emb exp="tf.calledCharacterName"]が人狼なのだ……？[r]
そんな気がするのだ。[p]
[stopse]
[return]


; シーン：「信じる」アクション実行時
*doAction_trust_logical
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/069_ずんだもん（ノーマル）_Xは絶対絶対人狼じ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/070_ずんだもん（ノーマル）_Xは絶対絶対人狼じ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/071_ずんだもん（ノーマル）_Xは絶対絶対人狼じ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/072_ずんだもん（ノーマル）_Xは絶対絶対人狼じ….mp3"]
[endif]

[emb exp="tf.calledCharacterName"]は絶対絶対人狼じゃないのだ。[r]
僕でも分かるのだ！[p]
[stopse]
[return]


*doAction_trust_emotional
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/065_ずんだもん（ノーマル）_僕はXを信じてるの….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/066_ずんだもん（ノーマル）_僕はXを信じてるの….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/067_ずんだもん（ノーマル）_僕はXを信じてるの….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/068_ずんだもん（ノーマル）_僕はXを信じてるの….mp3"]
[endif]

僕は[emb exp="tf.calledCharacterName"]を信じてるのだ。[r]
きっと人狼じゃないのだ！[p]
[stopse]
[return]


; シーン：「聞き出す」アクション実行時
*doAction_ask
[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

[emb exp="tf.calledCharacterName"]にちょっと質問なのだ。[r]
今の状況をどう思うのだ？[p]
[return]


; doAction_reaction_{actionId}_{feeling}
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
; ※targetIdの方がこのサブルーチンのキャラクターであること
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect_neutral
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/082_ずんだもん（ノーマル）_ぼ、僕は人狼じゃな….mp3"]
ぼ、僕は人狼じゃないのだっ！[p]
[stopse]
[return]


*doAction_reaction_suspect_love
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/083_ずんだもん（ノーマル）_違うのだ！僕じゃな….mp3"]
違うのだ！僕じゃないのだ！信じて欲しいのだ…！[p]
[stopse]
[return]


*doAction_reaction_suspect_hate
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/084_ずんだもん（ノーマル）_そう言うオマエこそ….mp3"]
そう言うオマエこそ人狼じゃないのだ？[p]
[stopse]
[return]


; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust_neutral
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/085_ずんだもん（ノーマル）_信じてくれてありが….mp3"]
信じてくれてありがとうなのだ！[p]
[stopse]
[return]


*doAction_reaction_trust_love
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/086_ずんだもん（ノーマル）_嬉しいのだ！そう言….mp3"]
嬉しいのだ！そう言ってくれるって信じてたのだ！[p]
[stopse]
[return]


*doAction_reaction_trust_hate
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[playse storage="chara/zundamon/087_ずんだもん（ノーマル）_…本当にそう思って….mp3"]
…本当にそう思ってるのだ？[r]
口先では何とでも言えるのだ。[p]
[stopse]
[return]


; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
もうなんにも分からないのだ……！[p]
[return]



; chooseWhoToBite
; シーン：人狼で、誰を噛むか選ぶときのセリフ
*chooseWhoToBite
[playse storage="chara/zundamon/089_ずんだもん（ノーマル）_くくく、今夜は誰を….mp3"]

くくく、今夜は誰を食べちゃおうかな……。[r]
いただきまーすなのだ！[p]
[stopse]
[return]



; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[playse storage="chara/zundamon/090_ずんだもん（ノーマル）_なんでなのだ！僕は….mp3"]

なんでなのだ！僕は悪くないのだ！[p]
[stopse]
[return]



; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
この決断が、間違ってないといいのだ……。[p]
[return]



; このサブルーチンのボイスファイルを全てpreloadするためのサブルーチン
*preloadVoice
  [iscript]
    tf.preloadList.push(
      "data/sound/chara/zundamon/001_ずんだもん（ノーマル）_僕は村人なのだ。悪….mp3",
      "data/sound/chara/zundamon/002_ずんだもん（ノーマル）_僕は占い師なのだ。….mp3",
      "data/sound/chara/zundamon/003_ずんだもん（ノーマル）_僕は人狼……。みん….mp3",
      "data/sound/chara/zundamon/004_ずんだもん（ノーマル）_僕は狂人なのだ……….mp3",
      "data/sound/chara/zundamon/005_ずんだもん（ノーマル）_発見なのだ！Xが人….mp3",
      "data/sound/chara/zundamon/006_ずんだもん（ノーマル）_発見なのだ！Xが人….mp3",
      "data/sound/chara/zundamon/007_ずんだもん（ノーマル）_発見なのだ！Xが人….mp3",
      "data/sound/chara/zundamon/008_ずんだもん（ノーマル）_発見なのだ！Xが人….mp3",
      "data/sound/chara/zundamon/009_ずんだもん（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/zundamon/010_ずんだもん（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/zundamon/011_ずんだもん（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/zundamon/012_ずんだもん（ノーマル）_Xは人狼じゃなかっ….mp3",
      "data/sound/chara/zundamon/013_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3",
      "data/sound/chara/zundamon/014_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3",
      "data/sound/chara/zundamon/015_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3",
      "data/sound/chara/zundamon/016_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3",
      "data/sound/chara/zundamon/017_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3",
      "data/sound/chara/zundamon/018_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3",
      "data/sound/chara/zundamon/019_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3",
      "data/sound/chara/zundamon/020_ずんだもん（ノーマル）_みんな、Xは人狼だ….mp3",
      "data/sound/chara/zundamon/021_ずんだもん（ノーマル）_力を合わせてやっつ….mp3",
      "data/sound/chara/zundamon/022_ずんだもん（ノーマル）_僕も今まで騙されて….mp3",
      "data/sound/chara/zundamon/023_ずんだもん（ノーマル）_ふふん！僕にはお見….mp3",
      "data/sound/chara/zundamon/024_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3",
      "data/sound/chara/zundamon/025_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3",
      "data/sound/chara/zundamon/026_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3",
      "data/sound/chara/zundamon/027_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3",
      "data/sound/chara/zundamon/028_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3",
      "data/sound/chara/zundamon/029_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3",
      "data/sound/chara/zundamon/030_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3",
      "data/sound/chara/zundamon/031_ずんだもん（ノーマル）_みんな、Xは人狼じ….mp3",
      "data/sound/chara/zundamon/032_ずんだもん（ノーマル）_つまり人狼は他にい….mp3",
      "data/sound/chara/zundamon/033_ずんだもん（ノーマル）_無実が証明できてよ….mp3",
      "data/sound/chara/zundamon/034_ずんだもん（ノーマル）_自分の占い結果が信….mp3",
      "data/sound/chara/zundamon/035_ずんだもん（ノーマル）_けど、残念ながら手….mp3",
      "data/sound/chara/zundamon/036_ずんだもん（ノーマル）_ひどいのだ…誰がこ….mp3",
      "data/sound/chara/zundamon/037_ずんだもん（ノーマル）_これじゃあ占った意….mp3",
      "data/sound/chara/zundamon/038_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/039_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/040_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/041_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/042_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/043_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/044_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/045_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/046_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/047_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/048_ずんだもん（ノーマル）_昨日はXを占ったの….mp3",
      "data/sound/chara/zundamon/049_ずんだもん（ノーマル）_もしかしてXが人狼….mp3",
      "data/sound/chara/zundamon/050_ずんだもん（ノーマル）_もしかしてXが人狼….mp3",
      "data/sound/chara/zundamon/051_ずんだもん（ノーマル）_もしかしてXが人狼….mp3",
      "data/sound/chara/zundamon/052_ずんだもん（ノーマル）_もしかしてXが人狼….mp3",
      "data/sound/chara/zundamon/053_ずんだもん（ノーマル）_僕のずんだ色の脳み….mp3",
      "data/sound/chara/zundamon/054_ずんだもん（ノーマル）_僕のずんだ色の脳み….mp3",
      "data/sound/chara/zundamon/055_ずんだもん（ノーマル）_僕のずんだ色の脳み….mp3",
      "data/sound/chara/zundamon/056_ずんだもん（ノーマル）_僕のずんだ色の脳み….mp3",
      "data/sound/chara/zundamon/057_ずんだもん（ノーマル）_僕もXは怪しいと思….mp3",
      "data/sound/chara/zundamon/058_ずんだもん（ノーマル）_僕もXは怪しいと思….mp3",
      "data/sound/chara/zundamon/059_ずんだもん（ノーマル）_僕もXは怪しいと思….mp3",
      "data/sound/chara/zundamon/060_ずんだもん（ノーマル）_僕もXは怪しいと思….mp3",
      "data/sound/chara/zundamon/061_ずんだもん（ノーマル）_どうしてXを信じて….mp3",
      "data/sound/chara/zundamon/062_ずんだもん（ノーマル）_どうしてXを信じて….mp3",
      "data/sound/chara/zundamon/063_ずんだもん（ノーマル）_どうしてXを信じて….mp3",
      "data/sound/chara/zundamon/064_ずんだもん（ノーマル）_どうしてXを信じて….mp3",
      "data/sound/chara/zundamon/065_ずんだもん（ノーマル）_僕はXを信じてるの….mp3",
      "data/sound/chara/zundamon/066_ずんだもん（ノーマル）_僕はXを信じてるの….mp3",
      "data/sound/chara/zundamon/067_ずんだもん（ノーマル）_僕はXを信じてるの….mp3",
      "data/sound/chara/zundamon/068_ずんだもん（ノーマル）_僕はXを信じてるの….mp3",
      "data/sound/chara/zundamon/069_ずんだもん（ノーマル）_Xは絶対絶対人狼じ….mp3",
      "data/sound/chara/zundamon/070_ずんだもん（ノーマル）_Xは絶対絶対人狼じ….mp3",
      "data/sound/chara/zundamon/071_ずんだもん（ノーマル）_Xは絶対絶対人狼じ….mp3",
      "data/sound/chara/zundamon/072_ずんだもん（ノーマル）_Xは絶対絶対人狼じ….mp3",
      "data/sound/chara/zundamon/073_ずんだもん（ノーマル）_先に言われちゃった….mp3",
      "data/sound/chara/zundamon/074_ずんだもん（ノーマル）_先に言われちゃった….mp3",
      "data/sound/chara/zundamon/075_ずんだもん（ノーマル）_先に言われちゃった….mp3",
      "data/sound/chara/zundamon/076_ずんだもん（ノーマル）_先に言われちゃった….mp3",
      "data/sound/chara/zundamon/077_ずんだもん（ノーマル）_X、大丈夫なのだ。….mp3",
      "data/sound/chara/zundamon/078_ずんだもん（ノーマル）_X、大丈夫なのだ。….mp3",
      "data/sound/chara/zundamon/079_ずんだもん（ノーマル）_X、大丈夫なのだ。….mp3",
      "data/sound/chara/zundamon/080_ずんだもん（ノーマル）_X、大丈夫なのだ。….mp3",
      "data/sound/chara/zundamon/081_ずんだもん（ノーマル）_Xにちょっと質問な….mp3",
      "data/sound/chara/zundamon/082_ずんだもん（ノーマル）_ぼ、僕は人狼じゃな….mp3",
      "data/sound/chara/zundamon/083_ずんだもん（ノーマル）_違うのだ！僕じゃな….mp3",
      "data/sound/chara/zundamon/084_ずんだもん（ノーマル）_そう言うオマエこそ….mp3",
      "data/sound/chara/zundamon/085_ずんだもん（ノーマル）_信じてくれてありが….mp3",
      "data/sound/chara/zundamon/086_ずんだもん（ノーマル）_そう言ってくれるっ….mp3",
      "data/sound/chara/zundamon/086_ずんだもん（ノーマル）_嬉しいのだ！そう言….mp3",
      "data/sound/chara/zundamon/087_ずんだもん（ノーマル）_……本当に本気なの….mp3",
      "data/sound/chara/zundamon/087_ずんだもん（ノーマル）_…本当にそう思って….mp3",
      "data/sound/chara/zundamon/088_ずんだもん（ノーマル）_もうなんにも分から….mp3",
      "data/sound/chara/zundamon/089_ずんだもん（ノーマル）_くくく、今夜は誰を….mp3",
      "data/sound/chara/zundamon/090_ずんだもん（ノーマル）_なんでなのだ！僕は….mp3",
      "data/sound/chara/zundamon/091_ずんだもん（ノーマル）_この決断が、間違っ….mp3",
    );
  [endscript]
[return]
