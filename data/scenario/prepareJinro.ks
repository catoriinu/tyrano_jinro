*prepareJinroGame
  ; シチュエーション開始チェック
  [t_setStartingSituation]

  ; チャプターリスト（再生するシナリオファイルを指定するためのChapterオブジェクトのリスト）の設定
  [call storage="prepareJinro.ks" target="*addChapterList"]

  ; 自動再生すべきシチュエーションがある場合は自動再生する
  [call storage="prepareJinro.ks" target="*playIntroChapter" cond="f.needPlayIntroChapter"]

  ; 開始する人狼ゲームデータを読み込む
  [j_prepareJinroGame jinroGameData="&f.targetJinroGameData" preload="true"]

  ; 人狼ゲーム開始
  [jump storage="playJinro.ks"]
[s]



*playIntroChapter
  [iscript]
    tf.episode = episodeData(f.startingSituation.pageId, f.startingSituation.episodeId);
    // 導入編を自動再生したあとにこのファイルに戻って来るために変数設定 関連マクロ：[t_setupChapter]
    f.returnJumpStorage = 'prepareJinro.ks';
    f.returnJumpTarget = '*end_playIntroChapter';
  [endscript]
  
  ; 導入編を自動再生する
  [jump storage="&tf.episode.introChapter.storage" target="*start"]
  *end_playIntroChapter

  [return]
[s]



; チャプターリストに登録するサブルーチン
*addChapterList
  [iscript]
    // チャプターリストの初期化
    f.chapterList = {};

    const pageId = f.startingSituation.pageId;
    const episodeId = f.startingSituation.episodeId;

    // シチュエーションが「誰がずんだもちを食べたのだ？」であるかつ解決編が未解放の場合、インストラクションを登録する
    tf.needAddInstruction = ((pageId === 'p01') && (episodeId === 'e01') && (getTheaterProgress('p01', 'e01') !== EPISODE_STATUS.OUTRO_UNLOCKED));
  [endscript]

  ; チャプターリストの登録
  [call storage="theater/chapterList.ks" target="*addInstruction" cond="tf.needAddInstruction"]

  [return]
[s]