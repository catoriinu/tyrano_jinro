; 櫻歌ミコのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = 'miko'"]

  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  ; 画面内への登場時の定位置はleft="796" top="143"
  [iscript]
    f.defaultPosition[tf.characterId] = {
      side: 'right', // デフォルト待機位置
      left: 1768, // デフォルト座標（left）
      top: 143, // デフォルト座標（top）
      width: 641, // 画像の幅（画面幅1280pxの中での幅）
      haight: 960, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 320, // 画像の幅の中央(反転しない状態で)
    }
    // キャラクターのイメージカラーのカラーコード
    f.color.character[tf.characterId] = '#ffccc5';
  [endscript]

  [chara_new name="&tf.characterId" storage="chara/miko/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="櫻歌ミコ"]
  [chara_face name="&tf.characterId" face="normal" storage="chara/miko/normal.png"]
  [chara_face name="&tf.characterId" face="gao" storage="chara/miko/gao.png"]
  [chara_face name="&tf.characterId" face="excite" storage="chara/miko/wakuwaku.png"]
  [chara_face name="&tf.characterId" face="smile" storage="chara/miko/笑顔.png"]
  [chara_face name="&tf.characterId" face="introduce" storage="chara/miko/説明.png"]
  [chara_face name="&tf.characterId" face="sad" storage="chara/miko/sad.png"]
  [chara_face name="&tf.characterId" face="surprised" storage="chara/miko/surprised.png"]
  [chara_face name="&tf.characterId" face="astonished" storage="chara/miko/astonished.png"]
  [chara_face name="&tf.characterId" face="embarrassed" storage="chara/miko/embarrassed.png"]
  [chara_face name="&tf.characterId" face="gao_smile" storage="chara/miko/gao_smile.png"]
  [chara_show name="&tf.characterId" face="normal" time="0" wait="true" left="&f.defaultPosition[tf.characterId].left" top="&f.defaultPosition[tf.characterId].top"]
[return]
