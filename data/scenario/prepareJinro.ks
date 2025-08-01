*prepareJinroGame
  ; シチュエーション開始チェック
  [t_setStartingSituation]

  ; [t_setStartingSituation]内で設定する変数をサブルーチンの外部で過不足なく設定済みなら、直接ここに飛んできてもよい
  *hasStartingSituationBeenSet

  ; チャプターリスト（再生するシナリオファイルを指定するためのChapterオブジェクトのリスト）の設定
  [call storage="prepareJinro.ks" target="*addChapterList"]

  ; 自動再生すべきチャプターがある場合は自動再生する
  [t_playChapter target="notice"]
  [t_playChapter target="introChapter"]

  ; 開始する人狼ゲームデータを読み込む
  [j_prepareJinroGame jinroGameData="&f.targetJinroGameData"]

  ; 人狼ゲームのプレイに必要なファイルをプリロードする
  [call storage="prepareJinro.ks" target="*preloadFiles" cond="sf.needPreload"]

  ; 人狼ゲーム開始
  [jump storage="playJinro.ks"]
[s]



; チャプターリストに登録するサブルーチン
*addChapterList
  [iscript]
    // 表示エピソード変数の初期化（シチュエーション開始ウィンドウの表示用）
    f.displayEpisode = null;

    const pageId = f.startingSituation.pageId;
    const episodeId = f.startingSituation.episodeId;

    // シチュエーション開始条件に合致したエピソードがある場合、そのエピソードの導入編と解決編をチャプターリストに登録する
    if (pageId && episodeId) {
      f.displayEpisode = episodeData(pageId, episodeId);
      const introChapter = f.displayEpisode.introChapter;
      const outroChapter = f.displayEpisode.outroChapter;
      f.chapterList.introChapter = {
        storage: introChapter.storage,
        target: introChapter.target,
        needPlay: f.needPlayIntroChapter // [t_setStartingSituation]で設定されたフラグをそのまま使う
      };
      f.chapterList.outroChapter = {
        storage: outroChapter.storage,
        target: outroChapter.target,
        needPlay: false // 一旦falseを入れておく。ゲーム終了時、checkOutroUnlockConditionサブルーチンの完遂チェックでOKかつ再生するとなったらtrueにする
      };
    }

    // 初めて「プレイスタート」したとき（「誰がずんだもちを食べたのだ？」の導入編が「1：導入編未解放かつ解放可」の場合）のみ、「はじめに」を登録する
    tf.needAddNotice = ((pageId === 'p01') && (episodeId === 'e01') && (getTheaterProgress('p01', 'e01') === EPISODE_STATUS.INTRO_LOCKED_AVAILABLE));
    // シチュエーションが「誰がずんだもちを食べたのだ？」であるかつ解決編が未解放の場合、インストラクションを登録する
    // インストラクションを行う場合は開始条件達成通知ウィンドウを表示したくないので、そのためにもこのフラグを用いる
    tf.needAddInstruction = ((pageId === 'p01') && (episodeId === 'e01') && (getTheaterProgress('p01', 'e01') !== EPISODE_STATUS.OUTRO_UNLOCKED));
  [endscript]

  ; 規定のチャプターリストの登録
  [call storage="theater/chapterList.ks" target="*addNotice" cond="tf.needAddNotice"]
  [call storage="theater/chapterList.ks" target="*addInstruction" cond="tf.needAddInstruction"]

  [return]
[s]



; playJinro内で使うファイルをプリロードするサブルーチン
*preloadFiles
  ; 人狼ゲームに参加するキャラクターのボイスをプリロードする
  [call storage="message/utility.ks" target="*preloadVoice"]

  [iscript]
    tf.preloadList = [
      // BGM
      "data/bgm/nc282335.ogg",
      // SE
      "data/sound/se/wadaiko_dodon.ogg",
      "data/sound/se/shakiin1.ogg",
      "data/sound/se/megaten.ogg",
      "data/sound/se/kirakira4.ogg",
      "data/sound/se/chiin1.ogg",
      // 画像
      "data/bgimage/living_night_close.jpg",
      "data/bgimage/living_day.jpg",
    ];
  [endscript]
  [preload storage="&tf.preloadList" single_use="false" name="jinroFiles"]

  [return]
[s]