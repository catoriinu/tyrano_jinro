; 春日部つむぎのmessageサブルーチン

; 呼び方サブルーチン
; 事前にtf.characterIdToCallにcharacterIdを入れてから、このサブルーチンを呼び出す
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

; COFortuneTelling_{result}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
; TODO：
; 役職COと結果COで差分を付けられるようにする。（「自分が占い師だ」「昨日の占い結果は～」）
; 役職COのとき、自分の前にCO済みの占い師がいる場合「自分こそが占い師だ」と主張することができるようにする
; 結果COのとき、自分の前のCO結果によって反応を変えられるようにする（同じ相手を占った、違う相手を占った）
*COFortuneTelling_true
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/tsumugi/005_春日部つむぎ（ノーマル）_あーしの占いだと、…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/tsumugi/006_春日部つむぎ（ノーマル）_あーしの占いだと、…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/tsumugi/007_春日部つむぎ（ノーマル）_あーしの占いだと、…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/tsumugi/008_春日部つむぎ（ノーマル）_あーしの占いだと、…(1).ogg" loop="false" sprite_time="50-20000"]
[endif]
;x
[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
[call target="changeIdToCallName"]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼だったんだよねー。[r]
隠し通せると思った？残念だったね。[p]
[stopse]
[return]

*COFortuneTelling_false
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/tsumugi/014_春日部つむぎ（ノーマル）_あーしの占いだと、…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/tsumugi/015_春日部つむぎ（ノーマル）_あーしの占いだと、…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/tsumugi/016_春日部つむぎ（ノーマル）_あーしの占いだと、…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/tsumugi/017_春日部つむぎ（ノーマル）_あーしの占いだと、…(1).ogg" loop="false" sprite_time="50-20000"]
[endif]
;x
[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
[call target="changeIdToCallName"]

あーしの占いだと、[emb exp="tf.calledCharacterName"]は人狼じゃなかったよ。[r]
友達になれるかなあ？[p]
[stopse]
[return]


; doAction_{actionId}
; NOTE：事前にtf.selectedCharacterIへの格納（PCならアクションボタンの実行、NPCならTODO）が必要。
; シーン：「疑う」アクション実行時
*doAction_suspect
[if exp="tf.selectedCharacterId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/tsumugi/011_春日部つむぎ（ノーマル）_Xってもしかしなく….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_METAN"]
[playse storage="chara/tsumugi/012_春日部つむぎ（ノーマル）_Xってもしかしなく….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_TSUMUGI"]

[elsif exp="tf.selectedCharacterId == CHARACTER_ID_HAU"]
[playse storage="chara/tsumugi/013_春日部つむぎ（ノーマル）_Xってもしかしなく….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_RITSU"]
[playse storage="chara/tsumugi/014_春日部つむぎ（ノーマル）_Xってもしかしなく….ogg" loop="false" sprite_time="50-20000"]
[endif]
;x
[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

[emb exp="tf.calledCharacterName"]ってもしかしなくても人狼だよね？[r]
ちょっとヤバい感じするし。[p]
[stopse]
[return]

; シーン：「信じる」アクション実行時
*doAction_trust
[if exp="tf.selectedCharacterId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/tsumugi/015_春日部つむぎ（ノーマル）_あーしはXを味方だ….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_METAN"]
[playse storage="chara/tsumugi/016_春日部つむぎ（ノーマル）_あーしはXを味方だ….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_TSUMUGI"]

[elsif exp="tf.selectedCharacterId == CHARACTER_ID_HAU"]
[playse storage="chara/tsumugi/017_春日部つむぎ（ノーマル）_あーしはXを味方だ….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_RITSU"]
[playse storage="chara/tsumugi/018_春日部つむぎ（ノーマル）_あーしはXを味方だ….ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

あーしは[emb exp="tf.calledCharacterName"]を味方だと思ってるよ。[r]
だから[emb exp="tf.calledCharacterName"]もあーしのこと、信じてほしいな……なんてね。[p]
[stopse]
[return]

; シーン：「聞き出す」アクション実行時
*doAction_ask
[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

あのさ、[emb exp="tf.calledCharacterName"]の考えも聞いてみたいなー。[p]
[return]


; doAction_reaction_{actionId}
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect
[playse storage="chara/tsumugi/020_春日部つむぎ（ノーマル）_そんな風に思われて….ogg" loop="false" sprite_time="50-20000"]

そんな風に思われてたんだ……。[r]
ちょっとショックかも。[p]
[stopse]
[return]

; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust
[playse storage="chara/tsumugi/021_春日部つむぎ（ノーマル）_マジ？なんか嬉しい….ogg" loop="false" sprite_time="50-20000"]

マジ？なんか嬉しいかも！[p]
[stopse]
[return]

; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
  そんなの聞かれても、あーしには分かんないよ……。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[playse storage="chara/tsumugi/023_春日部つむぎ（ノーマル）_うそ、あーし選ばれ….ogg" loop="false" sprite_time="50-20000"]
;x
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
