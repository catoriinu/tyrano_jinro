; TODO ボタン数が6以上になる場合、6列目は左右ボタンにしてページめくりできるようにしたい

; f.buttonObjectsに入っている要素をボタン化し、押したボタンのIDをf.selectedButtonIdに格納するサブルーチン
; 事前準備
; f.buttonObjects = [{id:ボタンのID, text:ボタンに表示するテキスト, side:ボタンを表示する位置（未使用）, addClasses:[ボタンに追加したいクラス名配列,...]},...]（必須。サブルーチン内で初期化するので毎回指定すること）
; tf.doSlideInCharacter = trueならキャラ画像がスライドインしてくる（必ずf.buttonObjects.idがキャラクターIDであること）
; （省略した場合false。サブルーチン内で初期化するので必要なら毎回指定すること）
; tf.noNeedStop = true（boolean型。2階層分表示したいときの第1階層でtrueにすること。省略した場合サブルーチン内の[s]タグで止まる。サブルーチン内で初期化するので必要なら毎回指定すること）
; MEMO:ボタンの表示・消去は呼び元で行うこと。サブルーチン内で行うと、2階層分表示したいときにちらつくため。
*glinkFromButtonObjects
[iscript]
  // キャラ画像のスライドインを行うか
  tf.doSlideInCharacter = ('doSlideInCharacter' in tf) ? tf.doSlideInCharacter : false;
  // 選択肢ボタン表示ループ
  tf.buttonCount = f.buttonObjects.length;
  // 背景を表示するサイドは、1つ目のボタンのsideを基準にする
  tf.side = f.buttonObjects[0].side;
  // ボタンの背景の高さ
  tf.top = BUTTON_RANGE_Y_LOWER / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER - BUTTON_MARGIN_HEIGHT;

  // ボタンを表示するサイドによって、背景とボタンを表示する位置およびそれぞれのクラス名を入れ分ける
  if (tf.side === 'left') {
    tf.x = 285;
    tf.left = 260;
    tf.class = 'left_button_window';
  } else if (tf.side === 'right') {
    tf.x = 665;
    tf.left = 640;
    tf.class = 'right_button_window';
  } else {
    tf.side = 'center';
    tf.x = 488;
    tf.left = 463.813;
    tf.class = 'center_button_window'
  }

  // ループ用カウンター
  tf.cnt = 0;
[endscript]

; ボタンの背景を表示（まずは位置だけ）
[html top="&tf.top" left="&tf.left" name="&tf.class"]
[endhtml]

*loopstart
  [iscript]
    // ボタンの背景を表示（ボタンが出揃う前に高さを決める）
    // height = 下から2番目のボタンのy座標 + 40（1つ分のボタンの高さ）+ (マージン*2)（上下に取りたい余白）
    tf.height = (BUTTON_RANGE_Y_LOWER * (tf.buttonCount - 1) / (tf.buttonCount + 1)) + 40 + (BUTTON_MARGIN_HEIGHT * 2) + 'px';
    $('.' + tf.class).css('height', tf.height);

    // y座標計算。範囲を(ボタン数+1)等分し、上限点と下限点を除く点に順番に配置することで、常に間隔が均等になる。式 = (範囲下限 * (tf.cnt + 1)) / (tf.buttonCount + 1) + (範囲上限)
    tf.y = (BUTTON_RANGE_Y_LOWER * (tf.cnt + 1)) / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER;

    // glinkのname（＝ボタンのclass要素）に設定するクラス名を文字列結合する
    tf.buttonObj = f.buttonObjects[tf.cnt];
    tf.glink_name = 
      'buttonhover,' + // ボタンにカーソルが乗ったときの処理を設定する用
      'selected_side_' + tf.buttonObj.side + '_buttonid_' + tf.buttonObj.id + // ホバーしたボタンの判定用
      tf.buttonObj.additionalClassName; // ボタンに追加したいクラスがあれば追加する（例：選択中）
  [endscript]

  ; ボタンを生成する
  ; 最終的に押下したボタンを判定するために、ボタン情報をpreexpに格納しておく
  ; 補足：ティラノスクリプトv521fにて、preexpの評価タイミングがボタン押下時ではなくボタン生成時に修正された
  ; 　　　そのおかげで、ホバーしたボタンのクラスからボタン情報を取得していた場合に存在した「ボタン表示時にカーソルが初めからボタンの位置にあると、hoverイベントが発生しないのでクラス名を取得できない」バグが解消された
  [glink color="&tf.buttonObj.color" size="26" width="300" x="&tf.x" y="&tf.y" name="&tf.glink_name" text="&tf.buttonObj.text" preexp="[tf.buttonObj.side, tf.buttonObj.id]" exp="[f.selectedSide, f.selectedButtonId] = preexp" target="*glinkFromButtonObjects_end" clickse="&tf.buttonObj.clickse" enterse="&tf.buttonObj.enterse"]

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
        changeCharacter(f.selectedButtonId, '通常');
      }
    },
    function(e) {
      if (tf.doSlideInCharacter) {
        exitCharacter(f.displayedCharacter.right.characterId);
      }
    }
  );
[endscript]

; tf.noNeedStopに明示的にtrueを渡されない限り、通常通りにボタンを表示したところで止まる
[s cond="tf.noNeedStop !== true"]

*glinkFromButtonObjects_end
[iscript]
  console.debug('button clicked side=' + f.selectedSide + ' id=' + f.selectedButtonId);

  // ボタン用変数の初期化
  f.buttonObjects = []
  tf.side = ''
  tf.noNeedStop = false
  tf.doSlideInCharacter = false
[endscript]
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

    // 役職を公開してよいかフラグを取得
    const shouldOpenRoleInfo = isShouldOpenRoleInfo(f.characterObjects, tf.characterId, f.winnerFaction, f.commonPerspective);
    // キャラ情報コンテナ取得。中身の情報はメソッド内で格納済み
    const $infoContainer = createInfoContainer(f.characterObjects, tf.characterId, tf.boxWidth, shouldOpenRoleInfo);
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


*COPhasePlayer

; PCがCOしたいかを確認する必要があるか。必要がなければジャンプ
[j_setIsNeedToAskPCWantToCO]
[jump target="*COPhasePlayer_end" cond="!tf.isNeedToAskPCWantToCO"]

  ; プレイヤーに確認をとる場合
  ; プレイヤーキャラクターを表示する
  [m_changeCharacter characterId="&f.playerCharacterId" face="通常" side="left"]

  ; プレイヤーのCO役職IDを格納しておく。未COなら空文字
  [eval exp="f.playerCORoleId = f.characterObjects[f.playerCharacterId].CORoleId"]
  ; 役職結果COをする役職ID格納用変数を初期化しておく
  [eval exp="f.resultCORoleId = ''"]

  ; プレイヤーのCO役職が占い師の場合（真・騙り共用）
  ; 結果COボタンを表示、騙りなら結果騙りも行う
  [call storage="./fortuneTellingForPC.ks" target="*startAskResultCO" cond="f.playerCORoleId === ROLE_ID_FORTUNE_TELLER"]

  ; プレイヤーが役職未COの場合
  ; 役職COボタンを表示、役職COするなら前日までの結果COも行う、視点オブジェクトを更新
  [call storage="./askCORole.ks" target="*startAskCORole" cond="f.playerCORoleId === ''"]

  ; 占い師の役職結果CO（（メッセージは当日分のみ表示）「役職COしない」「結果COしない」を選んだときはCOしない）
  [j_COFortuneTelling fortuneTellerId="&f.playerCharacterId" cond="f.resultCORoleId === ROLE_ID_FORTUNE_TELLER"]
  ; NOTE:役職が増えたときはここにcondでマクロを増やしていく

*COPhasePlayer_end
[return]
