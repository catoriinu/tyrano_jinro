; TyranoScript syntax その場プレビュー用事前設定ファイル
; ctrl + alt + Pで現在カーソル位置のプレビューを開くことができます。


; 以下、first.ksからコピペ。ただし[jump storage="title.ks"]だけはコピペしない
;一番最初に呼び出されるファイル

[title name="ボイボ人狼 ver.0.12.6"]

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

[iscript]
// デバッグモード
if (!('isDebugMode' in sf)) {
  sf.isDebugMode = true;
}

// シナリオ変数初期設定
// シアター含む、全てのゲーム進捗の初期化
if (!('theaterProgress' in sf)) {
  resetTheaterProgressToDefault();
}
// 人狼ゲームデータの初期化
if (!('jinroGameDataObjects' in sf)) {
  resetJinroGameDataObjectsToDefault();
}
// 紹介動画表示用の進捗
if (sf.isDebugMode) {
  // MEMO:必要になったら復活させる
  // setTheaterProgressForP99();
}
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
[endscript]

; タイトル表示
[title name="&sf.version.getVersionText('ボイボ人狼 ver.')"]

; ボタンホバー時、クリック時のSEをプリロードしておく（jsで非同期で鳴らす処理が遅れることによるボタン表示系のバグが頻発しているため、おまじないとして）
[preload storage="data/sound/se/button34.ogg" single_use="false"]
[preload storage="data/sound/se/button13.ogg" single_use="false"]
[preload storage="data/sound/se/button15.ogg" single_use="false"]

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
