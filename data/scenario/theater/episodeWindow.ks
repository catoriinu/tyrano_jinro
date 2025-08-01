; エピソードウィンドウ

*start
  [iscript]
    // 利用する変数の初期化
    f.displayEpisode = f.episodeList[f.displayEpisodeId];
    tf.episodeStatus = getTheaterProgress(f.displayPageId, f.displayEpisodeId);

    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;

    f.currentFrame = null;

    tf.isUnlockedIntro = (tf.episodeStatus !== EPISODE_STATUS.INTRO_LOCKED_AVAILABLE); // 0はこのウィンドウを開けている時点でありえないため、1以外で判定する
    tf.isUnlockedOutro = (tf.episodeStatus === EPISODE_STATUS.OUTRO_UNLOCKED);

    // 開始条件テキストとプレイスタートボタン、および解放条件テキストを表示するかのフラグ。
    // 進捗が「3：解決編まで解放済み」の場合のみ初期から表示する。それ以外なら表示用ボタンを押すまで表示しない
    tf.needDisplayStartConditionText = tf.isUnlockedOutro;
    tf.needDisplayUnlockConditionText = tf.isUnlockedOutro;
  [endscript]

  [w_openWindow hideMessage="true"]

  [image storage="&f.displayEpisode.thumbnail" layer="2" page="back" left="424" top="80" height="243" name="thumbnail"]
  [ptext layer="2" page="back" text="&f.displayEpisode.title" face="MPLUSRounded" size="36" x="180" y="330" width="920" align="center"]

  ; 開始条件テキストと解放条件テキスト。初期から表示してよいならここで裏ページに表示して、直後にtransで表ページに切り替える
  [ptext layer="2" page="back" text="&f.displayEpisode.startConditionText" face="MPLUSRounded" size="26" x="180" y="475" width="920" align="center" name="startConditionText" overwrite="true" cond="tf.needDisplayStartConditionText"]
  [ptext layer="2" page="back" text="&f.displayEpisode.unlockConditionText" face="MPLUSRounded" size="26" x="180" y="565" width="920" align="center" name="unlockConditionText" overwrite="true" cond="tf.needDisplayUnlockConditionText"]
  ; 導入編も未解放なら代替テキストを表示する
  [ptext layer="2" page="back" text="開始条件を満たしてプレイスタートすると、導入編が自動再生されます" face="MPLUSRounded" size="26" x="180" y="410" width="920" align="center" cond="!tf.isUnlockedIntro && !tf.isUnlockedOutro"]

  [trans layer="2" time="0"]

  *displayButtons
  ; 閉じるボタンまたは枠外（左右上下）のクリックで一覧に戻る
  [glink color="&tf.selectedButtonColor" size="26" width="210" x="875" y="80" text="閉じる" target="*returnMain" enterse="se/button34.ogg" clickse="se/button15.ogg"]
  [w_makeClickableAreaOuterWindow storage="theater/episodeWindow.ks" target="*returnMain"]

  [glink color="&tf.buttonColor" size="26" width="210" x="385" y="400" text="導入編" target="*startIntro" cond="tf.isUnlockedIntro" enterse="se/button34.ogg" clickse="se/button13.ogg"]
  [glink color="&tf.buttonColor" size="26" width="210" x="681" y="400" text="解決編" target="*startOutro" cond="tf.isUnlockedOutro" enterse="se/button34.ogg" clickse="se/button13.ogg"]

  [glink color="&tf.buttonColor" size="26" width="210" x="875" y="240" text="この開始条件で<br>プレイスタート" target="*startSituationPlay" cond="tf.needDisplayStartConditionText" enterse="se/button34.ogg" clickse="se/button13.ogg"]
  ; 開始条件テキストと解放条件テキスト。ボタンを押して表示する場合はここで表ページに表示させる。overwrite="true"を指定しているので既に表示済みの場合は上書き表示になる（＝重複表示はされない）
  [ptext layer="2" page="fore" text="&f.displayEpisode.startConditionText" face="MPLUSRounded" size="26" x="180" y="475" width="920" align="center" name="startConditionText" overwrite="true" cond="tf.needDisplayStartConditionText"]
  [ptext layer="2" page="fore" text="&f.displayEpisode.unlockConditionText" face="MPLUSRounded" size="26" x="180" y="565" width="920" align="center" name="unlockConditionText" overwrite="true" cond="tf.needDisplayUnlockConditionText"]

  [glink color="&tf.buttonColor" size="26" width="450" x="413" y="490" text="開始条件を見る（ネタバレ注意）" target="*displayStartConditionText" cond="!tf.needDisplayStartConditionText" enterse="se/button34.ogg" clickse="se/button13.ogg"]
  [glink color="&tf.buttonColor" size="26" width="450" x="413" y="580" text="解放条件を見る（ネタバレ注意）" target="*displayUnlockConditionText" cond="!tf.needDisplayUnlockConditionText" enterse="se/button34.ogg" clickse="se/button13.ogg"]
[s]


*displayStartConditionText
  [eval exp="tf.needDisplayStartConditionText = true"]
  [jump target="*displayButtons"]
[s]


*displayUnlockConditionText
  [eval exp="tf.needDisplayUnlockConditionText = true"]
  [jump target="*displayButtons"]
[s]


*startIntro
  [freeimage layer="0"]
  ; ウィンドウを閉じるアニメーション処理を待機する。待機しないとレイヤー削除処理が、この後のカットイン処理に被ってしまう
  [w_closeWindow waitAnime="true"]
  [stopbgm]
  [endnowait]

  [iscript]
    f.chapterList.introChapter = {
      storage: f.displayEpisode.introChapter.storage,
      target: f.displayEpisode.introChapter.target,
      needPlay: true
    };
  [endscript]

  [t_playChapter target="introChapter"]
  ; シアターのメイン画面から描画し、このウィンドウを自動で開くところまで実行する
  [jump storage="theater/main.ks" target="*start"]
[s]


*startOutro
  [freeimage layer="0"]
  ; ウィンドウを閉じるアニメーション処理を待機する。待機しないとレイヤー削除処理が、この後のカットイン処理に被ってしまう
  [w_closeWindow waitAnime="true"]
  [stopbgm]
  [endnowait]

  [iscript]
    f.chapterList.outroChapter = {
      storage: f.displayEpisode.outroChapter.storage,
      target: f.displayEpisode.outroChapter.target,
      needPlay: true
    };
  [endscript]

  [t_playChapter target="outroChapter"]
  ; シアターのメイン画面から描画し、このウィンドウを自動で開くところまで実行する
  [jump storage="theater/main.ks" target="*start"]
[s]


*startSituationPlay
  [freeimage layer="0"]
  ; ウィンドウを閉じるアニメーション処理を待機する。待機しないとレイヤー削除処理が、この後のカットイン処理に被ってしまう
  [w_closeWindow waitAnime="true"]
  [stopbgm]
  [endnowait]

  ; [t_setStartingSituation]内で設定する変数をこの場で設定してから、選択したシチュエーションで人狼ゲームを始める
  [iscript]
    f.startingSituation = {
      pageId: f.displayPageId,
      episodeId: f.displayEpisodeId
    };

    // 導入編が未解放である、または解放済みであっても自動再生する設定であれば、導入編を自動再生する
    f.needPlayIntroChapter = (!tf.isUnlockedIntro || !sf.doSkipPlayedEpisode);

    const jinroGameDataForTheater = getJinroGameDataForTheater(f.displayPageId);
    let isMatched = false;
    [isMatched, f.targetJinroGameData] = isMatchEpisodeSituation(f.displayEpisode.situationJinroGameData, jinroGameDataForTheater);
    if (!isMatched) {
      alert('開始条件に合致する人狼ゲームデータを準備できませんでした。getJinroGameDataForTheater()の返却値を確認してください。');
    }
  [endscript]
  [jump storage="prepareJinro.ks" target="*hasStartingSituationBeenSet"]
[s]


*returnMain
[w_closeWindow waitAnime="false"]
[jump storage="theater/main.ks" target="*hideEpisodeWindow"]
[s]
