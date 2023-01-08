; アクションボタンサブルーチン
*start
; 一時変数の初期化
[eval exp="tf.noNeedStop = false"]
[eval exp="f.selectedActionId = ''"]
[eval exp="f.selectedCharacterId = ''"]

*firstLayer
; 第1階層のボタンを表示
[call target="*displayFirstLayerButtons"]

; 第1階層のボタン押下結果によって次の第2階層のボタンを出し分ける
[jump target="*targetLayer" cond="f.selectedActionId == 'suspect'"]
[jump target="*targetLayer" cond="f.selectedActionId == 'trust'"]
[jump target="*targetLayer" cond="f.selectedActionId == 'ask'"]
; 当てはまるラベルがない（＝キャンセル）場合はアクション終了
[jump target="*end"]
[s]

*targetLayer
; 第2階層を表示するときにも第1階層を表示する。別の第1階層ボタンも押せるように。
[eval exp="tf.noNeedStop = true"]
[call target="*displayFirstLayerButtons"]
[call target="*displaySecondLayerButtons"]

; 第2階層のボタンを押下した場合（＝キャラクターIDが格納済みの場合）、アクション終了
[jump target="*end" cond="f.selectedCharacterId != ''"]
; 第1階層のボタン押下結果によって次の第2階層のボタンを出し分ける
[jump target="*targetLayer" cond="f.selectedActionId == 'suspect'"]
[jump target="*targetLayer" cond="f.selectedActionId == 'trust'"]
[jump target="*targetLayer" cond="f.selectedActionId == 'ask'"]
; 当てはまるラベルがない（＝キャンセル）場合はアクション終了
[jump target="*end"]
[s]

*end
[awakegame]
[return]



; 第1階層（左側。行動を選択する）のボタン表示サブルーチン
*displayFirstLayerButtons
[iscript]

; 「疑う」「信じる」「聞き出す」は基本セットとしておく
tf.candidateObjects = [
  {id: "suspect", text: "疑う", target: "*targetLayer"},
  {id: "trust", text: "信じる", target: "*targetLayer"},
  {id: "ask", text: "聞き出す", target: "*targetLayer"}
];

; TODO テストのため必ず表示 潜伏役職が残っているなら「COを促す」を表示
if (false) {
  tf.candidateObjects.push({id: "prompt", text: "COを促す", target: "*roleLayer"});
}

; TODO テストのため必ず表示 プレイヤーがCO可能な場合「COする」を表示
if (false) {
  tf.candidateObjects.push({id: "CO", text: "COする", target: "*roleLayer"});
}

; TODO テストのため必ず表示 「キャンセル」を表示
tf.candidateObjects.push({id: "cancel", text: "キャンセル", target: "*end"});

[endscript]

[eval exp="tf.side = 'left'"]
[call storage="./jinroSubroutines.ks" target="*glinkFromCandidateObjects"]

; ボタン押下後の処理
; 第1階層のボタンを押した場合、selectedActionIdに格納する
[eval exp="f.selectedActionId = f.targetButtonId"]
[return]


; 第2階層（右側。対象のキャラクターを選択する）のボタン表示サブルーチン
*displaySecondLayerButtons
[iscript]
tf.candidateObjects = [
  {id: "zundamon", text: "ずんだもん", target: "*end"},
  {id: "metan", text: "四国めたん", target: "*end"},
  {id: "tsumugi", text: "春日部つむぎ", target: "*end"},
  {id: "hau", text: "雨晴はう", target: "*end"},
  {id: "ritsu", text: "波音リツ", target: "*end"},
  {id: "typet", text: "六人表示が限界みたい", target: "*end"},
];
[endscript]
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
[call storage="./jinroSubroutines.ks" target="*glinkFromCandidateObjects"]

; ボタン押下後の処理
; 第2階層表示中には第1階層のボタンも押下できる状態のため、第1第2どちらを押下されても対応できるように判定する
[if exp="f.targetSide == 'right'"]
  ; 第1階層のボタンを押した場合、selectedCharacterIdに格納する
  [eval exp="f.selectedCharacterId = f.targetButtonId"]
[elsif exp="f.targetSide == 'left'"]
  ; 第1階層のボタンを押した場合、selectedActionIdに格納する。selectedCharacterIdは空にして改めて第2階層までボタンを表示する
  [eval exp="f.selectedActionId = f.targetButtonId"]
  [eval exp="f.selectedCharacterId = ''"]
[endif]
[return]
