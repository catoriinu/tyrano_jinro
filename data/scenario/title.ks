
[cm]

[clearstack]
[bg storage="voivojinrou_green.png" time="100" wait="true"]
[bg storage="voivojinrou_title_v3.png" time="100"]
[wait time="100"]

*start 
[ptext layer="1" x="1050" y="684" text="ver.0.11.0" color="white" size="24"]
[layopt layer="1" visible="true"]
; ボイス停止（人狼ゲームから戻ってきたとき用）
[stopse buf="0"]
[playbgm storage="fun_fun_Ukelele_1loop.ogg" volume="20" loop="true" restart="false"]

; 変数の初期化
[iscript]
  // タイトル画面に戻ってきたらバックログをリセットする
  // TODO ゲーム開始時にリセットするようにするなど、仕様を変えるならここも修正すること
  tf.system.backlog = [];
  // 人狼ゲーム中フラグ
  f.inJinroGame = false;
  // シチュエーションプレイで人狼ゲームを開始したフラグ
  f.isSituationPlay = false;
  // シアターで即座にエピソードウィンドウを開くフラグを初期化（タイトルに戻ってきたら次にシアターを開いてもウィンドウを開いてほしくないため）
  f.quickShowEpisodeWindow = false;

  // タイトル画面のボタン表示を判定するためにシアター進捗を取得していく
  // 初回起動時
  tf.isFirstStartup = (getTheaterProgress('p01', 'e01', 'c01') === THEATER_LOCKED);
  // チュートリアル未クリア
  tf.isTutolialNotCleared = (getTheaterProgress('p01', 'e01', 'c02') === THEATER_LOCKED);
  // ページ1未クリア
  tf.isPage01NotCleared = (getTheaterProgress('p01', 'e08', 'c02') === THEATER_WATCHED);

  // ボタンの色
  tf.buttonColor = CLASS_GLINK_DEFAULT;
[endscript]

; タイトル画面のボタン表示。予期せぬパターンがあると大変なので、面倒でもelsifで場合分けしておくこと
[if exp="tf.isFirstStartup"]
  [glink color="&tf.buttonColor" size="30" width="300" x="488" y="500" name="buttonhover" text="プレイスタート" target="*firstPlayStart"]
  [glink color="&tf.buttonColor" size="30" width="300" x="838" y="500" name="buttonhover" text="コンフィグ" target="*config"]
[elsif exp="tf.isTutolialNotCleared"]
  [glink color="&tf.buttonColor" size="30" width="300" x="138" y="500" name="buttonhover" text="シアター" target="*theater"]
  [glink color="&tf.buttonColor" size="30" width="300" x="488" y="500" name="buttonhover" text="プレイスタート" target="*firstPlayStart"]
  [glink color="&tf.buttonColor" size="30" width="300" x="838" y="500" name="buttonhover" text="コンフィグ" target="*config"]
[elsif exp="tf.isPage01NotCleared"]
  [glink color="&tf.buttonColor" size="30" width="300" x="138" y="500" name="buttonhover" text="シアター" target="*theater"]
  [glink color="&tf.buttonColor" size="30" width="300" x="488" y="500" name="buttonhover" text="プレイ" target="*gamestart"]
  [glink color="&tf.buttonColor" size="30" width="300" x="838" y="500" name="buttonhover" text="コンフィグ" target="*config"]
[else]
  [glink color="&tf.buttonColor" size="30" width="300" x="138" y="500" name="buttonhover" text="シアター" target="*theater"]
  [glink color="&tf.buttonColor" size="30" width="300" x="488" y="500" name="buttonhover" text="プレイ" target="*gamestart"]
  [glink color="&tf.buttonColor" size="30" width="300" x="838" y="500" name="buttonhover" text="コンフィグ" target="*config"]
  [glink color="&tf.buttonColor" size="30" width="300" x="488" y="610" name="buttonhover" text="カスタムプレイ" target="*selectStage"]
[endif]

; デバッグ系ボタン表示
[if exp="sf.isDebugMode"]
  [glink color="black" size="15" x="1152" y="684" text="開発者用" name="buttonhover" target="*developerSettings"]
  [glink color="black" size="15" x="1136" y="642" text="進捗初期化" name="buttonhover" target="*resetProgress"]
[endif]

[iscript]
  // ボタンにカーソルが乗ったときの処理
  $(".buttonhover").hover(
    function(e) {
      // glinkのenterse属性だと細かい設定ができないため独自に設定（特にbufがデフォルトだと他で鳴っている効果音を打ち消してしまう）
      TYRANO.kag.ftag.startTag("playse",{storage:"botan_b34.ogg",volume:40,buf:1});
    },
    function(e) {
      // ボタンが離れても何もしない。第二引数を明記しておかないと、離れたときも乗ったときと同じ処理が発生する
    }
  );
[endscript]
[s]

*gamestart
[freeimage layer="1"]
[stopbgm]

; 人狼ゲームのメインシナリオファイルへジャンプする
[j_registerParticipant characterId="&CHARACTER_ID_ZUNDAMON" isplayer="true"]
[j_prepareJinroGame participantsNumber="5" preload="true"]
[jump storage="playJinro.ks"]


*selectStage
[freeimage layer="1"]
[stopbgm]
;ステージ選択（TODO 現在はPCの役職のみ選択可能）シナリオファイルへジャンプする
[jump storage="selectStage.ks"]


*teststart
[freeimage layer="1"]
;テストファイルへジャンプする
[jump storage="movie_20230325.ks"]

*developerSettings
[freeimage layer="1"]
; 開発者用設定画面へジャンプする
[jump storage="developerSettings.ks"]


*theater
[freeimage layer="1"]
; シアターへジャンプする
[jump storage="theater/main.ks"]

*config
[freeimage layer="1"]
; コンフィグ画面へジャンプする
[jump storage="configJinro.ks"]

*resetProgress
[clearvar exp="sf.theaterProgress"]
[ptext layer="1" x="310" y="100" text="シアター進捗の初期化完了 再起動してください" color="black" size="60"]
[layopt layer="1" visible="true"]
[s]


*firstPlayStart
[freeimage layer="1"]
[stopbgm]

; 初回起動時なら「誰がずんだもちを食べたのだ？」導入編に飛ばす
[jump storage="theater/p01/e01_c01.ks" cond="tf.isFirstStartup"]
; それ以外でここに来た場合（は導入編は見終わったがまだチュートリアルをクリアしていない場合のみ）は、チュートリアルモードのまま人狼をプレイさせる
[jump storage="tutorial/tutorialSubroutines.ks" target="*toFirstInstruction"]
[s]
