; もち子さんのcharaサブルーチン
; chara_xxxタグ関連の処理をまとめておく
; ※同一キャラの画像は差分含め全く同じサイズにしておくこと
; ※キャラの待機位置は右側・左向きを基準とする
*executeCharaNewAndCharaFace
  [eval exp="tf.characterId = CHARACTER_ID_MOCHIKO"]

  ; キャラ画像のサイズと登場位置等をゲーム変数に格納する
  [iscript]
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
  [endscript]

  [chara_new name="&tf.characterId" storage="chara/mochiko/normal.png" width="&f.defaultPosition[tf.characterId].width" haight="&f.defaultPosition[tf.characterId].haight" jname="もち子さん" reflect="&f.defaultPosition[tf.characterId].reflect"]
  [chara_face name="&tf.characterId" face="通常" storage="chara/mochiko/normal.png"]
  [chara_face name="&tf.characterId" face="笑顔" storage="chara/mochiko/smile.png"]
  [chara_face name="&tf.characterId" face="驚き泣き" storage="chara/mochiko/surprise.png"]
  [chara_face name="&tf.characterId" face="苦笑" storage="chara/mochiko/wry_smile.png"]
  [chara_face name="&tf.characterId" face="紹介" storage="chara/mochiko/introduce.png"]
  [chara_face name="&tf.characterId" face="ハート目" storage="chara/mochiko/heart.png"]
  [chara_face name="&tf.characterId" face="企む" storage="chara/mochiko/plotting.png"]
  [chara_face name="&tf.characterId" face="げっそり" storage="chara/mochiko/tired.png"]
  [chara_face name="&tf.characterId" face="怒り" storage="chara/mochiko/tired.png"]
  [chara_face name="&tf.characterId" face="悲しみ" storage="chara/mochiko/cry.png"]
  [chara_face name="&tf.characterId" face="伏し目" storage="chara/mochiko/downcast_eyes.png"]
  [chara_face name="&tf.characterId" face="ドヤ顔" storage="chara/mochiko/doyagao.png"]
  [chara_face name="&tf.characterId" face="説明" storage="chara/mochiko/instruction.png"]
  [chara_show name="&tf.characterId" face="通常" time="0" wait="true" left="&f.defaultPosition[tf.characterId].leftOnDefautRight" top="&f.defaultPosition[tf.characterId].top"]
[return]
