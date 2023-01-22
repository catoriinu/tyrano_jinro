*openVoteTest
; 開票結果を表示するレイヤーを可視化する
[layopt layer="1" page="fore" visible="true"]
[iscript]
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

*openVoteTest_loopstart

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
    // boxに、投票先キャラの背景色のCSSをつけるためにクラスを追加する
    // TODO この後でcss()で直接background-colorを塗れば、CSSファイルに持たせておく必要はなくなるはず
    $('.' + classVoteNum).addClass('vote_target_' + tf.targetId);
    // .vote_containerの子要素の.classVoteNumの子要素に、キャラ画像のimg要素を移動する
    $('.' + tf.imageName).appendTo('.' + classVoteNum);
    // キャラ画像のimg要素を、boxと同じ幅になるよう左右をクリッピングする
    $('.' + tf.imageName).css('clip-path', 'inset(0px ' + clipPx.fromRight + 'px 0px ' + clipPx.fromLeft + 'px)');
  [endscript]

  [jump target="*openVoteTest_loopend" cond="tf.cnt == (tf.characterCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*openVoteTest_loopstart"]
*openVoteTest_loopend

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
