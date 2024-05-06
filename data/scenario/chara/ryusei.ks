; （キャラ名）のcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = CHARACTER_ID_RYUSEI"]

  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  [iscript]
    f.defaultPosition[tf.characterId] = {
      //side: 'right', // デフォルト待機位置
      //left: 1758, // デフォルト座標（left）
      side: 'left', // デフォルト待機位置
      left: -1149, // デフォルト座標（left）
      top: 87, // デフォルト座標（top）
      width: 674, // 画像の幅（画面幅1280pxの中での幅）
      haight: 841, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 310 // 画像の幅の中央(反転しない状態で)
    }
    // キャラクターのイメージカラーのカラーコード
    f.color.character[tf.characterId] = '#65e3ef';
    // ステータス画面等の立ち絵
    f.statusFace[tf.characterId] = {
      alive: 'normal.png',
      lose: 'astonished.png',
      win: {
        [FACTION_VILLAGERS]: 'relieved.png',
        [FACTION_WEREWOLVES]: 'wrysmile.png',
      },
      draw: 'tired.png',
    };
  [endscript]

  ; キャラクターの登録
  ; だいたいtf.characterIdを参照してくれるが、storageとjnameには正確な文字列を入れること
  ; 元画像が左向き（右側用の立ち絵）ならreflect="false"、逆ならreflect="true"とすること
  [chara_new name="&tf.characterId" storage="chara/ryusei/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="青山龍星" reflect="true" ]
  [chara_face name="&tf.characterId" face="normal" storage="chara/ryusei/normal.png"]
  [chara_show name="&tf.characterId" face="normal" time="0" wait="true" left="&f.defaultPosition[tf.characterId].left" top="&f.defaultPosition[tf.characterId].top"]
[return]