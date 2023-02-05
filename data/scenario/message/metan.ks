; 四国めたんのmessageサブルーチン

; 呼び方サブルーチン
; 事前にtf.characterIdToCallにcharacterIdを入れてから、このサブルーチンを呼び出す
; このmessageサブルーチンのキャラクターが、tf.characterIdToCallのキャラクターを呼ぶ際の二人称を出力する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [if exp="tf.characterIdToCall == CHARACTER_ID_ZUNDAMON"]
    ずんだもん
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_METAN"]
    わたくし
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_TSUMUGI"]
    つむぎさん
  [elsif exp="tf.characterIdToCall == CHARACTER_ID_HAU"]
    はうさん
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
  聞きなさい。[call target="changeIdToCallName"]は人狼だったわ！[r]
  ふふふ、わたくしの魔眼に見抜けぬものはないわ。[p]
[return]

*COFortuneTelling_false
  [eval exp="tf.characterIdToCall = f.actionObject.targetId"]
  聞きなさい。[call target="changeIdToCallName"]は人狼ではなかったわ。[r]
  信頼の証に、同盟を結ばせてもらえるかしら。[p]
[return]


; doAction_{actionId}
; NOTE：事前にtf.selectedCharacterIへの格納（PCならアクションボタンの実行、NPCならTODO）が必要。
; シーン：「疑う」アクション実行時
*doAction_suspect
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  ふふふ。[call target="changeIdToCallName"]、そろそろ認めたらどうかしら？[r]
  自分が人狼だということを。[p]
[return]

; シーン：「信じる」アクション実行時
*doAction_trust
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  [call target="changeIdToCallName"]、わたくしはあなたを信じているわ。[p]
[return]

; シーン：「聞き出す」アクション実行時
*doAction_ask
  [eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
  状況が混沌としてきたわね……。[r]
  [call target="changeIdToCallName"]の考えを聞かせてくれるかしら？[p]
[return]


; doAction_reaction_{actionId}
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect
  ふん。心外もいいところね。[p]
[return]

; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust
  べ、別に嬉しくなんてないわ……！[p]
[return]

; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
  わたくしに聞かないでちょうだい！[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
  これが運命なら受け入れるしかないのでしょうね。[p]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
  （未作成）[p]
[return]
