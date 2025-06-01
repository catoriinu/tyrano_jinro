; ファイルロード設定ウィンドウ表示用サブルーチン
*start

  ; 利用する変数の初期化
  [iscript]
    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;

    tf.explainText = `
      ボイス・SE・画像ファイル等を、<br>
      エピソード再生開始時にまとめてロードしますか？`;
    tf.preloadTrueText = `
      開始時にロード時間がかかるが、再生中は軽快<br>
      ブラウザ版ならオススメ`;
    tf.preloadFalseText = `
      再生中につどつどロードするが、開始は早い<br>
      Win版、Mac版ならオススメ`;

    tf.firstText = `
      この設定は「コンフィグ」→「ファイルロード設定」から再変更可能です。`;
    // TODO firstTextを表示するのは、初回起動時のみにする
  [endscript]

  [w_openWindow]

  [ptext layer="2" page="back" text="ファイルロード設定" face="MPLUSRounded" size="36" x="180" y="80" width="920" align="center" name="helpTitle" overwrite="true"]
  [ptext layer="2" page="back" text="&tf.explainText" face="MPLUSRounded" size="26" x="350" y="170" width="920" align="left" name="explainText" overwrite="true"]
  [ptext layer="2" page="back" text="&tf.preloadTrueText" face="MPLUSRounded" size="26" x="220" y="280" width="920" align="left" name="preloadTrueText" overwrite="true"]
  [ptext layer="2" page="back" text="&tf.preloadFalseText" face="MPLUSRounded" size="26" x="220" y="390" width="920" align="left" name="preloadFalseText" overwrite="true"]

  [ptext layer="2" page="back" text="&tf.firstText" face="MPLUSRounded" size="26" x="205" y="500" width="920" align="left" name="firstText" overwrite="true"]

  [ptext layer="2" page="back" text="ローディングアイコン表示：" face="MPLUSRounded" size="26" x="350" y="580" width="920" align="left" name="loadingIconText"]

  [trans layer="2" time="0"]


  *showButtons
  [w_makeClickableAreaOuterWindow target="*close"]
  [loading_log preload="notext" icon="&sf.doShowLoadingIcon"]

  [glink color="&tf.selectedButtonColor" size="26" width="210" x="875" y="80" text="閉じる" target="*close"]

  ; まとめてロード時
  [glink color="&tf.selectedButtonColor" size="26" width="250" x="810" y="292" text="まとめてロード" exp="sf.needPreload = true" target="*showButtons" cond="sf.needPreload"]
  [glink color="&tf.buttonColor"         size="26" width="250" x="810" y="402" text="つどつどロード" exp="sf.needPreload = false" target="*showButtons" cond="sf.needPreload"]
  ; つどつどロード時
  [glink color="&tf.buttonColor"         size="26" width="250" x="810" y="292" text="まとめてロード" exp="sf.needPreload = true" target="*showButtons" cond="!sf.needPreload"]
  [glink color="&tf.selectedButtonColor" size="26" width="250" x="810" y="402" text="つどつどロード" exp="sf.needPreload = false" target="*showButtons" cond="!sf.needPreload"]

  ; ローディングアイコン表示 ON時
  [glink color="&tf.selectedButtonColor" size="26" width="100" x="700" y="575" text="ON"  exp="sf.doShowLoadingIcon = true" target="*showButtons" cond="sf.doShowLoadingIcon"]
  [glink color="&tf.buttonColor"         size="26" width="100" x="830" y="575" text="OFF" exp="sf.doShowLoadingIcon = false" target="*showButtons" cond="sf.doShowLoadingIcon"]
  ; OFF時
  [glink color="&tf.buttonColor"         size="26" width="100" x="700" y="575" text="ON"  exp="sf.doShowLoadingIcon = true" target="*showButtons" cond="!sf.doShowLoadingIcon"]
  [glink color="&tf.selectedButtonColor" size="26" width="100" x="830" y="575" text="OFF" exp="sf.doShowLoadingIcon = false" target="*showButtons" cond="!sf.doShowLoadingIcon"]

[s]


*close
  [w_closeWindow waitAnime="false"]
  [jump storage="configJinro.ks" target="*returnFromWindow"]
[s]
