; PCの占いサブルーチン
*fortuneTellingForPC

  ; ボタン非表示
  [j_clearFixButton menu="true"]

  ; 占い候補のキャラクターID配列を取得、ボタンオブジェクトに格納
  [eval exp="tf.candidateCharacterIds = f.characterObjects[f.playerCharacterId].role.getCandidateCharacterIds(f.playerCharacterId)"]
  [j_setCharacterToButtonObjects characterIds="&tf.candidateCharacterIds"]
  [eval exp="tf.doSlideInCharacter = true"]
  ; 占い候補からボタンを生成。ボタン入力を受け付ける
  [call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

  ; 占い実行。占い結果をf.actionObjectに格納する
  [j_fortuneTelling fortuneTellerId="&f.playerCharacterId" characterId="&f.selectedButtonId"]

  ; ボタン再表示
  [j_displayFixButton menu="true"]

[return]


; PCの騙り占いサブルーチン
; 夜時間には直接呼び出してよい。
; 昼時間に騙り占い師COするために呼び出すときは、*fakeFortuneTellingCOMultipleDaysForPCから呼び出すこと
; （上記サブルーチン内で、tf.fortuneTelledDayの格納を行っておく必要がある）
*fakeFortuneTellingForPC
  ; TODO アクションボタンと同じように、第1階層はキャラクター、第2階層は騙り結果、という構成にできそう
  ; 入力し直しもできるようになるのでなるべくそうしたい

  ; ボタン非表示
  [j_clearFixButton menu="true"]

  ; 夜時間の呼び出しであれば、占い指定日に当日を格納する
  [if exp="!f.isDaytime"]
    [eval exp="tf.fortuneTelledDay = f.day"]
  [endif]

  ; 騙り占い候補のキャラクターID配列を取得。指定された日の夜時間開始時の生存者を参照する。
  [eval exp="tf.candidateCharacterIds = f.characterObjects[f.playerCharacterId].fakeRole.getCandidateCharacterIds(f.playerCharacterId, tf.fortuneTelledDay)"]
  [j_setCharacterToButtonObjects characterIds="&tf.candidateCharacterIds"]
  [eval exp="tf.doSlideInCharacter = true"]
  ; 騙り占い候補からボタンを生成。ボタン入力を受け付ける
  [call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]
  ; ここでボタンを押した対象のキャラクターのIDを別の変数に移しておかないと、この後の騙り結果入力のボタンで上書きされてしまう
  [eval exp="f.targetCharacterId = f.selectedButtonId"]

  ; 騙り占い先のキャラクター名をメッセージに表示する
  [m_displayFakeFortuneTellingTarget]

  ; 騙り結果入力を受け付ける
  [iscript]
    f.buttonObjects = [];
    f.buttonObjects.push(new Button(
      'black',
      '人狼だった',
      'center',
      CLASS_GLINK_DEFAULT,
      [CLASS_GLINK_BLACK]
    ));
    f.buttonObjects.push(new Button(
      'white',
      '人狼ではなかった',
      'center',
      CLASS_GLINK_DEFAULT,
      [CLASS_GLINK_WHITE]
    ));
  [endscript]
  [call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]
  ; ボタン入力をboolean型に変換する
  [eval exp="f.declarationResult = (f.selectedButtonId == 'black') ? true : false"]

  ; 騙り占い実行。占い結果をf.actionObjectに格納する
  [j_fortuneTelling fortuneTellerId="&f.playerCharacterId" day="&tf.fortuneTelledDay" characterId="&f.targetCharacterId" result="&f.declarationResult"]
  [m_displayFakeFortuneTellingResult result="&f.declarationResult"]

  ; ボタン再表示
  [j_displayFixButton menu="true"]

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
