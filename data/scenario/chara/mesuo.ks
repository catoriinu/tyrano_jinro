; 剣崎雌雄のcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*registerNewcharacter
  [iscript]
    tf.characterId = CHARACTER_ID_MESUO;
    tf.jname = '剣崎雌雄';

    // キャラ画像のデフォルト座標をゲーム変数に格納する
    f.defaultPosition[tf.characterId] = {
      width: 612, // 画像の幅（画面幅1280pxの中での幅）
      haight: 657, // 画像の高さ（画面高さ720pxの中での高
      top: 69, // キャラが登場したときのtopの値
      widthCenter: 343, // 画像の幅の中央（立ち絵の見た目の中央の位置。画像の左端からのpxで指定）
      leftOnLeft: -94, // キャラが左側に登場したときのleftの値
      leftOnRight: 764, // キャラが右側に登場したときのleftの値
      reflect: false, // キャラが右側に登場したときの立ち絵の向き。立ち絵が左向きならfalse, 右向きならtrueを指定する
    }
    // キャラが左(右)側から登場する直前の待機位置のleftの値。絶対値を上げるほど画面の遠くで待機する
    f.defaultPosition[tf.characterId].leftOnDefautLeft = f.defaultPosition[tf.characterId].leftOnLeft - 1000;
    f.defaultPosition[tf.characterId].leftOnDefautRight = f.defaultPosition[tf.characterId].leftOnRight + 1000;

    // TODO キャラクターのイメージカラーのカラーコード
    f.color.character[tf.characterId] = '#65e3ef';
    // TODO ステータス画面等の立ち絵
    f.statusFace[tf.characterId] = {
      alive: 'normal.png',
      lose: 'astonished.png',
      win: {
        [FACTION_VILLAGERS]: 'relieved.png',
        [FACTION_WEREWOLVES]: 'wrysmile.png',
      },
      draw: 'tired.png',
    };

    f.charaFaceObjects = [
      {face: '通常', storage: 'normal'},
      {face: '笑顔', storage: 'laughing'},
      {face: '煽り', storage: 'scorn'},
      {face: '驚き', storage: 'surprised'},
      {face: '困惑', storage: 'troubled'},
    ];
  [endscript]

  [call storage="./chara/common.ks" target="*executeCharaNewFaceShow"]
[return]
