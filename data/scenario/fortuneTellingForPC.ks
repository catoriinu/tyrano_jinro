*startAskResultCO
  ; 初期化
  [eval exp="f.askCOOnceMore = false"]
  [eval exp="f.resultCORoleId = ''"]

  ; （騙り）占い結果COをするか問うボタンを表示
  ; TODO 騙りの場合はテキストを変えたほうがよい
  昨夜の占い結果をCOしますか？
  [j_setFrotuneTellerResultCOToButtonObjects]
  [call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

  ; ０）「何もしない」を選んだ場合、f.resultCORoleIdは空文字のまま
  ; １）「占い結果COする」「騙り占い結果COする」を選んだ場合、f.resultCORoleIdに占い師を入れる
  [eval exp="f.resultCORoleId = ROLE_ID_FORTUNE_TELLER" cond="f.selectedButtonId === 'FortuneTellerCO' || f.selectedButtonId === 'fakeFortuneTellerCO'"]

  ; １－１）真占い師なら、すでに占い済みなのでここでは何もしない

  ; １－２）騙り占い師なら、前日の分の占い結果を騙っていく（※「一つ前に戻る」で戻ってくることがありうる）
  ; TODO storageを変えるなり、移してくるなりする
  [eval exp="f.fakeFortuneTellingStartDay = f.day - 1"]
  [call storage="./askCORole.ks" target="*askFakeFortuneTellingResultMultipleDays" cond="f.selectedButtonId === 'fakeFortuneTellerCO'"]

  ; 騙り結果COの選択肢で「一つ前に戻る」で戻ってきた場合、役職COするかの選択肢をもう一度出す
  [jump target="*startAskResultCO" cond="f.askCOOnceMore === true"]

  ; COした役職IDがf.resultCORoleIdに格納されている状態でサブルーチンを終了する（「何もしない」なら空文字）
[return]




; PCの占いサブルーチン
*fortuneTellingForPC

  ; 占い候補のキャラクターID配列を取得、ボタンオブジェクトに格納
  [eval exp="tf.candidateCharacterIds = f.characterObjects[f.playerCharacterId].role.getCandidateCharacterIds(f.playerCharacterId)"]
  [j_setCharacterToButtonObjects characterIds="&tf.candidateCharacterIds"]
  [eval exp="tf.doSlideInCharacter = true"]
  ; 占い候補からボタンを生成。ボタン入力を受け付ける
  [call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

  ; 占い実行。占い結果をf.actionObjectに格納する
  [j_fortuneTelling fortuneTellerId="&f.playerCharacterId" characterId="&f.selectedButtonId"]

[return]


; TODO 削除予定
; PCの騙り占いサブルーチン
; 昼時間は*fakeFortuneTellingCOMultipleDaysForPCから呼び出すこと
; （上記サブルーチン内で、f.fakeFortuneTelledDayの格納を行っておく必要がある）
; 夜時間に呼び出すことは現状考慮していない。
*fakeFortuneTellingForPC
  ; TODO アクションボタンと同じように、第1階層はキャラクター、第2階層は騙り結果、という構成にできそう
  ; 入力し直しもできるようになるのでなるべくそうしたい

  ; デッドコードを仕込む
  [eval exp="alert('*fakeFortuneTellingForPC が実行されました')"]

  ; 騙り占い候補のキャラクターID配列を取得。指定された日の夜時間開始時の生存者を参照する。
  [eval exp="tf.candidateCharacterIds = f.characterObjects[f.playerCharacterId].fakeRole.getCandidateCharacterIds(f.playerCharacterId, f.fakeFortuneTelledDay)"]
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
      'left',
      CLASS_GLINK_DEFAULT,
      [CLASS_GLINK_BLACK]
    ));
    f.buttonObjects.push(new Button(
      'white',
      '人狼ではなかった',
      'left',
      CLASS_GLINK_DEFAULT,
      [CLASS_GLINK_WHITE]
    ));
  [endscript]
  [call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]
  ; ボタン入力をboolean型に変換する
  [eval exp="f.declarationResult = (f.selectedButtonId == 'black') ? true : false"]

  ; 騙り占い実行。占い結果をf.actionObjectに格納する
  [j_fortuneTelling fortuneTellerId="&f.playerCharacterId" day="&f.fakeFortuneTelledDay" characterId="&f.targetCharacterId" result="&f.declarationResult"]
  [m_displayFakeFortuneTellingResult result="&f.declarationResult"]

[return]


; TODO 削除予定
; PC用の騙り占いCOサブルーチン
; 指定された日から、前日の夜までに占っていたことにできる。
; 指定された日がなければ初日から。（＝2日目以降の騙り占い師CO用）
; 指定された日が前日の夜ならその1回分のみ。（＝騙り占いCO済み時の、騙り占い結果CO用）
; @param f.fakeFortuneTellingStartDay 騙り占いを実行する開始日。指定する場合は、サブルーチン実行前に格納しておくこと。
*fakeFortuneTellingCOMultipleDaysForPC

  ; デッドコードを仕込む
  [eval exp="alert('*fakeFortuneTellingCOMultipleDaysForPC が実行されました')"]

  ; 騙り占いを行う最新の日の日付（＝前日）を入れる。
  [eval exp="f.lastDay = f.day - 1"]
  ; サブルーチン実行前に開始日が指定されていればそれを、されていなければ0（=初日）を入れる
  [eval exp="f.fakeFortuneTelledDay = ('fakeFortuneTellingStartDay' in f) ? f.fakeFortuneTellingStartDay : 0"]

  *fakeFortuneTellingCOMultipleDays_loopstart
    [eval exp="f.fakeFortuneTelledDayMsg = f.fakeFortuneTelledDay + '日目の夜'"]
    ; 昨夜の場合だけ、（昨夜）を追加してあげる。
    [eval exp="f.fakeFortuneTelledDayMsg = f.fakeFortuneTelledDayMsg + '（昨夜）'" cond="f.fakeFortuneTelledDay == f.lastDay"]
    [m_fakeFortuneTelledDayMsg]
    ; PCの騙り占いサブルーチンをループ実行していく
    [call storage="./fortuneTellingForPC.ks" target="*fakeFortuneTellingForPC"]

  ; 前日まで占い終わったらループ終了
  [jump target="*fakeFortuneTellingCOMultipleDays_loopend" cond="f.fakeFortuneTelledDay >= f.lastDay"]

  ; メッセージを表示しないでCOしたことにする（メッセージ表示が必要な、前日の分のCOは呼び元側で行う）
  [j_COFortuneTelling fortuneTellerId="&f.playerCharacterId" day="&f.fakeFortuneTelledDay" noNeedNotice="true"]

  ; 次の日の騙り占いを行う
  [eval exp="f.fakeFortuneTelledDay++"]
  [jump target="*fakeFortuneTellingCOMultipleDays_loopstart"]

  *fakeFortuneTellingCOMultipleDays_loopend

  ; 次にこのサブルーチンを呼び出したときのために初期化
  [eval exp="f.fakeFortuneTellingStartDay = 0"]

[return]
