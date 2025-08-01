; シアター用マクロファイル


; @param pageId シアター一覧のページID。必須。
[macro name="loadEpisodeList"]
[iscript]
  f.episodeList = getEpisodes(mp.pageId);

  // （現在の）ボイボ人狼ではエピソード数は1ページにつき8つ（e01-e08）
  const episodeIdList = ['e01', 'e02', 'e03', 'e04', 'e05', 'e06', 'e07', 'e08']
  // 導入編が未解放（取得できなかった、または0：導入編未解放かつ現時点では解放不可）のエピソードは、代わりに未解放用のエピソードを格納する
  console.debug(f.episodeList);
  for (let episodeId of episodeIdList) {
    const theaterProgress = getTheaterProgress(mp.pageId, episodeId);
    if (!(episodeId in f.episodeList) || theaterProgress === EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE){
      f.episodeList[episodeId] = new Episode(
        mp.pageId,
        episodeId,
        '？？？？？',
        'theater/TVStaticColor01_10.png',
        '',
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


; 指定されたチャプターの進捗が「未解放」なら一時変数にtrueを格納する
; @param pageId
; @param episodeId
[macro name="t_isProgressLocked"]
  [iscript]
    tf.isProgressLocked = (getTheaterProgress(mp.pageId, mp.episodeId) === EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE);
  [endscript]
[endmacro]


; チャプター再生開始時の準備用マクロ
; @param titleText
; @param actorsList
; @param bgParams
; @param playbgmParams
[macro name="t_setupChapter"]
  [cm]
  [clearfix]
  [start_keyconfig]

  [t_clearDisplay]

  ; タイトルカットイン表示。アニメーション処理は待機不要。処理の裏側でデータロードしたいため。代わりにt_waitClickCutInでクリック待ちする。
  [t_cutIn text="&mp.titleText" waitAnime="false"]

  ;このシナリオで登場する全キャラクターを宣言、表情登録
  [eval exp="tf.registerCharacterList = mp.actorsList"]
  [call storage="./chara/common.ks" target="*registerCharacters"]

  [iscript]
    // 再生中のチャプターのファイルパスを生成しておく（スキップからの再開のため・コンフィグでチャプター再生中と判定するため）
    f.chapterStorage = 'theater/' + f.pageId + '/' + f.episodeId + '_' + f.chapterId + '.ks';

    // 今回の再生でエピソード解放ステータスが進んだか
    tf.doAdvanceEpisodeStatus = false;

    // エピソード解放ステータスの更新
    // 解決編の場合、「2：導入編解放済みで解決編未解放」なら「3：解決編まで解放済み」に更新する
    if (f.chapterId === 'c02') {
      const [result, resultStatus] = advanceEpisodeStatus(f.pageId, f.episodeId, EPISODE_STATUS.OUTRO_UNLOCKED);
      sf.theaterProgress[f.pageId][f.episodeId] = resultStatus;
      tf.doAdvanceEpisodeStatus = result;
    }
  [endscript]

  ; シアター内のファイルのプリロード
  [call storage="&f.chapterStorage" target="*preloadFiles" cond="sf.needPreload"]

  [t_waitClickCutIn]

  [bg storage="&mp.bgParams.storage" time="1" wait="true"]
  [playbgm storage="&mp.playbgmParams.storage" loop="true" volume="&mp.playbgmParams.volume" restart="false"]

  [t_clearCutIn]

  ; ボタン表示
  [j_displayFixButton backlog="true" pauseMenu="true"]
[endmacro]


; チャプター再生終了時の後片付け用マクロ
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_teardownChapter"]
  [fadeoutse buf="1" time="500"]
  [fadeoutse buf="2" time="500"]
  [fadeoutbgm time="500"]

  ; キャラ名を消すための#
  # 

  [iscript]
    // 戻ったときにエピソードウィンドウを開くための設定
    f.displayPageId = mp.pageId;
    f.displayEpisodeId = mp.episodeId;
    f.quickShowEpisodeWindow = true;
    
    // 再生中のチャプターのファイルパスを初期化
    f.chapterStorage = null;

    // エピソード解放ステータスの更新
    // 導入編の場合、「1：導入編未解放かつ解放可」なら「2：導入編解放済みで解決編未解放」に更新する
    if (mp.chapterId === 'c01') {
      const [result, resultStatus] = advanceEpisodeStatus(mp.pageId, mp.episodeId, EPISODE_STATUS.INTRO_UNLOCKED_OUTRO_LOCKED);
      sf.theaterProgress[mp.pageId][mp.episodeId] = resultStatus;
      tf.doAdvanceEpisodeStatus = result;
    }
  [endscript]

  ; 再生終了時に解放すべきシアター進捗があれば解放する
  [call storage="theater/episodeSubroutines.ks" target="*unlockNextEpisode"]

  ; チャプター再生中に表示している可能性があるものは全て画面から消す（途中でスキップされた場合もここで消せるようにするため）
  [t_clearDisplay]
[endmacro]


; カットインマクロ
; 暗幕が降りてくるイメージ
; 関連マクロ：[t_waitClickCutIn][t_clearCutIn]
; @param text 表示するテキスト。タイトルなど。
; @param waitAnime true: アニメーション処理待機する（デフォルト） | false: 待機しない（String型のfalseを渡してもこちらになる）[t_waitClickCutIn]を併用するならfalseでよい
[macro name="t_cutIn"]
  [fadeoutse time="500" buf="1"]
  [fadeoutse time="500" buf="2"]
  [fadeoutbgm time="500"]

  [iscript]
    tf.needText = ('text' in mp);
    tf.needWaitAnime = ('waitAnime' in mp) ? parseBool(mp.waitAnime) : true;
  [endscript]
  [image layer="2" y="-720" folder="bgimage" storage="black.png" width="1280" height="720" name="cutin"]
  [ptext layer="2" x="40" y="-420" width="1200" align="center" text="&mp.text" color="white" size="50" name="cutin" cond="tf.needText"]
  [layopt layer="2" visible="true"]
  [anim name="cutin" top="+=720" time="750"]
  [wa cond="tf.needWaitAnime"]
[endmacro]


; アニメーション処理が完了するまで待機させたうえで、クリックして次へ進めるよう誘導する
; 関連マクロ：[t_cutIn][t_clearCutIn]
[macro name="t_waitClickCutIn"]
  [wa]
  [ptext layer="2" x="40" y="660" width="1200" align="right" text="クリックしてスタート" color="white" size="32" name="clickstart" time="100"]
  [p]
[endmacro]


; カットイン消去マクロ
; 暗幕を上げるイメージ
; 関連マクロ：[t_cutIn][t_waitClickCutIn]
[macro name="t_clearCutIn"]
  [free layer="2" name="clickstart" time="10" wait="false"]
  [anim name="cutin" top="-=720" time="750"]
  [wa]
  [free layer="2" name="cuitn" time="1" wait="true"]
[endmacro]


[macro name="t_clearDisplay"]
  [j_clearFixButton]
  [m_exitCharacter characterId="&f.displayedCharacter.left.characterId" time="1"]
  [m_exitCharacter characterId="&f.displayedCharacter.right.characterId" time="1"]
  [freeimage layer="1"]
  [freeimage layer="2"]
  [free_filter layer="base"]
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
    // シアター進捗を取得
    tf.theaterProgress = getTheaterProgress(mp.pageId, mp.episodeId);
  [endscript]
  
  ; 最も背景の長方形を表示
  [image storage="theater/theater_normal_rectangle.png" layer="0" name="theater1" x="&tf.episodeCoodinate[mp.episodeId].x" y="&tf.episodeCoodinate[mp.episodeId].y"]
  ; サムネイルを表示
  [image storage="&f.episodeList[mp.episodeId].thumbnail" layer="0" left="&tf.episodeCoodinate[mp.episodeId].thumbLeft" top="&tf.episodeCoodinate[mp.episodeId].thumbTop" width="200" height="112.5" name="thumbnail"]

  [if exp="tf.theaterProgress === EPISODE_STATUS.OUTRO_UNLOCKED"]
    ; 「3：解決編まで解放済み」なら金枠
    [image storage="theater/theater_gold_frame.png" layer="0" name="theater1" x="&tf.episodeCoodinate[mp.episodeId].x" y="&tf.episodeCoodinate[mp.episodeId].y"]
  [elsif exp="tf.theaterProgress === EPISODE_STATUS.INTRO_UNLOCKED_OUTRO_LOCKED"]
    ; 「2：導入編解放済みで解決編未解放」なら銀枠
    [image storage="theater/theater_silver_frame.png" layer="0" name="theater1" x="&tf.episodeCoodinate[mp.episodeId].x" y="&tf.episodeCoodinate[mp.episodeId].y"]
  [endif]
[endmacro]



; このマクロ内で更新するゲーム変数
; f.startingSituation    : シチュエーション開始条件に合致したエピソードのページIDとエピソードID。合致しなかった場合は値はnullのまま。{pageId: String|null, episodeId: String|null}
; f.needPlayIntroChapter : 導入編を自動再生するフラグ。true: 自動再生する | false: 自動再生しない
; f.targetJinroGameData  : ゲーム開始時に利用する人狼ゲームデータオブジェクト。合致したエピソードがあれば、そのシチュエーションに合わせて書き換えられる。なければ現在の人狼ゲームデータ自体のディープコピー。
[macro name="t_setStartingSituation"]
  [iscript]
    // このマクロ内で更新するゲーム変数の初期化
    f.startingSituation = {
      pageId: null,
      episodeId: null
    }
    f.needPlayIntroChapter = false;

    // 元々の人狼ゲームデータに書き換えを反映させないために、オブジェクトをcloneする
    const jinroGameData = mp.jinroGameData || sf.jinroGameDataObjects[sf.currentJinroGameDataKey];
    f.targetJinroGameData = clone(jinroGameData);

    // 「1:導入編未解放かつ解放可」のエピソードに対して、シチュエーション開始条件に合致したかのチェック
    const introAvailableEpisodes = getEpisodesByStatus(EPISODE_STATUS.INTRO_LOCKED_AVAILABLE, sf.theaterProgress);
    [f.needPlayIntroChapter, f.startingSituation.pageId, f.startingSituation.episodeId, f.targetJinroGameData] = checkMatchingEpisodeSituation(introAvailableEpisodes, f.targetJinroGameData);
    // 合致したエピソードがあった場合、再生済みエピソードをスキップする設定でも自動再生する（未再生なので）

    // シチュエーション開始条件に合致した「1:導入編未解放かつ解放可」のエピソードがなかった場合
    if (!f.needPlayIntroChapter) {
      // 「2:導入編解放済みで解決編未解放」のエピソードに対して、シチュエーション開始条件に合致したかのチェック
      const introUnlockedEpisodes = getEpisodesByStatus(EPISODE_STATUS.INTRO_UNLOCKED_OUTRO_LOCKED, sf.theaterProgress);
      [f.needPlayIntroChapter, f.startingSituation.pageId, f.startingSituation.episodeId, f.targetJinroGameData] = checkMatchingEpisodeSituation(introUnlockedEpisodes, f.targetJinroGameData);

      // 合致したエピソードがあったとしても、再生済みエピソードをスキップする設定なら自動再生はしない（ここに入ってきている＝再生済みなので）
      if (sf.doSkipPlayedEpisode) {
        f.needPlayIntroChapter = false;
      }
    }

    console.debug('★f.startingSituation');
    console.debug(f.startingSituation);
  [endscript]
[endmacro]


; f.chapterListに登録されているチャプターのうち、指定されたチャプターを再生する
; シアターや幕間のチャプターを再生するときには必ずこのマクロを使うこと
; @param string target チャプターリスト内のキー名
[macro name="t_playChapter"]
  [iscript]
    // チャプターリストの中に指定のキーが存在し、かつそのChapterオブジェクトのneedPlayフラグが立っていれば、再生する
    tf.targetChapter = (mp.target in f.chapterList) ? f.chapterList[mp.target] : null;
    tf.needPlay = (tf.targetChapter !== null && tf.targetChapter.needPlay);

    // 対象のChapterオブジェクトの再生フラグを折る
    if (tf.needPlay) {
      f.chapterList[mp.target].needPlay = false;
    }
    // チャプター再生後にこのファイルに戻って来るために変数設定
    f.returnJumpStorage = 'theater/macros.ks';
    f.returnJumpTarget = '*end_t_playChapter';
  [endscript]

  ; あえて[call]ではなく[jump]を使う。[call]だと再生中にスタックが残っておりfixボタンが押せなくなるため
  [jump storage="&tf.targetChapter.storage" target="&tf.targetChapter.target" cond="tf.needPlay"]
  ; MEMO:チャプターから戻って来るときには以下のタグを使う
  ; [jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
  *end_t_playChapter
[endmacro]