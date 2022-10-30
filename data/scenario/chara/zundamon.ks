; ずんだもんのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  ; 画面内への登場時の定位置はleft="-124" top="122"
  [eval exp="f.defaultPosition.zundamon = {side:'left', left:-1124, top:122}"]

  [chara_new name="zundamon" storage="chara/zundamon/normal.png" width="567" haight="756" jname="ずんだもん" reflect="true"]
  [chara_face name="zundamon" face="normal" storage="chara/zundamon/normal.png"]
  [chara_show name="zundamon" face="normal" time="0" wait="true" left="&f.defaultPosition.zundamon.left" top="&f.defaultPosition.zundamon.top"]
[return]
