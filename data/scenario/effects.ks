*openVoteTest
[layopt layer="1" page="fore" visible="true"]
[iscript]
  //setVoteResultObjects();
  $('.1_fore').append('<div class="vote_container">');
  tf.characterCount = f.voteResultObjects.length;
  tf.widthBox = 1280 / tf.characterCount;
  tf.halfOfWidthBox = tf.widthBox / 2;
  tf.cnt = 0;
[endscript]

*openVoteTest_loopstart

  [iscript]
    tf.characterId = f.voteResultObjects[tf.cnt].characterId;
    tf.targetId = f.voteResultObjects[tf.cnt].targetId;
    tf.left = (tf.halfOfWidthBox * ((tf.cnt + 1) * 2 - 1)) - f.defaultPosition[tf.characterId].widthCenter;
    tf.name = 'vote_' + tf.characterId + '_' + tf.cnt;
    tf.storage = 'chara/' + tf.characterId + '/normal.png';
  [endscript]

  [image storage="&tf.storage" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPositiont[tf.characterId].haight" left="&tf.left" name="&tf.name" layer="1"]

  [iscript]
    let classVoteNum = 'vote_' + tf.cnt
    let clipPx = {
      fromLeft: f.defaultPosition[tf.characterId].widthCenter - tf.halfOfWidthBox,
      fromRight: f.defaultPosition[tf.characterId].width - f.defaultPosition[tf.characterId].widthCenter - tf.halfOfWidthBox
    }

    $('.vote_container').append('<div class="vote_box ' + classVoteNum + '">'); // キャラを並べるためと以下の処理を行うために、flexBoxである.vote_containerに1キャラ分のdiv要素を追加する
    $('.vote_box').css('width', tf.widthBox + 'px'); // vote_boxの幅を設定する
    $('.' + classVoteNum).addClass('vote_target_' + tf.targetId); // 背景色のCSSをつけるためにクラスを追加する
    $('.' + tf.name).appendTo('.' + classVoteNum); // .vote_containerの子要素の.classVoteNumの子要素に、キャラ画像のimgを移動する
    $('.' + tf.name).css('clip-path', 'inset(0px ' + clipPx.fromRight + 'px 0px ' + clipPx.fromLeft + 'px)');
  [endscript]

  [jump target="*openVoteTest_loopend" cond="tf.cnt == (tf.characterCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*openVoteTest_loopstart"]
*openVoteTest_loopend


[return]
