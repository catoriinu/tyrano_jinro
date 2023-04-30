; 雨晴はうのmessageサブルーチン

; 呼び方サブルーチン
; 事前にtf.characterIdToCallにcharacterIdを入れてから、このサブルーチンを呼び出す
; このmessageサブルーチンのキャラクターが、tf.characterIdToCallのキャラクターを呼ぶ際の二人称を出力する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [if exp="tf.characterIdToCall == CHARACTER_ID_ZUNDAMON"]
    ずんだもん
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_METAN"]
    めたんさん
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_TSUMUGI"]
    つむぎさん
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_HAU"]
    僕
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_RITSU"]
    リツさん
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
[playse storage="chara/hau/005_雨晴はう（ノーマル）_僕が占ったのはXで…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/hau/006_雨晴はう（ノーマル）_僕が占ったのはXで…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/hau/007_雨晴はう（ノーマル）_僕が占ったのはXで…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/hau/008_雨晴はう（ノーマル）_僕が占ったのはXで…(1).ogg" loop="false" sprite_time="50-20000"]
[endif]
;x
[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
僕が占ったのは[call target="changeIdToCallName"]です。[r]
残念ながら、人狼でした……。[p]
[stopse]
[return]

*COFortuneTelling_false
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/hau/014_雨晴はう（ノーマル）_僕が占ったのはXで…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]
[playse storage="chara/hau/015_雨晴はう（ノーマル）_僕が占ったのはXで…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/hau/016_雨晴はう（ノーマル）_僕が占ったのはXで…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/hau/017_雨晴はう（ノーマル）_僕が占ったのはXで…(1).ogg" loop="false" sprite_time="50-20000"]
[endif]
;x
[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
僕が占ったのは[call target="changeIdToCallName"]です。[r]
安心してください、人狼ではありませんでした。[p]
[stopse]
[return]


; doAction_{actionId}
; NOTE：事前にtf.selectedCharacterIへの格納（PCならアクションボタンの実行、NPCならTODO）が必要。
; シーン：「疑う」アクション実行時
*doAction_suspect
[if exp="tf.selectedCharacterId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/hau/011_雨晴はう（ノーマル）_僕はXが怪しいと思….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_METAN"]
[playse storage="chara/hau/012_雨晴はう（ノーマル）_僕はXが怪しいと思….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/hau/013_雨晴はう（ノーマル）_僕はXが怪しいと思….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_HAU"]

[elsif exp="tf.selectedCharacterId == CHARACTER_ID_RITSU"]
[playse storage="chara/hau/014_雨晴はう（ノーマル）_僕はXが怪しいと思….ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
僕は[call target="changeIdToCallName"]が怪しいと思います。[r]
か、勘違いだったらすみません……！[p]
[stopse]
[return]

; シーン：「信じる」アクション実行時
*doAction_trust
[if exp="tf.selectedCharacterId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/hau/015_雨晴はう（ノーマル）_Xはきっと大丈夫で….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_METAN"]
[playse storage="chara/hau/016_雨晴はう（ノーマル）_Xはきっと大丈夫で….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/hau/017_雨晴はう（ノーマル）_Xはきっと大丈夫で….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_HAU"]

[elsif exp="tf.selectedCharacterId == CHARACTER_ID_RITSU"]
[playse storage="chara/hau/018_雨晴はう（ノーマル）_Xはきっと大丈夫で….ogg" loop="false" sprite_time="50-20000"]
[endif]
;x
[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]はきっと大丈夫です。[r]
僕はそう信じてます。[p]
[stopse]
[return]

; シーン：「聞き出す」アクション実行時
*doAction_ask
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  えっと、[call target="changeIdToCallName"]はどう思いますか？[p]
[return]


; doAction_reaction_{actionId}
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect
[playse storage="chara/hau/020_雨晴はう（ノーマル）_どうせ僕なんて、疑….ogg" loop="false" sprite_time="50-20000"]
;x
どうせ僕なんて、疑われても仕方ないですよね……。[p]
[stopse]
[return]

; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust
[playse storage="chara/hau/021_雨晴はう（ノーマル）_ありがとうございま….ogg" loop="false" sprite_time="50-20000"]
;x
ありがとうございます。[r]
僕も精一杯サポートしますね！[p]
[stopse]
[return]

; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
  ぼ、僕ではお役に立てなさそうです。ごめんなさい。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[playse storage="chara/hau/023_雨晴はう（ノーマル）_これ以上、頑張らな….ogg" loop="false" sprite_time="50-20000"]

これ以上、頑張らなくてもいいんですね。[r]
それじゃあ、おやすみなさい……。[p]
[stopse]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
  （未作成）[p]
[return]
