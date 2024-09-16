; サブルーチン
; f.displayEpisodeにエピソードオブジェクトを格納しておくこと
; 複数回ループで呼ばれることを考慮し、表示開始前後の処理（背景ブラーやメッセージレイヤの表示非表示など）は基本的に呼び元で行うこと。
; ただし「解決編を見る」「導入編から見る」ボタンを押した場合はこのサブルーチン内で後片付けすること。

*start
; 利用する変数の初期化
[eval exp="tf.buttonColor = CLASS_GLINK_DEFAULT"]

[image storage="theater/episodeWindow_rectangle.png" layer="1" page="back" name="episodeWindow" x="158.5" y="38"]
[kanim name="episodeWindow" keyframe="open_episodeWindow" time="150" easing="ease-out"]

[image storage="&f.displayEpisode.thumbnail" layer="1" page="back" left="424" top="80" height="243" name="thumbnail"]
[ptext layer="1" page="back" text="&f.displayEpisode.title" face="MPLUSRounded" size="36" x="180" y="330" width="920" align="center"]

; ✕ボタンまたは枠外（左右上下）のクリックは「あとで見る」ボタンと同義
[glink color="&tf.buttonColor" size="35" width="70" x="1005" y="85" text="✕" target="*closeAchieveEpisode"]
[clickable width="174" height="720" x="0" y="0" target="*closeAchieveEpisode"]
[clickable width="174" height="720" x="1105" y="0" target="*closeAchieveEpisode"]
[clickable width="1280" height="55" x="0" y="0" target="*closeAchieveEpisode"]
[clickable width="1280" height="55" x="0" y="665" target="*closeAchieveEpisode"]

[ptext layer="1" page="back" text="の解決編が解放されました！" size="28" x="180" y="380" width="920" align="center"]

; 導入編を視聴済みなら「解決編を見る」ボタンを、未視聴なら「導入編から見る」ボタンを表示する
[t_isProgressWatched pageId="&f.displayEpisode.pageId" episodeId="&f.displayEpisode.episodeId" chapterId="c01"]
[if exp="tf.isProgressWatched"]
  [glink color="&tf.buttonColor" size="24" width="300" x="488" y="435" text="解決編を見る" target="*startOutro"]
[else]
  [glink color="&tf.buttonColor" size="24" width="300" x="488" y="435" text="導入編から見る" target="*startIntro"]
[endif]

; 「あとで見る」ボタン
[glink color="&tf.buttonColor" size="24" width="300" x="488" y="510" text="あとで見る" target="*closeAchieveEpisode"]

; 達成した解放条件テキスト
[ptext layer="1" page="back" text="&f.displayEpisode.unlockCondition" face="MPLUSRounded" size="26" x="180" y="570" width="920" align="center"]

[trans layer="1" time="0"]
[s]


; TODO
*startIntro
[free_filter layer="0"]
[free_filter layer="base"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[freeimage layer="0"]
[stopbgm]
[endnowait]
[layopt layer="message0" visible="true"]

[iscript]
  f.inJinroGame = false;
  f.isSituationPlay = false;
[endscript]

[jump storage="&f.displayEpisode.introChapter.storage"]
[s]


; TODO
*startOutro
[free_filter layer="0"]
[free_filter layer="base"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[freeimage layer="0"]
[stopbgm]
[endnowait]
[layopt layer="message0" visible="true"]

[iscript]
  f.inJinroGame = false;
  f.isSituationPlay = false;
[endscript]

[jump storage="&f.displayEpisode.outroChapter.storage"]
[s]


*closeAchieveEpisode
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[return]
[s]
