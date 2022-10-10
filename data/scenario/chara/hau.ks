; 雨晴はうのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [chara_new name="hau" storage="chara/hau/normal.png" width="567" haight="958" jname="雨晴はう"]
  [chara_face name="hau" face="normal" storage="chara/hau/normal.png"]
  [call target="*setLeftAndTopBeforeCharaShow"]
  [chara_show name="hau" face="normal" time="0" wait="true" left="&tf.left" top="&tf.top"]
[return]


; 登場前座標格納サブルーチン
; m_showCharacterマクロで画面外からchara_moveで登場することを考慮したうえで、
; chara_showでデフォルトで登場するキャラ画像の座標を一時変数に格納する
*setLeftAndTopBeforeCharaShow
  ;本来の定位置はleft="796" top="143"
  [eval exp="tf.left = '1796'"]
  [eval exp="tf.top = '143'"]
[return]
