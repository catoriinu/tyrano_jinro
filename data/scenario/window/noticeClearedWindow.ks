; 初回クリア通知ウィンドウ表示用サブルーチン
*start
  [iscript]
    tf.needDisplayNoticeClearedWindow = (function(){
      // 「誰が人狼ゲームを始めたのだ？」を初めてクリアした直後のみtrue
      if (
        ('pageId' in f) && f.pageId === 'p01' &&
        ('episodeId' in f) && f.episodeId === 'e08' &&
        ('chapterId' in f) && f.chapterId === 'c02' &&
        (getTheaterProgress('p01', 'e08') === EPISODE_STATUS.OUTRO_UNLOCKED) &&
        ('doAdvanceEpisodeStatus' in tf) && tf.doAdvanceEpisodeStatus
      ) {
        return true;
      }
      return false;
    })();
  [endscript]

  ; 初回クリア時のみ以下に進む。それ以外は何もせず戻る
  [jump target="*returnTitle" cond="!tf.needDisplayNoticeClearedWindow"]
  ; メモ：動作確認用ターゲット
  *displayNoticeClearedWindow

  ; 利用する変数の初期化
  [iscript]
    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;

    tf.helpText = `
      <b>【クリア特典】カスタマイズで操作キャラを変更できるようになりました。</b><br>
      最後までプレイしていただきありがとうございました。<br>
      次回の大型アップデート「寮長の帰還」編では、3・4期生の参戦、新役職、</br>
      新アクション、新エピソード等を実装予定です。<br>
      鋭意開発中ですので今しばらくお待ち下さい。<br>
      <b>【告知】エピソード制作の協力者求む！詳しくは添付ファイルにて。</b>`;

    //  初回クリア通知ウィンドウを表示したら、次回以降は表示しないようにする
    // （表示して閉じた直後はまだ他の変数が残っているので、フラグを折っておかないとコンフィグなどを開いて閉じるだけでも再度ウィンドウが表示されてしまうため）
    tf.doAdvanceEpisodeStatus = false;
  [endscript]

  [w_openWindow]
  [w_makeClickableAreaOuterWindow target="*close"]

  [playse storage="kirakira4.ogg" buf="1" loop="false" volume="35" sprite_time="50-20000"]

  [image folder="bgimage" storage="living_day.jpg" layer="2" page="back" left="424" top="80" height="243" name="thumbnail"]
  [image storage="eleven_members.png" layer="2" page="back" left="424" top="80" height="243" name="thumbnail"]

  [ptext layer="2" page="back" text="ゲームクリアおめでとうございます！" face="MPLUSRounded" size="36" x="180" y="350" width="920" align="center" name="helpTitle" overwrite="true"]
  [ptext layer="2" page="back" text="&tf.helpText" face="MPLUSRounded" size="26" x="185" y="420" width="920" align="left" name="helpText" overwrite="true"]

  [trans layer="2" time="0"]

  [glink color="&tf.selectedButtonColor" size="26" width="210" x="875" y="80" text="閉じる" target="*close"]
[s]

*close
[w_closeWindow waitAnime="false"]
  *returnTitle
  [jump storage="title.ks" target="*displayButton"]
[s]
