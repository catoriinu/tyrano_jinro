; tf.candidateObjectsに入っているキャラクター名をボタン化し、押したcharacterIdをtf.targetCharacterIdに格納するサブルーチン
*glinkFromCandidateObjects

; 選択肢ボタン表示ループ
[eval exp="tf.buttonCount = tf.candidateObjects.length"]

; ボタンの背景を表示（まずは位置だけ）
[eval exp="tf.top = BUTTON_RANGE_Y_LOWER / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER - BUTTON_MARGIN_HEIGHT"]
[html top="&tf.top" left="463.813" name="center_button_window"]
[endhtml]

[eval exp="tf.cnt = 0"]
*loopstart
  ; y座標計算。範囲を(ボタン数+1)等分し、上限点と下限点を除く点に順番に配置することで、常に間隔が均等になる。式 = (範囲下限 * (tf.cnt + 1)) / (tf.buttonCount + 1) + (範囲上限)
  [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (tf.cnt + 1)) / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER"]
  [eval exp="tf.glink_name = 'glink_center,charahover,' + 'chara_' + tf.candidateObjects[tf.cnt].characterId"]
  [eval exp="console.log(tf.y)"]
  [glink color="btn_voivo" size="26" width="300" x="488" y="&tf.y" name="&tf.glink_name" text="&f.speaker[tf.candidateObjects[tf.cnt].name]" target="*glinkFromCandidateObjects_end"]
  
  [jump target="*loopend" cond="tf.cnt == (tf.buttonCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*loopstart"]
*loopend

[iscript]
  ; ボタンにカーソルが乗ったときにキャラ画像をスライドイン、離れたときに画面外へ移動。
  $(".charahover").hover(
    function(e) {
      ; ホバーしたボタンのclass属性の中から、ボタン生成時に付与しておいたcharacterId部分を抽出する
      const classList = $(this).attr("class").split(" ");
      const enterCharacterId = classList.find(className => className.match(/^chara_(.*)$/)).match(/^chara_(.*)$/)[1];

      ; 最後にホバーしていたキャラ=ボタンを押下したキャラになるため、ここで選択したキャラクターIDを格納しておく
      tf.targetCharacterId = enterCharacterId;

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

*glinkFromCandidateObjects_end
; 選択した（＝最後のボタンホバー時に表示していた）キャラクターを退場させる
; TODO TypeError: Cannot read property 'side' of undefinedになる。rightSideCharacterIdがnullと思われる。
; ボタン押下直後にhoverが外れたときのルートに入り、exitCharacter()済みになっているのかも。だとするとなぜ退場していないのかが気になるが……。
; [m_exitCharacter characterId="tf.targetCharacterId"]

[return]
