; ずんだもんのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと
; ※キャラの待機位置は右側・左向きを基準とする

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = CHARACTER_ID_ZUNDAMON"]

  ; キャラ画像のサイズと登場位置等をゲーム変数に格納する
  [iscript]
    f.defaultPosition[tf.characterId] = {
      width: 550, // 画像の幅（画面幅1280pxの中での幅）
      haight: 733, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 258, // 画像の中央（立ち絵の見た目の中央の位置。画像の左端からのpxで指定）
      top: 145,//135, // キャラが登場したときのtopの値
      leftOnLeft: -100, // キャラが左側に登場したときのleftの値
      leftOnRight: 831, // キャラが右側に登場したときのleftの値
      reflect: false, // キャラが右側に登場したときの立ち絵の向き。立ち絵が左向きならfalse, 右向きならtrueを指定する
    }
    // キャラが左(右)側から登場する直前の待機位置のleftの値。絶対値を上げるほど画面の遠くで待機する
    f.defaultPosition[tf.characterId].leftOnDefautLeft = f.defaultPosition[tf.characterId].leftOnLeft - 1090;
    f.defaultPosition[tf.characterId].leftOnDefautRight = f.defaultPosition[tf.characterId].leftOnRight + 1090;

    // キャラクターのイメージカラーのカラーコード
    f.color.character[tf.characterId] = '#67ef65';
    // ステータス画面等の立ち絵
    f.statusFace[tf.characterId] = {
      alive: 'normal.png',
      lose: 'sad.png',
      win: {
        [FACTION_VILLAGERS]: 'happy.png',
        [FACTION_WEREWOLVES]: 'proud.png',
      },
      draw: 'troubled.png',
    };
  [endscript]

  ; キャラクターの登録
  ; だいたいtf.characterIdを参照してくれるが、storageとjnameには正確な文字列を入れること
  [chara_new name="&tf.characterId" storage="chara/zundamon/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="ずんだもん" reflect="&f.defaultPosition[tf.characterId].reflect" ]
  [chara_face name="&tf.characterId" face="deny" storage="chara/zundamon/deny.png"]
  [chara_face name="&tf.characterId" face="happy" storage="chara/zundamon/happy.png"]
  [chara_face name="&tf.characterId" face="通常" storage="chara/zundamon/normal.png"]
  [chara_face name="&tf.characterId" face="panicked" storage="chara/zundamon/panicked.png"]
  [chara_face name="&tf.characterId" face="proud" storage="chara/zundamon/proud.png"]
  [chara_face name="&tf.characterId" face="sad" storage="chara/zundamon/sad.png"]
  [chara_face name="&tf.characterId" face="smug" storage="chara/zundamon/smug.png"]
  [chara_face name="&tf.characterId" face="surprised" storage="chara/zundamon/surprised.png"]
  [chara_face name="&tf.characterId" face="troubled" storage="chara/zundamon/troubled.png"]
  [chara_face name="&tf.characterId" face="thinking" storage="chara/zundamon/thinking.png"]
  [chara_face name="&tf.characterId" face="lose" storage="chara/zundamon/sad.png"]
  [chara_show name="&tf.characterId" face="通常" time="0" wait="true" left="&f.defaultPosition[tf.characterId].leftOnDefautRight" top="&f.defaultPosition[tf.characterId].top"]
[return]
