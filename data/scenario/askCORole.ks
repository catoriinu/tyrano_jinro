; TODO 「一つ前に戻る」でstartAskCORoleに戻れない
; TODO 2日目に0,1日目分をCOしたとき、（ゲーム終了時に占い履歴を確認したら）0日目の占い履歴が表示されていなかった
; TODO uhdefined isPublicのエラーが出る
; TODO 選択した「人狼だった」「人狼ではなかった」に色をつけておきたい

*startAskCORole
  ; 役職COするか？→バックアップしてから選択肢を出す
  ; 「騙り占い師COする」→騙り占い師のオブジェクトを取得して、fakeFortuneTellerCOに進む
  ; （「騙り霊能者COする」）
  ; 「役職COしない」→バックアップから復元して終了
  [j_setCORoleToButtonObjects]
  [call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

  [if exp="f.selectedButtonId === 'FortuneTellerCO'"]
    ; TODO ここはただ移植しただけ
    ; 「占い師COする」
    [eval exp="f.playerCORoleId = ROLE_ID_FORTUNE_TELLER"]
    ; 前日の分までの占い結果を、メッセージなしでCOしたことにする
    [j_COFortuneTellingUntilTheLastDay fortuneTellerId="&f.playerCharacterId"]
    ; TODO もっといい格納タイミングを検討する
    [eval exp="f.resultCORoleId = ROLE_ID_FORTUNE_TELLER" cond="f.selectedButtonId !== 'noCO'"]

  [elsif exp="f.selectedButtonId === 'fakeFortuneTellerCO'"]
    ; 「騙り占い師COする」
    [eval exp="f.playerCORoleId = ROLE_ID_FORTUNE_TELLER"]
    [call target="*askFakeFortuneTellingResultMultipleDays"]
    ; TODO もっといい格納タイミングを検討する
    [eval exp="f.resultCORoleId = ROLE_ID_FORTUNE_TELLER" cond="f.selectedButtonId !== 'noCO'"]

  [endif]

  ; 結果COの選択肢で「一つ前に戻る」で戻ってきた場合、もう一度役職COするかを確認する
  [jump target="*startAskCORole" cond="tf.noNeedToCO === true"]

[return]



*askFakeFortuneTellingResultMultipleDays

  ; 「一つ前に戻る」で結果COしないことに決めたかを判定する変数
  [eval exp="tf.noNeedToCO = false"]
  ; 騙り占いを行う最新の日の日付（＝前日）を入れる。
  [eval exp="f.lastDay = f.day - 1"]
  ; サブルーチン実行前に開始日が指定されていればそれを、されていなければ0（=初日）を入れる
  [eval exp="f.fakeFortuneTelledDay = ('fakeFortuneTellingStartDay' in f) ? f.fakeFortuneTellingStartDay : 0"]
  [eval exp="f.fakeFortuneTellingStartDay = f.fakeFortuneTelledDay"]

  *askFakeFortuneTellingResultMultipleDays_loopstart

    [eval exp="f.fakeFortuneTelledDayMsg = f.fakeFortuneTelledDay + '日目の夜'"]
    ; 昨夜の場合だけ、（昨夜）を追加してあげる。
    [eval exp="f.fakeFortuneTelledDayMsg = f.fakeFortuneTelledDayMsg + '（昨夜）'" cond="f.fakeFortuneTelledDay == f.lastDay"]
    [m_fakeFortuneTelledDayMsg]

    ;「一つ前に戻る」を選んだときにロールバックできるよう、バックアップをとっておく
    [j_backupJinroObjects buf="&f.fakeFortuneTelledDay"]

    [eval exp="console.log('★★★')"]
    ; 騙り役職COなら（まだ騙り役職オブジェクトを取得していないなら）騙り役職オブジェクトを取得する。この処理はバックアップより後で行うこと。
    [j_assignmentFakeRole characterId="&f.playerCharacterId" roleId="&f.playerCORoleId"]
    [eval exp="console.log(f.characterObjects[f.playerCharacterId])"]

    ; PCの騙り占いサブルーチンをループ実行していく
    [call target="*start"]

    ; 「一つ前に戻る」
    [jump target="*askFakeFortuneTellingResultMultipleDays_previousDay" cond="f.pcActionObject === {}"]

    ; 騙り占い実行。占い結果をf.actionObjectに格納する
    [j_fortuneTelling fortuneTellerId="&f.pcActionObject.characterId" day="&f.fakeFortuneTelledDay" characterId="&f.pcActionObject.targetId" result="&f.pcActionObject.result"]
    [m_displayFakeFortuneTellingResult result="&f.pcActionObject.result"]

    ; 前日まで占い終わったらループ終了
    [jump target="*askFakeFortuneTellingResultMultipleDays_loopend" cond="f.fakeFortuneTelledDay >= f.lastDay"]

    ; メッセージを表示しないでCOしたことにする（メッセージ表示が必要な、前日の分のCOは呼び元側で行う）
    [j_COFortuneTelling fortuneTellerId="&f.playerCharacterId" day="&f.fakeFortuneTelledDay" noNeedMessage="true"]

    ; 次の日の騙り占いを行う
    [eval exp="f.fakeFortuneTelledDay++"]
    [jump target="*askFakeFortuneTellingResultMultipleDays_loopstart"]

  *askFakeFortuneTellingResultMultipleDays_loopend

  ; 次にこのサブルーチンを呼び出したときのために初期化
  [eval exp="f.fakeFortuneTellingStartDay = 0"]

[return]


*askFakeFortuneTellingResultMultipleDays_previousDay
  ; バックアップから復元してから、CO対象日を一日戻す
  [j_restoreJinroObjects buf="f.fakeFortuneTelledDay"]
  [eval exp="f.fakeFortuneTelledDay--"]

  ; CO対象日が開始日以降（つまり戻れる日がある）なら、一日前の入力に戻る
  [jump target="*askFakeFortuneTellingResultMultipleDays_loopstart" cond="f.fakeFortuneTelledDay >= f.fakeFortuneTellingStartDay"]

  ; CO対象日が開始日より過去になったら「結果COしない」扱いとして終了
  [eval exp="tf.noNeedToCO = true"]
  [jump target="*askFakeFortuneTellingResultMultipleDays_loopend"]
[s]


*fakeFortuneTellerCO
  ; 2日分以上の占い結果を決める必要がある？


  ; 前日の占い結果を決めてください
  ; 「人狼だった」→第二階層を表示する
  ; 「人狼ではなかった」→第二階層を表示する
  ; 「一つ前に戻る」→askFakeRoleCOに戻る

[return]




; アクションボタンサブルーチン
; TODO 表示処理が重くて時間がかかるので、どうにか軽量化できないか？
*start
; アクションボタン用変数の初期化
[eval exp="tf.noNeedStop = false"]
[iscript]
  // PCがアクションを選択済みの場合に、ボタンの色を変えるために変数に格納しておく
  //f.selectedActionId = ('actionId' in f.pcActionObject) ? f.pcActionObject.actionId : ACTION_CANCEL; // 未選択なら「発言しない」の色を変える
  // 第2階層のキャラクターボタンの色を変えるかの判定に使うのは、前回選択したキャラクターIDとする。f.selectedCharacterIdはアクションボタン処理中に書き換わってしまうため使えない。
  //f.originalSelectedCharacterId = ('targetId' in f.pcActionObject) ? f.pcActionObject.targetId : '';
[endscript]
; アクションボタンとステータスボタンを非表示（バックログボタンは押せて良いので残す）
; アクションボタン自体がrole="sleepgame"のボタン（復元時に元のメッセージを表示したいため）のため、そこから更にfix属性であるステータスボタンは押せないため無効化しておく
;[j_clearFixButton action="true" status="true"]

*firstLayer
; 第1階層のボタンを表示
[call target="*displayFirstLayerButtons"]

; 第1階層のボタン押下結果によって次の第2階層のボタンを出し分ける
[jump target="*targetLayer" cond="f.selectedActionId == 'black'"]
[jump target="*targetLayer" cond="f.selectedActionId == 'white'"]
; 当てはまるラベルがない（＝一つ前に戻る）場合はアクション中断
[jump target="*cancel"]
[s]

*targetLayer
; 第2階層を表示するときにも第1階層を表示する。別の第1階層ボタンも押せるように。
[eval exp="tf.noNeedStop = true"]
[call target="*displayFirstLayerButtons"]
[call target="*displaySecondLayerButtons"]

; 第2階層のボタンを押下した場合（＝キャラクターIDが格納済みの場合）、アクションは正常終了
[jump target="*input" cond="f.selectedCharacterId != ''"]
; 第1階層のボタン押下結果によって次の第2階層のボタンを出し分ける
[jump target="*targetLayer" cond="f.selectedActionId == 'black'"]
[jump target="*targetLayer" cond="f.selectedActionId == 'white'"]
; 当てはまるラベルがない（＝一つ前に戻る）場合はアクション終了
[jump target="*cancel"]
[s]

*cancel
[eval exp="f.pcActionObject = {}"]
[jump target="*end"]

*input
[iscript]
  // ここまでにf.selectedActionIdに入っているのは'black'か'white'のどちらか。それはActionオブジェクトのresultに格納すべきデータなのでboolean型に変換して格納する。
  const declarationResult = (f.selectedActionId == 'black') ? true : false;
  // 本当にActionオブジェクトのactionIdに格納すべきは、結果COしようとしている騙り役職のアクションID
  // TODO 今は占いしか騙れないのでACTION_FORTUNE_TELLING決め打ち
  const actionId = ACTION_FORTUNE_TELLING;

  f.pcActionObject = new Action(f.playerCharacterId, actionId, f.selectedCharacterId, declarationResult);
  // MEMO: PCの判断基準IDを格納するのは、発言直前にする。ここではボタン処理のみに注力するため。
[endscript]

*end
; アクションボタンとステータスボタンを再表示
;[j_displayFixButton action="true" status="true"]

;[awakegame]
[return]



; 第1階層（左側。行動を選択する）のボタン表示サブルーチン
*displayFirstLayerButtons

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
    f.buttonObjects.push(new Button(
      'previous',
      '一つ前に戻る', // TODO 役職CO時ではなく結果CO時は「結果COしない」に変える
      'left',
      CLASS_GLINK_DEFAULT,
      //['previous']
    ));
  [endscript]
  [call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

; ボタン押下後の処理
; 第1階層のボタンを押した場合、selectedActionIdに格納する
[eval exp="f.selectedActionId = f.selectedButtonId"]
[return]


; 第2階層（右側。対象のキャラクターを選択する）のボタン表示サブルーチン
*displaySecondLayerButtons
  [eval exp="tf.candidateCharacterIds = f.characterObjects[f.playerCharacterId].fakeRole.getCandidateCharacterIds(f.playerCharacterId, f.fakeFortuneTelledDay)"]
  [eval exp="tf.doSlideInCharacter = true"]
  [j_setCharacterToButtonObjects side="right" characterIds="&tf.candidateCharacterIds"]
  [call target="*secondLayerLoop"]
[return]


*secondLayerLoop
[call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

; ボタン押下後の処理
; 第2階層表示中には第1階層のボタンも押下できる状態のため、第1第2どちらを押下されても対応できるように判定する
[if exp="f.selectedSide == 'right'"]
  ; 第2階層のボタンを押した場合、selectedCharacterIdに格納する
  [eval exp="f.selectedCharacterId = f.selectedButtonId"]
[elsif exp="f.selectedSide == 'left'"]
  ; 第1階層のボタンを押した場合、selectedActionIdに格納する。selectedCharacterIdは空にして改めて第2階層までボタンを表示する
  [eval exp="f.selectedActionId = f.selectedButtonId"]
  [eval exp="f.selectedCharacterId = ''"]
[endif]
[return]
