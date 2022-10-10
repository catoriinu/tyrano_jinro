; 波音リツのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [chara_new name="tsumugi" storage="chara/tsumugi/normal.png" width="520" haight="718" jname="春日部つむぎ"]
  [chara_face name="tsumugi" face="normal" storage="chara/tsumugi/normal.png"]
  [call target="*setLeftAndTopBeforeCharaShow"]
  [chara_show name="tsumugi" face="normal" time="0" wait="true" left="&tf.left" top="&tf.top"]
[return]


; 登場前座標格納サブルーチン
; m_showCharacterマクロで画面外からchara_moveで登場することを考慮したうえで、
; chara_showでデフォルトで登場するキャラ画像の座標を一時変数に格納する
*setLeftAndTopBeforeCharaShow
  ;本来の定位置はleft="845" top="133"
  [eval exp="tf.left = '1845'"]
  [eval exp="tf.top = '133'"]
[return]
