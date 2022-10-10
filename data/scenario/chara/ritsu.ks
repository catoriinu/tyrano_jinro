; 波音リツのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [chara_new name="ritsu" storage="chara/ritsu/normal.png" width="640" haight="960" jname="波音リツ"]
  [chara_face name="ritsu" face="normal" storage="chara/ritsu/normal.png"]
  [call target="*setLeftAndTopBeforeCharaShow"]
  [chara_show name="ritsu" face="normal" time="0" wait="true" left="&tf.left" top="&tf.top"]
[return]


; 登場前座標格納サブルーチン
; m_showCharacterマクロで画面外からchara_moveで登場することを考慮したうえで、
; chara_showでデフォルトで登場するキャラ画像の座標を一時変数に格納する
*setLeftAndTopBeforeCharaShow
  ; 本来の定位置はleft="765" top="111"
  [eval exp="tf.left = '1765'"]
  [eval exp="tf.top = '111'"]
[return]
