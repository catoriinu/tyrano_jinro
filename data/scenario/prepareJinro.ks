*prepareJinroGame
  ; シチュエーション開始チェック
  [t_setStartingSituation]

  ; 幕間リストの設定
  [call storage="prepareJinro.ks" target="*addInterludeList"]

  ; 自動再生すべきシチュエーションがある場合は自動再生する
  [call storage="prepareJinro.ks" target="*playIntroEpisode" cond="f.needPlayIntroEpisode"]
  *return_playIntroEpisode

  ; 開始する人狼ゲームデータを読み込む
  [j_prepareJinroGame jinroGameData="&f.targetJinroGameData" preload="true"]

  ; 人狼ゲーム開始
  [jump storage="playJinro.ks"]
[s]



*playIntroEpisode
  [iscript]
    tf.episode = episodeData(f.startingSituation.pageId, f.startingSituation.episodeId);
    // 導入編を自動再生したあとにこのファイルに戻って来るために変数設定 関連マクロ：[t_setupChapter]
    f.returnJumpStorage = 'prepareJinro.ks';
    f.returnJumpTarget = '*end_playIntroEpisode';
  [endscript]
  
  ; 導入編を自動再生する
  [jump storage="&tf.episode.introChapter.storage" target="*start"]
  *end_playIntroEpisode

  [return]
[s]



; 幕間リストに登録するサブルーチン
*addInterludeList
  [iscript]
    // 幕間リストの初期化
    f.interludeList = {};

    const pageId = f.startingSituation.pageId;
    const episodeId = f.startingSituation.episodeId;

    // シチュエーションが「誰がずんだもちを食べたのだ？」であるかつ解決編が未解放の場合、インストラクションを登録する
    tf.needAddInstruction = ((pageId === 'p01') && (episodeId === 'e01') && (getTheaterProgress('p01', 'e01') !== EPISODE_STATUS.OUTRO_UNLOCKED));
  [endscript]

  ; 幕間リストの登録
  [call storage="interlude/interludeList.ks" target="*addInstruction" cond="tf.needAddInstruction"]

  [return]
[s]