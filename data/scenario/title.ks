
[cm]

[clearstack]
[bg storage="voivojinrou_green.png" time="100" wait="true"]
[bg storage="voivojinrou_title_v2.png" time="100"]
[wait time="100"]

*start 
[ptext layer="1" x="1050" y="684" text="ver.0.7.1" color="white" size="24"]
[layopt layer="1" visible="true"]
[playbgm storage="fun_fun_Ukelele_1loop.ogg" volume="25" loop="true" restart="false"]
; TODO 役職選択画面（selectStage）関連の初期化処理
; タイトル画面に戻ってきたら、役職選択済みフラグを折る
[eval exp="f.isSelectedMyRole = false"]


[eval exp="tf.buttonColor = CLASS_GLINK_DEFAULT"]
[glink color="&tf.buttonColor" size="30" width="300" x="488" y="480" name="buttonhover" text="プレイ" target="*gamestart"]
[glink color="&tf.buttonColor" size="30" width="300" x="488" y="590" name="buttonhover" text="カスタムプレイ" target="*selectStage"]
; TODO 作成するまでコメントアウト
;[glink color="&tf.buttonColor" size="26" width="300" x="500" y="580" name="&tf.glink_name" text="シアター" target="*developerSettings"]
; TODO 戻るボタンでUncaught TypeError: Cannot read property 'caller' of undefinedになる。使えるようにするまでコメントアウト
;[glink color="&tf.buttonColor" size="26" width="300" x="488" y="630" name="&tf.glink_name" text="コンフィグ"  storage="config.ks" ]

[glink color="black" size="15" x="1152" y="684" text="開発者用" name="buttonhover" target="*developerSettings"]

[iscript]
  // ボタンにカーソルが乗ったときの処理
  $(".buttonhover").hover(
    function(e) {
      // glinkのenterse属性だと細かい設定ができないため独自に設定（特にbufがデフォルトだと他で鳴っている効果音を打ち消してしまう）
      TYRANO.kag.ftag.startTag("playse",{storage:"botan_b34.ogg",volume:40,buf:1});
    },
  );
[endscript]
[s]

*gamestart
[freeimage layer="1"]
[stopbgm]
;人狼ゲームのメインシナリオファイルへジャンプする
[jump storage="playJinro.ks"]


*selectStage
[freeimage layer="1"]
[stopbgm]
;ステージ選択（TODO 現在はPCの役職のみ選択可能）シナリオファイルへジャンプする
[jump storage="selectStage.ks"]


*teststart
[freeimage layer="1"]
;テストファイルへジャンプする
[jump storage="movie_20230325.ks"]

*developerSettings
[freeimage layer="1"]
; 開発者用設定画面へジャンプする
[jump storage="developerSettings.ks"]
