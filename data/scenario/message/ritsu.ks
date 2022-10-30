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
