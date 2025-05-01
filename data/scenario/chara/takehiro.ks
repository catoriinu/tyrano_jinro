; 玄野武宏のcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*registerNewcharacter
  [iscript]
    tf.characterId = CHARACTER_ID_TAKEHIRO;
    tf.jname = '玄野武宏';

    // キャラ画像のデフォルト座標をゲーム変数に格納する
    f.defaultPosition[tf.characterId] = {
      width: 549, // 画像の幅（画面幅1280pxの中での幅）
      haight: 824, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 245, // 画像の幅の中央（立ち絵の見た目の中央の位置。画像の左端からのpxで指定）
      top: 104, // キャラが登場したときのtopの値
      leftOnLeft: -90, // キャラが左側に登場したときのleftの値
      leftOnRight: 823, // キャラが右側に登場したときのleftの値
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
      {face: '喜び', storage: 'happy'},
      {face: '安心', storage: 'relieved'},
    ];
  [endscript]

  [call storage="./chara/common.ks" target="*executeCharaNewFaceShow"]
[return]
