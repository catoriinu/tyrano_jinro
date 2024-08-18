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



; COFortuneTelling_{result}_{feeling}_{isAlive}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true_neutral_alive
[eval exp="tf.face = 'thinking'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/hau/009_雨晴はう（ノーマル）_潔く認めていただけ….mp3"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼でした…！[r]
潔く認めていただけると嬉しいのですが…。[p]
[stopse]
[return]


*COFortuneTelling_true_love_alive
[eval exp="tf.face = 'sad'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_negative"]
[add_playselist storage="chara/hau/010_雨晴はう（ノーマル）_こんな結果、未だに….mp3"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼でした…！[r]
こんな結果、未だに信じられません…！[p]
[stopse]
[return]


*COFortuneTelling_true_hate_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/hau/011_雨晴はう（ノーマル）_人狼さん、もう隠れ….mp3"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼でした…！[r]
人狼さん、もう隠れても無駄ですよ？[p]
[stopse]
[return]


*COFortuneTelling_false_neutral_alive
[eval exp="tf.face = 'relieved'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/hau/020_雨晴はう（ノーマル）_みなさん、安心して….mp3"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
みなさん、安心して大丈夫ですよ。[p]
[stopse]
[return]


*COFortuneTelling_false_love_alive
[eval exp="tf.face = 'laughing'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/hau/021_雨晴はう（ノーマル）_もし人狼ならどうし….mp3"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
もし人狼ならどうしようって思ってました…！[p]
[stopse]
[return]


*COFortuneTelling_false_hate_alive
[eval exp="tf.face = 'wrysmile'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/hau/022_雨晴はう（ノーマル）_もう怪しまれるよう….mp3"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
もう怪しまれるようなことしないでくださいね。[p]
[stopse]
[return]


*COFortuneTelling_false_neutral_died
[eval exp="tf.face = 'astonished'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/hau/023_雨晴はう（ノーマル）_ああ、間に合いませ….mp3"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
ああ、間に合いませんでしたか…！[p]
[stopse]
[return]


*COFortuneTelling_false_love_died
[eval exp="tf.face = 'sad'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/hau/024_雨晴はう（ノーマル）_僕が力不足なばっか….mp3"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
僕が力不足なばっかりに、すみません…！[p]
[stopse]
[return]


*COFortuneTelling_false_hate_died
[eval exp="tf.face = 'wrysmile'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/hau/025_雨晴はう（ノーマル）_…いえ、僕がやった….mp3"]
[playselist]

僕が占った[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではありませんでした。[r]
…いえ、僕がやったんじゃないですからね？[p]
[stopse]
[return]


; COFortuneTelling_voice_{result}_{feeling}
; COFortuneTellingのボイス用サブルーチン
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_voice_true_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/001_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/002_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/003_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/004_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[endif]
[return]


*COFortuneTelling_voice_true_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/005_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/006_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/007_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/008_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[endif]
[return]


*COFortuneTelling_voice_false_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/012_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/013_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/014_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/015_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[endif]
[return]


*COFortuneTelling_voice_false_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/016_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/017_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/018_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/019_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3"]
[endif]
[return]



; doAction_{actionId}_{decision}
; シーン：「疑う」アクション実行時
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
*doAction_suspect_logical
[eval exp="tf.face = 'thinking'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/030_雨晴はう（ノーマル）_人狼はXですよね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/031_雨晴はう（ノーマル）_人狼はXですよね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/032_雨晴はう（ノーマル）_人狼はXですよね？.mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/033_雨晴はう（ノーマル）_人狼はXですよね？.mp3"]
[endif]
[add_playselist storage="chara/hau/034_雨晴はう（ノーマル）_どう考えてもそうと….mp3"]
[playselist]

人狼は[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]ですよね？[r]
どう考えてもそうとしか思えないのですが…。[p]
[stopse]
[return]


*doAction_suspect_emotional
[eval exp="tf.face = 'astonished'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/026_雨晴はう（ノーマル）_僕はXが怪しいと思….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/027_雨晴はう（ノーマル）_僕はXが怪しいと思….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/028_雨晴はう（ノーマル）_僕はXが怪しいと思….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/029_雨晴はう（ノーマル）_僕はXが怪しいと思….mp3"]
[endif]
[playselist]

僕は[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]が怪しいと思います。[r]
か、勘違いだったらすみません…！[p]
[stopse]
[return]


; シーン：「信じる」アクション実行時
*doAction_trust_logical
[eval exp="tf.face = 'laughing'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/039_雨晴はう（ノーマル）_Xは信頼に値する方….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/040_雨晴はう（ノーマル）_Xは信頼に値する方….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/041_雨晴はう（ノーマル）_Xは信頼に値する方….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/042_雨晴はう（ノーマル）_Xは信頼に値する方….mp3"]
[endif]
[add_playselist storage="chara/hau/043_雨晴はう（ノーマル）_少なくとも、僕にと….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は信頼に値する方です。[r]
少なくとも、僕にとっては確実に。[p]
[stopse]
[return]


*doAction_trust_emotional
[eval exp="tf.face = 'relieved'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/hau/035_雨晴はう（ノーマル）_Xはきっと大丈夫で….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[add_playselist storage="chara/hau/036_雨晴はう（ノーマル）_Xはきっと大丈夫で….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/hau/037_雨晴はう（ノーマル）_Xはきっと大丈夫で….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/hau/038_雨晴はう（ノーマル）_Xはきっと大丈夫で….mp3"]
[endif]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]はきっと大丈夫です。[r]
僕はそう信じてます。[p]
[stopse]
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
[eval exp="tf.face = 'astonished'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/045_雨晴はう（ノーマル）_どうせ僕なんて、疑….mp3"]
[playselist]

どうせ僕なんて、疑われても仕方ないですよね…。[p]
[stopse]
[return]


*doAction_reaction_suspect_love
[eval exp="tf.face = 'sad'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/046_雨晴はう（ノーマル）_…僕がどんなに頑張….mp3"]
[playselist]

…僕がどんなに頑張っても、報われることなんてないんですね。[p]
[stopse]
[return]


*doAction_reaction_suspect_hate
[eval exp="tf.face = 'wrysmile'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/047_雨晴はう（ノーマル）_はいはい、分かりま….mp3"]
[playselist]

はいはい、分かりました。お薬出しておきますね。[p]
[stopse]
[return]


; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust_neutral
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/048_雨晴はう（ノーマル）_ありがとうございま….mp3"]
[playselist]

ありがとうございます。僕も精一杯サポートしますね！[p]
[stopse]
[return]


*doAction_reaction_trust_love
[eval exp="tf.face = 'relieved'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/049_雨晴はう（ノーマル）_あなたと一緒だと心….mp3"]
[playselist]

あなたと一緒だと心強いです。最後まで頑張りましょう！[p]
[stopse]
[return]


*doAction_reaction_trust_hate
[eval exp="tf.face = 'thinking'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/hau/050_雨晴はう（ノーマル）_…まあ、あなたのこ….mp3"]
[playselist]

…まあ、あなたのことも見捨てはしませんよ。[r]
僕は看護師ですから。[p]
[stopse]
[return]


; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
ぼ、僕ではお役に立てなさそうです。ごめんなさい。[p]
[return]


; シーン：「喋りすぎ」アクション実行時
*doAction_talkToMuch
[call storage="./message/utility.ks" target="prepareMessage"]
そろそろお口にチャックでお願いしますね。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[eval exp="tf.face = 'tired'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[add_playselist storage="chara/hau/052_雨晴はう（ノーマル）_これ以上、頑張らな….mp3"]
[playselist]

これ以上、頑張らなくてもいいんですね。[r]
それじゃあ、おやすみなさい…。[p]
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
      "data/sound/chara/hau/001_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/002_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/003_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/004_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/005_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/006_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/007_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/008_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/009_雨晴はう（ノーマル）_潔く認めていただけ….mp3",
      "data/sound/chara/hau/010_雨晴はう（ノーマル）_こんな結果、未だに….mp3",
      "data/sound/chara/hau/011_雨晴はう（ノーマル）_人狼さん、もう隠れ….mp3",
      "data/sound/chara/hau/012_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/013_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/014_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/015_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/016_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/017_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/018_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/019_雨晴はう（ノーマル）_僕が占ったXは人狼….mp3",
      "data/sound/chara/hau/020_雨晴はう（ノーマル）_みなさん、安心して….mp3",
      "data/sound/chara/hau/021_雨晴はう（ノーマル）_もし人狼ならどうし….mp3",
      "data/sound/chara/hau/022_雨晴はう（ノーマル）_もう怪しまれるよう….mp3",
      "data/sound/chara/hau/023_雨晴はう（ノーマル）_ああ、間に合いませ….mp3",
      "data/sound/chara/hau/024_雨晴はう（ノーマル）_僕が力不足なばっか….mp3",
      "data/sound/chara/hau/025_雨晴はう（ノーマル）_…いえ、僕がやった….mp3",
      "data/sound/chara/hau/026_雨晴はう（ノーマル）_僕はXが怪しいと思….mp3",
      "data/sound/chara/hau/027_雨晴はう（ノーマル）_僕はXが怪しいと思….mp3",
      "data/sound/chara/hau/028_雨晴はう（ノーマル）_僕はXが怪しいと思….mp3",
      "data/sound/chara/hau/029_雨晴はう（ノーマル）_僕はXが怪しいと思….mp3",
      "data/sound/chara/hau/030_雨晴はう（ノーマル）_人狼はXですよね？.mp3",
      "data/sound/chara/hau/031_雨晴はう（ノーマル）_人狼はXですよね？.mp3",
      "data/sound/chara/hau/032_雨晴はう（ノーマル）_人狼はXですよね？.mp3",
      "data/sound/chara/hau/033_雨晴はう（ノーマル）_人狼はXですよね？.mp3",
      "data/sound/chara/hau/034_雨晴はう（ノーマル）_どう考えてもそうと….mp3",
      "data/sound/chara/hau/035_雨晴はう（ノーマル）_Xはきっと大丈夫で….mp3",
      "data/sound/chara/hau/036_雨晴はう（ノーマル）_Xはきっと大丈夫で….mp3",
      "data/sound/chara/hau/037_雨晴はう（ノーマル）_Xはきっと大丈夫で….mp3",
      "data/sound/chara/hau/038_雨晴はう（ノーマル）_Xはきっと大丈夫で….mp3",
      "data/sound/chara/hau/039_雨晴はう（ノーマル）_Xは信頼に値する方….mp3",
      "data/sound/chara/hau/040_雨晴はう（ノーマル）_Xは信頼に値する方….mp3",
      "data/sound/chara/hau/041_雨晴はう（ノーマル）_Xは信頼に値する方….mp3",
      "data/sound/chara/hau/042_雨晴はう（ノーマル）_Xは信頼に値する方….mp3",
      "data/sound/chara/hau/043_雨晴はう（ノーマル）_少なくとも、僕にと….mp3",
      "data/sound/chara/hau/044_雨晴はう（ノーマル）_えっと、Xはどう思….mp3",
      "data/sound/chara/hau/045_雨晴はう（ノーマル）_どうせ僕なんて、疑….mp3",
      "data/sound/chara/hau/046_雨晴はう（ノーマル）_…僕がどんなに頑張….mp3",
      "data/sound/chara/hau/047_雨晴はう（ノーマル）_はいはい、分かりま….mp3",
      "data/sound/chara/hau/048_雨晴はう（ノーマル）_ありがとうございま….mp3",
      "data/sound/chara/hau/049_雨晴はう（ノーマル）_あなたと一緒だと心….mp3",
      "data/sound/chara/hau/050_雨晴はう（ノーマル）_…まあ、あなたのこ….mp3",
      "data/sound/chara/hau/051_雨晴はう（ノーマル）_ぼ、僕ではお役に立….mp3",
      "data/sound/chara/hau/052_雨晴はう（ノーマル）_これ以上、頑張らな….mp3",
    );
  [endscript]
[return]
