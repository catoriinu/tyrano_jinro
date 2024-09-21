; もち子さんのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*registerNewcharacter
  [iscript]
    tf.characterId = CHARACTER_ID_MOCHIKO;
    tf.jname = 'もち子さん';

    // キャラ画像のデフォルト座標をゲーム変数に格納する
    f.defaultPosition[tf.characterId] = {
      width: 516, // 画像の幅（画面幅1280pxの中での幅）
      haight: 946, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 249, // 画像の中央（立ち絵の見た目の中央の位置。画像の左端からのpxで指定）
      top: 162, // キャラが登場したときのtopの値
      leftOnLeft: -52, // キャラが左側に登場したときのleftの値
      leftOnRight: 819, // キャラが右側に登場したときのleftの値
      reflect: false, // キャラが右側に登場したときの立ち絵の向き。立ち絵が左向きならfalse, 右向きならtrueを指定する
    }
    // キャラが左(右)側から登場する直前の待機位置のleftの値。絶対値を上げるほど画面の遠くで待機する
    f.defaultPosition[tf.characterId].leftOnDefautLeft = f.defaultPosition[tf.characterId].leftOnLeft - 1000;
    f.defaultPosition[tf.characterId].leftOnDefautRight = f.defaultPosition[tf.characterId].leftOnRight + 1000;

    // キャラクターのイメージカラーのカラーコード
    f.color.character[tf.characterId] = '#b7b6bb';
    // ステータス画面等の立ち絵
    f.statusFace[tf.characterId] = {
      alive: 'normal.png',
      lose: 'cry.png',
      win: {
        [FACTION_VILLAGERS]: 'smile.png',
        [FACTION_WEREWOLVES]: 'plotting.png',
      },
      draw: 'surprise.png',
    };

    f.charaFaceObjects = [
      {face: '通常', storage: 'normal'},
      {face: '笑顔', storage: 'smile'},
      {face: '驚き泣き', storage: 'surprise'},
      {face: '苦笑', storage: 'wry_smile'},
      {face: '紹介', storage: 'introduce'},
      {face: 'ハート目', storage: 'heart'},
      {face: '企む', storage: 'plotting'},
      {face: 'げっそり', storage: 'tired'},
      {face: '怒り', storage: 'angry'},
      {face: '悲しみ', storage: 'cry'},
      {face: '伏し目', storage: 'downcast_eyes'},
      {face: 'ドヤ顔', storage: 'doyagao'},
      {face: '説明', storage: 'instruction'},
    ];
  [endscript]

  [call storage="./chara/common.ks" target="*executeCharaNewFaceShow"]
[return]
