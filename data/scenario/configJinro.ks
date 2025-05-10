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

; メニューボタン非表示
[hidemenubutton]

[iscript]
  /* sf.configはfirst.ksで初期設定しておくこと */

  /* スライダーの初期位置 */
  tf.tmp_bgm_vol   = sf.config.current_bgm_vol;
  tf.tmp_se_vol    = sf.config.current_se_vol;
  tf.tmp_voice_vol = sf.config.current_voice_vol;
  tf.tmp_ch_speed_reverse = String(105 - sf.config.current_ch_speed);
  /*
   * tf.tmp_ch_speed_reverseについて：
   * ティラノの[configdelay]のspeedは「次の1文字を表示するまでのミリ秒」であり、値が小さいほど表示が早くなる。
   * それをスライダーで表すと、左の方が早くなり直感に反する。
   * なので、スライダーが0（左）なら最も遅い（speed="105"）、スライダーが100（右）なら最も早い（speed="5"）になるようにするため、
   * 一時変数には、105からシステム変数を引いた値を入れておく。
   * （※105の5は処理の猶予時間。猶予0だと変数格納が間に合わないエラーが多発したため）
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

  tf.classButtonSeHover = CLASS_BUTTON_SE_HOVER;
[endscript]

[cm]

; コンフィグ用の背景を読み込んでトランジション
[image storage="&tf.img_path +'voivo_config_bg_v2.png'" layer="1" visible="true" left="0" top="0" width="1280" height="720" name="config_bg" time="100"]

[ptext layer="1" x="490" y="25"  text="コンフィグ" color="#28332a" size="60"]
[ptext layer="1" x="100" y="170" text="音量" color="#28332a" size="44"]
[ptext layer="1" x="245" y="170" text="BGM" color="#28332a" size="44"]
[ptext layer="1" x="245" y="255" text="SE" color="#28332a" size="44"]
[ptext layer="1" x="245" y="340" text="VOICE" color="#28332a" size="44"]
[ptext layer="1" x="100" y="425" text="テキスト速度" color="#28332a" size="44"]
[ptext layer="1" x="100" y="510" text="キャラ名マーカー" color="#28332a" size="44"]

; テキスト表示速度のサンプルに使用するメッセージレイヤの設定
[position layer="message1" left="50" top="600" width="1174" height="80" page="fore" color="0xffffff" border_color="0x000000" border_size="7" radius="45" margint="8" marginl="40" opacity="210"]
[layopt layer="message1" visible="true"]
[current layer="message1"]

; 画面右上の「もどる」ボタン
[button fix="true" graphic="button/button_return_normal.png" enterimg="button/button_return_hover.png" target="*return" x="1143" y="17" width="114" height="103" enterse="se/button34.ogg" clickse="se/button15.ogg"]

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
[slider name="bgm_vol_slider" exp="tf.bgm_exp()" target="*vol_bgm_change" var="tf.tmp_bgm_vol" x="&tf.slider_x" y="200" width="560" height="10" active_color="#A5D4AD" thumb_width="30" thumb_height="30" thumb_color="#A5D4AD" tip_width="60" tip_height="30" tip_color="#A5D4AD" tip_text_color="#242424" tip_text_size="20" tip_tail="false" tip_margin="15"]

; ミュートボタン/アンミュートボタン
[eval exp="tf.bgm_mute_button = sf.config.mute_bgm ? tf.muting_button_path : tf.unmuting_button_path"]
[button name="bgmvol,bgmvol_0" fix="true" target="*vol_bgm_change" graphic="&tf.bgm_mute_button" width="&tf.btn_w" height="&tf.btn_h" x="&tf.btn_x" y="177"]


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
[slider name="se_vol_slider" exp="tf.se_exp()" target="*vol_se_change" var="tf.tmp_se_vol" x="&tf.slider_x" y="285" width="560" height="10" active_color="#A5D4AD" thumb_width="30" thumb_height="30" thumb_color="#A5D4AD" tip_width="60" tip_height="30" tip_color="#A5D4AD" tip_text_color="#242424" tip_text_size="20" tip_tail="false" tip_margin="15"]

; ミュートボタン/アンミュートボタン
[eval exp="tf.se_mute_button = sf.config.mute_se ? tf.muting_button_path : tf.unmuting_button_path"]
[button name="sevol,sevol_0" fix="true" target="*vol_se_change" graphic="&tf.se_mute_button" width="&tf.btn_w" height="&tf.btn_h" x="&tf.btn_x" y="262"]


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
[slider name="voice_vol_slider" exp="tf.voice_exp()" target="*vol_voice_change" var="tf.tmp_voice_vol" x="&tf.slider_x" y="370" width="560" height="10" active_color="#A5D4AD" thumb_width="30" thumb_height="30" thumb_color="#A5D4AD" tip_width="60" tip_height="30" tip_color="#A5D4AD" tip_text_color="#242424" tip_text_size="20" tip_tail="false" tip_margin="15"]

; ミュートボタン/アンミュートボタン
[eval exp="tf.voice_mute_button = sf.config.mute_voice ? tf.muting_button_path : tf.unmuting_button_path"]
[button name="vol,voicevol_0" fix="true" target="*vol_voice_change" graphic="&tf.voice_mute_button" width="&tf.btn_w" height="&tf.btn_h" x="&tf.btn_x" y="347"]


;------------------------------------------------------------------------------------------------------
; テキスト速度
;------------------------------------------------------------------------------------------------------

; スライダー
[slider name="ch_speed_slider" target="*ch_speed_change" var="tf.tmp_ch_speed_reverse" x="&tf.slider_x" y="455" width="560" height="10" active_color="#A5D4AD" thumb_width="30" thumb_height="30" thumb_color="#A5D4AD" tip_width="60" tip_height="30" tip_color="#A5D4AD" tip_text_color="#242424" tip_text_size="20" tip_tail="false" tip_margin="15"]


;------------------------------------------------------------------------------------------------------
; キャラ色マーカー
;------------------------------------------------------------------------------------------------------
*marker_button

[iscript]
  tf.mark100Color = CLASS_GLINK_DEFAULT;
  tf.mark20Color = CLASS_GLINK_DEFAULT;
  tf.mark0Color = CLASS_GLINK_DEFAULT;

  if (sf.config.mark_size === 100) {
    tf.mark100Color += " " + CLASS_GLINK_SELECTED;
  } else if (sf.config.mark_size === 20) {
    tf.mark20Color += " " + CLASS_GLINK_SELECTED;
  } else {
    tf.mark0Color += " " + CLASS_GLINK_SELECTED;
    sf.config.mark_size = 0;
  }
[endscript]

[glink color="&tf.mark100Color" enterse="se/button34.ogg" clickse="se/button13.ogg"size="26" width="180" x="940" y="520" text="塗りつぶし" exp="sf.config.mark_size = preexp" preexp="100" target="*marker_button"]
[glink color="&tf.mark20Color" enterse="se/button34.ogg" clickse="se/button13.ogg" size="26" width="180" x="710" y="520" text="下線" exp="sf.config.mark_size = preexp" preexp="20" target="*marker_button"]
[glink color="&tf.mark0Color" enterse="se/button34.ogg" clickse="se/button13.ogg" size="26" width="180" x="480" y="520" text="なし" exp="sf.config.mark_size = preexp" preexp="0" target="*marker_button"]

[eval exp="setButtonSe()"]
[s]


;--------------------------------------------------------------------------------
; コンフィグモードの終了
;--------------------------------------------------------------------------------
*return
[cm]

[endnolog]

;	テキスト速度のサンプル表示に使用していたメッセージレイヤを非表示に
[layopt layer="message1" visible="false"]
[current layer="message0"]

; 見出しのテキストと背景を非表示に
[freeimage layer="1"]

; fixボタンをクリア
[clearfix]

; キーコンフィグの有効化
[start_keyconfig]

; コールスタックのクリア
[clearstack]

; チャプター再生中ならポーズメニュー画面に戻る
[jump storage="theater/pauseMenu.ks" cond="f.chapterStorage != null"]
; 人狼ゲーム中ならメニュー画面に戻る
[jump storage="menuJinro.ks" target="*returnFromConfig" cond="f.inJinroGame"]

; それ以外ならタイトル画面に戻る
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
[seopt volume="&tf.tmp_se_vol" buf="0"]
; サンプルとしてSEを再生する
[playse storage="se/shock1.ogg" buf="0" loop="false" volume="35" sprite_time="50-20000"]

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
[seopt volume="&tf.tmp_voice_vol" buf="1"]
; サンプルとしてボイスを再生する
[playse storage="chara/zundamon/zundamon_noticeRole_villager_01.ogg" buf="1"]

[return]


;---------------------------------------------------------------------------------
; テキスト速度
;--------------------------------------------------------------------------------

*ch_speed_change

; 一時変数に格納されているのはスライダーで設定したvalue。105からそれを引くことで[configdelay]のspeedに設定したい値（この時点では数値型）になる。
; このファイルの「tf.tmp_ch_speed_reverseについて」のコメント参照
[iscript]
  sf.config.current_ch_speed = 105 - parseInt(tf.tmp_ch_speed_reverse);
  // 数字の0だと無視される仕様なので必ず文字列変換すること
  tf.tmp_ch_speed = String(sf.config.current_ch_speed);
[endscript]
[configdelay speed="&tf.tmp_ch_speed"]

[mark size="&sf.config.mark_size" cond="sf.config.mark_size > 0"]
表示テスト。この文章が消えるまで操作せずお待ち下さい。
[endmark cond="sf.config.mark_size > 0"]

; 待機時間は、バグを狙い打ちにくいくらい短く、かつ読むのを待ってくれてる感を感じる最低限の時間に設定しておく
[wait time="300"]
[er]

; バグ（致命的ではないので、テストメッセージに「操作せずお待ち下さい」と書くだけにとどめておく）
; テストメッセージが表示されきって[wait]中のタイミングでキャラ名マーカーの[glink]を押すと、[s]タグを飛び越えてしまい元の画面に戻ってしまう

; メモ
; サンプルのように「待ち時間をテキスト速度とサンプルの文字数に対応」させるのは、文字が勝手に消えてくれる点は良いが、
; 一度画面をクリックしてメッセージ送りをしてしまうと、次に[p]などのクリック待ちになるまで、メッセージ送り中の速度が維持されてしまう問題があった。
; そのため、明示的にクリックを待つようにした。
; 追記
; そうしたかったが、文字が勝手に消えるように戻した。メッセージ表示中は[wait]で操作を受け付けないようにし、メッセージ送りができないように対処した。
; キャラ名マーカー設定に[glink]を使おうとしたところ、[glink]表示中はクリックを受け付けないティラノの仕様の影響で、
; テストメッセージを消すためにクリックを待つことによって完全に操作不可能になるデッドロックが発生してしまったため。

[return]
