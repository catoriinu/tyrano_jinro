; ./dialogue/{characterId}.ksサブルーチンを呼び出すマクロ集。
; 発言者のキャラクターIDを引数にとり、./dialogue/{characterId}.ksのサブルーチンラベルを呼び出して適切なセリフを出力する。

; dialogueマクロ・サブルーチン作成方針：
; ・マクロは呼び出されるシーンごとの入口として作成し、キャラクターごとにサブルーチンファイルを、パターンごとにサブルーチンラベルを呼び分ける。
; ・サブルーチンファイルはキャラクター1人ごとに1ファイルを作成し、サブルーチンラベルを呼び出されたときに適切なセリフを出力する役割に徹する。
; ・サブルーチンラベル内で変数を利用することでラベル数を削減できる場合は、マクロの引数を増やすよりも優先する。
; ・可能な限りサブルーチンラベル内では分岐は行わないが、シチュエーションごとにセリフ差分が必要な場合は許可する。


; シチュエーション：初日、役職を告知されたときの反応
; @param characterId 発言者のキャラクターID。必須
; @param roleId 発言者の役職ID。必須
[macro name="d_noticeRole"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.dialogueStorage = './dialogue/' + mp.characterId + '.ks'"]
  [eval exp="tf.dialogueTarget = '*noticeRole_' + mp.roleId"]
  [call storage="&tf.dialogueStorage" target="&tf.dialogueTarget"]
[endmacro]


; シチュエーション：真占い師で、占い実行結果を知ったときの反応
; @param characterId 発言者のキャラクターID。必須
; @param result 占い結果（true:●/false:○）。必須
; boolean型で渡されても問題ない（文字列と結合する際にString型にキャストされるため）
[macro name="d_announcedFortuneTellingResult"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.dialogueStorage = './dialogue/' + mp.characterId + '.ks'"]
  [eval exp="tf.dialogueTarget = '*announcedFortuneTellingResult_' + mp.result"]
  [call storage="&tf.dialogueStorage" target="&tf.dialogueTarget"]
[endmacro]


; シチュエーション：投票により処刑対象に決まったときの反応
; @param characterId 発言者のキャラクターID。必須
[macro name="d_executed"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.dialogueStorage = './dialogue/' + mp.characterId + '.ks'"]
  [eval exp="tf.dialogueTarget = '*executed'"]
  [call storage="&tf.dialogueStorage" target="&tf.dialogueTarget"]
[endmacro]
