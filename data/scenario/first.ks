;一番最初に呼び出されるファイル

[title name="ボイボ人狼 ver.0.7.1"]

[stop_keyconfig]


;ティラノスクリプトが標準で用意している便利なライブラリ群
;コンフィグ、CG、回想モードを使う場合は必須
[call storage="tyrano.ks"]

;ゲームで必ず必要な初期化処理はこのファイルに記述するのがオススメ
[plugin name="jinro"] 
[call storage="jinroMacros.ks"]
[call storage="messageMacros.ks"]
[eval exp="f.color = {}"]
[loadcss file="./data/others/jinro.css"]

; デフォルトフォントの設定
[deffont size=32 color="0x28332a" face=MPLUSRounded][resetfont]

;メッセージボックスは非表示
[layopt layer="message" visible=false]

;最初は右下のメニューボタンを非表示にする
[hidemenubutton]

;タイトル画面へ移動
[jump storage="title.ks"]

[s]


