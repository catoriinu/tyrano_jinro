; フタバのmessageサブルーチン

; COFortuneTellingResult_{result}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE：事前に[j_fortuneTellingHistoryObjectThatDay]の実行が必要。
*COFortuneTellingResult_true
  占いCO！[r]
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]は●（クロ）だよ！ へへ、覚悟しなよ！[p]
[return]

*COFortuneTellingResult_false
  占いCO！[r]
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]は○（シロ）だったよ。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
  ええーっ！後悔しても遅いんだからねっ！[p]
[return]
