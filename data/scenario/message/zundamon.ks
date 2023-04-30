; ずんだもんのmessageサブルーチン

; 呼び方サブルーチン
; 事前にtf.characterIdToCallにcharacterIdを入れてから、このサブルーチンを呼び出す
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
[playse storage="chara/zundamon/001_ずんだもん（ノーマル）_僕は村人なのだ。悪….ogg" loop="false" sprite_time="50-20000"]

僕は村人なのだ。[r]
悪い人狼を見つけて平和な村にするのだ。[p]
[stopse]
[return]

*noticeRole_fortuneTeller
[playse storage="chara/zundamon/002_ずんだもん（ノーマル）_僕は占い師なのだ。….ogg" loop="false" sprite_time="50-20000"]

僕は占い師なのだ。[r]
さっそく誰か占ってみるのだ！[p]
[stopse]
[return]

*noticeRole_werewolf
[playse storage="chara/zundamon/003_ずんだもん（ノーマル）_僕は人狼……。みん….ogg" loop="false" sprite_time="50-20000"]

僕は人狼……。[r]
みんな僕がおいしく食べてやるのだ！[p]
[stopse]
[return]

*noticeRole_madman
[playse storage="chara/zundamon/004_ずんだもん（ノーマル）_僕は狂人なのだ……….ogg" loop="false" sprite_time="50-20000"]

僕は狂人なのだ……。[r]
僕がご主人の野望を手助けするのだ！[p]
[stopse]
[return]


; announcedFortuneTellingResult_{result}
; シーン：真占い師で、占い実行結果を知ったときの反応
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
; 備考：PCのみ想定
*announcedFortuneTellingResult_true
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/005_ずんだもん（ノーマル）_発見なのだ！Xが人….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/006_ずんだもん（ノーマル）_発見なのだ！Xが人….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/007_ずんだもん（ノーマル）_発見なのだ！Xが人….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/008_ずんだもん（ノーマル）_発見なのだ！Xが人….ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
[call target="changeIdToCallName"]

発見なのだ！[emb exp="tf.calledCharacterName"]が人狼だったのだ！[p]
[stopse]
[return]

*announcedFortuneTellingResult_false
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/009_ずんだもん（ノーマル）_Xは人狼じゃなかっ….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/010_ずんだもん（ノーマル）_Xは人狼じゃなかっ….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/011_ずんだもん（ノーマル）_Xは人狼じゃなかっ….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/012_ずんだもん（ノーマル）_Xは人狼じゃなかっ….ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
[call target="changeIdToCallName"]

[emb exp="tf.calledCharacterName"]は人狼じゃなかったのだ。[p]
[stopse]
[return]


; COFortuneTelling_{result}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
*COFortuneTelling_true
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/021_ずんだもん（ノーマル）_昨日はXを占ったの…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/022_ずんだもん（ノーマル）_昨日はXを占ったの…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/023_ずんだもん（ノーマル）_昨日はXを占ったの…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/024_ずんだもん（ノーマル）_昨日はXを占ったの…(1).ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
[call target="changeIdToCallName"]

昨日は[emb exp="tf.calledCharacterName"]を占ったのだ。[r]
結果は人狼だったのだ！[p]
[stopse]
[return]

*COFortuneTelling_false
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/027_ずんだもん（ノーマル）_昨日はXを占ったの…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/028_ずんだもん（ノーマル）_昨日はXを占ったの…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/029_ずんだもん（ノーマル）_昨日はXを占ったの…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/030_ずんだもん（ノーマル）_昨日はXを占ったの…(1).ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
[call target="changeIdToCallName"]

昨日は[emb exp="tf.calledCharacterName"]を占ったのだ。[r]
結果は人狼じゃなかったのだ。[p]
[stopse]
[return]


; doAction_{actionId}
; NOTE：事前にtf.selectedCharacterIへの格納（PCならアクションボタンの実行、NPCならTODO）が必要。
; シーン：「疑う」アクション実行時
*doAction_suspect
[if exp="tf.selectedCharacterId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="tf.selectedCharacterId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/027_ずんだもん（ノーマル）_もしかしてXが人狼….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/028_ずんだもん（ノーマル）_もしかしてXが人狼….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/029_ずんだもん（ノーマル）_もしかしてXが人狼….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/030_ずんだもん（ノーマル）_もしかしてXが人狼….ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

もしかして[emb exp="tf.calledCharacterName"]が人狼なのだ……？[r]
そんな気がするのだ。[p]
[stopse]
[return]

; シーン：「信じる」アクション実行時
*doAction_trust
[if exp="tf.selectedCharacterId == CHARACTER_ID_ZUNDAMON"]

[elsif exp="tf.selectedCharacterId == CHARACTER_ID_METAN"]
[playse storage="chara/zundamon/043_ずんだもん（ノーマル）_僕はXを信じてるの….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/zundamon/044_ずんだもん（ノーマル）_僕はXを信じてるの….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_HAU"]
[playse storage="chara/zundamon/045_ずんだもん（ノーマル）_僕はXを信じてるの….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_RITSU"]
[playse storage="chara/zundamon/046_ずんだもん（ノーマル）_僕はXを信じてるの….ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

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


; doAction_reaction_{actionId}
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect
[playse storage="chara/zundamon/060_ずんだもん（ノーマル）_ぼ、僕は人狼じゃな….ogg" loop="false" sprite_time="50-20000"]

ぼ、僕は人狼じゃないのだっ！[p]
[stopse]
[return]

; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust
[playse storage="chara/zundamon/063_ずんだもん（ノーマル）_信じてくれてありが….ogg" loop="false" sprite_time="50-20000"]

信じてくれてありがとうなのだ！[p]
[stopse]
[return]

; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
  もうなんにも分からないのだ……！[p]
[return]


; chooseWhoToBite
; シーン：人狼で、誰を噛むか選ぶときのセリフ
*chooseWhoToBite
[playse storage="chara/zundamon/067_ずんだもん（ノーマル）_くくく、今夜は誰を….ogg" loop="false" sprite_time="50-20000"]

くくく、今夜は誰を食べちゃおうかな……。[r]
いただきまーすなのだ！[p]
[stopse]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[playse storage="chara/zundamon/068_ずんだもん（ノーマル）_なんでなのだ！僕は….ogg" loop="false" sprite_time="50-20000"]

なんでなのだ！僕は悪くないのだ！[p]
[stopse]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
  この決断が、間違ってないといいのだ……。[p]
[return]


; コピー用
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[endif]
