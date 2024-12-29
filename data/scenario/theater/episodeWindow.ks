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

  [layopt layer="message0" visible="false"]
  [filter layer="0" blur="10"]

  [image storage="theater/episodeWindow_rectangle.png" layer="1" page="back" name="episodeWindow" x="158.5" y="38"]
  [kanim name="episodeWindow" keyframe="open_episodeWindow" time="150" easing="ease-out"]

  [image storage="&f.displayEpisode.thumbnail" layer="1" page="back" left="424" top="80" height="243" name="thumbnail"]
  [ptext layer="1" page="back" text="&f.displayEpisode.title" face="MPLUSRounded" size="36" x="180" y="330" width="920" align="center"]

  ; 開始条件テキストと解放条件テキスト。初期から表示してよいならここで裏ページに表示して、直後にtransで表ページに切り替える
  [ptext layer="1" page="back" text="&f.displayEpisode.startConditionText" face="MPLUSRounded" size="26" x="180" y="475" width="920" align="center" name="startConditionText" overwrite="true" cond="tf.needDisplayStartConditionText"]
  [ptext layer="1" page="back" text="&f.displayEpisode.unlockCondition" face="MPLUSRounded" size="26" x="180" y="565" width="920" align="center" name="unlockConditionText" overwrite="true" cond="tf.needDisplayUnlockConditionText"]

  [trans layer="1" time="0"]

  *displayButtons
  ; 閉じるボタンまたは枠外（左右上下）のクリックで一覧に戻る
  [glink color="&tf.selectedButtonColor" size="26" width="210" x="875" y="100" text="閉じる" target="*returnMain"]
  [clickable width="174" height="720" x="0" y="0" target="*returnMain"]
  [clickable width="174" height="720" x="1105" y="0" target="*returnMain"]
  [clickable width="1280" height="55" x="0" y="0" target="*returnMain"]
  [clickable width="1280" height="55" x="0" y="665" target="*returnMain"]

  [glink color="&tf.buttonColor" size="26" width="210" x="385" y="400" text="導入編" target="*startIntro" cond="tf.isUnlockedIntro"]
  [glink color="&tf.buttonColor" size="26" width="210" x="681" y="400" text="解決編" target="*startOutro" cond="tf.isUnlockedOutro"]

  [glink color="&tf.buttonColor" size="26" width="210" x="875" y="200" text="この開始条件で<br>プレイスタート" target="*startSituationPlay" cond="tf.needDisplayStartConditionText"]
  ; 開始条件テキストと解放条件テキスト。ボタンを押して表示する場合はここで表ページに表示させる。overwrite="true"を指定しているので既に表示済みの場合は上書き表示になる（＝重複表示はされない）
  [ptext layer="1" page="fore" text="&f.displayEpisode.startConditionText" face="MPLUSRounded" size="26" x="180" y="475" width="920" align="center" name="startConditionText" overwrite="true" cond="tf.needDisplayStartConditionText"]
  [ptext layer="1" page="fore" text="&f.displayEpisode.unlockCondition" face="MPLUSRounded" size="26" x="180" y="565" width="920" align="center" name="unlockConditionText" overwrite="true" cond="tf.needDisplayUnlockConditionText"]

  [glink color="&tf.buttonColor" size="26" width="450" x="413" y="490" text="開始条件を見る（ネタバレ注意）" target="*displayStartConditionText" cond="!tf.needDisplayStartConditionText"]
  [glink color="&tf.buttonColor" size="26" width="450" x="413" y="580" text="解放条件を見る（ネタバレ注意）" target="*displayUnlockConditionText" cond="!tf.needDisplayUnlockConditionText"]

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
[free_filter layer="0"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[freeimage layer="0"]
[stopbgm]
[endnowait]
[layopt layer="message0" visible="true"]

[jump storage="&f.displayEpisode.introChapter.storage" target="*start"]
[s]


*startOutro
[free_filter layer="0"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[freeimage layer="0"]
[stopbgm]
[endnowait]
[layopt layer="message0" visible="true"]

[jump storage="&f.displayEpisode.outroChapter.storage" target="*start"]
[s]


*startSituationPlay
  [free_filter layer="0"]
  [freeimage layer="1" page="fore"]
  [freeimage layer="1" page="back"]
  [freeimage layer="0"]
  [stopbgm]
  [endnowait]
  [layopt layer="message0" visible="true"]


  ; [t_setStartingSituation]内で設定する変数をこの場で設定してから、選択したシチュエーションで人狼ゲームを始める
  [iscript]
    f.startingSituation = {
      pageId: f.displayPageId,
      episodeId: f.displayEpisodeId
    };

    // 導入編が未解放である、または解放済みであっても自動再生する設定であれば、導入編を自動再生する
    f.needPlayIntroChapter = (!tf.isUnlockedIntro || !sf.doSkipWatchedChapter);

    const jinroGameDataForTheater = getJinroGameDataForTheater(f.displayPageId);
    let isMatched = false;
    [isMatched, f.targetJinroGameData] = isMatchEpisodeSituation(f.displayEpisode.situationJinroGameData, jinroGameDataForTheater);
    if (!isMatched) {
      alert('開始条件に合致する人狼ゲームデータを準備できませんでした。getJinroGameDataForTheater()の返却値を確認してください。');
    }
  [endscript]
  [jump storage="prepareJinro.ks" target="*hasStartingSituationBeenSet"]
[s]


; チュートリアル用ラベル
; MEMO 現在のところ、p01_e01でしか考慮していないので他で呼ぶ場合は要修正
*startTutorialPlay
[free_filter layer="0"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[freeimage layer="0"]
[stopbgm]
[endnowait]
[layopt layer="message0" visible="true"]

; シチュエーションプレイで人狼ゲームを開始したフラグ（人狼ゲーム終了時にエピソード画面に戻ってくるため）
[eval exp="f.isSituationPlay = true"]

; チュートリアル用ラベルにジャンプする。人狼ゲームの準備も含めてジャンプ先でやってくれる
[jump storage="tutorial/tutorialSubroutines.ks" target="*toFirstInstruction"]
[s]


*returnMain
[free_filter layer="0"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[layopt layer="message0" visible="true"]
[jump storage="theater/main.ks" target="*hideEpisodeWindow"]
[s]
