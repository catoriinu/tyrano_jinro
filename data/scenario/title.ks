*start
[cm]
[clearstack]
[bg storage="voivojinrou_title_v4.png" time="1" wait="true"]

; バージョン表示
[iscript]
  tf.versionText = sf.version.getVersionText('game ver.') + sf.jinroPluginVersion.getVersionText(' / plugin ver.');
[endscript]
[ptext layer="1" x="5" y="685" text="&tf.versionText" color="white" size="24"]
[layopt layer="1" visible="true"]

; ボイス停止（人狼ゲームから戻ってきたとき用）
[stopse buf="1"]
[playbgm storage="fun_fun_Ukelele_1loop.ogg" volume="15" loop="true" restart="false"]

; 変数の初期化
[iscript]
  // タイトル画面に戻ってきたらバックログをリセットする
  // TODO ゲーム開始時にリセットするようにするなど、仕様を変えるならここも修正すること
  tf.system.backlog = [];
  // 人狼ゲーム中フラグ
  f.inJinroGame = false;
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
[glink color="&tf.buttonColor" size="30" width="300" x="488" y="460" enterse="se/button34.ogg" clickse="se/button13.ogg" text="プレイスタート" target="*gamestart"]
[glink color="&tf.buttonColor" size="30" width="300" x="838" y="460" enterse="se/button34.ogg" clickse="se/button13.ogg" text="コンフィグ" target="*config"]

; インストラクションクリア済みなら
[if exp="tf.isInstructionCleared"]
  [glink color="&tf.buttonColor" size="30" width="300" x="138" y="460" enterse="se/button34.ogg" clickse="se/button13.ogg" text="シアター" target="*theater"]
  [glink color="&tf.buttonColor" size="30" width="300" x="488" y="580" enterse="se/button34.ogg" clickse="se/button13.ogg" text="カスタマイズ" target="*customize"]
  [glink color="&tf.buttonColor" size="30" width="300" x="838" y="580" enterse="se/button34.ogg" clickse="se/button13.ogg" text="ヘルプ" target="*help"]

  ; 再生済みエピソードスキップ要否ボタンを表示
  [iscript]
    const selectButtonSe = 'se/button13.ogg';
    const cancelButtonSe = 'se/button15.ogg';
    if (sf.doSkipPlayedEpisode) {
        tf.watchButtonColor = tf.buttonColor;
        tf.watchButtonSe = selectButtonSe;
        tf.skipButtonColor = tf.selectedButtonColor;
        tf.skipButtonSe = cancelButtonSe;
    } else {
        tf.watchButtonColor = tf.selectedButtonColor;
        tf.watchButtonSe = cancelButtonSe;
        tf.skipButtonColor = tf.buttonColor;
        tf.skipButtonSe = selectButtonSe;
    }
  [endscript]
  [ptext layer="1" x="157" y="555" text="解決編未解放時の導入編" color="0x28332a" size="24" cond="tf.isFirstTime"]
  [glink color="&tf.watchButtonColor" size="24" width="140" x="138" y="600" enterse="se/button34.ogg" clickse="&tf.watchButtonSe" text="自動再生" exp="sf.doSkipPlayedEpisode = false" target="*displayButton"]
  [glink color="&tf.skipButtonColor" size="24" width="140" x="298" y="600" enterse="se/button34.ogg" clickse="&tf.skipButtonSe" text="スキップ" exp="sf.doSkipPlayedEpisode = true" target="*displayButton"]
[endif]

; 進捗リセット
[glink color="black" size="15" x="1125" y="4" width="90" text="進捗リセット" enterse="se/button34.ogg" clickse="se/button13.ogg" target="*resetProgress"]
; 開発者用メニュー（デバッグモード時限定）
[glink color="black" size="15" x="1125" y="40" width="90" text="開発者用" enterse="se/button34.ogg" clickse="se/button13.ogg" target="*developerSettings" cond="sf.isDebugMode"]


[iscript]
  tf.isFirstTime = false;
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
; 進捗リセットウィンドウを表示する
[jump storage="window/resetProgressWindow.ks"]
[s]
