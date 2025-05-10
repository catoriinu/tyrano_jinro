; 開始条件達成通知ウィンドウ表示用サブルーチン
; f.displayEpisodeにエピソードオブジェクトを格納しておくこと
*start
  ; 利用する変数の初期化
  [iscript]
    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;
    tf.classButtonSeHover = CLASS_BUTTON_SE_HOVER;

    // 開始条件テキストとプレイスタートボタン、および解放条件テキストを表示するかのフラグ。ウィンドウ表示時点では表示しない
    tf.needDisplayStartConditionText = false;
    tf.needDisplayUnlockConditionText = false;
  [endscript]

  [image storage="&f.displayEpisode.thumbnail" layer="2" page="back" left="424" top="80" height="243" name="thumbnail"]
  [ptext layer="2" page="back" text="&f.displayEpisode.title" face="MPLUSRounded" size="36" x="180" y="330" width="920" align="center"]

  [ptext layer="2" page="back" text="解決編解放チャンス！" size="26" x="180" y="410" width="920" align="center"]

  ; 開始条件テキストと解放条件テキスト。初期から表示してよいならここで裏ページに表示して、直後にtransで表ページに切り替える
  [ptext layer="2" page="back" text="&f.displayEpisode.startConditionText" face="MPLUSRounded" size="26" x="180" y="475" width="920" align="center" name="startConditionText" overwrite="true" cond="tf.needDisplayStartConditionText"]
  [ptext layer="2" page="back" text="&f.displayEpisode.unlockConditionText" face="MPLUSRounded" size="26" x="180" y="565" width="920" align="center" name="unlockConditionText" overwrite="true" cond="tf.needDisplayUnlockConditionText"]

  [trans layer="2" time="0"]

  *displayButtons
  ; 閉じるボタンまたは枠外（左右上下）のクリックで閉じる
  [glink color="&tf.selectedButtonColor" size="26" width="210" x="875" y="80" text="閉じる" target="*close" enterse="se/button34.ogg" clickse="se/button15.ogg"]
  [w_makeClickableAreaOuterWindow storage="window/noticeStartingSituation.ks" target="*close"]

  ; 開始条件テキストと解放条件テキスト。ボタンを押して表示する場合はここで表ページに表示させる。overwrite="true"を指定しているので既に表示済みの場合は上書き表示になる（＝重複表示はされない）
  [ptext layer="2" page="fore" text="&f.displayEpisode.startConditionText" face="MPLUSRounded" size="26" x="180" y="475" width="920" align="center" name="startConditionText" overwrite="true" cond="tf.needDisplayStartConditionText"]
  [ptext layer="2" page="fore" text="&f.displayEpisode.unlockConditionText" face="MPLUSRounded" size="26" x="180" y="565" width="920" align="center" name="unlockConditionText" overwrite="true" cond="tf.needDisplayUnlockConditionText"]

  [glink color="&tf.buttonColor" size="26" width="450" x="413" y="490" text="開始条件を見る（ネタバレ注意）" target="*displayStartConditionText" cond="!tf.needDisplayStartConditionText" enterse="se/button34.ogg" clickse="se/button13.ogg"]
  [glink color="&tf.buttonColor" size="26" width="450" x="413" y="580" text="解放条件を見る（ネタバレ注意）" target="*displayUnlockConditionText" cond="!tf.needDisplayUnlockConditionText" enterse="se/button34.ogg" clickse="se/button13.ogg"]

  [eval exp="setButtonSe()"]
[s]


*displayStartConditionText
  [eval exp="tf.needDisplayStartConditionText = true"]
  [jump target="*displayButtons"]
[s]


*displayUnlockConditionText
  [eval exp="tf.needDisplayUnlockConditionText = true"]
  [jump target="*displayButtons"]
[s]


*close
  [return]
[s]
