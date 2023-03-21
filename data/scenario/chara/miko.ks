; 櫻歌ミコのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  ; 画面内への登場時の定位置はleft="796" top="143"
  [eval exp="f.defaultPosition.miko = {side:'right', left:1768, top:143}"]

  [chara_new name="miko" storage="chara/miko/normal.png" width="641" haight="960" jname="櫻歌ミコ"]
  [chara_face name="miko" face="normal" storage="chara/miko/normal.png"]
  [chara_face name="miko" face="gao" storage="chara/miko/gao.png"]
  [chara_face name="miko" face="excite" storage="chara/miko/wakuwaku.png"]
  [chara_face name="miko" face="smile" storage="chara/miko/笑顔.png"]
  [chara_face name="miko" face="introduce" storage="chara/miko/説明.png"]
  [chara_show name="miko" face="normal" time="0" wait="true" left="&f.defaultPosition.miko.left" top="&f.defaultPosition.miko.top"]
[return]
