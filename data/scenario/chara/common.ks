; 全キャラクター共通のcharaサブルーチン


; ゲームに登場する全キャラクターを登録するサブルーチン
; 全キャラクターのexecuteCharaNewAndCharaFaceサブルーチンを実行する
*registerAllCharacters
  [iscript]
    // defaultPositionをオブジェクトとして初期化する。これからキャラクターごとに格納していくため。
    f.defaultPosition = {}
    // 画面上に表示中のキャラクターを表すオブジェクト（表示キャラオブジェクト）の初期化
    f.displayedCharacter = {
      left: new DisplayedCharacterSingle(),
      right: new DisplayedCharacterSingle()
    }

    // キャラクターのイメージカラー用オブジェクト
    f.color.character = {}
    // ステータス画面等の立ち絵用オブジェクト
    f.statusFace = {}
  [endscript]
  
  [call storage="./chara/zundamon.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_ZUNDAMON)"]
  [call storage="./chara/metan.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_METAN)"]
  [call storage="./chara/tsumugi.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_TSUMUGI)"]
  [call storage="./chara/hau.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_HAU)"]
  [call storage="./chara/ritsu.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_RITSU)"]
  [call storage="./chara/takehiro.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_TAKEHIRO)"]
  [call storage="./chara/kotaro.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_KOTARO)"]
  [call storage="./chara/ryusei.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_RYUSEI)"]
  [call storage="./chara/himari.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_HIMARI)"]
  [call storage="./chara/sora.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_SORA)"]
  [call storage="./chara/mesuo.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_MESUO)"]
  ; TODO チュートリアル時だけ読み込めるようにしたい
  [call storage="./chara/mochiko.ks" target="*executeCharaNewAndCharaFace"]
  ;[call storage="./chara/mochiko.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_MOCHIKO)"]
  [call storage="./chara/miko.ks" target="*executeCharaNewAndCharaFace" cond="f.participantsIdList.includes(CHARACTER_ID_MIKO)"]
[return]
