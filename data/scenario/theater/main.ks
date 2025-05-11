; シアター画面のメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]

; シアター画面ではテキストは瞬間表示
[nowait]

; ボイス停止（エピソードから戻ってきたとき用）
[stopse buf="1"]
[playbgm storage="fun_fun_Ukelele_1loop.ogg" volume="15" loop="true" restart="false"]
[bg storage="bg_fafafa.png" time="100"]

[iscript]
// 即座にエピソードウィンドウを開くフラグがfalseの場合のみ、開くページIDとエピソードIDを初期化する（trueの場合はすでに格納済み）
if (!f.quickShowEpisodeWindow) {
  f.displayPageId = 'p01';
  f.displayEpisodeId = '';
}
[endscript]


*loadEpisodeList
[freeimage layer="0"]
[loadEpisodeList pageId="&f.displayPageId"]

;メッセージウィンドウの設定、文字が表示される領域を調整
[position layer="message0" left="53" top="484" width="1174" height="235" margint="65" marginl="75" marginr="80" marginb="65" opacity="220" page="fore"]
[position layer="message0" frame="message_window_none.png"]

; サムネイル
[t_imageTheaterThumbnail pageId="&f.displayPageId" episodeId="e01"]
[t_imageTheaterThumbnail pageId="&f.displayPageId" episodeId="e02"]
[t_imageTheaterThumbnail pageId="&f.displayPageId" episodeId="e03"]
[t_imageTheaterThumbnail pageId="&f.displayPageId" episodeId="e04"]
[t_imageTheaterThumbnail pageId="&f.displayPageId" episodeId="e05"]
[t_imageTheaterThumbnail pageId="&f.displayPageId" episodeId="e06"]
[t_imageTheaterThumbnail pageId="&f.displayPageId" episodeId="e07"]
[t_imageTheaterThumbnail pageId="&f.displayPageId" episodeId="e08"]

; シアタータイトル文字（全角24文字まで）
[ptext layer="0" text="&f.episodeList.e01.title" face="MPLUSRounded" size="24" x="29" y="138" width="200"]
[ptext layer="0" text="&f.episodeList.e02.title" face="MPLUSRounded" size="24" x="264" y="138" width="200"]
[ptext layer="0" text="&f.episodeList.e03.title" face="MPLUSRounded" size="24" x="501" y="138" width="200"]
[ptext layer="0" text="&f.episodeList.e04.title" face="MPLUSRounded" size="24" x="738" y="138" width="200"]

[ptext layer="0" text="&f.episodeList.e05.title" face="MPLUSRounded" size="24" x="29" y="393" width="200"]
[ptext layer="0" text="&f.episodeList.e06.title" face="MPLUSRounded" size="24" x="264" y="393" width="200"]
[ptext layer="0" text="&f.episodeList.e07.title" face="MPLUSRounded" size="24" x="501" y="393" width="200"]
[ptext layer="0" text="&f.episodeList.e08.title" face="MPLUSRounded" size="24" x="738" y="393" width="200"]

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
[iscript]
  tf.buttonColor = CLASS_GLINK_DEFAULT;
  tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;

  // 表示するメッセージの判定用
  tf.isPage01AllCleared = (getTheaterProgress('p01', 'e08') === EPISODE_STATUS.OUTRO_UNLOCKED);
[endscript]
[glink color="&tf.selectedButtonColor" size="30" width="270" x="975" y="38" text="タイトルに戻る" target="*returnTitle" enterse="se/button34.ogg" clickse="se/button15.ogg"]

; 以下、選択中のページのみボタンの色を変える
; TODO 初期リリース時はページ切り替え機能は不要なのでコメントアウトする
; MEMO プログラム上の区切りはpageだが、ゲーム表現上の区切りはActとする予定
;[glink color="&tf.selectedButtonColor" size="30" width="270" x="975" y="438" text="Act1" target="*loadEpisodeList" exp="f.displayPageId = 'p01'" cond="f.displayPageId === 'p01'"]
;[glink color="&tf.buttonColor" size="30" width="270" x="975" y="438" text="Act1" target="*loadEpisodeList" exp="f.displayPageId = 'p01'" cond="f.displayPageId !== 'p01'"]

; TODO sf.theaterProgressのpageIdを参照して出し分けるべき。以下のように現在表示してよいページID一覧を取得するなど
; TYRANO.kag.stat.f.availablePageIdList = Object.keys(TYRANO.kag.variable.sf.theaterProgress);
;[glink color="&tf.selectedButtonColor" size="30" width="270" x="975" y="38" text="紹介動画" target="*loadEpisodeList" exp="f.displayPageId = 'p99'" cond="sf.isDebugMode && f.displayPageId === 'p99'"]
;[glink color="&tf.buttonColor" size="30" width="270" x="975" y="38" text="紹介動画" target="*loadEpisodeList" exp="f.displayPageId = 'p99'" cond="sf.isDebugMode && f.displayPageId !== 'p99'"]


;メッセージウィンドウの表示
[layopt layer="message0" visible="true"]
#
視聴したいエピソードを選択してください。[r]

[if exp="tf.isPage01AllCleared"]
将来のアップデートで新規エピソードを追加予定です。
[else]
人狼ゲームで特定の条件を満たすと解決編が解放されます。
[endif]
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
; そのエピソードの導入編が解放済みかを一時変数に格納
[t_isProgressLocked pageId="&f.displayPageId" episodeId="&f.displayEpisodeId"]

; 解放済みかつクリッカブル領域を押したときだけ、選択のボタンSEを鳴らす（=エピソード再生から戻ってきたときは鳴らさない）
[playse storage="se/button13.ogg" buf="0" cond="!tf.isProgressLocked && !f.quickShowEpisodeWindow"]

; エピソード再生から戻ってきたときだけ立っているフラグを、このタイミングで折る
[eval exp="f.quickShowEpisodeWindow = false"]

; 解放済みならエピソードウィンドウを開く
[jump storage="theater/episodeWindow.ks" target="*start" cond="!tf.isProgressLocked"]

; 以下、未解放なら詳細を表示させない。キャンセルのボタンSEを鳴らして注意文を表示する
[playse storage="se/button15.ogg" buf="0"]
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
