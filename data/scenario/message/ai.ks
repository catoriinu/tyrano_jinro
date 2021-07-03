; アイのmessageサブルーチン

; noticeRole_{roleId}
; シーン：初日、役職を告知されたときの反応
; 備考：PCのみ想定
*noticeRole_villager
  私は村人なんだね。[r]
  推理で人狼を見つけて平和な村にしないと。[p]
[return]

*noticeRole_fortuneTeller
  私は占い師か……。[r]
  誰を占おうか？[p]
[return]

*noticeRole_werewolf
  私は人狼……。[r]
  この村の人間を食い尽くしてやる！[p]
[return]

*noticeRole_madman
  私は狂人か……。[r]
  ふふふ、全ては人狼のために！[p]
[return]


; announcedFortuneTellingResult_{result}
; シーン：真占い師で、占い実行結果を知ったときの反応
; 備考：PCのみ想定
*announcedFortuneTellingResult_true
  ……[emb exp="f.characterObjects[tf.todayResultObject.characterId].name"]が人狼だったんだね……。[p]
[return]

*announcedFortuneTellingResult_false
  [emb exp="f.characterObjects[tf.todayResultObject.characterId].name"]は人狼じゃないみたい。[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
  そっか……。信じてもらえなくて残念だよ。[p]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
  もし間違ってたら、ごめん……。[p]
[return]