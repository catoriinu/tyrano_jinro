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
      f.buttonObjects[tf.cnt].side + '_buttonclass_' + f.buttonObjects[tf.cnt].id // 押下したボタンの判定用
    ].concat(
      f.buttonObjects[tf.cnt].addClasses // ボタンに追加したいクラスがあれば追加する（例：選択中）
    ).join(); // ここまで配列に格納した各要素をカンマ区切りの文字列として結合する
  [endscript]
  [glink color="&f.buttonObjects[tf.cnt].color" size="26" width="300" x="&tf.x" y="&tf.y" name="&tf.glink_name" text="&f.buttonObjects[tf.cnt].text" target="*glinkFromButtonObjects_end"]
  
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

      // 最後にホバーしていたボタン=押下したボタンになる。どのサイドのボタンかと、押下したボタンのIDを格納しておく
      const classNameReg = new RegExp('^(.*)_buttonclass_(.*)$');
      const regResult = classList.find(className => className.match(classNameReg)).match(classNameReg);
      f.selectedSide = regResult[1];
      f.selectedButtonId = regResult[2];
      
      if (tf.doSlideInCharacter) {
        // 表示中のキャラを画面外に出してから、ホバーされたキャラを登場させる
        changeCharacter(f.selectedButtonId, 'normal');
      }

      // glinkのenterse属性だと細かい設定ができないため独自に設定（特にbufがデフォルトだと他で鳴っている効果音を打ち消してしまう）
      TYRANO.kag.ftag.startTag("playse",{storage:"botan_b34.ogg",volume:60,buf:1});
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
[eval exp="console.log('button clicked id=' + f.selectedButtonId)"]

; ボタン用変数の初期化
[eval exp="f.buttonObjects = []"]
[eval exp="tf.side = ''"]
[eval exp="tf.noNeedStop = false"]
[eval exp="tf.doSlideInCharacter = false"]
[return]



; 投票結果表示サブルーチン
*openVote
; 投票結果を表示するレイヤーを可視化する
[layopt layer="1" page="fore" visible="true"]
[iscript]
/*
  TYRANO.kag.stat.f.voteResultObjects.push(new Action(CHARACTER_ID_ZUNDAMON, 'vote', CHARACTER_ID_METAN));
  TYRANO.kag.stat.f.voteResultObjects.push(new Action(CHARACTER_ID_METAN, 'vote', CHARACTER_ID_TSUMUGI));
  TYRANO.kag.stat.f.voteResultObjects.push(new Action(CHARACTER_ID_TSUMUGI, 'vote', CHARACTER_ID_HAU));
  TYRANO.kag.stat.f.voteResultObjects.push(new Action(CHARACTER_ID_HAU, 'vote', CHARACTER_ID_RITSU));
  TYRANO.kag.stat.f.voteResultObjects.push(new Action(CHARACTER_ID_RITSU, 'vote', CHARACTER_ID_ZUNDAMON));
  TYRANO.kag.stat.f.voteResultObjects.push(new Action(CHARACTER_ID_ZUNDAMON, 'vote', CHARACTER_ID_ZUNDAMON));
*/

  // レイヤーに、FlexboxのCSSが適用されるdiv要素を追加する
  $('.1_fore').append('<div class="vote_container">');
  // 表示するキャラクター数
  tf.characterCount = f.voteResultObjects.length;
  // Flexboxの中のbox（＝1キャラクターごとの領域）の幅。1280は画面全体の幅
  tf.boxWidth = 1280 / tf.characterCount;
  // boxの半分の幅。計算で頻出するので先に取得しておく
  tf.halfOfBoxWidth = tf.boxWidth / 2;
  // ループカウントおよび配列のキーとして使う変数
  tf.cnt = 0;
[endscript]

*openVote_loopstart

  [iscript]
    tf.characterId = f.voteResultObjects[tf.cnt].characterId;
    tf.targetId = f.voteResultObjects[tf.cnt].targetId;

    // boxの左側からの表示開始位置（に余白分を足した値）
    // ティラノの変数にNumber型の0を入れて初期化しようとしても、キーを定義できずundefinedになる。そのため必ず余白分の値を入れること
    tf.boxLeft = (tf.boxWidth * tf.cnt) + 3;
    // 以下のpx数分だけ、キャラクター画像の表示位置を中央より右へずらす。投票先の文字を表示するスペースを作るため
    tf.displacedPxToRight = 20;
    // キャラクター画像の左側からの表示位置。そのキャラのwidthCenterの位置がboxの中央に来るようにした後、少し右へずらす
    tf.imageLeft = (tf.boxWidth * (tf.cnt + 1)) - tf.halfOfBoxWidth - f.defaultPosition[tf.characterId].widthCenter + tf.displacedPxToRight;
    // キャラクター画像の左側からの表示位置。通常の立ち絵表示時の高さよりも少し上に表示する（ただし得票数を表示するための余白はとっておくこと）
    tf.imageTop = f.defaultPosition[tf.characterId].top - 100;
    // キャラクター画像のクラス名。のちほどキャラ画像のimg要素をbox内に移動させるためのセレクタになる。
    tf.imageName = 'vote_' + tf.characterId + '_' + tf.cnt;
    // キャラクター画像の格納パス
    tf.storage = 'chara/' + tf.characterId + '/normal.png';
    // 投票先キャラクター名表示用文字列
    tf.voteTargetText = '→' + f.characterObjects[tf.targetId].name;
    // 得票数表示用文字列
    tf.votedCountText = (function(){
      if (tf.characterId in f.votedCountObject) {
        let electedMark = f.electedIdList.includes(tf.characterId) ? '★' : '';
        return electedMark + f.votedCountObject[tf.characterId] + '票';
      } else {
        return '0票';
      }
    })();
  [endscript]

  ; キャラクター画像、投票先キャラクター名、得票数を表示
  [image storage="&tf.storage" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" left="&tf.imageLeft" top="&tf.imageTop" name="&tf.imageName" layer="1"]
  ; yには、tf.boxLeftに足していた余白と同じ分だけ余白を入れておく
  [ptext layer="1" text="&tf.voteTargetText" x="&tf.boxLeft" y="3" vertical="true" face="にくまるフォント" color="0x28332a" size="38" edge="2px 0xFFFFFF"]
  [ptext layer="1" text="&tf.votedCountText" x="&tf.boxLeft" y="3" width="&tf.boxWidth" align="center" face="にくまるフォント" color="0x28332a" size="38" edge="2px 0xFFFFFF"]

  [iscript]
    // キャラ分のdiv要素の中のクラス名を作成する
    let classVoteNum = 'vote_' + tf.cnt;
    // キャラ画像のimg要素を、boxと同じ幅になるよう左右をクリッピングするために必要なpx数を計算する
    let clipPx = {
      fromLeft: f.defaultPosition[tf.characterId].widthCenter - tf.halfOfBoxWidth - tf.displacedPxToRight,
      fromRight: f.defaultPosition[tf.characterId].width - f.defaultPosition[tf.characterId].widthCenter - tf.halfOfBoxWidth + tf.displacedPxToRight
    }

    // キャラを並べるためとこれ以下の処理を行うために、Flexboxである.vote_containerに1キャラ分のdiv要素を追加する
    $('.vote_container').append('<div class="vote_box ' + classVoteNum + '">');
    // 1box分の幅を設定する
    $('.vote_box').css('width', tf.boxWidth + 'px');
    // boxに、投票先キャラの背景色をつける
    $('.' + classVoteNum).css("background-color", f.color.character[tf.targetId]);
    // .vote_containerの子要素の.classVoteNumの子要素に、キャラ画像のimg要素を移動する
    $('.' + tf.imageName).appendTo('.' + classVoteNum);
    // キャラ画像のimg要素を、boxと同じ幅になるよう左右をクリッピングする
    $('.' + tf.imageName).css('clip-path', 'inset(0px ' + clipPx.fromRight + 'px 0px ' + clipPx.fromLeft + 'px)');
  [endscript]

  [jump target="*openVote_loopend" cond="tf.cnt == (tf.characterCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*openVote_loopstart"]
*openVote_loopend

/*
MEMO 最終的には以下の構成のHTMLが生成される。
<div class="vote_container">
  <div class="vote_box vote_0 vote_target_tsumugi" style="width: 256px;">
    <img src="./data/fgimage/chara/zundamon/normal.png" class="vote_zundamon_0" style="position: absolute; top: 35px; left: -110px; width: 550px; z-index: 1; clip-path: inset(0px 184px 0px 110px);">
  </div>
  (中略)
</div>
*/
[return]
