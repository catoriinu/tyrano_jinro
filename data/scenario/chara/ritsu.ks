; 波音リツのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  ; 画面内への登場時の定位置はleft="765" top="111"
  [eval exp="f.defaultPosition.ritsu = {side:'right', left:1765, top:111}"]

  [chara_new name="ritsu" storage="chara/ritsu/normal.png" width="640" haight="960" jname="波音リツ"]
  [chara_face name="ritsu" face="normal" storage="chara/ritsu/normal.png"]
  [chara_show name="ritsu" face="normal" time="0" wait="true" left="&f.defaultPosition.ritsu.left" top="&f.defaultPosition.ritsu.top"]
[return]
