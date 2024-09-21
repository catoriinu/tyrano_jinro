; 櫻歌ミコのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*registerNewcharacter
  [iscript]
    tf.characterId = CHARACTER_ID_MIKO;
    tf.jname = '櫻歌ミコ';

    // キャラ画像のデフォルト座標をゲーム変数に格納する
    f.defaultPosition[tf.characterId] = {
      width: 641, // 画像の幅（画面幅1280pxの中での幅）
      haight: 962, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 320, // 画像の中央（立ち絵の見た目の中央の位置。画像の左端からのpxで指定）
      top: 153,//143, // キャラが登場したときのtopの値
      leftOnLeft: -124, // キャラが左側に登場したときのleftの値
      leftOnRight: 764, // キャラが右側に登場したときのleftの値
      reflect: false, // キャラが右側に登場したときの立ち絵の向き。立ち絵が左向きならfalse, 右向きならtrueを指定する
    }
    // キャラが左(右)側から登場する直前の待機位置のleftの値。絶対値を上げるほど画面の遠くで待機する
    f.defaultPosition[tf.characterId].leftOnDefautLeft = f.defaultPosition[tf.characterId].leftOnLeft - 1090;
    f.defaultPosition[tf.characterId].leftOnDefautRight = f.defaultPosition[tf.characterId].leftOnRight + 1090;

    // キャラクターのイメージカラーのカラーコード
    f.color.character[tf.characterId] = '#ffccc5';
    // ステータス画面等の立ち絵
    f.statusFace[tf.characterId] = {};

    f.charaFaceObjects = [
      {face: '通常', storage: 'normal'},
      {face: 'がおー', storage: 'gao'},
      {face: 'わくわく', storage: 'wakuwaku'},
      {face: '笑顔', storage: '笑顔'},
      {face: '説明', storage: '説明'},
      {face: '悲しみ', storage: 'sad'},
      {face: '驚き', storage: 'surprised'},
      {face: 'やれやれ', storage: 'astonished'},
      {face: '恥ずかしい', storage: 'embarrassed'},
      {face: '笑顔でがおー', storage: 'gao_smile'},
    ];
  [endscript]

  [call storage="./chara/common.ks" target="*executeCharaNewFaceShow"]
[return]
