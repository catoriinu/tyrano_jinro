; 波音リツのmessageサブルーチン

; 呼び方サブルーチン
; 事前にtf.characterIdToCallにcharacterIdを入れてから、このサブルーチンを呼び出す
; このmessageサブルーチンのキャラクターが、tf.characterIdToCallのキャラクターを呼ぶ際の二人称を出力する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [if exp="tf.characterIdToCall == CHARACTER_ID_ZUNDAMON"]
    ずんだもん
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_METAN"]
    めたん
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_TSUMUGI"]
    つむぎ
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_HAU"]
    はう
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_RITSU"]
    あたし
  [endif]
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
[playse storage="chara/ritsu/005_波音リツ（ノーマル）_X。アンタ人狼ね？…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/ritsu/006_波音リツ（ノーマル）_X。アンタ人狼ね？…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/ritsu/007_波音リツ（ノーマル）_X。アンタ人狼ね？…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/ritsu/008_波音リツ（ノーマル）_X。アンタ人狼ね？…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]

[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
[call target="changeIdToCallName"]。アンタ人狼ね？[r]
さあ、祭りを始めましょうか。[p]
[stopse]
[return]

*COFortuneTelling_false
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/ritsu/014_波音リツ（ノーマル）_X。アンタは人狼じ…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/ritsu/015_波音リツ（ノーマル）_X。アンタは人狼じ…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/ritsu/016_波音リツ（ノーマル）_X。アンタは人狼じ…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/ritsu/017_波音リツ（ノーマル）_X。アンタは人狼じ…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]

[endif]
;x
[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
[call target="changeIdToCallName"]。アンタは人狼じゃないらしいわね。[r]
住民としてこの村を盛り上げてちょうだい。[p]
[stopse]
[return]


; doAction_{actionId}
; NOTE：事前にtf.selectedCharacterIへの格納（PCならアクションボタンの実行、NPCならTODO）が必要。
; シーン：「疑う」アクション実行時
*doAction_suspect
[if exp="tf.selectedCharacterId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/ritsu/011_波音リツ（ノーマル）_Xはどうせ人狼でし….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_METAN"]
[playse storage="chara/ritsu/012_波音リツ（ノーマル）_Xはどうせ人狼でし….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/ritsu/013_波音リツ（ノーマル）_Xはどうせ人狼でし….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_HAU"]
[playse storage="chara/ritsu/014_波音リツ（ノーマル）_Xはどうせ人狼でし….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_RITSU"]

[endif]
;x
[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]はどうせ人狼でしょうね。[r]
まあ根拠はないけれど。[p]
[stopse]
[return]

; シーン：「信じる」アクション実行時
*doAction_trust
[if exp="tf.selectedCharacterId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/ritsu/015_波音リツ（ノーマル）_こう見えてもあたし….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_METAN"]
[playse storage="chara/ritsu/016_波音リツ（ノーマル）_こう見えてもあたし….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/ritsu/017_波音リツ（ノーマル）_こう見えてもあたし….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_HAU"]
[playse storage="chara/ritsu/018_波音リツ（ノーマル）_こう見えてもあたし….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_RITSU"]

[endif]
;o
[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
こう見えてもあたしは[call target="changeIdToCallName"]に期待してるの。[r]
だからがっかりさせないでほしいわね。[p]
[stopse]
[return]

; シーン：「聞き出す」アクション実行時
*doAction_ask
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  [call target="changeIdToCallName"]、三行で説明よろしく。[p]
[return]


; doAction_reaction_{actionId}
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect
[playse storage="chara/ritsu/020_波音リツ（ノーマル）_アンタがそう思うな….ogg" loop="false" sprite_time="50-20000"]

アンタがそう思うならそうなんでしょう。[r]
アンタの中ではね。[p]
[stopse]
[return]

; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust
[playse storage="chara/ritsu/021_波音リツ（ノーマル）_ふふ、嬉しいことを….ogg" loop="false" sprite_time="50-20000"]
;o
ふふ、嬉しいことを言ってくれるじゃない。[p]
[stopse]
[return]

; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
  アンタに教えることなんて何もないわ。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[playse storage="chara/ritsu/023_波音リツ（ノーマル）_安価は絶対……。あ….ogg" loop="false" sprite_time="50-20000"]
;o
安価は絶対……。あたしは潔く去るわ。[p]
[stopse]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
  （未作成）[p]
[return]
