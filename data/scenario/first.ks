;一番最初に呼び出されるファイル

[title name="人狼テスト"]

[stop_keyconfig]


;ティラノスクリプトが標準で用意している便利なライブラリ群
;コンフィグ、CG、回想モードを使う場合は必須
[call storage="tyrano.ks"]

;ゲームで必ず必要な初期化処理はこのファイルに記述するのがオススメ
[plugin name="jinro"] 
[call storage="jinroMacros.ks"]
[call storage="messageMacros.ks"]

; 開発モードか？ TODO:公開前にはOFFにすること！
[eval exp="f.developmentMode = false"]
; ヒントモードか？ TODO:公開前にはOFFにすること！
[eval exp="f.hintMode = true"]

;メッセージボックスは非表示
[layopt layer="message" visible=false]

;最初は右下のメニューボタンを非表示にする
[hidemenubutton]

;タイトル画面へ移動
[jump storage="title.ks"]

[s]


