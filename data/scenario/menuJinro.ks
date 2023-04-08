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
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[layopt layer="message0" visible="false"]
[jump storage="title.ks"]
[s]


*awake
[awakegame]
[s]
