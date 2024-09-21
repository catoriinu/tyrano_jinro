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


[if exp="f.isSituationPlay"]
  [glink color="&tf.buttonColor" size="30" width="400" x="439" y="180" name="buttonhover" text="シアターに戻る" target="*returnTheater"]
  [glink color="&tf.buttonColor" size="30" width="400" x="439" y="273.3" name="buttonhover" text="タイトルに戻る" target="*returnTitle"]
  [glink color="&tf.buttonColor" size="30" width="400" x="439" y="366.6" name="buttonhover" text="コンフィグ" target="*config"]
  [glink color="&tf.buttonColor" size="30" width="400" x="439" y="460" name="buttonhover" text="メニューを閉じる" target="*closeMenu"]
[else]
  [glink color="&tf.buttonColor" size="30" width="400" x="439" y="180" name="buttonhover" text="タイトルに戻る" target="*returnTitle"]
  [glink color="&tf.buttonColor" size="30" width="400" x="439" y="320" name="buttonhover" text="コンフィグ" target="*config"]
  [glink color="&tf.buttonColor" size="30" width="400" x="439" y="460" name="buttonhover" text="メニューを閉じる" target="*closeMenu"]
[endif]
; 「現在の変数を出力」は問い合わせ用に常に表示する。ただし他のボタンの邪魔にならないよう、枠外で。
[glink color="&tf.buttonColor" size="26" width="450" x="412" y="600" name="buttonhover" text="問い合わせ用 現在の変数を出力" target="*exportJson"]

[s]


*returnTheater
[j_clearFixButton]
[breakgame]
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId" time="1"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId" time="1"]
[layopt layer="message0" visible="false"]
[eval exp="f.currentFrame = null"]
[freeimage layer="1"]

[jump storage="theater/main.ks" target="*returnFromSituationPlay"]
[s]

*returnTitle
[j_clearFixButton]
; このシナリオにジャンプしてくるためのメニューボタンは、[button role="sleepgame"]である。
; 「ゲームを再開する」時には[awakegame]で押した箇所まで復帰するが、
; 「タイトルに戻る」のようにsleepgame中に別シナリオにジャンプしたい場合は、[breakgame]で停止データを削除しなければならない。
; しないでジャンプするとずっとsleepgame中の扱いになり、fix=trueのボタンがクリックできなくなる。
[breakgame]
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId" time="1"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId" time="1"]
[layopt layer="message0" visible="false"]
[eval exp="f.currentFrame = null"]
[freeimage layer="1"]

[jump storage="title.ks"]
[s]


*config
; コールスタックのクリア。コンフィグ画面の「もどる」はfixボタンなので、クリアしておかないとボタンが有効にならないため
[clearstack]
; コンフィグ
[jump storage="configJinro.ks"]
[s]


*closeMenu
[j_loadFixButton buf="menu"]
[awakegame]
[s]


*exportJson
[j_saveJson]
[jump target="*menuJinroButton"]
[s]
