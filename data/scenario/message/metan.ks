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



; COFortuneTelling_{result}_{feeling}_{isAlive}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true_neutral_alive
[eval exp="tf.face = 'smug'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/metan/005_四国めたん（ノーマル）_ふふっ、わたくしの….mp3"]
[playselist]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったわ！[r]
ふふっ、わたくしの千里眼に見抜けぬものはないわ。[p]
[stopse]
[return]


*COFortuneTelling_true_love_alive
[eval exp="tf.face = 'serious'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/metan/006_四国めたん（ノーマル）_わたくしの心を弄ん….mp3"]
[playselist]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったわ！[r]
わたくしの心を弄んだこと、後悔させてやるわ。[p]
[stopse]
[return]


*COFortuneTelling_true_hate_alive
[eval exp="tf.face = 'blank'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_true_positive"]
[add_playselist storage="chara/metan/007_四国めたん（ノーマル）_まあ、千里眼を使う….mp3"]
[playselist]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼だったわ！[r]
まあ、千里眼を使う前から視えていたけれど。[p]
[stopse]
[return]


*COFortuneTelling_false_neutral_alive
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/metan/016_四国めたん（ノーマル）_信頼の証に、同盟を….mp3"]
[playselist]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
信頼の証に、同盟を結ばせてもらえるかしら。[p]
[stopse]
[return]


*COFortuneTelling_false_love_alive
[eval exp="tf.face = 'smug'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_positive"]
[add_playselist storage="chara/metan/017_四国めたん（ノーマル）_これ以上疑いの眼を….mp3"]
[playselist]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
これ以上疑いの眼を向けることは、わたくしが許さないわ。[p]
[stopse]
[return]


*COFortuneTelling_false_hate_alive
[eval exp="tf.face = 'panicked'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/metan/018_四国めたん（ノーマル）_この千里眼の力、わ….mp3"]
[playselist]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
この千里眼の力、わたくしにも制御できないというの…?[p]
[stopse]
[return]


*COFortuneTelling_false_neutral_died
[eval exp="tf.face = 'blank'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/metan/019_四国めたん（ノーマル）_わたくしたちが共に….mp3"]
[playselist]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
わたくしたちが共に手を取り合えた未来もあったのかしら。[p]
[stopse]
[return]


*COFortuneTelling_false_love_died
[eval exp="tf.face = 'sad'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/metan/020_四国めたん（ノーマル）_仇は必ずとるわ。ど….mp3"]
[playselist]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
仇は必ずとるわ。どうかわたくしを見守ってちょうだい…！[p]
[stopse]
[return]


*COFortuneTelling_false_hate_died
[eval exp="tf.face = 'blank'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[call target="COFortuneTelling_voice_false_negative"]
[add_playselist storage="chara/metan/021_四国めたん（ノーマル）_どうやら人狼はわた….mp3"]
[playselist]

聞きなさい。[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]は人狼ではなかったわ。[r]
どうやら人狼はわたくしを陥れるつもりのようね。[p]
[stopse]
[return]


; COFortuneTelling_voice_{result}_{feeling}
; COFortuneTellingのボイス用サブルーチン
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_voice_true_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/metan/001_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/metan/002_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/metan/003_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/metan/004_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[endif]
[return]


*COFortuneTelling_voice_true_negative
利用するセリフなし
[return]


*COFortuneTelling_voice_false_positive
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/metan/008_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/metan/009_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/metan/010_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/metan/011_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[endif]
[return]


*COFortuneTelling_voice_false_negative
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/metan/012_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/metan/013_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/metan/014_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/metan/015_四国めたん（ノーマル）_聞きなさい。Xは人….mp3"]
[endif]
[return]



; doAction_{actionId}_{decision}
; シーン：「疑う」アクション実行時
; NOTE:事前にf.actionObjectにアクションオブジェクトを格納しておくこと
*doAction_suspect_logical
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/metan/026_四国めたん（ノーマル）_X、足掻いても無駄….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/metan/027_四国めたん（ノーマル）_X、足掻いても無駄….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/metan/028_四国めたん（ノーマル）_X、足掻いても無駄….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/metan/029_四国めたん（ノーマル）_X、足掻いても無駄….mp3"]
[endif]
[add_playselist storage="chara/metan/030_四国めたん（ノーマル）_あなたの犯した罪は….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]、足掻いても無駄よ。[r]
あなたの犯した罪は決して消えないわ。[p]
[stopse]
[return]


*doAction_suspect_emotional
[eval exp="tf.face = 'serious'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/metan/022_四国めたん（ノーマル）_X、そろそろ認めた….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/metan/023_四国めたん（ノーマル）_X、そろそろ認めた….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/metan/024_四国めたん（ノーマル）_X、そろそろ認めた….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/metan/025_四国めたん（ノーマル）_X、そろそろ認めた….mp3"]
[endif]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]、そろそろ認めたらどうかしら？[r]
自分が人狼だということを。[p]
[stopse]
[return]


; シーン：「信じる」アクション実行時
*doAction_trust_logical
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/metan/035_四国めたん（ノーマル）_Xとわたくしが手を….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/metan/036_四国めたん（ノーマル）_Xとわたくしが手を….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/metan/037_四国めたん（ノーマル）_Xとわたくしが手を….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/metan/038_四国めたん（ノーマル）_Xとわたくしが手を….mp3"]
[endif]
[add_playselist storage="chara/metan/039_四国めたん（ノーマル）_フォルトゥナによっ….mp3"]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]とわたくしが手を携えることは、[r]
運命の女神によって定められているわ。[p]
[stopse]
[return]


*doAction_trust_emotional
[eval exp="tf.face = 'smug'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[add_playselist storage="chara/metan/031_四国めたん（ノーマル）_X、わたくしと共に….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[add_playselist storage="chara/metan/032_四国めたん（ノーマル）_X、わたくしと共に….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[add_playselist storage="chara/metan/033_四国めたん（ノーマル）_X、わたくしと共に….mp3"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[add_playselist storage="chara/metan/034_四国めたん（ノーマル）_X、わたくしと共に….mp3"]
[endif]
[playselist]

[j_callName targetId="&tf.targetId" targetName="&tf.targetName"]、わたくしと共にこの苦難を乗り越えましょう。[p]
[stopse]
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
[eval exp="tf.face = 'blank'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/metan/041_四国めたん（ノーマル）_心外ね。あなたはも….mp3"]
[playselist]

心外ね。あなたはもう少し賢いと思っていたのだけど。[p]
[stopse]
[return]


*doAction_reaction_suspect_love
[eval exp="tf.face = 'panicked'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/metan/042_四国めたん（ノーマル）_わ、わたくしを裏切….mp3"]
[playselist]

わ、わたくしを裏切るというのね！[r]
この代償は高くつくわよ…！[p]
[stopse]
[return]


*doAction_reaction_suspect_hate
[eval exp="tf.face = 'blank'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/metan/043_四国めたん（ノーマル）_そう、わたくしたち….mp3"]
[playselist]

そう、わたくしたちは光と闇の両極。[r]
決して相容れない存在よ。[p]
[stopse]
[return]


; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust_neutral
[eval exp="tf.face = '通常'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/metan/044_四国めたん（ノーマル）_ふふ。わたくしがあ….mp3"]
[playselist]

ふふ。わたくしがあなたを勝利に導いてあげるわ。[p]
[stopse]
[return]


*doAction_reaction_trust_love
[eval exp="tf.face = 'embarrassed'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/metan/045_四国めたん（ノーマル）_べ、別に嬉しくなん….mp3"]
[playselist]

べ、別に嬉しくなんてないわ…！[p]
[stopse]
[return]


*doAction_reaction_trust_hate
[eval exp="tf.face = 'panicked'"]
[call storage="./message/utility.ks" target="prepareMessage"]

[add_playselist storage="chara/metan/046_四国めたん（ノーマル）_まさか、あなたの口….mp3"]
[playselist]

まさか、あなたの口からそんな言葉が聞けるとはね。[p]
[stopse]
[return]

; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
わたくしに聞かないでちょうだい！[p]
[return]


; シーン：「喋りすぎ」アクション実行時
*doAction_talkToMuch
[eval exp="tf.face = 'serious'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[playse storage="chara/metan/048_四国めたん_そのよく回る口を封….ogg" sprite_time="50-20000"]

そのよく回る口を封印できる魔導書はどこかしら？[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[eval exp="tf.face = 'sad'"]
[call storage="./message/utility.ks" target="prepareMessage"]
[add_playselist storage="chara/metan/048_四国めたん（ノーマル）_これがわたくしの運….mp3"]
[playselist]

これがわたくしの運命なら、受け入れるしかないのでしょうね。[p]
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
      "data/sound/chara/metan/001_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/002_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/003_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/004_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/005_四国めたん（ノーマル）_ふふっ、わたくしの….mp3",
      "data/sound/chara/metan/006_四国めたん（ノーマル）_わたくしの心を弄ん….mp3",
      "data/sound/chara/metan/007_四国めたん（ノーマル）_まあ、千里眼を使う….mp3",
      "data/sound/chara/metan/008_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/009_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/010_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/011_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/012_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/013_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/014_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/015_四国めたん（ノーマル）_聞きなさい。Xは人….mp3",
      "data/sound/chara/metan/016_四国めたん（ノーマル）_信頼の証に、同盟を….mp3",
      "data/sound/chara/metan/017_四国めたん（ノーマル）_これ以上疑いの眼を….mp3",
      "data/sound/chara/metan/018_四国めたん（ノーマル）_この千里眼の力、わ….mp3",
      "data/sound/chara/metan/019_四国めたん（ノーマル）_わたくしたちが共に….mp3",
      "data/sound/chara/metan/020_四国めたん（ノーマル）_仇は必ずとるわ。ど….mp3",
      "data/sound/chara/metan/021_四国めたん（ノーマル）_どうやら人狼はわた….mp3",
      "data/sound/chara/metan/022_四国めたん（ノーマル）_X、そろそろ認めた….mp3",
      "data/sound/chara/metan/023_四国めたん（ノーマル）_X、そろそろ認めた….mp3",
      "data/sound/chara/metan/024_四国めたん（ノーマル）_X、そろそろ認めた….mp3",
      "data/sound/chara/metan/025_四国めたん（ノーマル）_X、そろそろ認めた….mp3",
      "data/sound/chara/metan/026_四国めたん（ノーマル）_X、足掻いても無駄….mp3",
      "data/sound/chara/metan/027_四国めたん（ノーマル）_X、足掻いても無駄….mp3",
      "data/sound/chara/metan/028_四国めたん（ノーマル）_X、足掻いても無駄….mp3",
      "data/sound/chara/metan/029_四国めたん（ノーマル）_X、足掻いても無駄….mp3",
      "data/sound/chara/metan/030_四国めたん（ノーマル）_あなたの犯した罪は….mp3",
      "data/sound/chara/metan/031_四国めたん（ノーマル）_X、わたくしと共に….mp3",
      "data/sound/chara/metan/032_四国めたん（ノーマル）_X、わたくしと共に….mp3",
      "data/sound/chara/metan/033_四国めたん（ノーマル）_X、わたくしと共に….mp3",
      "data/sound/chara/metan/034_四国めたん（ノーマル）_X、わたくしと共に….mp3",
      "data/sound/chara/metan/035_四国めたん（ノーマル）_Xとわたくしが手を….mp3",
      "data/sound/chara/metan/036_四国めたん（ノーマル）_Xとわたくしが手を….mp3",
      "data/sound/chara/metan/037_四国めたん（ノーマル）_Xとわたくしが手を….mp3",
      "data/sound/chara/metan/038_四国めたん（ノーマル）_Xとわたくしが手を….mp3",
      "data/sound/chara/metan/039_四国めたん（ノーマル）_フォルトゥナによっ….mp3",
      "data/sound/chara/metan/040_四国めたん（ノーマル）_状況が混沌としてき….mp3",
      "data/sound/chara/metan/041_四国めたん（ノーマル）_心外ね。あなたはも….mp3",
      "data/sound/chara/metan/042_四国めたん（ノーマル）_わ、わたくしを裏切….mp3",
      "data/sound/chara/metan/043_四国めたん（ノーマル）_そう、わたくしたち….mp3",
      "data/sound/chara/metan/044_四国めたん（ノーマル）_ふふ。わたくしがあ….mp3",
      "data/sound/chara/metan/045_四国めたん（ノーマル）_べ、別に嬉しくなん….mp3",
      "data/sound/chara/metan/046_四国めたん（ノーマル）_まさか、あなたの口….mp3",
      "data/sound/chara/metan/047_四国めたん（ノーマル）_わたくしに聞かない….mp3",
      "data/sound/chara/metan/048_四国めたん（ノーマル）_これがわたくしの運….mp3",
      "data/sound/chara/metan/048_四国めたん_そのよく回る口を封….ogg",
    );
  [endscript]
[return]
