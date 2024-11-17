; シアター用マクロファイル


; @param pageId シアター一覧のページID。必須。
[macro name="loadEpisodeList"]
[iscript]
  f.episodeList = getEpisodes(mp.pageId);

  // （現在の）ボイボ人狼ではエピソード数は1ページにつき8つ（e01-e08）
  const episodeIdList = ['e01', 'e02', 'e03', 'e04', 'e05', 'e06', 'e07', 'e08']
  // 導入編が未解放（＝getEpisodesで取得できなかった）のエピソードは、代わりに未解放用のエピソードを格納する
  console.log(f.episodeList);
  for (let episodeId of episodeIdList) {
    if (!(episodeId in f.episodeList)){
      f.episodeList[episodeId] = new Episode(
        mp.pageId,
        episodeId,
        '？？？？？',
        'theater/TVStaticColor01_10.png',
        '',
        null,
        null,
        null,
        null,
       );
    }
  }
[endscript]
[endmacro]


; 現在選択中のシアター詳細に紐づいているシチュエーションの参加者オブジェクト配列を一時変数に登録する
; シアター詳細画面では、j_registerParticipantの代わりにこのマクロで登録すること
[macro name="t_registerSituationParticipants"]
  [iscript]
    tf.tmpParticipantObjectList = clone(f.displayEpisode.situation.participantsList);
  [endscript]
[endmacro]


; 指定されたチャプターの進捗が「未解放」なら一時変数にtrueを格納する
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_isProgressLocked"]
  [iscript]
    tf.isProgressLocked = (getTheaterProgress(mp.pageId, mp.episodeId, mp.chapterId) === THEATER_LOCKED);
  [endscript]
[endmacro]


; 指定されたチャプターの進捗が「解放済みだが未視聴」なら一時変数にtrueを格納する
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_isProgressUnlocked"]
  [iscript]
    tf.isProgressUnlocked = (getTheaterProgress(mp.pageId, mp.episodeId, mp.chapterId) === THEATER_UNLOCKED);
  [endscript]
[endmacro]


; 指定されたチャプターの進捗が「視聴済み」なら一時変数にtrueを格納する
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_isProgressWatched"]
  [iscript]
    tf.isProgressWatched = (getTheaterProgress(mp.pageId, mp.episodeId, mp.chapterId) === THEATER_WATCHED);
  [endscript]
[endmacro]


; 指定されたチャプターの進捗を「視聴済み」に更新する
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_updateProgressWatched"]
  [iscript]
    sf.theaterProgress[mp.pageId][mp.episodeId][mp.chapterId] = THEATER_WATCHED;
  [endscript]
[endmacro]


; チャプター視聴開始時の準備用マクロ
; @param actorsList
; @param bgParams
; @param playbgmParams
[macro name="t_setupChapter"]

  [cm]
  [clearfix]
  [start_keyconfig]

  ; 背景
  [bg storage="&mp.bgParams.storage" time="300"]

  ; BGM
  [playbgm storage="&mp.playbgmParams.storage" loop="true" volume="&mp.playbgmParams.volume" restart="false"]

  ;メッセージウィンドウの設定、文字が表示される領域を調整
  [position layer="message0" left="53" top="484" width="1174" height="235" margint="65" marginl="75" marginr="80" marginb="65" opacity="220" page="fore"]

  ;キャラクターの名前が表示される文字領域
  [ptext name="chara_name_area" layer="message0" face="にくまるフォント" color="0x28332a" size="36" x="175" y="505"]

  ;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
  [chara_config ptext="chara_name_area"]
  ; pos_mode:キャラの初期位置はキャラ宣言時に全指定するのでfalse
  [chara_config pos_mode="false" memory="true" time="200"]

  ; 再生中のチャプターのファイルパスを生成しておく（スキップからの再開のため・コンフィグでチャプター再生中と判定するため）
  [eval exp="f.chapterStorage = 'theater/' + f.pageId + '/' + f.episodeId + '_' + f.chapterId + '.ks'"]

  ; スキップした場合用の変数を初期化
  [eval exp="tf.chapterSkiped = false"]

  ;このシナリオで登場する全キャラクターを宣言、表情登録
  [eval exp="tf.registerCharacterList = mp.actorsList"]
  [call storage="./chara/common.ks" target="*registerCharacters"]

  ; ボタン表示
  [j_displayFixButton backlog="true" pauseMenu="true"]

[endmacro]


; チャプター視聴終了時の後片付け用マクロ
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_teardownChapter"]

  ; キャラ名を消すための#
  # 

  ; 視聴済みに更新する
  [t_updateProgressWatched pageId="&mp.pageId" episodeId="&mp.episodeId" chapterId="&mp.chapterId"]
  ; 視聴終了時に解放すべきシアター進捗があれば解放する
  [call storage="theater/unlockProgress.ks" target="*start"]

  [iscript]
    // 戻ったときにエピソードウィンドウを開くための設定
    f.displayPageId = mp.pageId;
    f.displayEpisodeId = mp.episodeId;
    f.quickShowEpisodeWindow = true;
    
    // 再生中のチャプターのファイルパスを初期化
    f.chapterStorage = null;
  [endscript]

  ; チャプター再生中に表示している可能性があるものは全て画面から消す（途中でスキップされた場合もここで消せるようにするため）
  [j_clearFixButton]
  [m_exitCharacter characterId="&f.displayedCharacter.left.characterId" time="1"]
  [m_exitCharacter characterId="&f.displayedCharacter.right.characterId" time="1"]
  [layopt layer="1" visible="false"]
  [layopt layer="2" visible="false"]
  [layopt layer="message0" visible="false"]
  [eval exp="f.currentFrame = null"]
[endmacro]


; シアター画面のエピソード選択用の背景、サムネイル、進捗枠表示用マクロ
; @param pageId
; @param episodeId
[macro name="t_imageTheaterThumbnail"]
  [iscript]
    // e01～e08までの画像の表示位置を定義
    tf.episodeCoodinate = {
      'e01':{x: 12,  y: 6,   thumbLeft: 24.5,  thumbTop: 19},
      'e02':{x: 249, y: 6,   thumbLeft: 261.5, thumbTop: 19},
      'e03':{x: 486, y: 6,   thumbLeft: 498.5, thumbTop: 19},
      'e04':{x: 723, y: 6,   thumbLeft: 735.5, thumbTop: 19},
      'e05':{x: 12,  y: 260, thumbLeft: 24.5,  thumbTop: 274},
      'e06':{x: 249, y: 260, thumbLeft: 261.5, thumbTop: 274},
      'e07':{x: 486, y: 260, thumbLeft: 498.5, thumbTop: 274},
      'e08':{x: 723, y: 260, thumbLeft: 735.5, thumbTop: 274},
    }
  [endscript]
  
  ; 最も背景の長方形を表示
  [image storage="theater/theater_normal_rectangle.png" layer="0" name="theater1" x="&tf.episodeCoodinate[mp.episodeId].x" y="&tf.episodeCoodinate[mp.episodeId].y"]
  ; サムネイルを表示
  [image storage="&f.episodeList[mp.episodeId].thumbnail" layer="0" left="&tf.episodeCoodinate[mp.episodeId].thumbLeft" top="&tf.episodeCoodinate[mp.episodeId].thumbTop" width="200" height="112.5" name="thumbnail"]

  ; 解決編の進捗を一時変数に取得
  [t_isProgressUnlocked pageId="&mp.pageId" episodeId="&mp.episodeId" chapterId="c02"]
  [t_isProgressWatched  pageId="&mp.pageId" episodeId="&mp.episodeId" chapterId="c02"]

  [if exp="tf.isProgressWatched"]
    ; 解決編が視聴済みなら金枠
    [image storage="theater/theater_gold_frame.png" layer="0" name="theater1" x="&tf.episodeCoodinate[mp.episodeId].x" y="&tf.episodeCoodinate[mp.episodeId].y"]
  [elsif exp="tf.isProgressUnlocked"]
    ; 解決編が解放済みだが未視聴なら銀枠（導入編の進捗は考慮しなくてよい。プレイヤーが解放条件を満たすか、導入編を見るかしないといけない、ということを銀枠は示している）
    [image storage="theater/theater_silver_frame.png" layer="0" name="theater1" x="&tf.episodeCoodinate[mp.episodeId].x" y="&tf.episodeCoodinate[mp.episodeId].y"]
  [endif]
[endmacro]



; このマクロ内で更新するゲーム変数
; f.startingSituation    : シチュエーション開始条件に合致したエピソードのページIDとエピソードID。合致しなかった場合は値はnullのまま。{pageId: String|null, episodeId: String|null}
; f.needPlayIntroEpisode : 導入編を自動再生するフラグ。true: 自動再生する | false: 自動再生しない
; f.targetJinroGameData  : ゲーム開始時に利用する人狼ゲームデータオブジェクト。合致したエピソードがあれば、そのシチュエーションに合わせて書き換えられる。なければ現在の人狼ゲームデータ自体のディープコピー。
[macro name="t_setStartingEpisodeSituation"]
  [iscript]
    // このマクロ内で更新するゲーム変数の初期化
    f.startingSituation = {
      pageId: null,
      episodeId: null
    }
    f.needPlayIntroEpisode = false;
    let tmpNeedPlayIntroEpisode = false;

    // 元々の人狼ゲームデータに書き換えを反映させないために、オブジェクトをcloneする
    const jinroGameData = mp.jinroGameData || sf.jinroGameDataObjects[sf.currentJinroGameDataKey];
    f.targetJinroGameData = clone(jinroGameData);

    // 「導入編未解放かつ解放可」のエピソードに対して、シチュエーション開始条件に合致したかのチェック
    const introAvailableEpisodes = getEpisodesByStatus(EPISODE_STATUS.INTRO_LOCKED_AVAILABLE, sf.theaterProgress);
    [tmpNeedPlayIntroEpisode, f.startingSituation.pageId, f.startingSituation.episodeId, f.targetJinroGameData] = checkMatchingEpisodeSituation(introAvailableEpisodes, f.targetJinroGameData);

    // シチュエーション開始条件に合致した「導入編未解放かつ解放可」のエピソードがなかった場合
    if (!tmpNeedPlayIntroEpisode) {
      // 「導入編解放済みで解決編未解放」のエピソードに対して、シチュエーション開始条件に合致したかのチェック
      const introUnlockedEpisodes = getEpisodesByStatus(EPISODE_STATUS.INTRO_UNLOCKED_OUTRO_LOCKED, sf.theaterProgress);
      [, f.startingSituation.pageId, f.startingSituation.episodeId, f.targetJinroGameData] = checkMatchingEpisodeSituation(introUnlockedEpisodes, f.targetJinroGameData);
      // 合致したエピソードがあってもなくても、tmpNeedPlayIntroEpisodeはfalseのままとする。
    }

    // TODO 「視聴済みの導入編を自動スキップする」チェックボックスを導入する場合はこのあたりの修正が必要
    f.needPlayIntroEpisode = tmpNeedPlayIntroEpisode;
  [endscript]
[endmacro]
