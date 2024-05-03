; 波音リツのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = CHARACTER_ID_RITSU"]

  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  [iscript]
    f.defaultPosition[tf.characterId] = {
      //side: 'right', // デフォルト待機位置
      //left: 1775, // デフォルト座標（left）
      side: 'left', // デフォルト待機位置
      left: -1133, // デフォルト座標（left）
      top: 124, // デフォルト座標（top）
      width: 640, // 画像の幅（画面幅1280pxの中での幅）
      haight: 960, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 305, // 画像の幅の中央(反転しない状態で)
    }
    // キャラクターのイメージカラーのカラーコード
    f.color.character[tf.characterId] = '#ef6a65';
    // ステータス画面等の立ち絵
    f.statusFace[tf.characterId] = {
      alive: 'normal.png',
      lose: 'astonished.png',
      win: {
        [FACTION_VILLAGERS]: 'laughing.png',
        [FACTION_WEREWOLVES]: 'scorn.png',
      },
      draw: 'troubled.png',
    };
  [endscript]

  ; キャラクターの登録
  ; だいたいtf.characterIdを参照してくれるが、storageとjnameには正確な文字列を入れること
  [chara_new name="&tf.characterId" storage="chara/ritsu/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="波音リツ" reflect="true" ]
  [chara_face name="&tf.characterId" face="angry" storage="chara/ritsu/angry.png"]
  [chara_face name="&tf.characterId" face="astonished" storage="chara/ritsu/astonished.png"]
  [chara_face name="&tf.characterId" face="blank" storage="chara/ritsu/blank.png"]
  [chara_face name="&tf.characterId" face="laughing" storage="chara/ritsu/laughing.png"]
  [chara_face name="&tf.characterId" face="normal" storage="chara/ritsu/normal.png"]
  [chara_face name="&tf.characterId" face="scorn" storage="chara/ritsu/scorn.png"]
  [chara_face name="&tf.characterId" face="troubled" storage="chara/ritsu/troubled.png"]
  [chara_show name="&tf.characterId" face="normal" time="0" wait="true" left="&f.defaultPosition[tf.characterId].left" top="&f.defaultPosition[tf.characterId].top"]
[return]
