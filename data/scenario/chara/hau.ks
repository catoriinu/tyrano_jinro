; 雨晴はうのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと
; ※キャラの待機位置は右側・左向きを基準とする

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = CHARACTER_ID_HAU"]

  ; キャラ画像のサイズと登場位置等をゲーム変数に格納する
  [iscript]
    f.defaultPosition[tf.characterId] = {
      width: 556, // 画像の幅（画面幅1280pxの中での幅）
      haight: 940, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 285, // 画像の中央（立ち絵の見た目の中央の位置。画像の左端からのpxで指定）
      top: 159, // キャラが登場したときのtopの値
      leftOnLeft: -82, // キャラが左側に登場したときのleftの値
      leftOnRight: 807, // キャラが右側に登場したときのleftの値
      reflect: false, // キャラが右側に登場したときの立ち絵の向き。立ち絵が左向きならfalse, 右向きならtrueを指定する
    }
    // キャラが左(右)側から登場する直前の待機位置のleftの値。絶対値を上げるほど画面の遠くで待機する
    f.defaultPosition[tf.characterId].leftOnDefautLeft = f.defaultPosition[tf.characterId].leftOnLeft - 1000;
    f.defaultPosition[tf.characterId].leftOnDefautRight = f.defaultPosition[tf.characterId].leftOnRight + 1000;

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
  [chara_new name="&tf.characterId" storage="chara/hau/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="雨晴はう" reflect="&f.defaultPosition[tf.characterId].reflect" ]
  [chara_face name="&tf.characterId" face="astonished" storage="chara/hau/astonished.png"]
  [chara_face name="&tf.characterId" face="laughing" storage="chara/hau/laughing.png"]
  [chara_face name="&tf.characterId" face="通常" storage="chara/hau/normal.png"]
  [chara_face name="&tf.characterId" face="relieved" storage="chara/hau/relieved.png"]
  [chara_face name="&tf.characterId" face="sad" storage="chara/hau/sad.png"]
  [chara_face name="&tf.characterId" face="thinking" storage="chara/hau/thinking.png"]
  [chara_face name="&tf.characterId" face="tired" storage="chara/hau/tired.png"]
  [chara_face name="&tf.characterId" face="wrysmile" storage="chara/hau/wrysmile.png"]
  [chara_face name="&tf.characterId" face="lose" storage="chara/hau/astonished.png"]
  [chara_show name="&tf.characterId" face="通常" time="0" wait="true" left="&f.defaultPosition[tf.characterId].leftOnDefautRight" top="&f.defaultPosition[tf.characterId].top"]
[return]
