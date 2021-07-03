; ヒヨリのmessageサブルーチン

; COFortuneTellingResult_{result}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE：事前に[j_fortuneTellingHistoryObjectThatDay]の実行が必要。
*COFortuneTellingResult_true
  う、占いCOです！[r]
  わたし、[emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]さんを占いました。[r]
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]さんは、じ、人狼だったんです……！[p]
[return]

*COFortuneTellingResult_false
  う、占いCOです！[r]
  わたし、[emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]さんを占いました。[r]
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]さんは、人狼ではなかったです。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
  わたし、人狼なんかじゃないよ……っ[p]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
  もう嫌だよ……こんなのがまだ続くの……？[p]
[return]