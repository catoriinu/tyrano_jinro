*statusJinroMain
[cm]
[clearfix]
[bg storage="black.png" time="100" wait="true"]
; TODO:メッセージ枠、名前表示テキストを消去し、awakeするときには再表示する

[ptext layer="1" x="400" y="100" text="現在のCO状況" color="white" size="60"]

; 占い師のCO状況表示
[ptext layer="1" x="200" y="200" text="占い師" color="white" size="40"]
[j_getAllFortuneTellerCOText]
[ptext layer="1" x="240" y="250" text="&tf.allFortuneTellerCOText" color="white" size="40"]

; バックログボタン表示
[button graphic="button/button_backlog_normal.png" x="1005" y="23" width="114" height="103" fix="true" role="backlog" name="button_j_fix,button_j_backlog" enterimg="button/button_backlog_hover.png"]
[glink color="blue" size="28" x="300" y="500" width="500" text="元の画面に戻る" target="*awake"]
[s]


*awake
; TODO:背景は元の画像に戻す。または人狼メニュー画面のbgはbgではなくレイヤー深めの画像を使うだけにするか。
;[bg storage="living_day_nc238325.jpg" time="100" wait="true"]

; バックログボタンを非表示にする
[clearfix name="button_j_backlog"]
[awakegame]
[s]
