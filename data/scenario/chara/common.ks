; 全キャラクター共通のcharaサブルーチン


; キャラクター登録状況初期化用サブルーチン
*initialize
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
  ; ここに来るまでにシナリオの都合でフィルターをかけている可能性があるので、外しておく。
  ; MEMO: 現状全フィルター外してしまっているので、問題がある場合はlayer指定やname指定やcond指定などすること
  [free_filter]
[return]


; ゲームに登場するキャラクターを登録するサブルーチン
; tf.registerCharacterListにキャラクターIDを登録済みのキャラのexecuteCharaNewAndCharaFaceサブルーチンを実行する
; *registerCharactersFromParticipantsIdListを経由してくるか、事前にtf.registerCharacterListに登録しておくこと
*registerCharacters
  [iscript]
    // 明示的にfalseを入れて呼び出したときは初期化しない。それ以外は初期化する
    tf.needInitialize = ('needInitialize' in tf) ? tf.needInitialize : true;
  [endscript]
  [call target="*initialize" cond="tf.needInitialize"]

  [call storage="./chara/zundamon.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_ZUNDAMON)"]
  [call storage="./chara/metan.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_METAN)"]
  [call storage="./chara/tsumugi.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_TSUMUGI)"]
  [call storage="./chara/hau.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_HAU)"]
  [call storage="./chara/ritsu.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_RITSU)"]
  [call storage="./chara/takehiro.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_TAKEHIRO)"]
  [call storage="./chara/kotaro.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_KOTARO)"]
  [call storage="./chara/ryusei.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_RYUSEI)"]
  [call storage="./chara/himari.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_HIMARI)"]
  [call storage="./chara/sora.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_SORA)"]
  [call storage="./chara/mesuo.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_MESUO)"]
  [call storage="./chara/mochiko.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_MOCHIKO)"]
  [call storage="./chara/miko.ks" target="*executeCharaNewAndCharaFace" cond="tf.registerCharacterList.includes(CHARACTER_ID_MIKO)"]
[return]


; f.participantsIdListに登録されている（＝今回のの人狼ゲームに登場する）キャラクターを登録する
*registerCharactersFromParticipantsIdList
  [iscript]
    tf.registerCharacterList = f.participantsIdList;
  [endscript]
  [call target="*registerCharacters"]
[return]


; 追加でキャラクターを登録したいときはこちらから登録する
; 事前にtf.registerCharacterListに登録しておくこと
*addRegisterCharacters
  [iscript]
    tf.needInitialize = false;
  [endscript]
  [call target="*registerCharacters"]
[return]
