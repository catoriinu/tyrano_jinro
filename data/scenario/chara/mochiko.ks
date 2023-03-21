; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  ; 画面内への登場時の定位置はleft="796" top="143"
  [eval exp="f.defaultPosition.mochiko = {side:'left', left:-1070, top:140}"]

  [chara_new name="mochiko" storage="chara/mochiko/normal.png" width="522" haight="95836" jname="もち子さん" reflect="true"]
  [chara_face name="mochiko" face="normal" storage="chara/mochiko/normal.png"]
  [chara_face name="mochiko" face="smile" storage="chara/mochiko/笑顔.png"]
  [chara_face name="mochiko" face="surprise" storage="chara/mochiko/驚き泣き.png"]
  [chara_face name="mochiko" face="wry_smile" storage="chara/mochiko/苦笑.png"]
  [chara_face name="mochiko" face="introduce" storage="chara/mochiko/紹介.png"]
  [chara_show name="mochiko" face="normal" time="0" wait="true" left="&f.defaultPosition.mochiko.left" top="&f.defaultPosition.mochiko.top"]
[return]
