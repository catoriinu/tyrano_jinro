*prepareJinroGame
  ; シチュエーション開始チェック
  [t_setStartingSituation]

  ; 自動再生できる場合は、導入編を自動再生する
  [jump storage="prepareJinro.ks" target="*playIntroEpisode" cond="f.needPlayIntroEpisode"]
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

  [jump storage="prepareJinro.ks" target="*return_playIntroEpisode" cond="f.needPlayIntroEpisode"]
[s]