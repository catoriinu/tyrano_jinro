*prepareJinroGame
  ; シチュエーション開始チェック
  [t_setStartingSituation]

  ; チャプターリスト（再生するシナリオファイルを指定するためのChapterオブジェクトのリスト）の設定
  [call storage="prepareJinro.ks" target="*addChapterList"]

  ; 自動再生すべき導入編がある場合は自動再生する
  [t_playChapter target="introChapter"]

  ; 開始する人狼ゲームデータを読み込む
  [j_prepareJinroGame jinroGameData="&f.targetJinroGameData" preload="true"]

  ; 人狼ゲーム開始
  [jump storage="playJinro.ks"]
[s]



; チャプターリストに登録するサブルーチン
*addChapterList
  [iscript]
    // チャプターリストの初期化
    f.chapterList = {};

    const pageId = f.startingSituation.pageId;
    const episodeId = f.startingSituation.episodeId;

    // シチュエーション開始条件に合致したエピソードがある場合、そのエピソードの導入編と解決編をチャプターリストに登録する
    if (pageId !== null && episodeId !== null) {
      const episode = episodeData(pageId, episodeId);
      const introChapter = episode.introChapter;
      const outroChapter = episode.outroChapter;
      f.chapterList.introChapter = {
        storage: introChapter.storage,
        target: introChapter.target,
        needPlay: f.needPlayIntroChapter // [t_setStartingSituation]で設定されたフラグをそのまま使う
      };
      f.chapterList.outroChapter = {
        storage: outroChapter.storage,
        target: outroChapter.target,
        needPlay: f.needPlayIntroChapter // [t_setStartingSituation]で設定されたフラグをそのまま使う。ゲーム終了時、checkOutroUnlockConditionサブルーチンの完遂チェックでNGとなった場合はそこで折る
      };
    }

    // シチュエーションが「誰がずんだもちを食べたのだ？」であるかつ解決編が未解放の場合、インストラクションを登録する
    tf.needAddInstruction = ((pageId === 'p01') && (episodeId === 'e01') && (getTheaterProgress('p01', 'e01') !== EPISODE_STATUS.OUTRO_UNLOCKED));
  [endscript]

  ; 規定のチャプターリストの登録
  [call storage="theater/chapterList.ks" target="*addInstruction" cond="tf.needAddInstruction"]

  [return]
[s]