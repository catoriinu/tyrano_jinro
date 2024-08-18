; 波音リツのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと
; ※キャラの待機位置は右側・左向きを基準とする

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = CHARACTER_ID_RITSU"]

  ; キャラ画像のサイズと登場位置等をゲーム変数に格納する
  [iscript]
    f.defaultPosition[tf.characterId] = {
      width: 640, // 画像の幅（画面幅1280pxの中での幅）
      haight: 960, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 305, // 画像の中央（立ち絵の見た目の中央の位置。画像の左端からのpxで指定）
      top: 124, // キャラが登場したときのtopの値
      leftOnLeft: -133, // キャラが左側に登場したときのleftの値
      leftOnRight: 775, // キャラが右側に登場したときのleftの値
      reflect: false, // キャラが右側に登場したときの立ち絵の向き。立ち絵が左向きならfalse, 右向きならtrueを指定する
    }
    // キャラが左(右)側から登場する直前の待機位置のleftの値。絶対値を上げるほど画面の遠くで待機する
    f.defaultPosition[tf.characterId].leftOnDefautLeft = f.defaultPosition[tf.characterId].leftOnLeft - 1000;
    f.defaultPosition[tf.characterId].leftOnDefautRight = f.defaultPosition[tf.characterId].leftOnRight + 1000;

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
  [chara_new name="&tf.characterId" storage="chara/ritsu/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="波音リツ" reflect="&f.defaultPosition[tf.characterId].reflect" ]
  [chara_face name="&tf.characterId" face="怒り" storage="chara/ritsu/angry.png"]
  [chara_face name="&tf.characterId" face="ため息" storage="chara/ritsu/astonished.png"]
  [chara_face name="&tf.characterId" face="真顔" storage="chara/ritsu/blank.png"]
  [chara_face name="&tf.characterId" face="笑顔" storage="chara/ritsu/laughing.png"]
  [chara_face name="&tf.characterId" face="通常" storage="chara/ritsu/normal.png"]
  [chara_face name="&tf.characterId" face="煽り" storage="chara/ritsu/scorn.png"]
  [chara_face name="&tf.characterId" face="困惑" storage="chara/ritsu/troubled.png"]
  [chara_face name="&tf.characterId" face="敗北" storage="chara/ritsu/astonished.png"]
  [chara_show name="&tf.characterId" face="通常" time="0" wait="true" left="&f.defaultPosition[tf.characterId].leftOnDefautRight" top="&f.defaultPosition[tf.characterId].top"]
[return]
