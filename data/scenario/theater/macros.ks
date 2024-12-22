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
  1 // TODO getTheaterProgressの第3引数を削除して判定を変えること
    tf.tmpParticipantObjectList = clone(f.displayEpisode.situation.participantsList);
  [endscript]
[endmacro]


; 指定されたチャプターの進捗が「未解放」なら一時変数にtrueを格納する
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_isProgressLocked"]
  [iscript]
    // TODO getTheaterProgressの第3引数を削除して判定を変えること
    tf.isProgressLocked = (getTheaterProgress(mp.pageId, mp.episodeId, mp.chapterId) === THEATER_LOCKED);
  [endscript]
[endmacro]


; 指定されたチャプターの進捗が「解放済みだが未視聴」なら一時変数にtrueを格納する
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_isProgressUnlocked"]
  [iscript]
    // TODO getTheaterProgressの第3引数を削除して判定を変えること
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


; チャプター視聴開始時の準備用マクロ
; @param chapterId
; @param actorsList
; @param bgParams
; @param playbgmParams
[macro name="t_setupChapter"]
  [cm]
  [clearfix]
  [start_keyconfig]

  [t_clearDisplay]

  ; 背景
  [bg storage="&mp.bgParams.storage" time="300"]

  ; BGM
  [playbgm storage="&mp.playbgmParams.storage" loop="true" volume="&mp.playbgmParams.volume" restart="false"]

  ;このシナリオで登場する全キャラクターを宣言、表情登録
  [eval exp="tf.registerCharacterList = mp.actorsList"]
  [call storage="./chara/common.ks" target="*registerCharacters"]

  [iscript]
    // 再生中のチャプターのファイルパスを生成しておく（スキップからの再開のため・コンフィグでチャプター再生中と判定するため）
    f.chapterStorage = 'theater/' + f.pageId + '/' + f.episodeId + '_' + f.chapterId + '.ks';

    // シアター終了後のジャンプ先を指定する。指定があればそこへ、なければシアター画面に戻る
    f.currentReturnJumpStorage = f.returnJumpStorage || 'theater/main.ks';
    f.currentReturnJumpTarget = f.returnJumpTarget || '*start';
    // 次に使うときには初期化されていてほしいので指定用変数はここで初期化する
    f.returnJumpStorage = null;
    f.returnJumpTarget = null;

    // エピソード解放ステータスの更新
    // 解決編の場合、「2：導入編解放済みで解決編未解放」なら「3：解決編まで解放済み」に更新する
    if (mp.chapterId === 'c02') {
      sf.theaterProgress[mp.pageId][mp.episodeId] = advanceEpisodeStatus(mp.pageId, mp.episodeId, EPISODE_STATUS.OUTRO_UNLOCKED);
    }
  [endscript]

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
      sf.theaterProgress[mp.pageId][mp.episodeId] = advanceEpisodeStatus(mp.pageId, mp.episodeId, EPISODE_STATUS.INTRO_UNLOCKED_OUTRO_LOCKED);
    }
  [endscript]

  ; 視聴終了時に解放すべきシアター進捗があれば解放する
  [call storage="theater/episodeSubroutines.ks" target="*unlockNextEpisode"]

  ; チャプター再生中に表示している可能性があるものは全て画面から消す（途中でスキップされた場合もここで消せるようにするため）
  [t_clearDisplay]
[endmacro]


[macro name="t_clearDisplay"]
  [j_clearFixButton]
  [m_exitCharacter characterId="&f.displayedCharacter.left.characterId" time="1"]
  [m_exitCharacter characterId="&f.displayedCharacter.right.characterId" time="1"]
  [freeimage layer="1"]
  [freeimage layer="2"]
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
    let tmpNeedPlayIntroChapter = false;

    // 元々の人狼ゲームデータに書き換えを反映させないために、オブジェクトをcloneする
    const jinroGameData = mp.jinroGameData || sf.jinroGameDataObjects[sf.currentJinroGameDataKey];
    f.targetJinroGameData = clone(jinroGameData);

    // 「導入編未解放かつ解放可」のエピソードに対して、シチュエーション開始条件に合致したかのチェック
    const introAvailableEpisodes = getEpisodesByStatus(EPISODE_STATUS.INTRO_LOCKED_AVAILABLE, sf.theaterProgress);
    [tmpNeedPlayIntroChapter, f.startingSituation.pageId, f.startingSituation.episodeId, f.targetJinroGameData] = checkMatchingEpisodeSituation(introAvailableEpisodes, f.targetJinroGameData);

    // シチュエーション開始条件に合致した「導入編未解放かつ解放可」のエピソードがなかった場合
    if (!tmpNeedPlayIntroChapter) {
      // 「導入編解放済みで解決編未解放」のエピソードに対して、シチュエーション開始条件に合致したかのチェック
      const introUnlockedEpisodes = getEpisodesByStatus(EPISODE_STATUS.INTRO_UNLOCKED_OUTRO_LOCKED, sf.theaterProgress);
      [, f.startingSituation.pageId, f.startingSituation.episodeId, f.targetJinroGameData] = checkMatchingEpisodeSituation(introUnlockedEpisodes, f.targetJinroGameData);
      // 合致したエピソードがあってもなくても、tmpNeedPlayIntroChapterはfalseのままとする。
    }

    // TODO 「視聴済みの導入編を自動スキップする」チェックボックスを導入する場合はこのあたりの修正が必要
    f.needPlayIntroChapter = tmpNeedPlayIntroChapter;

    console.log('★f.startingSituation');
    console.log(f.startingSituation);
  [endscript]
[endmacro]


; f.chapterListに登録されているチャプターのうち、指定されたチャプターを再生する
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
    // チャプター再生後にこのファイルに戻って来るために変数設定 関連マクロ：[t_setupChapter]
    // MEMO：シアターでもこのマクロを経由して再生するルールにすれば、「シアター終了後のジャンプ先を指定する。指定があればそこへ、なければシアター画面に戻る」は不要になりそう
    f.returnJumpStorage = 'theater/macros.ks';
    f.returnJumpTarget = '*end_t_playChapter';
  [endscript]
  ; あえて[call]ではなく[jump]を使う。[call]だと再生中にスタックが残っておりfixボタンが押せなくなるため
  [jump storage="&tf.targetChapter.storage" target="&tf.targetChapter.target" cond="tf.needPlay"]
  ; MEMO:戻って来るときは基本的には下記を使う
  ; [jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
  *end_t_playChapter
[endmacro]