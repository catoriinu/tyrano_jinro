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
