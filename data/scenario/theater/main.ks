; シアター画面のメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]

; シアター画面ではテキストは瞬間表示
[nowait]


[bg storage="bg_fafafa.png" time="300"]

; シアター一覧の1ページ目の情報を取得
[eval exp="f.displayPageId = 'p01'"]

*loadTheaterList
[freeimage layer="0"]
[loadEpisodeList pageId="&f.displayPageId"]

[iscript]
// 即座にエピソードウィンドウを開くフラグについて
// 初回のみ初期値falseを入れる
if (!('quickShowEpisodeWindow' in f)) {
  f.quickShowEpisodeWindow = false;
}
// falseの場合のみエピソードIDを初期化する（trueの場合は開くエピソードIDがすでに格納済みのはず）
if (!f.quickShowEpisodeWindow) {
  f.displayEpisodeId = '';
}
[endscript]

;メッセージウィンドウの設定、文字が表示される領域を調整
[position layer="message0" left="53" top="484" width="1174" height="235" margint="65" marginl="75" marginr="80" marginb="65" opacity="220" page="fore"]
[position layer="message0" frame="message_window_none.png"]


; シアター枠画像
[image storage="theater/theater_rectangle.png" layer="0" name="theater1" x="12" y="6"]
[image storage="theater/theater_rectangle.png" layer="0" name="theater1" x="249" y="6"]
[image storage="theater/theater_rectangle.png" layer="0" name="theater1" x="486" y="6"]
[image storage="theater/theater_rectangle.png" layer="0" name="theater1" x="723" y="6"]

[image storage="theater/theater_rectangle.png" layer="0" name="theater1" x="12" y="260"]
[image storage="theater/theater_rectangle.png" layer="0" name="theater1" x="249" y="260"]
[image storage="theater/theater_rectangle.png" layer="0" name="theater1" x="486" y="260"]
[image storage="theater/theater_rectangle.png" layer="0" name="theater1" x="723" y="260"]

; サムネ画像
[image storage="&f.episodeList.e01.thumbnail" layer="0" left="24.5" top="19" width="200" height="112.5" name="thumbnail"]
[image storage="&f.episodeList.e02.thumbnail" layer="0" left="261.5" top="19" width="200" height="112.5" name="thumbnail"]
[image storage="&f.episodeList.e03.thumbnail" layer="0" left="498.5" top="19" width="200" height="112.5" name="thumbnail"]
[image storage="&f.episodeList.e04.thumbnail" layer="0" left="735.5" top="19" width="200" height="112.5" name="thumbnail"]

[image storage="&f.episodeList.e05.thumbnail" layer="0" left="24.5" top="274" width="200" height="112.5" name="thumbnail"]
[image storage="&f.episodeList.e06.thumbnail" layer="0" left="261.5" top="274" width="200" height="112.5" name="thumbnail"]
[image storage="&f.episodeList.e07.thumbnail" layer="0" left="498.5" top="274" width="200" height="112.5" name="thumbnail"]
[image storage="&f.episodeList.e08.thumbnail" layer="0" left="735.5" top="274" width="200" height="112.5" name="thumbnail"]

; シアタータイトル文字（全角24文字まで）
[ptext layer="0" text="&f.episodeList.e01.title" face="MPLUSRounded" size="24" x="29" y="136" width="200"]
[ptext layer="0" text="&f.episodeList.e02.title" face="MPLUSRounded" size="24" x="264" y="136" width="200"]
[ptext layer="0" text="&f.episodeList.e03.title" face="MPLUSRounded" size="24" x="501" y="136" width="200"]
[ptext layer="0" text="&f.episodeList.e04.title" face="MPLUSRounded" size="24" x="738" y="136" width="200"]

[ptext layer="0" text="&f.episodeList.e05.title" face="MPLUSRounded" size="24" x="29" y="391" width="200"]
[ptext layer="0" text="&f.episodeList.e06.title" face="MPLUSRounded" size="24" x="264" y="391" width="200"]
[ptext layer="0" text="&f.episodeList.e07.title" face="MPLUSRounded" size="24" x="501" y="391" width="200"]
[ptext layer="0" text="&f.episodeList.e08.title" face="MPLUSRounded" size="24" x="738" y="391" width="200"]

[layopt visible="true" layer="0"]

; クリッカブル領域はメイン画面を表示するたびに必要。ただしquickShowEpisodeWindowが立っているときはすぐに詳細画面を表示してしまうので、領域は表示しない
*setClickable
[eval exp="tf.episodeWindowTarget = '*episodeWindow_' + f.displayEpisodeId"]
[jump target="&tf.episodeWindowTarget" cond="f.quickShowEpisodeWindow"]

; quickShowEpisodeWindowが立っていないときはクリッカブル領域を表示する
[clickable width="210" height="234" x="20" y="14" color="0x333333" opacity="0" mouseopacity="40" target="*episodeWindow_e01"]
[clickable width="210" height="234" x="257" y="14" color="0x333333" opacity="0" mouseopacity="40" target="*episodeWindow_e02"]
[clickable width="210" height="234" x="494" y="14" color="0x333333" opacity="0" mouseopacity="40" target="*episodeWindow_e03"]
[clickable width="210" height="234" x="731" y="14" color="0x333333" opacity="0" mouseopacity="40" target="*episodeWindow_e04"]

[clickable width="210" height="234" x="20" y="268" color="0x333333" opacity="0" mouseopacity="40" target="*episodeWindow_e05"]
[clickable width="210" height="234" x="257" y="268" color="0x333333" opacity="0" mouseopacity="40" target="*episodeWindow_e06"]
[clickable width="210" height="234" x="494" y="268" color="0x333333" opacity="0" mouseopacity="40" target="*episodeWindow_e07"]
[clickable width="210" height="234" x="731" y="268" color="0x333333" opacity="0" mouseopacity="40" target="*episodeWindow_e08"]

; ボタン類
[eval exp="tf.buttonColor = CLASS_GLINK_DEFAULT"]
[glink color="&tf.buttonColor" size="30" width="270" x="975" y="438" text="タイトルに戻る" target="*returnTitle"]
; TODO sf.theaterProgressのpageIdを参照して出し分けるべき。以下のように現在表示してよいページID一覧を取得するなど
; TYRANO.kag.stat.f.availablePageIdList = Object.keys(TYRANO.kag.variable.sf.theaterProgress);
[glink color="&tf.buttonColor" size="30" width="270" x="975" y="338" text="1期・2期" target="*loadTheaterList" exp="f.displayPageId = 'p01'"]
;[glink color="&tf.buttonColor" size="30" width="270" x="975" y="38" text="もち子ミコ" target="*loadTheaterList" exp="f.theaterListPage = 99"]

;メッセージウィンドウの表示
[layopt layer="message0" visible="true"]

視聴したいシアターを選択してください。[r]
人狼ゲームで特定の条件を満たすと解決編が解放されます。
[s]


*episodeWindow_e01
[eval exp="f.displayEpisodeId = 'e01'"]
[jump target="*showEpisodeWindow"]
[s]

*episodeWindow_e02
[eval exp="f.displayEpisodeId = 'e02'"]
[jump target="*showEpisodeWindow"]
[s]

*episodeWindow_e03
[eval exp="f.displayEpisodeId = 'e03'"]
[jump target="*showEpisodeWindow"]
[s]

*episodeWindow_e04
[eval exp="f.displayEpisodeId = 'e04'"]
[jump target="*showEpisodeWindow"]
[s]

*episodeWindow_e05
[eval exp="f.displayEpisodeId = 'e05'"]
[jump target="*showEpisodeWindow"]
[s]

*episodeWindow_e06
[eval exp="f.displayEpisodeId = 'e06'"]
[jump target="*showEpisodeWindow"]
[s]

*episodeWindow_e07
[eval exp="f.displayEpisodeId = 'e07'"]
[jump target="*showEpisodeWindow"]
[s]

*episodeWindow_e08
[eval exp="f.displayEpisodeId = 'e08'"]
[jump target="*showEpisodeWindow"]
[s]


*showEpisodeWindow
[eval exp="f.quickShowEpisodeWindow = false"]

; そのエピソードの導入編が解放済みなら、エピソードウィンドウ表示。chapterIdは導入編で固定
[t_isProgressLocked pageId="&f.displayPageId" episodeId="&f.displayEpisodeId" chapterId="c01"]
[jump storage="theater/detail.ks" target="*start" cond="!tf.isProgressLocked"]

; TODO こちらはテスト用。実際には↑を有効化すること
; [jump storage="theater/detail.ks" target="*start" cond="!isIntroProgressLocked(f.theaterList[f.theaterEpisodeWindowNum])"]

; そのエピソードが未解放なら、詳細を表示させないで戻す
未解放のエピソードのため選択できません。[p]

*hideEpisodeWindow
; エピソードウィンドウ非表示（ウィンドウから戻ってくるためのラベル）
[jump target="*setClickable"]
[s]


*returnTitle
[endnowait]
[layopt layer="message0" visible="false"]
[freeimage layer="0"]
[jump storage="title.ks"]
[s]
