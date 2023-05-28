; 以下は、ステータス画面からメニュー画面に遷移する場合のシナリオ
*menuJinroMainFromStatus
[cm]
[j_clearFixButton]

; ここで表示するステータスボタンはただのステータス画面再表示ボタンであり、fix属性ではないかつrole="sleepgame"指定もしていない
; 通常画面→ステータス画面→メニュー画面と遷移してきた場合、通常画面でsleepしている状態のため、fix属性のボタンを押したり、再度sleepgameすることはできない。
; 同様の理由で、タイトル画面に戻る場合以外は[breakgame]してはいけない。通常画面に戻れなくなるため。
[j_displayFixButton status="nofix"]

[bg storage="black.png" time="100" wait="true"]
[ptext layer="1" x="310" y="100" text="テスト用メニュー画面" color="white" size="60"]
[layopt layer="1" visible="true"]


*menuJinroButtonFromStatus
[glink color="blue" size="28" x="300" y="240" width="500" text="現在の変数を出力" target="*exportJsonFromStatus"]
[glink color="blue" size="28" x="300" y="350" width="500" text="タイトルに戻る" target="*returnTitleFromStatus"]
[s]


*exportJsonFromStatus
[j_saveJson]
[jump target="*menuJinroButtonFromStatus"]
[s]

*returnTitleFromStatus
[j_clearFixButton]
[breakgame]
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[layopt layer="message0" visible="false"]
[freeimage layer="1"]
[jump storage="title.ks"]
[s]




; 以下は、通常画面からメニュー画面に遷移する場合のシナリオ
; [button graphic="button/button_menu_normal.png" storage="menuJinro.ks" target="*menuJinroMain" x="867" y="23" width="114" height="103" fix="true" role="sleepgame" name="button_j_fix,button_j_menu" enterimg="button/button_menu_hover.png"]
; で呼び出すこと

*menuJinroMain
[cm]
[clearfix]
[bg storage="black.png" time="100" wait="true"]
[ptext layer="1" x="310" y="100" text="テスト用メニュー画面" color="white" size="60"]
[layopt layer="1" visible="true"]


*menuJinroButton
[glink color="blue" size="28" x="300" y="240" width="500" text="現在の変数を出力" target="*exportJson"]
[glink color="blue" size="28" x="300" y="350" width="500" text="タイトルに戻る" target="*returnTitle"]
[glink color="blue" size="28" x="300" y="460" width="500" text="ゲームを再開する" target="*awake"]
[s]


*exportJson
[j_saveJson]
[jump target="*menuJinroButton"]
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


*awake
[awakegame]
[s]
