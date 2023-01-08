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

; COFortuneTellingResult_{result}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE：事前に[j_fortuneTellingHistoryObjectThatDay]の実行が必要。
; TODO：
; 役職COと結果COで差分を付けられるようにする。（「自分が占い師だ」「昨日の占い結果は～」）
; 役職COのとき、自分の前にCO済みの占い師がいる場合「自分こそが占い師だ」と主張することができるようにする
; 結果COのとき、自分の前のCO結果によって反応を変えられるようにする（同じ相手を占った、違う相手を占った）
*COFortuneTellingResult_true
  [eval exp="tf.characterIdToCall = tf.fortuneTellingHistoryObject.characterId"]
  [call target="changeIdToCallName"]。アンタ人狼ね？[r]
  さあ、祭りを始めましょうか。[p]
[return]

*COFortuneTellingResult_false
  [eval exp="tf.characterIdToCall = tf.fortuneTellingHistoryObject.characterId"]
  [call target="changeIdToCallName"]。アンタは人狼じゃないらしいわね。[r]
  住民としてこの村を盛り上げてちょうだい。[p]
[return]


; doAction_{actionId}
; NOTE：事前にtf.selectedCharacterIへの格納（PCならアクションボタンの実行、NPCならTODO）が必要。
; シーン：「疑う」アクション実行時
*doAction_suspect
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  [call target="changeIdToCallName"]はどうせ人狼でしょうね。[r]
  まあ根拠はないけれど。[p]
[return]

; シーン：「信じる」アクション実行時
*doAction_trust
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  こう見えてもあたしは[call target="changeIdToCallName"]を信じてるの。[r]
  だからがっかりさせないでほしいわね。[p]
[return]

; シーン：「聞き出す」アクション実行時
*doAction_ask
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  [call target="changeIdToCallName"]、三行で説明よろしく。[p]
[return]


; doAction_reaction_{actionId}
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect
  アンタがそう思うならそうなんでしょう。[r]
  アンタの中ではね。[p]
[return]

; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust
  ふふ、嬉しいことを言ってくれるじゃない。[p]
[return]

; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
  アンタに教えることなんて何もないわ。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
  安価は絶対……。あたしは潔く去るわ。[p]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
  （未作成）[p]
[return]
