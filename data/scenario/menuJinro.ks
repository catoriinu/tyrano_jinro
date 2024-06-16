; 人狼ゲーム中にメニュー画面を表示するシナリオ
*menuJinroMain
[cm]
[j_saveFixButton buf="menu"]
[j_clearFixButton]

*returnFromConfig

*menuJinroButton
; ボタンとその背景
[html top="130" left="413.813" name="pause_menu_button_window"]
[endhtml]
[eval exp="tf.buttonColor = CLASS_GLINK_DEFAULT"]
; TODO:「現在の変数を出力」はテスト時限定の表示とする。リリース版では非表示にし、「コンフィグ」をy="320"にする
; TODO:エピソードから人狼ゲームを始めた時は、「シアターに戻る」を表示する
[glink color="&tf.buttonColor" size="30" width="400" x="439" y="180"name="buttonhover" text="タイトルに戻る" target="*returnTitle"]
[glink color="&tf.buttonColor" size="30" width="400" x="439" y="273.3" name="buttonhover" text="現在の変数を出力" target="*exportJson"]
[glink color="&tf.buttonColor" size="30" width="400" x="439" y="366.6" name="buttonhover" text="コンフィグ" target="*config"]
[glink color="&tf.buttonColor" size="30" width="400" x="439" y="460" name="buttonhover" text="メニューを閉じる" target="*closeMenu"]

[s]


*returnTitle
[j_clearFixButton]
; このシナリオにジャンプしてくるためのメニューボタンは、[button role="sleepgame"]である。
; 「ゲームを再開する」時には[awakegame]で押した箇所まで復帰するが、
; 「タイトルに戻る」のようにsleepgame中に別シナリオにジャンプしたい場合は、[breakgame]で停止データを削除しなければならない。
; しないでジャンプするとずっとsleepgame中の扱いになり、fix=trueのボタンがクリックできなくなる。
[breakgame]
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[layopt layer="message0" visible="false"]
[freeimage layer="1"]
[jump storage="title.ks"]
[s]


*config
; コールスタックのクリア。コンフィグ画面の「もどる」はfixボタンなので、クリアしておかないとボタンが有効にならないため
[clearstack]
; コンフィグ
[jump storage="configJinro.ks"]
[s]


*exportJson
[j_saveJson]
[jump target="*menuJinroButton"]
[s]


*closeMenu
[j_loadFixButton buf="menu"]
[awakegame]
[s]
