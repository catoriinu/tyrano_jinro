; 全キャラクター共通のcharaサブルーチン


; ゲームに登場する全キャラクターを登録するサブルーチン
; 全キャラクターのexecuteCharaNewAndCharaFaceサブルーチンを実行する
*registerAllCharacters
  ; defaultPositionをオブジェクトとして初期化する。これからキャラクターごとに格納していくため。
  [eval exp="f.defaultPosition = {}"]
  [call storage="./chara/zundamon.ks" target="*executeCharaNewAndCharaFace"]
  [call storage="./chara/metan.ks" target="*executeCharaNewAndCharaFace"]
  [call storage="./chara/tsumugi.ks" target="*executeCharaNewAndCharaFace"]
  [call storage="./chara/hau.ks" target="*executeCharaNewAndCharaFace"]
  [call storage="./chara/ritsu.ks" target="*executeCharaNewAndCharaFace"]
  [call storage="./chara/mochiko.ks" target="*executeCharaNewAndCharaFace"]
  [call storage="./chara/miko.ks" target="*executeCharaNewAndCharaFace"]
[return]
