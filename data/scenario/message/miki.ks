; ミキのmessageサブルーチン

; COFortuneTellingResult_{result}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE：事前に[j_fortuneTellingHistoryObjectThatDay]の実行が必要。
; TODO：
; 役職COと結果COで差分を付けられるようにする。（「自分が占い師だ」「昨日の占い結果は～」）
; 役職COのとき、自分の前にCO済みの占い師がいる場合「自分こそが占い師だ」と主張することができるようにする
; 結果COのとき、自分の前のCO結果によって反応を変えられるようにする（同じ相手を占った、違う相手を占った）
*COFortuneTellingResult_true
  私の占い結果を聞きなさい！[r]
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]は人狼だったわ！　早く吊るのよ！[p]
[return]

*COFortuneTellingResult_false
  私の占い結果を聞きなさい！[r]
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]は人狼じゃなかったわ。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
  や、やめなさい！私は違うと言っているでしょう！[p]
[return]
