;一番最初に呼び出されるファイル
[stop_keyconfig]

; 素材ロード中にローディング表示をする
[loading_log preload="notext" icon="true"]

;ティラノスクリプトが標準で用意している便利なライブラリ群
;コンフィグ、CG、回想モードを使う場合は必須
[call storage="tyrano.ks"]

;ゲームで必ず必要な初期化処理はこのファイルに記述するのがオススメ
[plugin name="jinro"] 
[call storage="jinroMacros.ks"]
[call storage="messageMacros.ks"]
[call storage="effect/effectMacros.ks"]
[call storage="effect/keyframe.ks"]
[eval exp="f.color = {}"]
[loadcss file="./data/others/jinro.css"]

[plugin name="playselist"] 

; さくた氏の「拡張UIパーツプラグイン」
[plugin name="uiparts_set"]
; ティラノ公式の「ドラッグ＆ドロッププラクイン」
; [plugin name="drag-and-drop"]

; ボイボ人狼用初期化
[call storage="theater/macros.ks"]
[call storage="window/macros.ks"]
[loadjs storage="voivoJinro/theater/Episode.js"]
[loadjs storage="voivoJinro/theater/Chapter.js"]
[loadjs storage="voivoJinro/theater/ResultCondition.js"]
[loadjs storage="voivoJinro/theater/CharacterCondition.js"]
[loadjs storage="voivoJinro/theater/theaterScripts.js"]
[loadjs storage="voivoJinro/theater/episodeData.js"]
[loadjs storage="voivoJinro/record/recordScripts.js"]
[loadjs storage="voivoJinro/sf/Version.js"]

[iscript]
// デバッグモード
// TODO: リリース時にはfalseにすること
if (!('isDebugMode' in sf)) {
  sf.isDebugMode = true;
}

// ゲーム本体のバージョンをシナリオ変数に設定
sf.version = buildSfVersion(1, 0, 0, sf.isDebugMode, false);

// jinroプラグインのバージョンをシナリオ変数に設定
sf.jinroPluginVersion = new Version(
  sf.jinro.version.major,
  sf.jinro.version.minor,
  sf.jinro.version.patch,
  sf.jinro.isDebugMode,
);

// シナリオ変数初期設定
// シアター含む、全てのゲーム進捗の初期化
if (!('theaterProgress' in sf)) {
  resetTheaterProgressToDefault();
}
// 人狼ゲームデータの初期化
if (!('jinroGameDataObjects' in sf)) {
  resetJinroGameDataObjectsToDefault();
}
// 再生済みエピソードスキップ要否フラグ
if (!('doSkipPlayedEpisode' in sf)) {
  sf.doSkipPlayedEpisode = true;
}
// 紹介動画表示用の進捗
// MEMO:必要になったら復活させる
/*
if (sf.isDebugMode) {
  setTheaterProgressForP99();
}
*/

// レコードの初期化
if (!('record' in sf)) {
  resetRecordToDefault();
}

// コンフィグ用初期設定
if (!('config' in sf)) {
  console.debug("★RESET config★");
  sf.config = {
    current_bgm_vol:       70, // TG.config.defaultBgmVolume, // BGM音量
    current_button_se_vol: 70, // TG.config.defaultSeVolume, // ボタンSE音量
    current_se_vol:        70, // TG.config.defaultSeVolume, // その他SE音量
    current_voice_vol:     70, // TG.config.defaultSeVolume, // VOICE音量 デフォルトではSEと同じ
    current_ch_speed:   TG.config.chSpeed, // テキスト表示速度
    current_auto_speed: TG.config.autoSpeed, // オート時のテキスト表示速度 現在未使用
    mute_bgm:   false,
    mute_se:    false,
    mute_voice: false,
    mark_size: 20, // キャラ名マーカーのサイズ（0:なし、20:下線、100:塗りつぶし）
    show_icon: false, // キャラアイコン表示の有無 現在未使用
  }
}
tf.tmp_bgm_vol       = sf.config.mute_bgm       ? "0" : String(sf.config.current_bgm_vol);
tf.tmp_button_se_vol = sf.config.mute_button_se ? "0" : String(sf.config.current_button_se_vol);
tf.tmp_se_vol        = sf.config.mute_se        ? "0" : String(sf.config.current_se_vol);
tf.tmp_voice_vol     = sf.config.mute_voice     ? "0" : String(sf.config.current_voice_vol);
tf.tmp_ch_speed      = String(sf.config.current_ch_speed);

// ローディング表示
if (!('doShowLoadingIcon' in sf)) {
  sf.doShowLoadingIcon = true;
}
// loading_logのiconを有効にするには、文字列の'true'を設定する必要があるため変換
tf.doShowLoadingIcon = sf.doShowLoadingIcon ? 'true' : 'false';

// 必須ファイルのプリロード用
tf.preloadList = {
  multiUse: [
    // タイトル画面の背景画像
    "data/bgimage/voivojinrou_title_v4.png",
    // タイトル画面のBGM
    "data/bgm/fun_fun_Ukelele_1loop.ogg",
    // ボタンホバー時、クリック時のSE
    "data/sound/se/button34.ogg",
    "data/sound/se/button13.ogg",
    "data/sound/se/button15.ogg",
    // メッセージウィンドウ
    "data/image/message_window_none.png",
    "data/image/message_window_left.png",
    "data/image/message_window_right.png",
    "data/image/message_window_double.png",
    // ウィンドウ
    "data/fgimage/window_rectangle.png"
  ]
};

// まとめてロードするか
// TODO:タイトル画面で、初期値入ってなければ強制的にウィンドウ出す
if (!('needPreload' in sf)) {
  sf.needPreload = true;
}
[endscript]

; 素材ロード中にローディング表示をするか
[loading_log preload="notext" icon="&tf.doShowLoadingIcon"]

; タイトル表示
[title name="&sf.version.getVersionText('ボイボ人狼 ver.')"]

; 必須ファイルのプリロード
[preload storage="&tf.preloadList.multiUse" single_use="false"]

; 音量（BGM、ボタンSE、その他SE、VOICE）、テキスト速度の初期値を設定
[bgmopt volume="&tf.tmp_bgm_vol"]
[seopt volume="&tf.tmp_button_se_vol" buf="0"]
[seopt volume="&tf.tmp_voice_vol" buf="1"]
[seopt volume="&tf.tmp_se_vol" buf="2"]
[configdelay speed="&tf.tmp_ch_speed"]

; デフォルトフォントの設定
[deffont size="32" color="0x28332a" face="MPLUSRounded"]
[resetfont]

; メッセージウィンドウの設定
; ゲーム起動時は非表示
[layopt layer="message" visible="false"]
; 文字が表示される領域を調整
[position layer="message0" left="53" top="484" width="1174" height="235" margint="65" marginl="75" marginr="80" marginb="65" opacity="220" page="fore"]
; キャラクターの名前が表示される文字領域
[ptext name="chara_name_area" layer="message0" face="にくまるフォント" color="0x28332a" size="36" x="175" y="505"]

; キャラクターコンフィグ
; 上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
[chara_config ptext="chara_name_area"]
; pos_mode:キャラの初期位置はキャラ宣言時に全指定するのでfalse
[chara_config pos_mode="false" memory="true" time="200"]

;最初は右下のメニューボタンを非表示にする
[hidemenubutton]

;タイトル画面へ移動
[jump storage="title.ks"]

[s]


