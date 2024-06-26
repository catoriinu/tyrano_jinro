; 雨晴はうのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = CHARACTER_ID_HAU"]

  ; キャラ画像のデフォルト座標をゲーム変数に格納する
  ; 画面内への登場時の定位置はleft="796" top="143"
  [iscript]
    f.defaultPosition[tf.characterId] = {
      side: 'right', // デフォルト待機位置
      left: 1807, // デフォルト座標（left）
      top: 159, // デフォルト座標（top）
      width: 556, // 画像の幅（画面幅1280pxの中での幅）
      haight: 940, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 285, // 画像の幅の中央(反転しない状態で)
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
  [chara_new name="&tf.characterId" storage="chara/hau/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="雨晴はう"]
  [chara_face name="&tf.characterId" face="astonished" storage="chara/hau/astonished.png"]
  [chara_face name="&tf.characterId" face="laughing" storage="chara/hau/laughing.png"]
  [chara_face name="&tf.characterId" face="normal" storage="chara/hau/normal.png"]
  [chara_face name="&tf.characterId" face="relieved" storage="chara/hau/relieved.png"]
  [chara_face name="&tf.characterId" face="sad" storage="chara/hau/sad.png"]
  [chara_face name="&tf.characterId" face="thinking" storage="chara/hau/thinking.png"]
  [chara_face name="&tf.characterId" face="tired" storage="chara/hau/tired.png"]
  [chara_face name="&tf.characterId" face="wrysmile" storage="chara/hau/wrysmile.png"]
  [chara_show name="&tf.characterId" face="normal" time="0" wait="true" left="&f.defaultPosition[tf.characterId].left" top="&f.defaultPosition[tf.characterId].top"]
[return]
