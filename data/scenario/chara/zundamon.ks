; ずんだもんのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = CHARACTER_ID_ZUNDAMON"]

  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  ; 画面内への登場時の定位置はleft="-124" top="122"
  [iscript]
    f.defaultPosition.zundamon = {
      side: 'left', // デフォルト待機位置
      left: -1118, // デフォルト座標（left）
      top: 135, // デフォルト座標（top）
      width: 550, // 画像の幅（画面幅1280pxの中での幅）
      haight: 733, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 258, // 画像の幅の中央(反転しない状態で)
    }
  [endscript]

  ; キャラクターの登録
  ; だいたいtf.characterIdを参照してくれるが、storageとjnameには正確な文字列を入れること
  [chara_new name="&tf.characterId" storage="chara/zundamon/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="ずんだもん" reflect="true"]
  [chara_face name="&tf.characterId" face="normal" storage="chara/zundamon/normal.png"]
  [chara_show name="&tf.characterId" face="normal" time="0" wait="true" left="&f.defaultPosition[tf.characterId].left" top="&f.defaultPosition[tf.characterId].top"]
[return]
