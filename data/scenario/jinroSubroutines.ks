; tf.candidateCharacterObjectsに入っているキャラクター名をボタン化し、押したcharacterIdをf.targetCharacterIdに格納するサブルーチン
*glinkFromCandidateCharacterObjects

; 選択肢ボタン表示ループ
[eval exp="tf.buttonCount = tf.candidateCharacterObjects.length"]

; ボタンの背景を表示（まずは位置だけ）
[eval exp="tf.top = BUTTON_RANGE_Y_LOWER / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER - BUTTON_MARGIN_HEIGHT"]
[html top="&tf.top" left="463.813" name="center_button_window"]
[endhtml]

[eval exp="tf.cnt = 0"]
*character_loopstart
  ; y座標計算。範囲を(ボタン数+1)等分し、上限点と下限点を除く点に順番に配置することで、常に間隔が均等になる。式 = (範囲下限 * (tf.cnt + 1)) / (tf.buttonCount + 1) + (範囲上限)
  [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (tf.cnt + 1)) / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER"]
  [eval exp="tf.glink_name = 'charahover,' + 'chara_' + tf.candidateCharacterObjects[tf.cnt].characterId"]
  [glink color="btn_voivo" size="26" width="300" x="488" y="&tf.y" name="&tf.glink_name" text="&f.speaker[tf.candidateCharacterObjects[tf.cnt].name]" target="*glinkFromCandidateCharacterObjects_end"]
  
  [jump target="*character_loopend" cond="tf.cnt == (tf.buttonCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*character_loopstart"]
*character_loopend

[iscript]
  ; ボタンにカーソルが乗ったときにキャラ画像をスライドイン、離れたときに画面外へ移動。
  $(".charahover").hover(
    function(e) {
      ; ホバーしたボタンのclass属性の中から、ボタン生成時に付与しておいたcharacterId部分を抽出する
      const classList = $(this).attr("class").split(" ");
      const enterCharacterId = classList.find(className => className.match(/^chara_(.*)$/)).match(/^chara_(.*)$/)[1];

      ; 最後にホバーしていたキャラ=ボタンを押下したキャラになるため、ここで選択したキャラクターIDを格納しておく
      f.targetCharacterId = enterCharacterId;

      ; 表示中のキャラを画面外に出してから、ホバーされたキャラを登場させる
      changeCharacter(enterCharacterId, 'normal', f.defaultPosition[enterCharacterId].side);
      
      ; glinkのenterse属性だと細かい設定ができないため独自に設定（特にbufがデフォルトだと他で鳴っている効果音を打ち消してしまう）
      TYRANO.kag.ftag.startTag("playse",{storage:"botan_b34.ogg",volume:60,buf:1});
    },
    function(e) {
      if (typeof f.rightSideCharacterId != 'undefined') {
        exitCharacter(
          f.rightSideCharacterId,
          f.defaultPosition[f.rightSideCharacterId].side,
          f.defaultPosition[f.rightSideCharacterId].left
        );
      }
    }
  );

; ボタンの背景を表示（ボタンが出揃ってから高さを決める）
; height = 下から2番目のボタンのy座標 + 40（1つ分のボタンの高さ）+ (マージン*2)（上下に取りたい余白）
tf.height = (BUTTON_RANGE_Y_LOWER * tf.cnt / (tf.buttonCount + 1)) + 40 + (BUTTON_MARGIN_HEIGHT * 2) + 'px';
$('.center_button_window').css('height', tf.height);
[endscript]
[s]

*glinkFromCandidateCharacterObjects_end
; 選択した（＝最後のボタンホバー時に表示していた）キャラクターを退場させる
; TODO TypeError: Cannot read property 'side' of undefinedになる。rightSideCharacterIdがnullと思われる。
; ボタン押下直後にhoverが外れたときのルートに入り、exitCharacter()済みになっているのかも。だとするとなぜ退場していないのかが気になるが……。
; MEMO:tfを参照していたせいで、サブルーチンから戻ると消えてしまっていたのかもしれない。
; [m_exitCharacter characterId="tf.targetCharacterId"]

[return]


; TODO ボタン数が6以上になる場合、6列目は左右ボタンにしてページめくりできるようにしたい
; TODO 第2階層のボタン表示時、選択済みの第1階層のボタンを目立たせたい（glinkのボタン自体か文字色を変える）


; tf.candidateObjectsに入っている要素をボタン化し、押したボタンのIDをtf.targetButtonIdに格納するサブルーチン
; 事前準備
; tf.candidateObjects = [{id:ボタンのID, text:ボタンに表示するテキスト},...]
; tf.side = 'left','right'のいずれか（省略した場合center。サブルーチン内で初期化するので毎回指定すること）
; tf.noNeedStop = true（boolean型。省略した場合サブルーチン内の[s]タグで止まる。サブルーチン内で初期化するので毎回指定すること）
*glinkFromCandidateObjects

; 選択肢ボタン表示ループ
[eval exp="tf.buttonCount = tf.candidateObjects.length"]

; ボタンの背景を表示（まずは位置だけ）
[eval exp="tf.top = BUTTON_RANGE_Y_LOWER / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER - BUTTON_MARGIN_HEIGHT"]

; ボタンを表示するサイドによって、背景とボタンを表示する位置およびそれぞれのクラス名を入れ分ける
[if exp="tf.side == 'left'"]
  [eval exp="tf.class = 'left_button_window'"]
  [html top="&tf.top" left="260" name="&tf.class"]
  [eval exp="tf.x = 285"]
[elsif exp="tf.side == 'right'"]
  [eval exp="tf.class = 'right_button_window'"]
  [html top="&tf.top" left="640" name="&tf.class"]
  [eval exp="tf.x = 665"]
[else]
  [eval exp="tf.side = 'center'"]
  [eval exp="tf.class = 'center_button_window'"]
  [html top="&tf.top" left="463.813" name="&tf.class"]
  [eval exp="tf.x = 488"]
[endif]
[endhtml]

[eval exp="tf.cnt = 0"]
*loopstart
  ; y座標計算。範囲を(ボタン数+1)等分し、上限点と下限点を除く点に順番に配置することで、常に間隔が均等になる。式 = (範囲下限 * (tf.cnt + 1)) / (tf.buttonCount + 1) + (範囲上限)
  [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (tf.cnt + 1)) / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER"]
  [eval exp="tf.glink_name = 'buttonhover,' + tf.side + '_buttonclass_' + tf.candidateObjects[tf.cnt].id"]
  [glink color="btn_voivo" size="26" width="300" x="&tf.x" y="&tf.y" name="&tf.glink_name" text="&tf.candidateObjects[tf.cnt].text" target="*glinkFromCandidateObjects_end"]
  
  [jump target="*loopend" cond="tf.cnt == (tf.buttonCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*loopstart"]
*loopend

[iscript]
  ; ボタンにカーソルが乗ったときの処理
  $(".buttonhover").hover(
    function(e) {
      ; ホバーしたボタンのclass属性の中から、ボタン生成時に付与しておいたId部分を抽出する
      const classList = $(this).attr("class").split(" ");

      ; 最後にホバーしていたボタン=押下したボタンになる。どのサイドのボタンかと、押下したボタンのIDを格納しておく
      const classNameReg = new RegExp('^(.*)_buttonclass_(.*)$');
      const regResult = classList.find(className => className.match(classNameReg)).match(classNameReg);
      f.targetSide = regResult[1];
      f.targetButtonId = regResult[2];
      
      ; glinkのenterse属性だと細かい設定ができないため独自に設定（特にbufがデフォルトだと他で鳴っている効果音を打ち消してしまう）
      TYRANO.kag.ftag.startTag("playse",{storage:"botan_b34.ogg",volume:60,buf:1});
    },
    function(e) {
      ; 今のところホバーを外したときの処理は不要
    }
  );

; ボタンの背景を表示（ボタンが出揃ってから高さを決める）
; height = 下から2番目のボタンのy座標 + 40（1つ分のボタンの高さ）+ (マージン*2)（上下に取りたい余白）
tf.height = (BUTTON_RANGE_Y_LOWER * tf.cnt / (tf.buttonCount + 1)) + 40 + (BUTTON_MARGIN_HEIGHT * 2) + 'px';
$('.' + tf.class).css('height', tf.height);
[endscript]

; tf.noNeedStopに明示的にtrueを渡されない限り、通常通りにボタンを表示したところで止まる
[if exp="tf.noNeedStop !== true"]
  [s]
[endif]

*glinkFromCandidateObjects_end
[eval exp="console.log('button clicked id=' + tf.targetButtonId)"]

; 一時変数の初期化
[eval exp="tf.side = ''"]
[eval exp="tf.noNeedStop = false"]
[return]
