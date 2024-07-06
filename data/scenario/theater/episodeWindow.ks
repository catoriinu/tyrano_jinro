; エピソードウィンドウ

*start
; 利用する変数の初期化
[eval exp="f.displayEpisode = f.episodeList[f.displayEpisodeId]"]
[eval exp="tf.buttonColor = CLASS_GLINK_DEFAULT"]

[layopt layer="message0" visible="false"]
[filter layer="0" blur="10"]

[image storage="theater/episodeWindow_rectangle.png" layer="1" page="back" name="episodeWindow" x="158.5" y="38"]
[kanim name="episodeWindow" keyframe="open_episodeWindow" time="150" easing="ease-out"]

[image storage="&f.displayEpisode.thumbnail" layer="1" page="back" left="424" top="80" height="243" name="thumbnail"]
[ptext layer="1" page="back" text="&f.displayEpisode.title" face="MPLUSRounded" size="36" x="180" y="330" width="920" align="center"]

; ✕ボタンまたは枠外（左右上下）のクリックで一覧に戻る
[glink color="&tf.buttonColor" size="35" width="70" x="1005" y="85" text="✕" target="*returnMain"]
[clickable width="174" height="720" x="0" y="0" target="*returnMain"]
[clickable width="174" height="720" x="1105" y="0" target="*returnMain"]
[clickable width="1280" height="55" x="0" y="0" target="*returnMain"]
[clickable width="1280" height="55" x="0" y="665" target="*returnMain"]

; 「導入編を見る」ボタン
[glink color="&tf.buttonColor" size="26" width="300" x="488" y="395" text="導入編を見る" target="*startIntro"]

; 「このシチュエーションでプレイする」ボタンまたはプレイできない理由を表示
[if exp="f.displayEpisode.cantPlayReason === null"]
  [glink color="&tf.buttonColor" size="26" width="450" x="412.9" y="480" text="このシチュエーションでプレイする" target="*startSituationPlay"]
[else]
  [ptext layer="1" page="back" text="&f.displayEpisode.cantPlayReason" face="MPLUSRounded" size="30" x="180" y="480" width="920" align="center"]
[endif]


; 「解決編を見る」ボタンまたは解放条件
[t_isProgressLocked pageId="&f.displayPageId" episodeId="&f.displayEpisodeId" chapterId="c02"]
[if exp="tf.isProgressLocked"]
  ; 解決編がロック中の場合、解放条件を表示する
  [ptext layer="1" page="back" text="&f.displayEpisode.unlockCondition" face="MPLUSRounded" size="30" x="180" y="555" width="920" align="center"]
[else]

  [t_isProgressUnlocked pageId="&f.displayPageId" episodeId="&f.displayEpisodeId" chapterId="c01"]
  [if exp="tf.isProgressUnlocked"]
    ; 解決編の解放条件は達成済みだが導入編を未視聴の場合、誘導テキストを表示する
    [ptext layer="1" page="back" text="解決編は導入編を見ると解放されます" face="MPLUSRounded" size="30" x="180" y="555" width="920" align="center"]
  [else]
    ; 解決編を見てよい状態なら「解決編を見る」ボタンを表示する
    [glink color="&tf.buttonColor" size="26" width="300" x="488" y="565" text="解決編を見る" target="*startOutro"]
  [endif]
[endif]

[trans layer="1" time="0"]
[s]


*startIntro
[free_filter layer="0"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[freeimage layer="0"]
[stopbgm]
[endnowait]
[layopt layer="message0" visible="true"]

[jump storage="&f.displayEpisode.introChapter.storage"]
[s]


*startOutro
[free_filter layer="0"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[freeimage layer="0"]
[stopbgm]
[endnowait]
[layopt layer="message0" visible="true"]

[jump storage="&f.displayEpisode.outroChapter.storage"]
[s]


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


*returnMain
[free_filter layer="0"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[layopt layer="message0" visible="true"]
[jump storage="theater/main.ks" target="*hideEpisodeWindow"]
[s]
