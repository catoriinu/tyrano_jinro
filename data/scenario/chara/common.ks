; 全キャラクター共通のcharaサブルーチン


; ゲームに登場する全キャラクターを登録するサブルーチン
; 全キャラクターのexecuteCharaNewAndCharaFaceサブルーチンを実行する
*registerAllCharacters
  [iscript]
    // defaultPositionをオブジェクトとして初期化する。これからキャラクターごとに格納していくため。
    f.defaultPosition = {}
    f.color.character = {}
    // 画面上に表示中のキャラクターを表すオブジェクト（表示キャラオブジェクト）の初期化
    f.displayedCharacter = {
      left: new DisplayedCharacterSingle(),
      right: new DisplayedCharacterSingle()
    }
  [endscript]
  
  [call storage="./chara/zundamon.ks" target="*executeCharaNewAndCharaFace"]
  [call storage="./chara/metan.ks" target="*executeCharaNewAndCharaFace"]
  [call storage="./chara/tsumugi.ks" target="*executeCharaNewAndCharaFace"]
  [call storage="./chara/hau.ks" target="*executeCharaNewAndCharaFace"]
  [call storage="./chara/ritsu.ks" target="*executeCharaNewAndCharaFace"]
  ;[call storage="./chara/mochiko.ks" target="*executeCharaNewAndCharaFace"]
  ;[call storage="./chara/miko.ks" target="*executeCharaNewAndCharaFace"]
[return]
