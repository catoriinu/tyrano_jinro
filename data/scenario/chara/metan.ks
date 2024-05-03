; 四国めたんのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = CHARACTER_ID_METAN"]

  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  [iscript]
    f.defaultPosition[tf.characterId] = {
      //side: 'right', // デフォルト待機位置
      //left: 1711, // デフォルト座標（left）
      side: 'left', // デフォルト待機位置
      left: -1230, // デフォルト座標（left）
      top: 108, // デフォルト座標（top）
      width: 800, // 画像の幅（画面幅1280pxの中での幅）
      haight: 800, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 373, // 画像の幅の中央(反転しない状態で)
    }
    // キャラクターのイメージカラーのカラーコード
    f.color.character[tf.characterId] = '#ef65ec';
    // ステータス画面等の立ち絵
    f.statusFace[tf.characterId] = {
      alive: 'normal.png',
      lose: 'sad.png',
      win: {
        [FACTION_VILLAGERS]: 'blank.png', // TODO 笑顔の表情増やしたい
        [FACTION_WEREWOLVES]: 'smug.png',
      },
      draw: 'panicked.png',
    };
  [endscript]

  ; キャラクターの登録
  ; だいたいtf.characterIdを参照してくれるが、storageとjnameには正確な文字列を入れること
  [chara_new name="&tf.characterId" storage="chara/metan/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="四国めたん" reflect="true" ]
  [chara_face name="&tf.characterId" face="blank" storage="chara/metan/blank.png"]
  [chara_face name="&tf.characterId" face="embarrassed" storage="chara/metan/embarrassed.png"]
  [chara_face name="&tf.characterId" face="normal" storage="chara/metan/normal.png"]
  [chara_face name="&tf.characterId" face="panicked" storage="chara/metan/panicked.png"]
  [chara_face name="&tf.characterId" face="sad" storage="chara/metan/sad.png"]
  [chara_face name="&tf.characterId" face="serious" storage="chara/metan/serious.png"]
  [chara_face name="&tf.characterId" face="smug" storage="chara/metan/smug.png"]
  [chara_show name="&tf.characterId" face="normal" time="0" wait="true" left="&f.defaultPosition[tf.characterId].left" top="&f.defaultPosition[tf.characterId].top"]
[return]
