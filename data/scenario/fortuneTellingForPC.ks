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
