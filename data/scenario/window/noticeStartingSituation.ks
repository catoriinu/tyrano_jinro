; 開始条件達成通知ウィンドウ表示用サブルーチン
; f.displayEpisodeにエピソードオブジェクトを格納しておくこと
*start
  ; 利用する変数の初期化
  [iscript]
    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;
    tf.needDisplayConditionText = false;
  [endscript]

  [image storage="theater/episodeWindow_rectangle.png" layer="1" page="back" name="episodeWindow" x="158.5" y="38"]
  [kanim name="episodeWindow" keyframe="open_episodeWindow" time="150" easing="ease-out"]

  [image storage="&f.displayEpisode.thumbnail" layer="1" page="back" left="424" top="80" height="243" name="thumbnail"]
  [ptext layer="1" page="back" text="&f.displayEpisode.title" face="MPLUSRounded" size="36" x="180" y="330" width="920" align="center"]

  [ptext layer="1" page="back" text="解決編解放チャンス！" size="28" x="180" y="380" width="920" align="center"]

  [trans layer="1" time="0"]

  *displayButtons
  ; 枠外（左右上下）のクリックは「スタート」ボタンと同義
  [clickable width="174" height="720" x="0" y="0" target="*close"]
  [clickable width="174" height="720" x="1105" y="0" target="*close"]
  [clickable width="1280" height="55" x="0" y="0" target="*close"]
  [clickable width="1280" height="55" x="0" y="665" target="*close"]

  [glink color="&tf.buttonColor" size="24" width="420" x="428" y="470" text="解放条件を見る（ネタバレあり）" target="*displayConditionText" cond="!tf.needDisplayConditionText"]
  [glink color="&tf.selectedButtonColor" size="24" width="300" x="488" y="580" text="スタート" target="*close"]
[s]



*displayConditionText
  ; 開始条件と解放条件テキストを表示する
  [ptext layer="1" page="fore" text="&f.displayEpisode.startConditionText" face="MPLUSRounded" size="26" x="180" y="455" width="920" align="center"]
  [ptext layer="1" page="fore" text="&f.displayEpisode.unlockCondition" face="MPLUSRounded" size="26" x="180" y="520" width="920" align="center"]
  [eval exp="tf.needDisplayConditionText = true"]
  [jump target="*displayButtons"]
[s]



*close
  [freeimage layer="1" page="fore" time="130" wait="false"]
  [freeimage layer="1" page="back" time="130" wait="false"]
[return]
[s]
