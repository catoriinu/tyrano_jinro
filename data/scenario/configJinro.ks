;=========================================
; コンフィグ モード　画面作成
;=========================================

; メッセージレイヤ0を不可視に
[layopt layer="message0" visible="false"]

[nolog]

; fixボタンをクリア
[clearfix]

; キーコンフィグの無効化
[stop_keyconfig]

; レイヤーモードの解放
[free_layermode time="100" wait="true"]

; カメラのリセット
[reset_camera time="100" wait="true"]

; 前景レイヤの中身をすべて空に
[iscript]
  $(".layer_camera").empty();
[endscript]

; メニューボタン非表示
 [hidemenubutton]

[iscript]
  /* sf.configはfirst.ksで初期設定しておくこと */

  /* スライダーの初期位置 */
  tf.tmp_bgm_vol   = sf.config.current_bgm_vol;
  tf.tmp_se_vol    = sf.config.current_se_vol;
  tf.tmp_voice_vol = sf.config.current_voice_vol;
  tf.tmp_ch_speed_reverse = String(100 - sf.config.current_ch_speed);
  /*
   * tf.tmp_ch_speed_reverseについて：
   * ティラノの[configdelay]のspeedは「次の1文字を表示するまでのミリ秒」であり、値が小さいほど表示が早くなる。
   * それをスライダーで表すと、左の方が早くなり直感に反する。
   * なので、スライダーが0（左）なら最も遅い（speed="100"）、スライダーが100（右）なら最も早い（speed="0"）になるようにするため、
   * 一時変数には、100からシステム変数を引いた値を入れておく。
   */

  /* 画像類のパス */
  tf.img_path = '../image/config/';

  /* 画像類のパス（ボタン） */
  tf.btn_path_off = tf.img_path + 'c_btn.gif';
  tf.btn_path_on  = tf.img_path + 'c_set.png';
  tf.muting_button_path = tf.img_path + 'muting_button.png';
  tf.unmuting_button_path = tf.img_path + 'unmuting_button.png';

  // ミュートボタン/アンミュートボタン
  tf.btn_w = 54; // 幅
  tf.btn_h = 54; // 高さ
  tf.btn_x = 1070; // X座標

  // スライダーのX座標
  tf.slider_x = 435;

[endscript]

[cm]

; コンフィグ用の背景を読み込んでトランジション
[bg storage="&tf.img_path +'voivo_config_bg.png'" time="100"]

[ptext layer="1" x="490" y="30"  text="コンフィグ" color="#28332a" size="60"]
[ptext layer="1" x="100" y="180" text="音量" color="#28332a" size="46"]
[ptext layer="1" x="245" y="180" text="BGM" color="#28332a" size="46"]
[ptext layer="1" x="245" y="270" text="SE" color="#28332a" size="46"]
[ptext layer="1" x="245" y="360" text="VOICE" color="#28332a" size="46"]
[ptext layer="1" x="100" y="450" text="テキスト速度" color="#28332a" size="46"]

; テキスト表示速度のサンプルに使用するメッセージレイヤの設定
[position layer="message1" left="50" top="600" width="1174" height="80" page="fore" color="0xffffff" border_color="0x000000" border_size="7" radius="45" margint="8" marginl="40" opacity="210"]
[layopt layer="message1" visible="true"]
[current layer="message1"]

; 画面右上の「Back」ボタン
[button fix="true" graphic="&tf.img_path + 'c_btn_back.png'" enterimg="&tf.img_path + 'c_btn_back2.png'" target="*backtitle" x="1160" y="20"]

[jump target="*config_page"]


*config_page
;------------------------------------------------------------------------------------------------------
; BGM音量
;------------------------------------------------------------------------------------------------------

; スライダー
[iscript]
  tf.bgm_exp = function(){
    // スライダーを動かしたら、アンミュートボタンを表示する
    $(".bgmvol_0").attr("src","data/image/config/unmuting_button.png");
    tf.use_slider_bgm = true;
    // BGMは常に鳴っているのでスライダー内で音量を変更する（TODO 人狼ゲーム中の鳴っていないタイミングならどうする？）
    TYRANO.kag.ftag.startTag("bgmopt", {
      volume: tf.tmp_bgm_vol
    })
  }
[endscript]
[slider name="bgm_vol_slider" exp="tf.bgm_exp()" target="*vol_bgm_change" var="tf.tmp_bgm_vol" x="&tf.slider_x" y="210" width="560" height="10" active_color="#A5D4AD" thumb_width="30" thumb_height="30" thumb_color="#A5D4AD" tip_width="60" tip_height="30" tip_color="#A5D4AD" tip_text_color="#242424" tip_text_size="20" tip_tail="false" tip_margin="15"]

; ミュートボタン/アンミュートボタン
[eval exp="tf.bgm_mute_button = sf.config.mute_bgm ? tf.muting_button_path : tf.unmuting_button_path"]
[button name="bgmvol,bgmvol_0" fix="true" target="*vol_bgm_change" graphic="&tf.bgm_mute_button" width="&tf.btn_w" height="&tf.btn_h" x="&tf.btn_x" y="187"]


;------------------------------------------------------------------------------------------------------
; SE音量
;------------------------------------------------------------------------------------------------------

; スライダー
[iscript]
  tf.se_exp = function(){
    // スライダーを動かしたら、アンミュートボタンを表示する
    // 実際のミュート解除ロジックはサブルーチン側で行う
    $(".sevol_0").attr("src","data/image/config/unmuting_button.png");
    tf.use_slider_se = true;
  }
[endscript]
[slider name="se_vol_slider" exp="tf.se_exp()" target="*vol_se_change" var="tf.tmp_se_vol" x="&tf.slider_x" y="300" width="560" height="10" active_color="#A5D4AD" thumb_width="30" thumb_height="30" thumb_color="#A5D4AD" tip_width="60" tip_height="30" tip_color="#A5D4AD" tip_text_color="#242424" tip_text_size="20" tip_tail="false" tip_margin="15"]

; ミュートボタン/アンミュートボタン
[eval exp="tf.se_mute_button = sf.config.mute_se ? tf.muting_button_path : tf.unmuting_button_path"]
[button name="sevol,sevol_0" fix="true" target="*vol_se_change" graphic="&tf.se_mute_button" width="&tf.btn_w" height="&tf.btn_h" x="&tf.btn_x" y="277"]


;------------------------------------------------------------------------------------------------------
; VOICE音量
;------------------------------------------------------------------------------------------------------

; スライダー
[iscript]
  tf.voice_exp = function(){
    // スライダーを動かしたら、アンミュートボタンを表示する
    // 実際のミュート解除ロジックはサブルーチン側で行う
    $(".voicevol_0").attr("src","data/image/config/unmuting_button.png");
    tf.use_slider_voice = true;
  }
[endscript]
[slider name="voice_vol_slider" exp="tf.voice_exp()" target="*vol_voice_change" var="tf.tmp_voice_vol" x="&tf.slider_x" y="390" width="560" height="10" active_color="#A5D4AD" thumb_width="30" thumb_height="30" thumb_color="#A5D4AD" tip_width="60" tip_height="30" tip_color="#A5D4AD" tip_text_color="#242424" tip_text_size="20" tip_tail="false" tip_margin="15"]

; ミュートボタン/アンミュートボタン
[eval exp="tf.voice_mute_button = sf.config.mute_voice ? tf.muting_button_path : tf.unmuting_button_path"]
[button name="vol,voicevol_0" fix="true" target="*vol_voice_change" graphic="&tf.voice_mute_button" width="&tf.btn_w" height="&tf.btn_h" x="&tf.btn_x" y="367"]


;------------------------------------------------------------------------------------------------------
; テキスト速度
;------------------------------------------------------------------------------------------------------

; スライダー
[slider name="ch_speed_slider" target="*ch_speed_change" var="tf.tmp_ch_speed_reverse" x="&tf.slider_x" y="480" width="560" height="10" active_color="#A5D4AD" thumb_width="30" thumb_height="30" thumb_color="#A5D4AD" tip_width="60" tip_height="30" tip_color="#A5D4AD" tip_text_color="#242424" tip_text_size="20" tip_tail="false" tip_margin="15"]

[iscript]
/*
  // コンフィグに関わる設定を全て削除する。sf.configだけでなく下記のシステム変数まで削除しないと、config.tjsの設定を再読み込みしに行ってくれない。
  delete sf.config;
  delete sf._system_config_bgm_volume;
  delete sf._system_config_se_volume;
  delete sf._config_ch_speed;
  console.log("config all deleted");
*/
[endscript]
[s]


;--------------------------------------------------------------------------------
; コンフィグモードの終了
;--------------------------------------------------------------------------------
*backtitle
[cm]

[endnolog]

;	テキスト速度のサンプル表示に使用していたメッセージレイヤを非表示に
[layopt layer="message1" visible="false"]
;[layopt layer="message0" visible="true"]
[current layer="message0"]

; 見出しのテキストを非表示に
[freeimage layer="1"]

; fixボタンをクリア
[clearfix]

; キーコンフィグの有効化
[start_keyconfig]

; コールスタックのクリア
[clearstack]

;	ゲーム復帰
;[awakegame]
[jump storage="title.ks"]

;================================================================================
; サブルーチン
;================================================================================

;--------------------------------------------------------------------------------
; BGM音量
;--------------------------------------------------------------------------------
*vol_bgm_change

[if exp="tf.use_slider_bgm || sf.config.mute_bgm"]
  ; スライダーを動かした、またはミュート状態でアンミュートボタンを押した場合はミュートを解除する
  [iscript]
    $(".bgmvol_0").attr("src","data/image/config/unmuting_button.png");
    sf.config.mute_bgm = false;

    if (tf.use_slider_bgm) {
      // スライダーを動かしたときは、スライダーで決めた値でシステム変数を更新する
      sf.config.current_bgm_vol = tf.tmp_bgm_vol = String(tf.tmp_bgm_vol); // 数字の0だと無視される仕様なので必ず文字列変換すること
      // スライダーフラグはfalseに戻す
      tf.use_slider_bgm = false;
    } else {
      // アンミュートボタンを押したときは、システム変数に入っている値を使う
      tf.tmp_bgm_vol = sf.config.current_bgm_vol;
    }
  [endscript]

[else]
  ; 非ミュート状態ならミュートにする
  [iscript]
    $(".bgmvol_0").attr("src","data/image/config/muting_button.png");
    sf.config.mute_bgm = true;
    tf.tmp_bgm_vol = "0"; // 数字の0だと無視される仕様なので必ず文字列の"0"を指定すること
  [endscript]
[endif]

[bgmopt volume="&tf.tmp_bgm_vol"]

[return]


;--------------------------------------------------------------------------------
; SE音量
;--------------------------------------------------------------------------------

*vol_se_change

[if exp="tf.use_slider_se || sf.config.mute_se"]
  ; スライダーを動かした、またはミュート状態でアンミュートボタンを押した場合はミュートを解除する
  [iscript]
    $(".sevol_0").attr("src","data/image/config/unmuting_button.png");
    sf.config.mute_se = false;

    if (tf.use_slider_se) {
      // スライダーを動かしたときは、スライダーで決めた値でシステム変数を更新する
      sf.config.current_se_vol = tf.tmp_se_vol = String(tf.tmp_se_vol); // 数字の0だと無視される仕様なので必ず文字列変換すること
      // スライダーフラグはfalseに戻す
      tf.use_slider_se = false;
    } else {
      // アンミュートボタンを押したときは、システム変数に入っている値を使う
      tf.tmp_se_vol = sf.config.current_se_vol;
    }
  [endscript]
 
[else]
  ; アンミュート状態でミュートボタンを押した場合はミュートにする
  [iscript]
    $(".sevol_0").attr("src","data/image/config/muting_button.png");
    sf.config.mute_se = true;
    tf.tmp_se_vol = "0"; // 数字の0だと無視される仕様なので必ず文字列の"0"を指定すること
  [endscript]
[endif]

; 音量変更
[seopt volume="&tf.tmp_se_vol" buf="1"]
; サンプルとしてSEを再生する
[playse storage="shock1.ogg" buf="1" loop="false" volume="35" sprite_time="50-20000"]

[return]


;--------------------------------------------------------------------------------
; VOICE音量
;--------------------------------------------------------------------------------

*vol_voice_change

[if exp="tf.use_slider_voice || sf.config.mute_voice"]
  ; スライダーを動かした、またはミュート状態でアンミュートボタンを押した場合はミュートを解除する
  [iscript]
    $(".voicevol_0").attr("src","data/image/config/unmuting_button.png");
    sf.config.mute_voice = false;

    if (tf.use_slider_voice) {
      // スライダーを動かしたときは、スライダーで決めた値でシステム変数を更新する
      sf.config.current_voice_vol = tf.tmp_voice_vol = String(tf.tmp_voice_vol); // 数字の0だと無視される仕様なので必ず文字列変換すること
      // スライダーフラグはfalseに戻す
      tf.use_slider_voice = false;
    } else {
      // アンミュートボタンを押したときは、システム変数に入っている値を使う
      tf.tmp_voice_vol = sf.config.current_voice_vol;
    }
  [endscript]
 
[else]
  ; アンミュート状態でミュートボタンを押した場合はミュートにする
  [iscript]
    $(".voicevol_0").attr("src","data/image/config/muting_button.png");
    sf.config.mute_voice = true;
    tf.tmp_voice_vol = "0"; // 数字の0だと無視される仕様なので必ず文字列の"0"を指定すること
  [endscript]
[endif]

; 音量変更
[seopt volume="&tf.tmp_voice_vol" buf="0"]
; サンプルとしてボイスを再生する
[playse storage="chara/zundamon/001_ずんだもん（ノーマル）_僕は村人なのだ。悪….mp3"]

[return]


;---------------------------------------------------------------------------------
; テキスト速度
;--------------------------------------------------------------------------------

*ch_speed_change

[iscript]
  // 一時変数に格納されているのはスライダーで設定したvalue。そこから100を引くことで[configdelay]のspeedに設定したい値（この時点では数値型）になる。このファイルの「tf.tmp_ch_speed_reverseについて」のコメント参照
  sf.config.current_ch_speed = 100 - parseInt(tf.tmp_ch_speed_reverse);
  // 数字の0だと無視される仕様なので必ず文字列変換すること
  tf.tmp_ch_speed = String(sf.config.current_ch_speed);
[endscript]
[configdelay speed="&tf.tmp_ch_speed"]
表示速度テスト。ボタン以外をクリックしてメッセージを消してください。[p]

; メモ
; サンプルのように「待ち時間をテキスト速度とサンプルの文字数に対応」させるのは、文字が勝手に消えてくれる点は良いが、
; 一度画面をクリックしてメッセージ送りをしてしまうと、次に[p]などのクリック待ちになるまで、メッセージ送り中の速度が維持されてしまう問題があった。
; そのため、明示的にクリックを待つようにした。

[return]
