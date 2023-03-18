
[cm]

[clearstack]
[bg storage="voivojinrou_green.png" time="100" wait="true"]
[bg storage="voivojinrou_title_v2.png" time="100"]
[wait time="100"]

*start 

[button x=175 y=480 graphic="title/button_start.png" enterimg="title/button_start2.png"  target="gamestart"]
[button x=175 y=570 graphic="title/button_load.png" enterimg="title/button_load2.png" role="load" ]
[button x=740 y=480 graphic="title/button_config.png" enterimg="title/button_config2.png" role="sleepgame" storage="config.ks" ]
[button x=740 y=570 graphic="title/button_start3.png" enterimg="title/button_start2.png" target="selectStage"]

[s]

*gamestart
;人狼ゲームのメインシナリオファイルへジャンプする
[jump storage="playJinro.ks"]


*selectStage
;ステージ選択（TODO 現在はPCの役職のみ選択可能）シナリオファイルへジャンプする
[jump storage="selectStage.ks"]


