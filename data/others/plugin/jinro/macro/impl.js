/**
 * m_changeCharacterマクロのjsポーティング版メソッド
 * ※基本的にはマクロの方を使うべき。jsから呼び出したいときのみこのメソッドを使うことを許容。
 * 　jsでティラノタグを呼び出し実行すると、ページ送りが行われてしまうことに注意すること。
 * 登場しているキャラクターを交代する。既に登場しているキャラクターの場合は表情のみ変える。
 * キャラの表示位置は、PC：画面左側、NPC：画面右側とする。同じ側には一人しか出ない（ので、例えばNPC1が右側にいるときNPC2が喋る場合、NPC1が退場してからNPC2が登場する）
 * すでにそのキャラがchara_newで登録,およびその表情がchara_faceで登録済みである前提とする。
 * @param characterId 登場させたいキャラのキャラクターID。必須。
 * @param face 登場させたいキャラのface。基本的に必須。
 */
function changeCharacter(characterId, face = null) {

  // そのキャラがデフォルトで登場する位置を格納する（マクロ側と違い、単に変数名の短縮のため）
  let side = TYRANO.kag.stat.f.defaultPosition[characterId].side;

  // その位置に既に登場しているキャラがいる場合
  if (TYRANO.kag.stat.f.displayedCharacter[side].isDisplay) {

    // それが登場させたいキャラ自身の場合
    if (TYRANO.kag.stat.f.displayedCharacter[side].characterId == characterId) {
      // 表情の指定があり、かつ今の表情と違う場合、表情を変える
      if (face && TYRANO.kag.stat.f.displayedCharacter[side].face != face) {
        TYRANO.kag.ftag.startTag('chara_mod', {
          name: characterId,
          face: face,
          time: 500,
          wait: 'false'
        });
        // 表示キャラオブジェクトを更新する
        TYRANO.kag.stat.f.displayedCharacter[side].face = face;
      }

    } else {
      // 今登場している別のキャラを退場させてから、そのキャラを登場させる
      exitCharacter(TYRANO.kag.stat.f.displayedCharacter[side].characterId);
      enterCharacter(characterId, face, side);
    }

  } else {
    // 登場しているキャラがいないなら、そのキャラを登場させる
    enterCharacter(characterId, face, side);
  }
}

/**
 * m_enterCharacterマクロのjsポーティング版メソッド
 * ※基本的にはマクロの方を使うべき。jsから呼び出したいときのみこのメソッドを使うことを許容。
 * 　jsでティラノタグを呼び出し実行すると、ページ送りが行われてしまうことに注意すること。
 * 現在は登場していないキャラを登場させる
 * @param characterId 登場させたいキャラのキャラクターID。必須。
 * @param face 登場させたいキャラのface。必須。
 * @param side 画面内にキャラが登場する位置。必須。
 */
function enterCharacter(characterId, face, side) {

  console.log('★enter ' + characterId);

  // 表情を変える
  // MEMO 「そのキャラの今の表情」を取得可能であれば、「今の表情と違う場合のみ」にしたい。が、HTML要素内に表情の情報がimgのパスくらいしかなかったので無理そう。
  TYRANO.kag.ftag.startTag('chara_mod', {
    name: characterId,
    face: face,
    time: 1,
    wait: 'false'
  });

  // sideに合わせて、キャラクター画像を移動させるべき量を格納する
  let moveLeft = '-=1000';
  if (side == 'left') {
    moveLeft = '+=1000';
  }

  // sideがrightなら画面右から右側に、leftなら画面左から左側にスライドインしてくる
  TYRANO.kag.ftag.startTag("chara_move",{
    name: characterId,
    time: 600,
    anim: "true",
    left: moveLeft,
    wait: "false",
    effect: "easeOutExpo"
  });

  // 表示キャラオブジェクトを更新する
  TYRANO.kag.stat.f.displayedCharacter[side] = new DisplayedCharacterSingle(true, characterId, face);
}


/**
 * m_exitCharacterマクロのjsポーティング版メソッド
 * ※基本的にはマクロの方を使うべき。jsから呼び出したいときのみこのメソッドを使うことを許容。
 * 　jsでティラノタグを呼び出し実行すると、ページ送りが行われてしまうことに注意すること。
 * 退場マクロ
 * 現在登場しているキャラを退場させる
 * @param characterId 退場させたいキャラのキャラクターID。必須。
 */
function exitCharacter(characterId) {

  // そのキャラがどちらのサイドに表示されているかを取得する
  let side = (function(){
    if (TYRANO.kag.stat.f.displayedCharacter.right != null && TYRANO.kag.stat.f.displayedCharacter.right.characterId == characterId) return 'right';
    if (TYRANO.kag.stat.f.displayedCharacter.left  != null && TYRANO.kag.stat.f.displayedCharacter.left.characterId  == characterId) return 'left';
    return null;
  })();
  // 現在そのキャラが表示されていないなら、何もせず終了
  if (side === null) return;

  console.log('★exit ' + characterId);

  // そのキャラをデフォルトの位置に移動させる
  TYRANO.kag.ftag.startTag('chara_move', {
    name: characterId,
    time: 600,
    left: TYRANO.kag.stat.f.defaultPosition[characterId].left,
    wait: 'false',
  });

  // 表示キャラオブジェクトを更新する
  TYRANO.kag.stat.f.displayedCharacter[side] = new DisplayedCharacterSingle();
}


// TODO 別の場所に移動したい。このファイル自体も改名したい。
/**
 * @classdec 表示キャラオブジェクト（f.displayedCharacter）のleft/rightの値として格納する、一人分のキャラクター情報クラス
 * @param {Boolean} isDisplay 表示中か true:表示中 | false:表示されていない
 * @param {String} characterId キャラクターID
 * @param {String} face 表情
 */
function DisplayedCharacterSingle(isDisplay = false, characterId = null, face = null) {
  this.isDisplay = isDisplay;
  this.characterId = characterId;
  this.face = face;
}


/**
 * 横並びでキャラクター画像を表示するサブルーチン(displayCharactersHorizontally)用の情報オブジェクト
 * 生成したオブジェクトはf.dchに格納しておくこと
 * @param {Array} characterList 表示するキャラクター情報（DisplayCharactersHorizontallySingleオブジェクト）を値に持つ配列
 * @param {Number} displacedPxToRight キャラクター画像の左側からの表示位置を、標準からどれだけ右にずらしたいか(px)(負の値なら左にずれる)
 * @param {Number} displacedPxToTop キャラクター画像の上側からの表示位置を、標準からどれだけ下にずらしたいか(px)(負の値なら上にずれる)
 */
function DisplayCharactersHorizontally(characterList = [], displacedPxToRight = 0, displacedPxToTop = 0) {
  this.characterList = characterList;
  this.displacedPxToRight = displacedPxToRight;
  this.displacedPxToTop = displacedPxToTop;
}


/**
 * 横並びでキャラクター画像を表示する際のキャラクター単体についての情報オブジェクト
 * 生成したオブジェクトは、DisplayCharactersHorizontallyオブジェクトのcharacterList配列の値として格納すること
 * @param {String} characterId キャラクターID
 * @param {String} fileName 表示する画像のファイルパス。拡張子も必要。最終的には[image storage="chara/{characterId}/{fileName}"]形式で渡される。
 * @param {String} bgColor 背景色のカラーコード
 * @param {String} topText box上部に横書きで表示するテキスト。表示不要なら引数不要
 * @param {String} leftText box左部に縦書きで表示するテキスト。表示不要なら引数不要
 */
function DisplayCharactersHorizontallySingle(characterId, fileName, bgColor, topText = '', leftText = '') {
  this.characterId = characterId;
  this.fileName = fileName;
  this.bgColor = bgColor;
  this.topText = topText;
  this.leftText = leftText;
}


/**
 * [playselist]で再生したいSEを登録しておき、連続再生を実行するためのオブジェクト
 * （ObserverパターンのSubjectにあたるオブジェクト）
 */
function PlaySeListSubject() {

  this.playSeObserverList = [];

  // subscribe
  this.addPlaySeList = function (playSeObserver) {
    this.playSeObserverList.push(playSeObserver);
  }

  // notify
  this.playSeList = async function () {
    for (let i = 0; i < this.playSeObserverList.length; i++) {
      // 最後以外はmp.stopをtrueにする（trueならnextOrderしない）
      let needStop = (i == (this.playSeObserverList.length - 1)) ? false : true;

      // SEを再生する
      const playSeObserver = this.playSeObserverList[i];
      try {
        await playSeObserver.playSe(needStop);
      } catch (error) {
        // Promiseがrejectされた場合の処理
        break;
      }
    }
  }

}


/**
 * [playselist]で再生するためのSE1つ分の情報を保持しておく役目と、
 * PlaySeListSubjectから呼ばれたときに実際にSEを再生する機能を有するオブジェクト
 * （ObserverパターンのObserverにあたるオブジェクト）
 */
function PlaySeObserver(mp) {
  // 引数のintervalを数値に変換。指定がなければデフォルトで0を入れる
  mp.interval = ('interval' in mp) ? parseInt(mp.interval) : 0;
  // [playse]に渡すための引数をプロパティに保持しておく
  this.mp = mp;

  // 再生終了チェックを行うまでの時間。単位はミリ秒
  // もっとこまめにチェックしてほしいなら値を小さくすること。ただし処理の負荷が高くなる可能性あり
  // 引数のintervalをここよりも小さい数値にした場合、最悪でloopTimeのミリ秒分待機が発生しうることを許容してください
  this.loopTime = 100;

  // 実際にSEを再生するメソッド
  this.playSe = function(needStop) {
    this.mp.stop = needStop;

    // SEの再生処理の顛末が正常終了or中断のどちらになったかを検知するためにPromiseを生成、返却する
    return new Promise((resolve, reject) => {
      // このPlaySeObserverに保持されていたSEを再生する
      TYRANO.kag.ftag.startTag("playse", this.mp);
      // 再生中のHowlオブジェクトを格納する
      let playingSoundObj = TYRANO.kag.tmp.map_se[this.mp.buf];
      // 再生完了後に待機すべきインターバルの時間を、プロパティから取得する
      let intervalAfterPlaySe = this.mp.interval;

      // 再生終了チェック
      const intervalId = setInterval(() => {
        if (playingSoundObj !== TYRANO.kag.tmp.map_se[this.mp.buf]) {
          // 再生中のHowlオブジェクトが、格納しておいたHowlオブジェクトと異なっていた場合、rejectして処理を中断する
          // クリック等の操作でシナリオが先に進んだことにより別のSEが再生中なので、[playselist]を継続してはいけないため
          clearInterval(intervalId);
          reject();
        } else if (!TYRANO.kag.tmp.map_se[this.mp.buf].playing()) {
          // Howlオブジェクトの再生が完了している場合
          // 注意：
          // sprite_time=""を指定しておりかつ終了時間が実際のファイルの再生時間よりも長い場合、playing()がfalseになるのはsprite_timeの終了時間の方

          // 再生完了後に待機すべきインターバルの時間ぶんの待機も完了したら、処理を正常終了する
          if (intervalAfterPlaySe <= 0) {
            clearInterval(intervalId);
            resolve();
          }

          // intervalAfterPlaySeがloopTimeよりも短い場合、
          // このままでは残り時間が先に終わるのに、再生終了チェックが行われるまで無駄に待機してしまうため、
          // intervalAfterPlaySeでloopTimeを上書きすることで、当初のインターバルの時間ピッタリで処理終了できるようにする
          if (intervalAfterPlaySe < this.loopTime) {
            this.loopTime = intervalAfterPlaySe;
          }
          // intervalAfterPlaySeの残り時間からloopTimeぶんを減らす
          intervalAfterPlaySe -= this.loopTime;
        }
      }, this.loopTime); // loopTimeのミリ秒分待機してから、再度再生終了チェックを行う
    });
  }
}
