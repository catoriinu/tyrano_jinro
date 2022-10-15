; 波音リツのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  ; 画面内への登場時の定位置はleft="845" top="133"
  [eval exp="f.defaultPosition.tsumugi = {side:'right', left:1845, top:133}"]

  [chara_new name="tsumugi" storage="chara/tsumugi/normal.png" width="520" haight="718" jname="春日部つむぎ"]
  [chara_face name="tsumugi" face="normal" storage="chara/tsumugi/normal.png"]
  [chara_show name="tsumugi" face="normal" time="0" wait="true" left="&f.defaultPosition.tsumugi.left" top="&f.defaultPosition.tsumugi.top"]
[return]
