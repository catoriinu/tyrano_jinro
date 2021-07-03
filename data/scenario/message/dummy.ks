; ダミーのmessageサブルーチン

; COFortuneTellingResult_{result}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE：事前に[j_fortuneTellingHistoryObjectThatDay]の実行が必要。
*COFortuneTellingResult_true
  占いCOやで！[r]
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]は人狼やでー！[p]
[return]

*COFortuneTellingResult_false
  占いCOやで！[r]
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]は人狼やあらへんかったわ。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
  あっ……ホンマ……[p]
[return]
