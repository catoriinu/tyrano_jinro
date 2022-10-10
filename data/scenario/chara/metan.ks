; 四国めたんのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [chara_new name="metan" storage="chara/metan/normal.png" width="800" haight="800" jname="四国めたん"]
  [chara_face name="metan" face="normal" storage="chara/metan/normal.png"]
  [call target="*setLeftAndTopBeforeCharaShow"]
  [chara_show name="metan" face="normal" time="0" wait="true" left="&tf.left" top="&tf.top"]
[return]


; 登場前座標格納サブルーチン
; m_showCharacterマクロで画面外からchara_moveで登場することを考慮したうえで、
; chara_showでデフォルトで登場するキャラ画像の座標を一時変数に格納する
*setLeftAndTopBeforeCharaShow
  ; 本来の定位置はleft="711" top="105"
  [eval exp="tf.left = '1711'"]
  [eval exp="tf.top = '105'"]
[return]
