; エピソードウィンドウ

*start
  [iscript]
    // 利用する変数の初期化
    f.displayEpisode = f.episodeList[f.displayEpisodeId];
    tf.episodeStatus = getTheaterProgress(f.displayPageId, f.displayEpisodeId);

    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;

    f.currentFrame = null;
    // 開始条件テキストとプレイスタートボタン、および解放条件テキストを表示するかのフラグ。
    // 進捗が「3：解決編まで解放済み」の場合のみ初期から表示する。それ以外なら表示用ボタンを押すまで表示しない
    tf.needDisplayStartConditionText = (tf.episodeStatus === EPISODE_STATUS.OUTRO_UNLOCKED);
    tf.needDisplayUnlockConditionText = (tf.episodeStatus === EPISODE_STATUS.OUTRO_UNLOCKED);
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

  [glink color="&tf.buttonColor" size="26" width="210" x="385" y="400" text="導入編" target="*startIntro"]
  [glink color="&tf.buttonColor" size="26" width="210" x="681" y="400" text="解決編" target="*startOutro"]

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


; TODO 削除予定。もしくは中身を修正する必要あり
*startSituationPlay
[free_filter layer="0"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[freeimage layer="0"]
[stopbgm]
[endnowait]
[layopt layer="message0" visible="true"]

; シチュエーションプレイで人狼ゲームを開始したフラグ（人狼ゲーム終了時にエピソード画面に戻ってくるため）
[eval exp="f.isSituationPlay = true"]

[t_registerSituationParticipants]
[j_prepareJinroGame participantsNumber="&f.displayEpisode.situation.participantsNumber" preload="true"]

[jump storage="playJinro.ks"]
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
