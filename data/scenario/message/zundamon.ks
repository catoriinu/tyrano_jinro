; ずんだもんのmessageサブルーチン

; 呼び方サブルーチン
; 事前にtf.characterIdToCallにcharacterIdを入れてから、このサブルーチンを呼び出す
; このmessageサブルーチンのキャラクターが、tf.characterIdToCallのキャラクターを呼ぶ際の二人称を出力する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [if exp="tf.characterIdToCall == CHARACTER_ID_ZUNDAMON"]
    僕
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_METAN"]
    めたん
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_TSUMUGI"]
    つむぎ
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_HAU"]
    はう
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_RITSU"]
    リツ
  [endif]
[return]

; noticeRole_{roleId}
; シーン：初日、役職を告知されたときの反応
; 備考：PCのみ想定
*noticeRole_villager
  僕は村人なのだ。[r]
  悪い人狼を見つけて平和な村にするのだ。[p]
[return]

*noticeRole_fortuneTeller
  僕は占い師なのだ。[r]
  さっそく誰か占ってみるのだ！[p]
[return]

*noticeRole_werewolf
  僕は人狼……。[r]
  みんな僕がおいしく食べてやるのだ！[p]
[return]

*noticeRole_madman
  僕は狂人なのだ……。[r]
  僕がご主人の野望を手助けするのだ！[p]
[return]


; announcedFortuneTellingResult_{result}
; シーン：真占い師で、占い実行結果を知ったときの反応
; 備考：PCのみ想定
*announcedFortuneTellingResult_true
  [eval exp="tf.characterIdToCall = tf.todayResultObject.characterId"]
  発見なのだ！[call target="changeIdToCallName"]が人狼だったのだ！[p]
[return]

*announcedFortuneTellingResult_false
  [eval exp="tf.characterIdToCall = tf.todayResultObject.characterId"]
  [call target="changeIdToCallName"]は人狼じゃなかったのだ。[p]
[return]


; COFortuneTellingResult_{result}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE：事前に[j_fortuneTellingHistoryObjectThatDay]の実行が必要。
*COFortuneTellingResult_true
  [eval exp="tf.characterIdToCall = tf.fortuneTellingHistoryObject.characterId"]
  昨日は[call target="changeIdToCallName"]を占ったのだ。[r]
  結果は人狼だったのだ！[p]
[return]

*COFortuneTellingResult_false
  [eval exp="tf.characterIdToCall = tf.fortuneTellingHistoryObject.characterId"]
  昨日は[call target="changeIdToCallName"]を占ったのだ。[r]
  結果は人狼じゃなかったのだ。[p]
[return]


; chooseWhoToBite
; シーン：人狼で、誰を噛むか選ぶときのセリフ
*chooseWhoToBite
  くくく、今夜は誰を食べてやろうか……[r]
  いただきますなのだ！[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
  なんでなのだ！僕は悪くないのだ！[p]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
  この決断が、間違ってないといいのだ……。[p]
[return]
