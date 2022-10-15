; 四国めたんのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  ; 画面内への登場時の定位置はleft="711" top="105"
  [eval exp="f.defaultPosition.metan = {side:'right', left:1711, top:105}"]

  [chara_new name="metan" storage="chara/metan/normal.png" width="800" haight="800" jname="四国めたん"]
  [chara_face name="metan" face="normal" storage="chara/metan/normal.png"]
  [chara_show name="metan" face="normal" time="0" wait="true" left="&f.defaultPosition.metan.left" top="&f.defaultPosition.metan.top"]
[return]
