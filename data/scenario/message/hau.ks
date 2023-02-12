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
  [eval exp="tf.characterIdToCall = f.actionObject.targetId"]
  僕、[call target="changeIdToCallName"]を占ったんです。[r]
  [call target="changeIdToCallName"]は人狼でした……！[p]
[return]

*COFortuneTelling_false
  [eval exp="tf.characterIdToCall = f.actionObject.targetId"]
  僕、[call target="changeIdToCallName"]を占ったんです。[r]
  [call target="changeIdToCallName"]は人狼ではありませんでした。[p]
[return]


; doAction_{actionId}
; NOTE：事前にtf.selectedCharacterIへの格納（PCならアクションボタンの実行、NPCならTODO）が必要。
; シーン：「疑う」アクション実行時
*doAction_suspect
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  僕は[call target="changeIdToCallName"]が怪しいと思います。[r]
  か、勘違いだったらすみません……！[p]
[return]

; シーン：「信じる」アクション実行時
*doAction_trust
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  [call target="changeIdToCallName"]はきっと大丈夫な人です。[r]
  僕はそう信じてます。[p]
[return]

; シーン：「聞き出す」アクション実行時
*doAction_ask
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  えっと、[call target="changeIdToCallName"]はどう思いますか？[p]
[return]


; doAction_reaction_{actionId}
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect
  どうせ僕なんて、疑われても仕方ないですよね……。[p]
[return]

; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust
  ありがとうございます。[r]
  僕も精一杯サポートしますね！[p]
[return]

; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
  ぼ、僕ではお役に立てなさそうです。ごめんなさい。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
  もっと僕のこと、信じてほしかったです……。[p]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
  （未作成）[p]
[return]
