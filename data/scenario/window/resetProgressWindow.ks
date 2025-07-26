; 進捗リセットウィンドウ表示用サブルーチン
*start
  ; 利用する変数の初期化
  [iscript]
    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;

    tf.windowText = `
      セーブデータを特定の状態にリセットします。<br>
      この機能を使用したことによるデータ消失、ネタバレ等は<b>自己責任</b>でお願いします。<br>
      <b>確認画面は出ません。ボタンを押すとすぐにリセットされます。</b>`;
  [endscript]

  [w_openWindow]
  [w_makeClickableAreaOuterWindow target="*close"]

  [ptext layer="2" page="back" text="進捗リセット" face="MPLUSRounded" size="36" x="180" y="80" width="920" align="center" name="windowTitle" overwrite="true"]
  [ptext layer="2" page="back" text="&tf.windowText" face="MPLUSRounded" size="24" x="185" y="150" width="920" align="left" name="windowText" overwrite="true"]

  [trans layer="2" time="0"]

  [glink color="&tf.buttonColor" size="24" width="460" x="439" y="300" enterse="se/button34.ogg" clickse="se/button13.ogg" text="設定含めて完全初期化" target="*resetAll"]
  [glink color="&tf.buttonColor" size="24" width="460" x="439" y="390" enterse="se/button34.ogg" clickse="se/button13.ogg" text="エピソード進捗のみ初期化" target="*resetTheater"]
  [glink color="&tf.buttonColor" size="24" width="460" x="439" y="480" enterse="se/button34.ogg" clickse="se/button13.ogg" text="第1話解決編再生後の状態にリセット" target="*resetAfterTutorial"]
  [glink color="&tf.buttonColor" size="24" width="460" x="439" y="570" enterse="se/button34.ogg" clickse="se/button13.ogg" text="エンディング後の状態にリセット" target="*resetAfterEnding"]

  [glink color="&tf.selectedButtonColor" size="26" width="210" x="875" y="80" text="閉じる" target="*close" enterse="se/button34.ogg" clickse="se/button15.ogg"]
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
[ptext layer="2" x="258" y="410" text="リセット完了 再起動してください" color="black" align="center" size="50"]
[s]


*close
  [w_closeWindow waitAnime="false"]
  [jump storage="title.ks" target="*displayButton"]
[s]
