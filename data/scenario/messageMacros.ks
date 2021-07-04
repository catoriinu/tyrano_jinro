; ./message/{characterId}.ksサブルーチンを呼び出すマクロ集。
; 発言者のキャラクターIDを引数にとり、./message/{characterId}.ksのサブルーチンラベルを呼び出して適切なセリフを出力する。

; messageマクロ・サブルーチン作成方針：
; ・マクロは呼び出されるシーンごとの入口として作成し、キャラクターごとにサブルーチンファイルを、パターンごとにサブルーチンラベルを呼び分ける。
; ・サブルーチンファイルはキャラクター1人ごとに1ファイルを作成し、サブルーチンラベルを呼び出されたときに適切なセリフを出力する役割に徹する。
; ・サブルーチンラベル内で変数を利用することでラベル数を削減できる場合は、マクロの引数を増やすよりも優先する。
; ・可能な限りサブルーチンラベル内では分岐は行わないが、シチュエーションごとにセリフ差分が必要な場合は許可する。


; シーン：初日、役職を告知されたときの反応
; @param characterId 発言者のキャラクターID。必須
; @param roleId 発言者の役職ID。必須
[macro name="m_noticeRole"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*noticeRole_' + mp.roleId"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：真占い師で、占い実行結果を知ったときの反応
; @param characterId 発言者のキャラクターID。必須
; @param result 占い結果（true:●/false:○）。必須
; boolean型で渡されても問題ない（文字列と結合する際にString型にキャストされるため）
[macro name="m_announcedFortuneTellingResult"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*announcedFortuneTellingResult_' + mp.result"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：占いCOをするかを問うシステムメッセージ
; @param canCOFortuneTellerStatus 占い師COすることができる役職・CO状態かの定数。必須。関連マクロ：[j_setCanCOFortuneTellerStatus]
[macro name="m_askFortuneTellerCO"]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*askFortuneTellerCO_' + mp.canCOFortuneTellerStatus"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：前日の占い結果をCOするときのセリフ
; @param characterId 発言者のキャラクターID。必須
; @param result 占い結果（true:●/false:○）。必須
; boolean型で渡されても問題ない（文字列と結合する際にString型にキャストされるため）
[macro name="m_COFortuneTellingResult"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*COFortuneTellingResult_' + mp.result"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：投票により処刑対象に決まったときの反応
; @param characterId 発言者のキャラクターID。必須
[macro name="m_executed"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*executed'"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：処刑後の反応
; @param characterId 発言者のキャラクターID。必須
[macro name="m_afterExecution"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*afterExecution'"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：時間が経過したときのシステムメッセージ
; @param isDaytime （true:昼/faklse:夜）になったか。必須。関連メソッド：timePasses()
[macro name="m_timePasses"]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*timePasses_' + mp.isDaytime"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：占い先を決めることを促すシステムメッセージ
; @param isFortuneTeller 真占い師(true)か、騙り占い師か(false)。必須。関連マクロ：[j_setCanCOFortuneTellerStatus]を元に呼び元でbooleanに変換しておくこと。
[macro name="m_askFortuneTellingTarget"]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*askFortuneTellingTarget_' + mp.isFortuneTeller"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：偽の占い対象を入力した後、それを表示しつつそのCO結果を決めることを促すシステムメッセージ
[macro name="m_fortuneTelledDayMsg"]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*fortuneTelledDayMsg'"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：偽の占い対象を入力した後、それを表示しつつそのCO結果を決めることを促すシステムメッセージ
[macro name="m_displayFakeFortuneTellingTarget"]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*displayFakeFortuneTellingTarget'"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：入力した偽の占いCO結果を表示するシステムメッセージ
; @param result 偽の占い結果（true:●/false:○）。必須
[macro name="m_displayFakeFortuneTellingResult"]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*displayFakeFortuneTellingResult_' + mp.result"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]
