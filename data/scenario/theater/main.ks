; シアター画面のメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]

; シアター画面ではテキストは瞬間表示
[nowait]


[bg storage="bg_fafafa.png" time="300"]

; シアター一覧の1ページ目の情報を取得
[eval exp="f.theaterListPage = 1"]

*loadTheaterList
[freeimage layer="0"]
[loadTheaterList page="&f.theaterListPage"]

;メッセージウィンドウの設定、文字が表示される領域を調整
[position layer="message0" left="53" top="484" width="1174" height="235" margint="65" marginl="75" marginr="80" marginb="65" opacity="210" page="fore"]
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
[image storage="&f.theaterList[1].thumbnail" layer="0" left="24.5" top="19" width="200" height="112.5" name="thumbnail"]
[image storage="&f.theaterList[2].thumbnail" layer="0" left="261.5" top="19" width="200" height="112.5" name="thumbnail"]
[image storage="&f.theaterList[3].thumbnail" layer="0" left="498.5" top="19" width="200" height="112.5" name="thumbnail"]
[image storage="&f.theaterList[4].thumbnail" layer="0" left="735.5" top="19" width="200" height="112.5" name="thumbnail"]

[image storage="&f.theaterList[5].thumbnail" layer="0" left="24.5" top="274" width="200" height="112.5" name="thumbnail"]
[image storage="&f.theaterList[6].thumbnail" layer="0" left="261.5" top="274" width="200" height="112.5" name="thumbnail"]
[image storage="&f.theaterList[7].thumbnail" layer="0" left="498.5" top="274" width="200" height="112.5" name="thumbnail"]
[image storage="&f.theaterList[8].thumbnail" layer="0" left="735.5" top="274" width="200" height="112.5" name="thumbnail"]

[iscript]
if (!('quickShowDetail' in f)) {f.quickShowDetail = false}
[endscript]

; シアタータイトル文字（全角24文字まで）
[ptext layer="0" text="&f.theaterList[1].title" face="MPLUSRounded" size="24" x="29" y="136" width="200"]
[ptext layer="0" text="&f.theaterList[2].title" face="MPLUSRounded" size="24" x="264" y="136" width="200"]
[ptext layer="0" text="&f.theaterList[3].title" face="MPLUSRounded" size="24" x="501" y="136" width="200"]
[ptext layer="0" text="&f.theaterList[4].title" face="MPLUSRounded" size="24" x="738" y="136" width="200"]

[ptext layer="0" text="&f.theaterList[5].title" face="MPLUSRounded" size="24" x="29" y="391" width="200"]
[ptext layer="0" text="&f.theaterList[6].title" face="MPLUSRounded" size="24" x="264" y="391" width="200"]
[ptext layer="0" text="&f.theaterList[7].title" face="MPLUSRounded" size="24" x="501" y="391" width="200"]
[ptext layer="0" text="&f.theaterList[8].title" face="MPLUSRounded" size="24" x="738" y="391" width="200"]

[layopt visible="true" layer="0"]

; クリッカブル領域はメイン画面を表示するたびに必要。ただしquickShowDetailが立っているときはすぐに詳細画面を表示してしまうので、領域は表示しない
*setClickable
[if exp="!f.quickShowDetail"]

  [clickable width="210" height="234" x="20" y="14" color="0x333333" opacity="0" mouseopacity="40" target="*detail_1"]
  [clickable width="210" height="234" x="257" y="14" color="0x333333" opacity="0" mouseopacity="40" target="*detail_2"]
  [clickable width="210" height="234" x="494" y="14" color="0x333333" opacity="0" mouseopacity="40" target="*detail_3"]
  [clickable width="210" height="234" x="731" y="14" color="0x333333" opacity="0" mouseopacity="40" target="*detail_4"]

  [clickable width="210" height="234" x="20" y="268" color="0x333333" opacity="0" mouseopacity="40" target="*detail_5"]
  [clickable width="210" height="234" x="257" y="268" color="0x333333" opacity="0" mouseopacity="40" target="*detail_6"]
  [clickable width="210" height="234" x="494" y="268" color="0x333333" opacity="0" mouseopacity="40" target="*detail_7"]
  [clickable width="210" height="234" x="731" y="268" color="0x333333" opacity="0" mouseopacity="40" target="*detail_8"]

  ; ボタン類
  [eval exp="tf.buttonColor = CLASS_GLINK_DEFAULT"]
  [glink color="&tf.buttonColor" size="30" width="270" x="975" y="438" text="タイトルに戻る" target="*returnTitle"]
  [glink color="&tf.buttonColor" size="30" width="270" x="975" y="338" text="1期・2期" target="*loadTheaterList" exp="f.theaterListPage = 1"]
  ;[glink color="&tf.buttonColor" size="30" width="270" x="975" y="38" text="もち子ミコ" target="*loadTheaterList" exp="f.theaterListPage = 99"]

  ;メッセージウィンドウの表示
  [layopt layer="message0" visible="true"]

  視聴したいシアターを選択してください。[r]
  人狼ゲームで特定の条件を満たすと解決編が解放されます。

[else]
  [eval exp="tf.detailTarget = '*detail_' + f.theaterDetailNum"]
  [jump target="&tf.detailTarget"]
[endif]
[s]


*detail_1
[eval exp="f.theaterDetailNum = 1"]
[jump target="*showDetail"]
[s]

*detail_2
[eval exp="f.theaterDetailNum = 2"]
[jump target="*showDetail"]
[s]

*detail_3
[eval exp="f.theaterDetailNum = 3"]
[jump target="*showDetail"]
[s]

*detail_4
[eval exp="f.theaterDetailNum = 4"]
[jump target="*showDetail"]
[s]

*detail_5
[eval exp="f.theaterDetailNum = 5"]
[jump target="*showDetail"]
[s]

*detail_6
[eval exp="f.theaterDetailNum = 6"]
[jump target="*showDetail"]
[s]

*detail_7
[eval exp="f.theaterDetailNum = 7"]
[jump target="*showDetail"]
[s]

*detail_8
[eval exp="f.theaterDetailNum = 8"]
[jump target="*showDetail"]
[s]


*showDetail
[eval exp="f.quickShowDetail = false"]

; そのシアターが解放済みなら、シアター詳細モジュール表示
;[jump storage="theater/detail.ks" target="*start" cond="!isIntroProgressLocked(sf.theater[f.theaterListPage][f.theaterDetailNum])"]
; TODO こちらはテスト用。実際には↑を有効化すること
[jump storage="theater/detail.ks" target="*start" cond="!isIntroProgressLocked(f.theaterList[f.theaterDetailNum])"]

; そのシアターが未解放なら、詳細を表示させないで戻す
未解放のシアターのため選択できません。[p]

*hideDetail
; シアター詳細モジュール非表示（モジュールから戻ってくるためのラベル）
[jump target="*setClickable"]
[s]


*returnTitle
[endnowait]
[layopt layer="message0" visible="false"]
[freeimage layer="0"]
[jump storage="title.ks"]
[s]
