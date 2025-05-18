; auto_wseプラグインで使用する外部JSファイルを読み込む
[loadjs storage="plugin/auto_wse/impl.js"]


; [add_playselist]で登録しておいたSEを連続再生するマクロ
; @param buf 再生するスロット（[add_playselist]で登録したスロットと同じもの）を指定する。デフォルト="0"
; @param no_init "true"指定時は、再生終了後もそのbufに追加済みのSEを初期化しない。デフォルト=false(初期化する)


; [wse]ではTYRANO.kag.tmp.is_se_playを用いてSE再生中かを判断しているが、そのフラグは[playse]が再生終了したタイミングで必ずfalseになってしまう。
; この仕様は、SEを同時再生している場合に[wse]で再生終了を待機できないことがある問題に繋がる。つまり以下のような流れになる。
; 1. [playse buf="0"], [playse buf="1"]を同時に再生→is_se_play = true
; 2. [playse buf="0"]が先に再生終了→is_se_play = false
; 3. [wse]で再生中か判定→is_se_play = falseなので、[wse]は再生終了を待機しない（is_se_play_wait = falseのまま）
; 4. [playse buf="1"]が再生終了→is_se_play_wait = falseなので、[playse buf="1"]の再生終了を待機しない（nextOrder()実行）
[macro name="auto_wse"]
  [iscript]
    //mp.interval = mp.interval ? parseInt(mp.interval) : 2000;

    mp.need_interval = false;
    if (isSePlaying()) {
      // [wse]とは違ってこの場でSEマップを走査して、いずれかのSEが再生中であればフラグを立てる
      TYRANO.kag.tmp.is_se_play_wait = true;
      mp.need_interval = true;
    }
  [endscript]

  [if exp="mp.need_interval"]
    [iscript]
      waitSeStopAndInterval();
    [endscript]
  [endif]

  [p]
[endmacro]

[return ]
