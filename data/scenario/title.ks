
[cm]

[clearstack]
[bg storage="voivojinrou_title_v3.png" time="1" wait="true"]

*start 
[ptext layer="1" x="5" y="685" text="ver.0.12.1" color="white" size="24"]
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
  tf.isPage01NotCleared = (getTheaterProgress('p01', 'e08', 'c02') !== THEATER_WATCHED);

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
  [glink color="&tf.buttonColor" size="30" width="300" x="488" y="500" name="buttonhover" text="プレイスタート" target="*gamestart"]
  [glink color="&tf.buttonColor" size="30" width="300" x="838" y="500" name="buttonhover" text="コンフィグ" target="*config"]
[else]
  [glink color="&tf.buttonColor" size="30" width="300" x="138" y="500" name="buttonhover" text="シアター" target="*theater"]
  [glink color="&tf.buttonColor" size="30" width="300" x="488" y="500" name="buttonhover" text="プレイスタート" target="*gamestart"]
  [glink color="&tf.buttonColor" size="30" width="300" x="838" y="500" name="buttonhover" text="コンフィグ" target="*config"]
  ;[glink color="&tf.buttonColor" size="30" width="300" x="488" y="600" name="buttonhover" text="カスタムプレイ" target="*selectStage"]
[endif]

  [glink color="&tf.buttonColor" size="30" width="300" x="488" y="600" name="buttonhover" text="カスタマイズ" target="*customize"]

; デバッグ系ボタン表示
[if exp="sf.isDebugMode"]
  [glink color="black" size="15" x="1125" y="4" width="90" text="進捗リセット" name="buttonhover" target="*resetProgress"]
  [glink color="black" size="15" x="1125" y="40" width="90" text="開発者用" name="buttonhover" target="*developerSettings"]
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

; シチュエーション開始チェック
[t_setStartingEpisodeSituation]
; TODO f.needPlayIntroEpisode = trueなら自動再生

; 開始する人狼ゲームデータを読み込み、人狼ゲームのメインシナリオファイルへジャンプする
[j_prepareJinroGame preload="true"]
[jump storage="playJinro.ks"]


*selectStage
[freeimage layer="1"]
[stopbgm]
;ステージ選択（TODO 現在はPCの役職のみ選択可能）シナリオファイルへジャンプする
[jump storage="selectStage.ks"]


*customize
[freeimage layer="1"]
; カスタマイズ画面へジャンプする
[jump storage="customize/main.ks"]


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
[html top="130" left="413.813" name="pause_menu_button_window"]
[endhtml]
[glink color="&tf.buttonColor" size="26" width="400" x="439" y="153" name="buttonhover" text="設定含めて完全初期化" target="*resetAll"]
[glink color="&tf.buttonColor" size="26" width="400" x="439" y="238" name="buttonhover" text="シアターのみ初期化" target="*resetTheater"]
[glink color="&tf.buttonColor" size="26" width="400" x="439" y="323" name="buttonhover" text="チュートリアル完了後" target="*resetAfterTutorial"]
[glink color="&tf.buttonColor" size="26" width="400" x="439" y="408" name="buttonhover" text="エンディング後" target="*resetAfterEnding"]
[glink color="&tf.buttonColor" size="26" width="400" x="439" y="493" name="buttonhover" text="何もしない" target="*start"]
[s]

*resetAll
[clearvar]
[jump target="*doneReset"]

*resetTheater
[clearvar exp="sf.theaterProgress"]
[jump target="*doneReset"]

*resetAfterTutorial
[iscript]
sf.theaterProgress = 
  {
    'p01': {
      'e01': {'c01': THEATER_WATCHED, 'c02': THEATER_WATCHED},
      'e02': {'c01': THEATER_UNLOCKED},
      'e03': {'c01': THEATER_UNLOCKED},
      'e04': {'c01': THEATER_UNLOCKED},
      'e05': {'c01': THEATER_UNLOCKED},
      'e06': {'c01': THEATER_UNLOCKED},
      'e07': {'c01': THEATER_UNLOCKED},
    }
  }
[endscript]
[jump target="*doneReset"]

*resetAfterEnding
[iscript]
sf.theaterProgress = 
  {
    'p01': {
      'e01': {'c01': THEATER_WATCHED, 'c02': THEATER_WATCHED},
      'e02': {'c01': THEATER_WATCHED, 'c02': THEATER_WATCHED},
      'e03': {'c01': THEATER_WATCHED, 'c02': THEATER_WATCHED},
      'e04': {'c01': THEATER_WATCHED, 'c02': THEATER_WATCHED},
      'e05': {'c01': THEATER_WATCHED, 'c02': THEATER_WATCHED},
      'e06': {'c01': THEATER_WATCHED, 'c02': THEATER_WATCHED},
      'e07': {'c01': THEATER_WATCHED, 'c02': THEATER_WATCHED},
      'e08': {'c01': THEATER_WATCHED, 'c02': THEATER_WATCHED},
    }
  }
[endscript]

*doneReset
[ptext layer="1" x="181" y="490" text="リセット完了 再起動してください" color="black" size="60"]
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
