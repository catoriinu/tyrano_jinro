;一番最初に呼び出されるファイル

[title name="ボイボ人狼 ver.0.12.1"]

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
[eval exp="f.color = {}"]
[loadcss file="./data/others/jinro.css"]

[plugin name="playselist"] 

; さくた氏の「拡張UIパーツプラグイン」
[plugin name="uiparts_set"]

; ボイボ人狼用初期化
[call storage="theater/macros.ks"]
[call storage="achievement/macros.ks"]
[loadjs storage="voivoJinro/theater/Episode.js"]
[loadjs storage="voivoJinro/theater/Chapter.js"]
[loadjs storage="voivoJinro/theater/ResultCondition.js"]
[loadjs storage="voivoJinro/theater/CharacterCondition.js"]
[loadjs storage="voivoJinro/theater/theaterScripts.js"]
[loadjs storage="voivoJinro/theater/episodeData.js"]
[loadjs storage="voivoJinro/record/recordScripts.js"]

; キーフレーム定義読み込み
[call storage="keyframe.ks"]


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
  setTheaterProgressForP99();
}
// レコードの初期化
if (!('record' in sf)) {
  resetRecordToDefault();
}

// コンフィグ用初期設定
if (!('config' in sf)) {
  console.log("★RESET config★");
  sf.config = {
    current_bgm_vol:    70, // TG.config.defaultBgmVolume, // BGM音量
    current_se_vol:     70, // TG.config.defaultSeVolume, // SE音量
    current_voice_vol:  70, // TG.config.defaultSeVolume, // VOICE音量 デフォルトではSEと同じ
    current_ch_speed:   TG.config.chSpeed, // テキスト表示速度
    current_auto_speed: TG.config.autoSpeed, // オート時のテキスト表示速度 現在未使用
    mute_bgm:   false,
    mute_se:    false,
    mute_voice: false,
    mark_size: 20, // キャラ名マーカーのサイズ（0:なし、20:下線、100:塗りつぶし）
    show_icon: false, // キャラアイコン表示の有無 現在未使用
  }
}
tf.tmp_bgm_vol = sf.config.mute_bgm ? "0" : String(sf.config.current_bgm_vol);
tf.tmp_se_vol = sf.config.mute_se ? "0" : String(sf.config.current_se_vol);
tf.tmp_voice_vol = sf.config.mute_voice ? "0" : String(sf.config.current_voice_vol);
tf.tmp_ch_speed = String(sf.config.current_ch_speed);
[endscript]

[bgmopt volume="&tf.tmp_bgm_vol"]
[seopt volume="&tf.tmp_se_vol" buf="1"]
[seopt volume="&tf.tmp_voice_vol" buf="0"]
[configdelay speed="&tf.tmp_ch_speed"]

; デフォルトフォントの設定
[deffont size=32 color="0x28332a" face=MPLUSRounded][resetfont]

;メッセージボックスは非表示
[layopt layer="message" visible=false]

;最初は右下のメニューボタンを非表示にする
[hidemenubutton]

;タイトル画面へ移動
[jump storage="title.ks"]

[s]


