; 雨晴はうのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  ; 画面内への登場時の定位置はleft="796" top="143"
  [eval exp="f.defaultPosition.hau = {side:'right', left:1796, top:143}"]

  [chara_new name="hau" storage="chara/hau/normal.png" width="567" haight="958" jname="雨晴はう"]
  [chara_face name="hau" face="normal" storage="chara/hau/normal.png"]
  [chara_show name="hau" face="normal" time="0" wait="true" left="&f.defaultPosition.hau.left" top="&f.defaultPosition.hau.top"]
[return]
