; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = 'mochiko'"]

  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  [iscript]
    f.defaultPosition[tf.characterId] = {
      //side: 'right', // デフォルト待機位置
      //left: 1819, // デフォルト座標（left）
      side: 'left', // デフォルト待機位置
      left: -1052, // デフォルト座標（left）
      top: 162, // キャラが登場したときのtopの値
      width: 516, // 画像の幅（画面幅1280pxの中での幅）
      haight: 946, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 249, // 画像の幅の中央(反転しない状態で)
    }
    // キャラクターのイメージカラーのカラーコード
    f.color.character[tf.characterId] = '#b7b6bb';
  [endscript]

  [chara_new name="&tf.characterId" storage="chara/mochiko/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="もち子さん" reflect="true"]
  [chara_face name="&tf.characterId" face="normal" storage="chara/mochiko/normal.png"]
  [chara_face name="&tf.characterId" face="smile" storage="chara/mochiko/笑顔.png"]
  [chara_face name="&tf.characterId" face="surprise" storage="chara/mochiko/驚き泣き.png"]
  [chara_face name="&tf.characterId" face="wry_smile" storage="chara/mochiko/苦笑.png"]
  [chara_face name="&tf.characterId" face="introduce" storage="chara/mochiko/紹介.png"]
  [chara_face name="&tf.characterId" face="heart" storage="chara/mochiko/heart.png"]
  [chara_face name="&tf.characterId" face="plotting" storage="chara/mochiko/plotting.png"]
  [chara_face name="&tf.characterId" face="tired" storage="chara/mochiko/tired.png"]
  [chara_show name="&tf.characterId" face="normal" time="0" wait="true" left="&f.defaultPosition[tf.characterId].left" top="&f.defaultPosition[tf.characterId].top"]
[return]
