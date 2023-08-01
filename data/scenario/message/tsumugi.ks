; 春日部つむぎのmessageサブルーチン

; 呼び方サブルーチン
; 事前準備：tf.characterIdToCall = キャラクターID
; このmessageサブルーチンのキャラクターが、tf.characterIdToCallのキャラクターを呼ぶ際の二人称をtf.calledCharacterNameに格納する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [iscript]
    tf.calledCharacterName = (function(characterId) {
      const calledCharacterNameObject = {
        [CHARACTER_ID_ZUNDAMON]: 'ずんだもん先輩',
        [CHARACTER_ID_METAN]:    'めたん先輩',
        [CHARACTER_ID_TSUMUGI]:  'あーし',
        [CHARACTER_ID_HAU]:      'はうちゃん',
        [CHARACTER_ID_RITSU]:    'りっちゃん',
      }
      return calledCharacterNameObject[characterId];
    }(tf.characterIdToCall));
  [endscript]
[return]



; COFortuneTelling_{result}_{feeling}_{isAlive}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true_neutral_alive
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/tsumugi/009_春日部つむぎ（ノーマル）_隠し通せると思った….mp3"]
[playselist]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼だったんだよねー。[r]
隠し通せると思った？残念だったね。[p]
[stopse]
[return]


*COFortuneTelling_true_love_alive
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/tsumugi/010_春日部つむぎ（ノーマル）_友達だと思ってたの….mp3"]
[playselist]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼だったんだよねー。[r]
友達だと思ってたのはあーしだけだったんだね。[p]
[stopse]
[return]


*COFortuneTelling_true_hate_alive
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/tsumugi/011_春日部つむぎ（ノーマル）_ぶっちゃけ、やっぱ….mp3"]
[playselist]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼だったんだよねー。[r]
ぶっちゃけ、やっぱりそっか、って感じかな。[p]
[stopse]
[return]


*COFortuneTelling_false_neutral_alive
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/tsumugi/020_春日部つむぎ（ノーマル）_友達になってくれる….mp3"]
[playselist]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼じゃなかったよ。[r]
友達になってくれるかな？[p]
[stopse]
[return]


*COFortuneTelling_false_love_alive
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/tsumugi/021_春日部つむぎ（ノーマル）_みんなにもキミのこ….mp3"]
[playselist]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼じゃなかったよ。[r]
みんなにもきみのこと、信じてもらえるように頑張るね！[p]
[stopse]
[return]


*COFortuneTelling_false_hate_alive
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/tsumugi/022_春日部つむぎ（ノーマル）_ごめんね、ちょっと….mp3"]
[playselist]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼じゃなかったよ。[r]
ごめんね、ちょっと疑っちゃってたかも…。[p]
[stopse]
[return]


*COFortuneTelling_false_neutral_died
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/tsumugi/023_春日部つむぎ（ノーマル）_って言っても、ちょ….mp3"]
[playselist]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼じゃなかったよ。[r]
って言っても、ちょっと遅かったけどね…。[p]
[stopse]
[return]


*COFortuneTelling_false_love_died
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/tsumugi/024_春日部つむぎ（ノーマル）_こんなのウソだよね….mp3"]
[playselist]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼じゃなかったよ。[r]
こんなのウソだよね？ねえ、早く戻ってきてよ…。[p]
[stopse]
[return]


*COFortuneTelling_false_hate_died
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/tsumugi/025_春日部つむぎ（ノーマル）_こんなことになるな….mp3"]
[playselist]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼じゃなかったよ。[r]
こんなことになるなら、もっと仲良くすればよかったかな。[p]
[stopse]
[return]


; COFortuneTelling_voice_{result}_{feeling}
; COFortuneTellingのボイス用サブルーチン
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_voice_true_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/001_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/002_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/003_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/004_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[endif]
[return]


*COFortuneTelling_voice_true_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/005_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/006_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/007_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/008_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[endif]
[return]


*COFortuneTelling_voice_false_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/012_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/013_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/014_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/015_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[endif]
[return]


*COFortuneTelling_voice_false_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/016_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/017_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/018_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/019_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3"]
[endif]
[return]



; doAction_{actionId}_{decision}
; シーン：「疑う」アクション実行時
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
*doAction_suspect_logical
[call storage="./message/utility.ks" target="prepareMessage"]
[add_playselist storage="chara/tsumugi/031_春日部つむぎ（ノーマル）_あーし、全部分かっ….mp3"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/032_春日部つむぎ（ノーマル）_Xが人狼なんでしょ？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/033_春日部つむぎ（ノーマル）_Xが人狼なんでしょ？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/034_春日部つむぎ（ノーマル）_Xが人狼なんでしょ？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/035_春日部つむぎ（ノーマル）_Xが人狼なんでしょ？.mp3"]
[endif]
[playselist]

あーし、全部分かっちゃった。[r]
[emb exp="tf.calledCharacterName"]が人狼なんでしょ？[p]
[stopse]
[return]


*doAction_suspect_emotional
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/026_春日部つむぎ（ノーマル）_Xってもしかして人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/027_春日部つむぎ（ノーマル）_Xってもしかして人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/028_春日部つむぎ（ノーマル）_Xってもしかして人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/029_春日部つむぎ（ノーマル）_Xってもしかして人….mp3"]
[endif]
[add_playselist storage="chara/tsumugi/030_春日部つむぎ（ノーマル）_ちょっとヤバい感じ….mp3"]
[playselist]

[emb exp="tf.calledCharacterName"]ってもしかして人狼？[r]
ちょっとヤバい感じするし。[p]
[stopse]
[return]


; シーン：「信じる」アクション実行時
*doAction_trust_logical
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/041_春日部つむぎ（ノーマル）_Xとあーしは最強の….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/042_春日部つむぎ（ノーマル）_Xとあーしは最強の….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/043_春日部つむぎ（ノーマル）_Xとあーしは最強の….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/044_春日部つむぎ（ノーマル）_Xとあーしは最強の….mp3"]
[endif]
[add_playselist storage="chara/tsumugi/045_春日部つむぎ（ノーマル）_これから先も、ずっ….mp3"]
[playselist]

[emb exp="tf.calledCharacterName"]とあーしは最強の友達だよね。[r]
これから先も、ずっと！[p]
[stopse]
[return]


*doAction_trust_emotional
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/tsumugi/036_春日部つむぎ（ノーマル）_あーしはXを味方だ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/tsumugi/037_春日部つむぎ（ノーマル）_あーしはXを味方だ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/tsumugi/038_春日部つむぎ（ノーマル）_あーしはXを味方だ….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/tsumugi/039_春日部つむぎ（ノーマル）_あーしはXを味方だ….mp3"]
[endif]
[add_playselist storage="chara/tsumugi/040_春日部つむぎ（ノーマル）_できたらきみもあー….mp3"]
[playselist]

あーしは[emb exp="tf.calledCharacterName"]を味方だと思ってるよ。[r]
できたらきみもあーしのこと、信じてほしいな。[p]
[stopse]
[return]


; シーン：「聞き出す」アクション実行時
*doAction_ask
[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

あのさ、[emb exp="tf.calledCharacterName"]の考えも聞いてみたいなー。[p]
[return]


; doAction_reaction_{actionId}_{feeling}
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
; ※targetIdの方がこのサブルーチンのキャラクターであること
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect_neutral
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/047_春日部つむぎ（ノーマル）_そんな風に思われて….mp3"]
[playselist]

そんな風に思われてたんだ…。[r]
ちょっとショックかも。[p]
[stopse]
[return]


*doAction_reaction_suspect_love
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/048_春日部つむぎ（ノーマル）_あ…うん、今まで馴….mp3"]
[playselist]

あ…うん、今まで馴れ馴れしくしてごめんね。[p]
[stopse]
[return]


*doAction_reaction_suspect_hate
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/049_春日部つむぎ（ノーマル）_そっか、分かった。….mp3"]
[playselist]

そっか、分かった。しばらく距離置こっか。[p]
[stopse]
[return]


; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust_neutral
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/050_春日部つむぎ（ノーマル）_マジ？なんか嬉しい….mp3"]
[playselist]

マジ？なんか嬉しいかも！[p]
[stopse]
[return]


*doAction_reaction_trust_love
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/051_春日部つむぎ（ノーマル）_やった！きみに信じ….mp3"]
[playselist]

やった！きみに信じてもらえるなんて、最高！[p]
[stopse]
[return]


*doAction_reaction_trust_hate
[eval exp="tf.reaction = true"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/tsumugi/052_春日部つむぎ（ノーマル）_えー？もしきみが激….mp3"]
[playselist]

えー？[r]
もしきみが激辛カレーを食べ切れたら、本気だって信じてあげるけど。[p]
[stopse]
[return]


; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
そんなの聞かれても、あーしには分かんないよ…。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[add_playselist storage="chara/tsumugi/054_春日部つむぎ（ノーマル）_うそ、あーし選ばれ….mp3"]
[playselist]

うそ。あーし選ばれちゃったの？[r]
そんなに怪しかったのかな……[p]
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
      "data/sound/chara/tsumugi/001_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/002_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/003_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/004_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/005_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/006_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/007_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/008_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/009_春日部つむぎ（ノーマル）_隠し通せると思った….mp3",
      "data/sound/chara/tsumugi/010_春日部つむぎ（ノーマル）_友達だと思ってたの….mp3",
      "data/sound/chara/tsumugi/011_春日部つむぎ（ノーマル）_ぶっちゃけ、やっぱ….mp3",
      "data/sound/chara/tsumugi/012_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/013_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/014_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/015_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/016_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/017_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/018_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/019_春日部つむぎ（ノーマル）_あーしの占いだと、….mp3",
      "data/sound/chara/tsumugi/020_春日部つむぎ（ノーマル）_友達になってくれる….mp3",
      "data/sound/chara/tsumugi/021_春日部つむぎ（ノーマル）_みんなにもキミのこ….mp3",
      "data/sound/chara/tsumugi/022_春日部つむぎ（ノーマル）_ごめんね、ちょっと….mp3",
      "data/sound/chara/tsumugi/023_春日部つむぎ（ノーマル）_って言っても、ちょ….mp3",
      "data/sound/chara/tsumugi/024_春日部つむぎ（ノーマル）_こんなのウソだよね….mp3",
      "data/sound/chara/tsumugi/025_春日部つむぎ（ノーマル）_こんなことになるな….mp3",
      "data/sound/chara/tsumugi/026_春日部つむぎ（ノーマル）_Xってもしかして人….mp3",
      "data/sound/chara/tsumugi/027_春日部つむぎ（ノーマル）_Xってもしかして人….mp3",
      "data/sound/chara/tsumugi/028_春日部つむぎ（ノーマル）_Xってもしかして人….mp3",
      "data/sound/chara/tsumugi/029_春日部つむぎ（ノーマル）_Xってもしかして人….mp3",
      "data/sound/chara/tsumugi/030_春日部つむぎ（ノーマル）_ちょっとヤバい感じ….mp3",
      "data/sound/chara/tsumugi/031_春日部つむぎ（ノーマル）_あーし、全部分かっ….mp3",
      "data/sound/chara/tsumugi/032_春日部つむぎ（ノーマル）_Xが人狼なんでしょ？.mp3",
      "data/sound/chara/tsumugi/033_春日部つむぎ（ノーマル）_Xが人狼なんでしょ？.mp3",
      "data/sound/chara/tsumugi/034_春日部つむぎ（ノーマル）_Xが人狼なんでしょ？.mp3",
      "data/sound/chara/tsumugi/035_春日部つむぎ（ノーマル）_Xが人狼なんでしょ？.mp3",
      "data/sound/chara/tsumugi/036_春日部つむぎ（ノーマル）_あーしはXを味方だ….mp3",
      "data/sound/chara/tsumugi/037_春日部つむぎ（ノーマル）_あーしはXを味方だ….mp3",
      "data/sound/chara/tsumugi/038_春日部つむぎ（ノーマル）_あーしはXを味方だ….mp3",
      "data/sound/chara/tsumugi/039_春日部つむぎ（ノーマル）_あーしはXを味方だ….mp3",
      "data/sound/chara/tsumugi/040_春日部つむぎ（ノーマル）_できたらきみもあー….mp3",
      "data/sound/chara/tsumugi/041_春日部つむぎ（ノーマル）_Xとあーしは最強の….mp3",
      "data/sound/chara/tsumugi/042_春日部つむぎ（ノーマル）_Xとあーしは最強の….mp3",
      "data/sound/chara/tsumugi/043_春日部つむぎ（ノーマル）_Xとあーしは最強の….mp3",
      "data/sound/chara/tsumugi/044_春日部つむぎ（ノーマル）_Xとあーしは最強の….mp3",
      "data/sound/chara/tsumugi/045_春日部つむぎ（ノーマル）_これから先も、ずっ….mp3",
      "data/sound/chara/tsumugi/046_春日部つむぎ（ノーマル）_あのさ、Xの考えも….mp3",
      "data/sound/chara/tsumugi/047_春日部つむぎ（ノーマル）_そんな風に思われて….mp3",
      "data/sound/chara/tsumugi/048_春日部つむぎ（ノーマル）_あ…うん、今まで馴….mp3",
      "data/sound/chara/tsumugi/049_春日部つむぎ（ノーマル）_そっか、分かった。….mp3",
      "data/sound/chara/tsumugi/050_春日部つむぎ（ノーマル）_マジ？なんか嬉しい….mp3",
      "data/sound/chara/tsumugi/051_春日部つむぎ（ノーマル）_やった！きみに信じ….mp3",
      "data/sound/chara/tsumugi/052_春日部つむぎ（ノーマル）_えー？もしきみが激….mp3",
      "data/sound/chara/tsumugi/053_春日部つむぎ（ノーマル）_そんなの聞かれても….mp3",
      "data/sound/chara/tsumugi/054_春日部つむぎ（ノーマル）_うそ、あーし選ばれ….mp3",
    );
  [endscript]
[return]
