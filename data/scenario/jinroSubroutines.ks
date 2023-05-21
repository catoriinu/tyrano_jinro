; TODO ボタン数が6以上になる場合、6列目は左右ボタンにしてページめくりできるようにしたい

; f.buttonObjectsに入っている要素をボタン化し、押したボタンのIDをf.selectedButtonIdに格納するサブルーチン
; 事前準備
; f.buttonObjects = [{id:ボタンのID, text:ボタンに表示するテキスト, side:ボタンを表示する位置（未使用）, addClasses:[ボタンに追加したいクラス名配列,...]},...]（必須。サブルーチン内で初期化するので毎回指定すること）
; tf.doSlideInCharacter = trueならキャラ画像がスライドインしてくる（必ずf.buttonObjects.idがキャラクターIDであること）
; （省略した場合false。サブルーチン内で初期化するので必要なら毎回指定すること）
; tf.noNeedStop = true（boolean型。2階層分表示したいときの第1階層でtrueにすること。省略した場合サブルーチン内の[s]タグで止まる。サブルーチン内で初期化するので必要なら毎回指定すること）
; MEMO:ボタンの表示・消去は呼び元で行うこと。サブルーチン内で行うと、2階層分表示したいときにちらつくため。
*glinkFromButtonObjects

; キャラ画像のスライドインを行うか
[eval exp="tf.doSlideInCharacter = ('doSlideInCharacter' in tf) ? tf.doSlideInCharacter : false"]

; 選択肢ボタン表示ループ
[eval exp="tf.buttonCount = f.buttonObjects.length"]
; 背景を表示するサイドは、1つ目のボタンのsideを基準にする
[eval exp="tf.side = f.buttonObjects[0].side"]

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
  [iscript] 
    // glinkのname（＝ボタンのclass要素）に設定するクラス名を格納する
    tf.glink_name = [
      'buttonhover', // ボタンにカーソルが乗ったときの処理を設定する用
      'selected_side_' + f.buttonObjects[tf.cnt].side + '_buttonid_' + f.buttonObjects[tf.cnt].id // ホバーしたボタンの判定用
    ].concat(
      f.buttonObjects[tf.cnt].addClasses // ボタンに追加したいクラスがあれば追加する（例：選択中）
    ).join(); // ここまで配列に格納した各要素をカンマ区切りの文字列として結合する
  [endscript]
  ; ボタンを生成する
  ; 最終的に押下したボタンを判定するために、ボタン情報をpreexpに格納しておく
  ; 補足：ティラノスクリプトv521fにて、preexpの評価タイミングがボタン押下時ではなくボタン生成時に修正された
  ; 　　　そのおかげで、ホバーしたボタンのクラスからボタン情報を取得していた場合に存在した「ボタン表示時にカーソルが初めからボタンの位置にあると、hoverイベントが発生しないのでクラス名を取得できない」バグが解消された
  [glink color="&f.buttonObjects[tf.cnt].color" size="26" width="300" x="&tf.x" y="&tf.y" name="&tf.glink_name" text="&f.buttonObjects[tf.cnt].text" preexp="[f.buttonObjects[tf.cnt].side, f.buttonObjects[tf.cnt].id]" exp="[f.selectedSide, f.selectedButtonId] = preexp" target="*glinkFromButtonObjects_end"]

  ; TODO なぜか勢い余ってtf.cntが終了条件以上に超えてしまうことがあるので、>=での判定にしている。それでもたまに1週多くループするバグが起きるので修正する。
  [jump target="*loopend" cond="tf.cnt >= (tf.buttonCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*loopstart"]
*loopend

[iscript]
  // ボタンにカーソルが乗ったときの処理
  $(".buttonhover").hover(
    function(e) {
      // ホバーしたボタンのclass属性の中から、ボタン生成時に付与しておいたId部分を抽出する
      const classList = $(this).attr("class").split(" ");

      // どのサイドのボタンかと、押下したボタンのIDを格納しておく。ver.0.7（ティラノスクリプトv521f）以降では、ホバー時に登場させるキャラの判定のみに使っている
      const classNameReg = new RegExp('^selected_side_(.*)_buttonid_(.*)$');
      const regResult = classList.find(className => className.match(classNameReg)).match(classNameReg);
      f.selectedSide = regResult[1];
      f.selectedButtonId = regResult[2];
      
      if (tf.doSlideInCharacter) {
        // 表示中のキャラを画面外に出してから、ホバーされたキャラを登場させる
        changeCharacter(f.selectedButtonId, 'normal');
      }

      // glinkのenterse属性だと細かい設定ができないため独自に設定（特にbufがデフォルトだと他で鳴っている効果音を打ち消してしまう）
      TYRANO.kag.ftag.startTag("playse",{storage:"botan_b34.ogg",volume:40,buf:1});
    },
    function(e) {
      if (tf.doSlideInCharacter) {
        exitCharacter(f.displayedCharacter.right.characterId);
      }
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

*glinkFromButtonObjects_end
[eval exp="console.log('button clicked side=' + f.selectedSide + ' id=' + f.selectedButtonId)"]

; ボタン用変数の初期化
[eval exp="f.buttonObjects = []"]
[eval exp="tf.side = ''"]
[eval exp="tf.noNeedStop = false"]
[eval exp="tf.doSlideInCharacter = false"]
[return]



; 横並びでキャラクター画像を表示するサブルーチン
; 事前にf.dchオブジェクトに必要な情報を格納しておくこと
*displayCharactersHorizontally
; キャラクターを表示するレイヤーを可視化する
[layopt layer="1" page="fore" visible="true"]
[iscript]
  // レイヤーに、FlexboxのCSSが適用されるdiv要素を追加する
  $('.1_fore').append('<div class="dch_container">');
  // 表示するキャラクター数
  tf.characterCount = f.dch.characterList.length;
  // Flexboxの中のbox（＝1キャラクターごとの領域）の幅。1280は画面全体の幅
  tf.boxWidth = 1280 / tf.characterCount;
  // boxの半分の幅。計算で頻出するので先に取得しておく
  tf.halfOfBoxWidth = tf.boxWidth / 2;
  // ループカウントおよび配列のキーとして使う変数
  tf.cnt = 0;
[endscript]

*displayCharactersHorizontally_loopstart

  [iscript]
    // 扱いやすいようにf.dchから一時変数に取得
    tf.characterId = f.dch.characterList[tf.cnt].characterId;
    tf.bgColor = f.dch.characterList[tf.cnt].bgColor;

    // 余白(px)
    tf.mergin = 3;
    // boxの左側からの表示開始位置（に余白分を足した値）
    // ティラノの変数にNumber型の0を入れて初期化しようとしても、キーを定義できずundefinedになる。そのため必ず余白分の値を入れること
    tf.boxLeft = (tf.boxWidth * tf.cnt) + tf.mergin;
    // キャラクター画像の左側からの表示位置。そのキャラのwidthCenterの位置がboxの中央に来るようにした後、f.dch.displacedPxToRightの分だけ右へずらす
    tf.imageLeft = (tf.boxWidth * (tf.cnt + 1)) - tf.halfOfBoxWidth - f.defaultPosition[tf.characterId].widthCenter + f.dch.displacedPxToRight;
    // キャラクター画像の上側からの表示位置。通常の立ち絵表示時の高さよりもf.dch.displacedPxToTopの分だけ下にずらして表示する（※基本的にはf.dch.displacedPxToTopには負の数を入れ、上にずらすほうが見栄えが良い）
    tf.imageTop = f.defaultPosition[tf.characterId].top + f.dch.displacedPxToTop;
    // キャラクター画像のクラス名。のちほどキャラ画像のimg要素をbox内に移動させるためのセレクタになる。
    tf.imageName = 'dch_' + tf.characterId + '_' + tf.cnt;
    // キャラクター画像の格納パス
    tf.storage = 'chara/' + tf.characterId + '/' + f.dch.characterList[tf.cnt].fileName;
  [endscript]

  ; キャラクター画像、横テキスト、上テキストを表示
  [image storage="&tf.storage" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" left="&tf.imageLeft" top="&tf.imageTop" name="&tf.imageName" layer="1"]
  [ptext layer="1" text="&f.dch.characterList[tf.cnt].leftText" x="&tf.boxLeft" y="&tf.mergin" vertical="true" face="にくまるフォント" color="0x28332a" size="38" edge="2px 0xFFFFFF"]
  [ptext layer="1" text="&f.dch.characterList[tf.cnt].topText" x="&tf.boxLeft" y="&tf.mergin" width="&tf.boxWidth" align="center" face="にくまるフォント" color="0x28332a" size="38" edge="2px 0xFFFFFF"]

  [iscript]
    // キャラ1人分のdiv要素の中のクラス名を作成する
    let classNum = 'dch_' + tf.cnt;
    // キャラ画像のimg要素を、boxと同じ幅になるよう左右をクリッピングするために必要なpx数を計算する
    let clipPx = {
      fromLeft: f.defaultPosition[tf.characterId].widthCenter - tf.halfOfBoxWidth - f.dch.displacedPxToRight,
      fromRight: f.defaultPosition[tf.characterId].width - f.defaultPosition[tf.characterId].widthCenter - tf.halfOfBoxWidth + f.dch.displacedPxToRight
    }

    // キャラを並べるためおよびこれ以下の処理を行うために、Flexboxである.dch_containerに1キャラ分のdiv要素を追加する
    $('.dch_container').append('<div class="dch_box ' + classNum + '">');
    // 1box分の幅を設定する
    $('.dch_box').css('width', tf.boxWidth + 'px');
    // boxに背景色をつける
    // 現在のCSSは、画面の上部が背景色で、下部に行くに従って黒にグラデーションするというもの。別の演出にしたい場合は書き換えるなり格納しわけるなりすること
    let boxCss = {
      "background-image": "linear-gradient(to bottom, " + tf.bgColor + " 10%, rgba(0, 0, 0, 1) 150%"
    }
    $('.' + classNum).css(boxCss);
    // .dch_containerの子要素の.classNumの子要素に、キャラ画像のimg要素を移動する
    $('.' + tf.imageName).appendTo('.' + classNum);
    // キャラ画像のimg要素を、boxと同じ幅になるよう左右をクリッピングする
    $('.' + tf.imageName).css('clip-path', 'inset(0px ' + clipPx.fromRight + 'px 0px ' + clipPx.fromLeft + 'px)');
  [endscript]

  [jump target="*displayCharactersHorizontally_loopend" cond="tf.cnt == (tf.characterCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*displayCharactersHorizontally_loopstart"]
*displayCharactersHorizontally_loopend

/*
MEMO 最終的には以下の構成のHTMLが生成される。
<div class="dch_container">
  <div class="dch_box dch_0" style="width: 256px; background-image: linear-gradient(rgb(103, 239, 101) 10%, rgb(0, 0, 0) 160%);">
    <img src="./data/fgimage/chara/zundamon/normal.png" class="dch_zundamon_0" style="position: absolute; top: 35px; left: -110px; width: 550px; z-index: 1; clip-path: inset(0px 184px 0px 110px);">
  </div>
  （以下キャラクター数分のboxが続く）
</div>
*/
[return]



; 横並びでキャラクター画像を表示するサブルーチン
; 事前にf.dchオブジェクトに必要な情報を格納しておくこと
*displayCharactersHorizontallyForStatus
; キャラクターを表示するレイヤーを可視化する
;[layopt layer="1" page="fore" visible="true"]
[iscript]
  // レイヤーに、FlexboxのCSSが適用されるdiv要素を追加する
  //$('.1_fore').append('<div class="dch_container">');
  // 表示するキャラクター数
  tf.characterCount = f.dch.characterList.length;
  // Flexboxの中のbox（＝1キャラクターごとの領域）の幅。1280は画面全体の幅
  tf.boxWidth = 1280 / tf.characterCount;
  // boxの半分の幅。計算で頻出するので先に取得しておく
  tf.halfOfBoxWidth = tf.boxWidth / 2;
  // ループカウントおよび配列のキーとして使う変数
  tf.cnt = 0;
[endscript]

*displayCharactersHorizontallyForStatus_loopstart

  [iscript]
    // 扱いやすいようにf.dchから一時変数に取得
    tf.characterId = f.dch.characterList[tf.cnt].characterId;
    tf.bgColor = f.dch.characterList[tf.cnt].bgColor;

    // 余白(px)
    tf.mergin = 100;
    // boxの左側からの表示開始位置（に余白分を足した値）
    // ティラノの変数にNumber型の0を入れて初期化しようとしても、キーを定義できずundefinedになる。そのため必ず余白分の値を入れること
    tf.boxLeft = (tf.boxWidth * tf.cnt) + 3;
    // キャラクター画像の左側からの表示位置。そのキャラのwidthCenterの位置がboxの中央に来るようにした後、f.dch.displacedPxToRightの分だけ右へずらす
    //tf.imageLeft = (tf.boxWidth * (tf.cnt + 1)) - tf.halfOfBoxWidth - f.defaultPosition[tf.characterId].widthCenter + f.dch.displacedPxToRight;
    // MEMO $characterImgのpositionを、absoluteからrelativeに変更したことで、(tf.cnt + 1))が不要になった
    tf.imageLeft = tf.boxWidth - tf.halfOfBoxWidth - f.defaultPosition[tf.characterId].widthCenter + f.dch.displacedPxToRight;
    // キャラクター画像の上側からの表示位置。通常の立ち絵表示時の高さよりもf.dch.displacedPxToTopの分だけ下にずらして表示する（※基本的にはf.dch.displacedPxToTopには負の数を入れ、上にずらすほうが見栄えが良い）
    tf.imageTop = f.defaultPosition[tf.characterId].top + f.dch.displacedPxToTop;
    // キャラクター画像のクラス名。のちほどキャラ画像のimg要素をbox内に移動させるためのセレクタになる。
    tf.imageName = 'dch_' + tf.characterId + '_' + tf.cnt;
    // キャラクター画像の格納パス
    tf.storage = 'chara/' + tf.characterId + '/' + f.dch.characterList[tf.cnt].fileName;
  [endscript]

  ; TODO ここがなくなったので、サブルーチン内を完全にjs化することが可能
  ; キャラクター画像、横テキスト、上テキストを表示
  ;[image storage="&tf.storage" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" left="&tf.imageLeft" top="&tf.imageTop" name="&tf.imageName" layer="1"]
  ;[ptext layer="1" text="&f.dch.characterList[tf.cnt].leftText" x="&tf.boxLeft" y="&tf.mergin" vertical="true" face="にくまるフォント" color="0x28332a" size="38" edge="2px 0xFFFFFF"]
  ;[ptext layer="1" text="&f.dch.characterList[tf.cnt].topText" x="&tf.boxLeft" y="&tf.mergin" width="&tf.boxWidth" align="center" face="にくまるフォント" color="0x28332a" size="38" edge="2px 0xFFFFFF"]

  [iscript]
    // キャラ1人分のdiv要素の中のクラス名を作成する
    let classNum = 'dch_' + tf.cnt;

    // キャラを並べるためおよびこれ以下の処理を行うために、Flexboxである.dchStatusContainerに1キャラ分のdiv要素を追加する
    const $statusBox = $('<div>').attr({
      'class': 'statusBox ' + classNum
    }).css({
      'width': tf.boxWidth + 'px', // 1box分の幅を設定する
      'background-image': 'linear-gradient(to bottom, ' + tf.bgColor + ' 5%, rgba(0, 0, 0, 1) 130%', // boxに背景色をつける。現在のCSSは、画面の上部が背景色で、下部に行くに従って黒にグラデーションするというもの。
    });

    const $statusBoxVerticalText = $('<p>').attr({
      'class': 'statusBoxVerticalText ' + classNum + 'VerticalText'
    }).css({
       // tyrano/libs.jsの縁取り用メソッドを借用する（[ptext edge="2px 0xFFFFFF"]で使っているメソッドと同じ。渡す引数の指定方法も同じ）
      'text-shadow': $.generateTextShadowStrokeCSS('2px #FFFFFF'),
    }).text(
      f.dch.characterList[tf.cnt].leftText
    );
    // 文字をboxの子要素として追加する
    $statusBoxVerticalText.appendTo($statusBox);

    // キャラ画像のimg要素を、boxと同じ幅になるよう左右をクリッピングするために必要なpx数を計算する
    let clipPx = {
      fromLeft: f.defaultPosition[tf.characterId].widthCenter - tf.halfOfBoxWidth - f.dch.displacedPxToRight,
      fromRight: f.defaultPosition[tf.characterId].width - f.defaultPosition[tf.characterId].widthCenter - tf.halfOfBoxWidth + f.dch.displacedPxToRight
    }
    // キャラ画像表示
    const $characterImg = $('<img>').attr({
      'src': './data/fgimage/chara/' + tf.characterId + '/' + f.dch.characterList[tf.cnt].fileName,
      'class': 'statusBoxCharaImg ' + tf.imageName
    }).css({
      'top': tf.imageTop,
      'left': tf.imageLeft,
      'width': f.defaultPosition[tf.characterId].width,
      'clip-path': 'inset(0px ' + clipPx.fromRight + 'px 0px ' + clipPx.fromLeft + 'px)'
    });
    // キャラ画像のimg要素をboxの子要素として追加する
    $characterImg.appendTo($statusBox);

    // キャラ情報コンテナ取得。中身の情報はメソッド内で格納済み
    const $infoContainer = createInfoContainer(f.characterObjects, tf.characterId, tf.boxWidth);
    $infoContainer.appendTo($statusBox);

    // 1キャラ分のboxを.dchStatusContainerの子要素として追加する
    $statusBox.appendTo('.dchStatusContainer');
  [endscript]

  [jump target="*displayCharactersHorizontallyForStatus_loopend" cond="tf.cnt == (tf.characterCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*displayCharactersHorizontallyForStatus_loopstart"]
*displayCharactersHorizontallyForStatus_loopend

/*
MEMO 最終的には以下の構成のHTMLが生成される。
<div class="dch_container">
  <div class="dch_box dch_0" style="width: 256px; background-image: linear-gradient(rgb(103, 239, 101) 10%, rgb(0, 0, 0) 160%);">
    <img src="./data/fgimage/chara/zundamon/normal.png" class="dch_zundamon_0" style="position: absolute; top: 35px; left: -110px; width: 550px; z-index: 1; clip-path: inset(0px 184px 0px 110px);">
  </div>
  （以下キャラクター数分のboxが続く）
</div>
*/
[return]
