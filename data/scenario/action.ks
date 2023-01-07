*start

*firstLayer
[call target="*displayFirstLayerButtons"]
[s]

*targetLayer
; 第２階層を表示するときにも第１階層を表示する。別の第一階層ボタンも押せるように。
[call target="*displayFirstLayerButtons"]
[call target="*displaySecondLayerButtons"]
[s]

*roleLayer
; 第２階層を表示するときにも第１階層を表示する。別の第一階層ボタンも押せるように。
[call target="*displayFirstLayerButtons"]
[call target="*displayRoleLayerButtons"]
[s]

*end

[awakegame]
[return]




*displayFirstLayerButtons
[iscript]

; 「疑う」「信じる」「聞き出す」は基本セットとしておく
f.firstLayerButtons = [
  {id: "suspect", text: "疑う", target: "*targetLayer"},
  {id: "trust", text: "信じる", target: "*targetLayer"},
  {id: "ask", text: "聞き出す", target: "*targetLayer"}
];

; TODO テストのため必ず表示 潜伏役職が残っているなら「COを促す」を表示
if (false) {
  f.firstLayerButtons.push({id: "prompt", text: "COを促す", target: "*roleLayer"});
}

; TODO テストのため必ず表示 プレイヤーがCO可能な場合「COする」を表示
if (false) {
  f.firstLayerButtons.push({id: "CO", text: "COする", target: "*roleLayer"});
}

; TODO テストのため必ず表示 「キャンセル」を表示
f.firstLayerButtons.push({id: "cancel", text: "キャンセル", target: "*end"});

[endscript]

; ボタンのy軸を計算しつつ選択肢ボタン表示ループ
[eval exp="tf.buttonCount = f.firstLayerButtons.length"]
[eval exp="tf.cnt = 0"]
*firstLayerLoopStart
  ; y座標計算。範囲を(ボタン数+1)等分し、上限点と下限点を除く点に順番に配置することで、常に間隔が均等になる。式 = (範囲下限 * (tf.cnt + 1)) / (tf.buttonCount + 1) + (範囲上限)
  [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (tf.cnt + 1)) / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER"]

  [glink color="btn_voivo" size="26" width="300" x="300" y="&tf.y" text="&f.firstLayerButtons[tf.cnt].text" target="&f.firstLayerButtons[tf.cnt].target"]
  
  [jump target="*firstLayerLoopEnd" cond="tf.cnt == (tf.buttonCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*firstLayerLoopStart"]
*firstLayerLoopEnd

; 第一階層用背景を出力
; top要素は、一番上のボタンから-20px分の余白をとった位置とする
[eval exp="tf.top = BUTTON_RANGE_Y_LOWER / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER - 20"]
[html left="282" top="&tf.top" name="left_button_window"]
[endhtml]

[iscript]
; TODO height要素の計算方法を再考する。ボタン数によって余白がまちまちになる。heightはtopからの相対距離なのを意識すること。
tf.height = (tf.y + 10) + 'px';
$('.left_button_window').css({
  'width': '340px',
  'height': tf.height,
})
[endscript]

[return]


*displaySecondLayerButtons
[iscript]
f.secondLayerButtons = [
  {id: "hiyori", text: "ずんだもん", target: "*end"},
  {id: "futaba", text: "フタバ", target: "*end"},
  {id: "miki", text: "あいうえおか", target: "*end"},
  {id: "futaba", text: "あいうえおかきくけこ", target: "*end"},
  {id: "futaba", text: "ナースロボ_タイプT", target: "*end"},
  {id: "futaba", text: "フタバ", target: "*end"},
];
[endscript]
[call target="*secondLayerLoop"]
[return]



*displayRoleLayerButtons
[iscript]
f.secondLayerButtons = [
  {id: "fortuneTeller", text: "占い師", target: "*end"},
  {id: "hoge", text: "霊能者", target: "*end"},
]
[endscript]
[call target="*secondLayerLoop"]
[return]


*secondLayerLoop

; ボタンのy軸を計算しつつ選択肢ボタン表示ループ
[eval exp="tf.buttonCount = f.secondLayerButtons.length"]
[eval exp="tf.cnt = 0"]
*secondLayerLoopStart
  ; y座標計算。範囲を(ボタン数+1)等分し、上限点と下限点を除く点に順番に配置することで、常に間隔が均等になる。式 = (範囲下限 * (tf.cnt + 1)) / (tf.buttonCount + 1) + (範囲上限)
  [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (tf.cnt + 1)) / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER"]

  [glink color="btn_voivo" size="26" width="300" x="670" y="&tf.y" text="&f.secondLayerButtons[tf.cnt].text" target="&f.secondLayerButtons[tf.cnt].target"]

  [jump target="*secondLayerLoopEnd" cond="tf.cnt == (tf.buttonCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*secondLayerLoopStart"]
*secondLayerLoopEnd

; 第一階層用背景を出力
; top要素は、一番上のボタンから-20px分の余白をとった位置とする
[eval exp="tf.top = BUTTON_RANGE_Y_LOWER / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER - 20"]
[html left="650" top="&tf.top" name="right_button_window"]
[endhtml]

[iscript]
; TODO height要素の計算方法を再考する。ボタン数によって余白がまちまちになる。heightはtopからの相対距離なのを意識すること。
tf.height =  (tf.y + 10) + 'px';
$('.right_button_window').css({
  'width': '340px',
  'height': tf.height,
})
[endscript]

[return]
