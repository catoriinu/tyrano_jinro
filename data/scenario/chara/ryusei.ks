; 青山龍星のcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと

; キャラクター登録サブルーチン
; chara_newタグとchara_faceタグをまとめて実行
; widthとhaightはここで設定しておくこと。
*executeCharaNewAndCharaFace
  [iscript]
    tf.characterId = CHARACTER_ID_RYUSEI;
    tf.jname = '青山龍星';

    // キャラ画像のデフォルト座標をゲーム変数に格納する
    f.defaultPosition[tf.characterId] = {
      width: 674, // 画像の幅（画面幅1280pxの中での幅）
      haight: 841, // 画像の高さ（画面高さ720pxの中での高さ）
      widthCenter: 310, // 画像の幅の中央（立ち絵の見た目の中央の位置。画像の左端からのpxで指定）
      top: 87, // キャラが登場したときのtopの値
      leftOnLeft: -149, // キャラが左側に登場したときのleftの値
      leftOnRight: 758, // キャラが右側に登場したときのleftの値
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
  [endscript]

  ; キャラクターの登録
  ; だいたいtf.characterIdを参照してくれるが、storageとjnameには正確な文字列を入れること
  ; 元画像が左向き（右側用の立ち絵）ならreflect="false"、逆ならreflect="true"とすること
  [chara_new name="&tf.characterId" storage="chara/ryusei/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="&tf.jname" reflect="&f.defaultPosition[tf.characterId].reflect"]
  [chara_face name="&tf.characterId" face="通常" storage="chara/ryusei/normal.png"]
  [chara_show name="&tf.characterId" face="通常" time="0" wait="true" left="&f.defaultPosition[tf.characterId].leftOnDefautRight" top="&f.defaultPosition[tf.characterId].top"]
[return]
