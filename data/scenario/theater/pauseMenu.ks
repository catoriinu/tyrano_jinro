; チャプター再生中のポーズメニュー画面

*start
[cm]

; 全ボタンとメッセージウィンドウを消去
[j_clearFixButton]
[layopt layer="message0" visible="false"]

; ボタンとその背景
[html top="130" left="413.813" name="pause_menu_button_window"]
[endhtml]
[eval exp="tf.buttonColor = CLASS_GLINK_DEFAULT"]
[glink color="&tf.buttonColor" size="30" width="400" x="439" y="180" name="buttonhover" text="終了までスキップする" target="*skip"]
[glink color="&tf.buttonColor" size="30" width="400" x="439" y="320" name="buttonhover" text="コンフィグ" target="*config"]
[glink color="&tf.buttonColor" size="30" width="400" x="439" y="460" name="buttonhover" text="メニューを閉じる" target="*resume"]

[s]


*skip
; 終了までスキップする
[layopt layer="message0" visible="true"]
[eval exp="f.currentFrame = null"]
[freeimage layer="1"]
[free_filter]

; すぐさま終了するのでボタンは再表示しない
;[j_displayFixButton backlog="true" pauseMenu="true"]

; 再生中のチャプターの終了直前のラベルに飛ぶ
[breakgame]
[eval exp="tf.chapterSkiped = true"]
[jump storage="&f.chapterStorage" target="*end"]
[s]


*config
; コンフィグ
[jump storage="configJinro.ks"]
[s]



*resume
; メニューを閉じる
[layopt layer="message0" visible="true"]
[freeimage layer="1"]
[free_filter]

[j_displayFixButton backlog="true" pauseMenu="true"]
[awakegame]
[s]
