; 四国めたんのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*registerNewcharacter
  [iscript]
    tf.characterId = CHARACTER_ID_METAN;
    tf.jname = '四国めたん';

    // キャラ画像のデフォルト座標をゲーム変数に格納する
    f.defaultPosition[tf.characterId] = {
      width: 800, // 画像の幅（画面幅1280pxの中での幅）
      haight: 800, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 373, // 画像の中央（立ち絵の見た目の中央の位置。画像の左端からのpxで指定）
      top: 108, // キャラが登場したときのtopの値
      leftOnLeft: -230, // キャラが左側に登場したときのleftの値
      leftOnRight: 711, // キャラが右側に登場したときのleftの値
      reflect: false, // キャラが右側に登場したときの立ち絵の向き。立ち絵が左向きならfalse, 右向きならtrueを指定する
    }
    // キャラが左(右)側から登場する直前の待機位置のleftの値。絶対値を上げるほど画面の遠くで待機する
    f.defaultPosition[tf.characterId].leftOnDefautLeft = f.defaultPosition[tf.characterId].leftOnLeft - 1000;
    f.defaultPosition[tf.characterId].leftOnDefautRight = f.defaultPosition[tf.characterId].leftOnRight + 1000;

    // キャラクターのイメージカラーのカラーコード
    f.color.character[tf.characterId] = '#ef65ec';
    // ステータス画面等の立ち絵
    f.statusFace[tf.characterId] = {
      alive: 'normal.png',
      lose: 'sad.png',
      win: {
        [FACTION_VILLAGERS]: 'happy.png',
        [FACTION_WEREWOLVES]: 'smug.png',
      },
      draw: 'panicked.png',
    };

    // キャラ立ち絵のfaceとstorageの紐づけ
    f.charaFaceObjects = [
      {face: '通常', storage: 'normal'},
      {face: '目閉じ', storage: 'blank'},
      {face: '恥ずかしい', storage: 'embarrassed'},
      {face: '困惑', storage: 'panicked'},
      {face: '悲しみ', storage: 'sad'},
      {face: '真剣', storage: 'serious'},
      {face: 'クスクス', storage: 'smug'},
      {face: '大喜び', storage: 'happy'},
      {face: '興奮', storage: 'excite'},
      {face: '夢中_ハイド', storage: 'trance_hide'},
    ];

    // 規定のイベントとfaceの紐づけ
    f.charaFaceForEvent[tf.characterId] = {
      '被襲撃': '悲しみ',
      '投票': '真剣',
    }
  [endscript]

  [call storage="./chara/common.ks" target="*executeCharaNewFaceShow"]
[return]
