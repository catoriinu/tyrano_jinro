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
  mp.interval = ('interval' in mp) ? parseInt(mp.interval, 10) : 0;
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

      // Howlオブジェクトをロードするためのポーリング処理を行う
      // ただしmaxChecks * checkInterval(ms)の時間ぶんポーリングしてもロードが完了しない場合は[playselist]自体を中断する
      // 環境によってロードに時間がかかる場合は、maxChecksやcheckIntervalの値を調整すること
      const maxChecks = 20;     // 最大チェック回数
      const checkInterval = 50; // チェック間隔(ms)
      let checks = 0;

      const buf = this.mp.buf;
      const waitForHowl = () => {
        const howl = TYRANO.kag.tmp.map_se[buf];
        // state() があればロード済み、なければ未ロード or 未生成
        if (howl && typeof howl.state === 'function' && howl.state() === 'loaded') {
          startMonitoring(howl);
        } else if (checks++ < maxChecks) {
          setTimeout(waitForHowl, checkInterval);
        } else {
          return reject(new Error(`[playselist] Howlオブジェクトのロードがタイムアウトしたため中断 buf=${buf}`));
        }
      };

      // 監視ループ開始
      const startMonitoring = (howl) => {
        // 再生完了後に待機すべきインターバルの時間を、プロパティから取得する
        let intervalAfterPlaySe = this.mp.interval;

        // 再生終了チェック
        const intervalId = setInterval(() => {
          if (howl !== TYRANO.kag.tmp.map_se[buf]) {
            // 再生中のHowlオブジェクトが、格納しておいたHowlオブジェクトと異なっていた場合、rejectして処理を中断する
            // クリック等の操作でシナリオが先に進んだことにより別のSEが再生中なので、[playselist]を継続してはいけないため
            clearInterval(intervalId);
            reject(new Error(`[playselist] 別のSEの再生が開始されているため中断 buf=${buf}`));
            return;
          }

          // Howlオブジェクトの再生が完了している場合
          // 注意：
          // sprite_time=""を指定しておりかつ終了時間が実際のファイルの再生時間よりも長い場合、playing()がfalseになるのはsprite_timeの終了時間の方
          if (!howl.playing()) {
            // 再生完了後に待機すべきインターバルの時間ぶんの待機も完了したら、処理を正常終了する
            if (intervalAfterPlaySe <= 0) {
              clearInterval(intervalId);
              resolve();
            } else {
              intervalAfterPlaySe -= this.loopTime;
            }
          }
        }, this.loopTime); // loopTimeのミリ秒分待機してから、再度再生終了チェックを行う
      };

      // 最初のチェックをキック
      waitForHowl();
    });
  };
}
