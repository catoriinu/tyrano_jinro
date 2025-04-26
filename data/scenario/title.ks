*start
[cm]
[clearstack]
[bg storage="voivojinrou_title_v4.png" time="1" wait="true"]

; バージョン表示
[ptext layer="1" x="5" y="685" text="ver.0.12.6" color="white" size="24"]
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
  // チャプターリストの初期化
  f.chapterList = {};

  // タイトル画面のボタン表示を判定するためにエピソード進捗ステータスを取得していく
  // インストラクションクリア済みか
  tf.isInstructionCleared = (getTheaterProgress('p01', 'e01') === EPISODE_STATUS.OUTRO_UNLOCKED);

  // ボタンの色
  tf.buttonColor = CLASS_GLINK_DEFAULT;
  tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;

  // タイトル画面初回表示フラグ
  // ゲームの初回起動の意味ではない。displayButtonラベルに戻るボタンを押したときに、初回表示時以外は実行したくない処理を弾くためのフラグ
  tf.isFirstTime = true;
[endscript]

; 初回クリア通知ウィンドウ表示（初回クリア時以外は何もせず戻ってくる）
[jump storage="window/noticeClearedWindow.ks" target="*start"]

*displayButton

; タイトル画面のボタン表示
[glink color="&tf.buttonColor" size="30" width="300" x="488" y="460" name="buttonhover" text="プレイスタート" target="*gamestart"]
[glink color="&tf.buttonColor" size="30" width="300" x="838" y="460" name="buttonhover" text="コンフィグ" target="*config"]

; インストラクションクリア済みなら
[if exp="tf.isInstructionCleared"]
  [glink color="&tf.buttonColor" size="30" width="300" x="138" y="460" name="buttonhover" text="シアター" target="*theater"]
  [glink color="&tf.buttonColor" size="30" width="300" x="488" y="580" name="buttonhover" text="カスタマイズ" target="*customize"]
  [glink color="&tf.buttonColor" size="30" width="300" x="838" y="580" name="buttonhover" text="ヘルプ" target="*help"]

  ; 視聴済みエピソードスキップ要否ボタンを表示
  [iscript]
    tf.watchButtonColor = sf.doSkipWatchedEpisode ? tf.buttonColor : tf.selectedButtonColor;
    tf.skipButtonColor = sf.doSkipWatchedEpisode ? tf.selectedButtonColor : tf.buttonColor;
  [endscript]
  [ptext layer="1" x="157" y="555" text="解決編未解放時の導入編" color="0x28332a" size="24" cond="tf.isFirstTime"]
  [glink color="&tf.watchButtonColor" size="24" width="140" x="138" y="600" name="buttonhover" text="自動再生" exp="sf.doSkipWatchedEpisode = false" target="*displayButton"]
  [glink color="&tf.skipButtonColor" size="24" width="140" x="298" y="600" name="buttonhover" text="スキップ" exp="sf.doSkipWatchedEpisode = true" target="*displayButton"]
[endif]

; デバッグ系ボタン表示
[glink color="black" size="15" x="1125" y="4" width="90" text="進捗リセット" name="buttonhover" target="*resetProgress" cond="sf.isDebugMode"]
[glink color="black" size="15" x="1125" y="40" width="90" text="開発者用" name="buttonhover" target="*developerSettings" cond="sf.isDebugMode"]


[iscript]
  tf.isFirstTime = false;

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
; 人狼ゲームの準備、導入編自動再生、ゲーム開始
[jump storage="prepareJinro.ks" target="*prepareJinroGame"]


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


*help
; ヘルプウィンドウを表示する
[jump storage="window/helpWindow.ks"]
; メモ：初回クリア通知ウィンドウ表示テスト用
;[jump storage="window/noticeClearedWindow.ks" target="*displayNoticeClearedWindow"]

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
      'e01': EPISODE_STATUS.OUTRO_UNLOCKED,
      'e02': EPISODE_STATUS.INTRO_LOCKED_AVAILABLE,
      'e03': EPISODE_STATUS.INTRO_LOCKED_AVAILABLE,
      'e04': EPISODE_STATUS.INTRO_LOCKED_AVAILABLE,
      'e05': EPISODE_STATUS.INTRO_LOCKED_AVAILABLE,
      'e06': EPISODE_STATUS.INTRO_LOCKED_AVAILABLE,
      'e07': EPISODE_STATUS.INTRO_LOCKED_AVAILABLE,
      'e08': EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE,
    }
  }
[endscript]
[jump target="*doneReset"]

*resetAfterEnding
[iscript]
sf.theaterProgress = 
  {
    'p01': {
      'e01': EPISODE_STATUS.OUTRO_UNLOCKED,
      'e02': EPISODE_STATUS.OUTRO_UNLOCKED,
      'e03': EPISODE_STATUS.OUTRO_UNLOCKED,
      'e04': EPISODE_STATUS.OUTRO_UNLOCKED,
      'e05': EPISODE_STATUS.OUTRO_UNLOCKED,
      'e06': EPISODE_STATUS.OUTRO_UNLOCKED,
      'e07': EPISODE_STATUS.OUTRO_UNLOCKED,
      'e08': EPISODE_STATUS.OUTRO_UNLOCKED,
    }
  }
[endscript]

*doneReset
[ptext layer="1" x="181" y="490" text="リセット完了 再起動してください" color="black" size="60"]
[layopt layer="1" visible="true"]
[s]
