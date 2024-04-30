;一番最初に呼び出されるファイル

[title name="ボイボ人狼 ver.0.9.0"]

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
[loadjs storage="voivoJinro/achievement/AchievementCondition.js"]
[loadjs storage="voivoJinro/achievement/CharacterCondition.js"]
[loadjs storage="voivoJinro/theater/Episode.js"]
[loadjs storage="voivoJinro/theater/Chapter.js"]
[loadjs storage="voivoJinro/theater/Situation.js"]
[loadjs storage="voivoJinro/theater/theaterScripts.js"]
[loadjs storage="voivoJinro/theater/episodeData.js"]

; キーフレーム定義読み込み
[call storage="keyframe.ks"]

; コンフィグ用初期設定
[iscript]
// 初回起動時
if (!('config' in sf)) {
  console.log("★RESET config★");
  sf.config = {
    current_bgm_vol:    TG.config.defaultBgmVolume, // BGM音量
    current_se_vol:     TG.config.defaultSeVolume, // SE音量
    current_voice_vol:  TG.config.defaultSeVolume, // VOICE音量 デフォルトではSEと同じ
    current_ch_speed:   TG.config.chSpeed, // テキスト表示速度
    current_auto_speed: TG.config.autoSpeed, // オート時のテキスト表示速度 現在未使用
    mute_bgm:   false,
    mute_se:    false,
    mute_voice: false,
    mark_size: 0, // キャラ名マーカーのサイズ（0ならマーカーを引かない）
    show_icon: false, // キャラアイコン表示の有無 現在未使用
  }
}
tf.tmp_bgm_vol = sf.config.mute_bgm ? "0" : String(sf.config.current_bgm_vol);
tf.tmp_se_vol = sf.config.mute_se ? "0" : String(sf.config.current_se_vol);
// TODO sf.config.tmp_voice_volではなくsf.config.current_voice_volでは？
tf.tmp_voice_vol = sf.config.mute_voice ? "0" : String(sf.config.tmp_voice_vol);
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


