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
; tf.registerCharacterListにキャラクターIDを登録済みのキャラのregisterNewcharacterサブルーチンを実行する
; *registerCharactersFromParticipantsIdListを経由してくるか、事前にtf.registerCharacterListに登録しておくこと
*registerCharacters
  [iscript]
    // 明示的にfalseを入れて呼び出したときは初期化しない。それ以外は初期化する
    tf.needInitialize = ('needInitialize' in tf) ? tf.needInitialize : true;
  [endscript]
  [call target="*initialize" cond="tf.needInitialize"]

  [call storage="./chara/zundamon.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_ZUNDAMON)"]
  [call storage="./chara/metan.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_METAN)"]
  [call storage="./chara/tsumugi.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_TSUMUGI)"]
  [call storage="./chara/hau.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_HAU)"]
  [call storage="./chara/ritsu.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_RITSU)"]
  [call storage="./chara/takehiro.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_TAKEHIRO)"]
  [call storage="./chara/kotaro.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_KOTARO)"]
  [call storage="./chara/ryusei.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_RYUSEI)"]
  [call storage="./chara/himari.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_HIMARI)"]
  [call storage="./chara/sora.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_SORA)"]
  [call storage="./chara/mesuo.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_MESUO)"]
  [call storage="./chara/mochiko.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_MOCHIKO)"]
  [call storage="./chara/miko.ks" target="*registerNewcharacter" cond="tf.registerCharacterList.includes(CHARACTER_ID_MIKO)"]
[return]


; f.participantsIdListに登録されている（＝今回の人狼ゲームに登場する）キャラクターを登録する
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


; キャラの立ち絵情報を登録するサブルーチン。[chara_new][chara_face][chara_show]を連続実行する。
; 各キャラのregisterNewcharacterサブルーチンから呼び出すこと。
; 事前準備
; tf.characterId = キャラクターID
; tf.jname = キャラクター名
; f.defaultPosition[tf.characterId] = デフォルトポジションオブジェクト
; f.charaFaceObjects = {face: String, storage: String}のオブジェクトの配列
*executeCharaNewFaceShow
  [iscript]
    // chara_newのstorage用パスを変数に格納しておく
    tf.normalPath = 'chara/' + tf.characterId + '/normal.png';
    // ループ用カウンター
    tf.cnt = 0;
    tf.layer = tf.layer || 0;
  [endscript]
  [chara_new name="&tf.characterId" storage="&tf.normalPath" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="&tf.jname" reflect="&f.defaultPosition[tf.characterId].reflect"]

  ; chara_faceをwhileループ実行
  *executeCharaFace_loopstart
    [jump target="*executeCharaFace_loopend" cond="tf.cnt === f.charaFaceObjects.length"]
    [iscript]
      tf.face = f.charaFaceObjects[tf.cnt].face;
      tf.filePath = 'chara/' + tf.characterId + '/' + f.charaFaceObjects[tf.cnt].storage + '.png';
      // このタイミングでcntをインクリメントすることでiscript1回にまとめられる
      tf.cnt++;
    [endscript]
    [chara_face name="&tf.characterId" face="&tf.face" storage="&tf.filePath"]
    [jump target="*executeCharaFace_loopstart"]
  *executeCharaFace_loopend

  ; chara_showで通常の立ち絵だけをデフォルトの位置に表示しておく
  [chara_show name="&tf.characterId" face="通常" time="0" wait="true" layer="&tf.layer" left="&f.defaultPosition[tf.characterId].leftOnDefautRight" top="&f.defaultPosition[tf.characterId].top"]
  [eval exp="tf.layer = null"]
[return]
