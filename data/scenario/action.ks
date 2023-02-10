; アクションボタンサブルーチン
; TODO 表示処理が重くて時間がかかるので、どうにか軽量化できないか？
; TODO 一度第2階層のアクションのボタンまで押した後、再度同じキャラ、アクションを選択を繰り返すと、アクションボタンが閉じなくなったり、第2階層のボタンが増殖したりするバグあり
*start
; アクションボタン用変数の初期化
[eval exp="tf.noNeedStop = false"]
[iscript]
  // PCがアクションを選択済みの場合に、ボタンの色を変えるために変数に格納しておく
  f.selectedActionId = ('actionId' in f.pcActionObject) ? f.pcActionObject.actionId : ACTION_CANCEL; // 未選択なら「発言しない」の色を変える
  f.selectedCharacterId = ('targetId' in f.pcActionObject) ? f.pcActionObject.targetId : '';
[endscript]

*firstLayer
; 第1階層のボタンを表示
[call target="*displayFirstLayerButtons"]

; 第1階層のボタン押下結果によって次の第2階層のボタンを出し分ける
[jump target="*targetLayer" cond="f.selectedActionId == ACTION_SUSPECT"]
[jump target="*targetLayer" cond="f.selectedActionId == ACTION_TRUST"]
[jump target="*targetLayer" cond="f.selectedActionId == ACTION_ASK"]
; 当てはまるラベルがない（＝発言しない）場合はアクション中断
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
[jump target="*targetLayer" cond="f.selectedActionId == ACTION_SUSPECT"]
[jump target="*targetLayer" cond="f.selectedActionId == ACTION_TRUST"]
[jump target="*targetLayer" cond="f.selectedActionId == ACTION_ASK"]
; 当てはまるラベルがない（＝発言しない）場合はアクション終了
[jump target="*cancel"]
[s]

*cancel
[eval exp="f.pcActionObject = {}"]
[jump target="*end"]

*input
[iscript]
  f.pcActionObject = new Action(f.playerCharacterId, f.selectedActionId, f.selectedCharacterId);
[endscript]

*end
[awakegame]
[return]



; 第1階層（左側。行動を選択する）のボタン表示サブルーチン
*displayFirstLayerButtons
[j_setActionToButtonObjects]

[eval exp="tf.side = 'left'"]
[call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

; ボタン押下後の処理
; 第1階層のボタンを押した場合、selectedActionIdに格納する
[eval exp="f.selectedActionId = f.selectedButtonId"]
[return]


; 第2階層（右側。対象のキャラクターを選択する）のボタン表示サブルーチン
*displaySecondLayerButtons
[j_setCharacterToButtonObjects onlySurvivor="true"]
[call target="*secondLayerLoop"]
[return]



*displayRoleLayerButtons
[iscript]
tf.candidateObjects = [
  {id: "fortuneTeller", text: "占い師", target: "*end"},
  {id: "hoge", text: "霊能者", target: "*end"},
]
[endscript]
[call target="*secondLayerLoop"]
[return]



*secondLayerLoop
[eval exp="tf.side = 'right'"]
[call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

; ボタン押下後の処理
; 第2階層表示中には第1階層のボタンも押下できる状態のため、第1第2どちらを押下されても対応できるように判定する
[if exp="f.selectedSide == 'right'"]
  ; 第1階層のボタンを押した場合、selectedCharacterIdに格納する
  [eval exp="f.selectedCharacterId = f.selectedButtonId"]
[elsif exp="f.selectedSide == 'left'"]
  ; 第1階層のボタンを押した場合、selectedActionIdに格納する。selectedCharacterIdは空にして改めて第2階層までボタンを表示する
  [eval exp="f.selectedActionId = f.selectedButtonId"]
  [eval exp="f.selectedCharacterId = ''"]
[endif]
[return]
