; PCの占いサブルーチン
*fortuneTellingForPC

  ; 占い候補のキャラオブジェクト配列を取得
  [eval exp="tf.candidateCharacterObjects = f.characterObjects[f.playerCharacterId].role.getCandidateCharacterObjects(f.playerCharacterId)"]

  ; 占い候補からボタンを生成。ボタン入力を受け付ける
  [call storage="./jinroSubroutines.ks" target="*glinkFromCandidateCharacterObjects"]

  ; 占い実行。占い結果をf.actionObjectに格納する
  [j_fortuneTelling fortuneTellerId="&f.playerCharacterId" characterId="&f.targetCharacterId"]

[return]


; PCの騙り占いサブルーチン
; 夜時間には直接呼び出してよい。
; 昼時間に騙り占い師COするために呼び出すときは、*fakeFortuneTellingCOMultipleDaysForPCから呼び出すこと
; （上記サブルーチン内で、tf.fortuneTelledDayの格納を行っておく必要がある）
*fakeFortuneTellingForPC

  ; 夜時間の呼び出しであれば、占い指定日に当日を格納する
  [if exp="!f.isDaytime"]
    [eval exp="tf.fortuneTelledDay = f.day"]
  [endif]

  ; 騙り占い候補のキャラオブジェクト配列を取得。指定された日の夜時間開始時の生存者を参照する。
  [eval exp="tf.candidateCharacterObjects = f.characterObjects[f.playerCharacterId].fakeRole.getCandidateCharacterObjects(f.playerCharacterId, tf.fortuneTelledDay)"]

  ; 騙り占い候補からボタンを生成。ボタン入力を受け付ける
  [call storage="./jinroSubroutines.ks" target="*glinkFromCandidateCharacterObjects"]

  ; 騙り占い先のキャラクター名をメッセージに表示する
  [m_displayFakeFortuneTellingTarget]

  ; 騙り結果入力を受け付ける
  [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (0 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
  [glink color="black" size="28" x="360" width="500" y="&tf.y" text="●（人狼だった）とCOする" target="*doFakeFortuneTelling" exp="tf.declarationResult = true"]
  [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (1 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
  [glink color="white" size="28" x="360" width="500" y="&tf.y" text="○（人狼ではなかった）とCOする" target="*doFakeFortuneTelling" exp="tf.declarationResult = false"]
  [s]

  ; 騙り占い実行。占い結果をf.actionObjectに格納する
  *doFakeFortuneTelling
  [j_fortuneTelling fortuneTellerId="&f.playerCharacterId" day="&tf.fortuneTelledDay" characterId="&f.targetCharacterId" result="&tf.declarationResult"]
  [m_displayFakeFortuneTellingResult result="&tf.declarationResult"]

[return]


; PC用の騙り占いCOマクロ
; 初日から、指定された日付の前日の夜までを占ったことにできる。
*fakeFortuneTellingCOMultipleDaysForPC

  ; 騙り占いを行う最新の日の日付（＝前日）を入れる。（NOTE:もし指定できた方がよければ引数用変数を追加する）
  [eval exp="tf.lastDay = f.day - 1"]
  [eval exp="tf.fortuneTelledDay = 0"]
  [eval exp="tf.fortuneTelledDayMsg = '初日の夜'"]
  *fakeFortuneTellingCOMultipleDays_loopstart
    
    [m_fortuneTelledDayMsg]
    ; PCの騙り占いサブルーチンを、初日(day=0)から最新の日の日付までループ実行していく
    [call storage="./fortuneTellingForPC.ks" target="*fakeFortuneTellingForPC"]

  [jump target="*fakeFortuneTellingCOMultipleDays_loopend" cond="tf.fortuneTelledDay == tf.lastDay"]
  [eval exp="tf.fortuneTelledDay++"]
  ; 次の日用の表示メッセージ作成。昨夜の場合だけ、（昨夜）を追加してあげる。
  [eval exp="tf.fortuneTelledDayMsg = (tf.fortuneTelledDay + 1) + '日目の夜'"]
  [eval exp="tf.fortuneTelledDayMsg = tf.fortuneTelledDayMsg + '（昨夜）'" cond="tf.fortuneTelledDay == tf.lastDay"]
  [jump target="*fakeFortuneTellingCOMultipleDays_loopstart"]

  *fakeFortuneTellingCOMultipleDays_loopend

[return]
