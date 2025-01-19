; ヘルプウィンドウ表示用サブルーチン
*start
  ; 利用する変数の初期化
  [iscript]
    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;

    tf.helpText = `
      ・<b>「プレイスタート」</b>で人狼ゲームを開始することができます。<br>
      ・特定の開始条件を満たして開始すると、そのエピソードの導入編が再生されます。<br>
      ・特定の解放条件を満たして決着すると、そのエピソードの解決編が再生されます。<br>
      ・全てのエピソードの解決を目指しましょう。<br>
      ・エピソードの進捗状況はオートセーブされます。手動セーブ機能はありません。<br>
      <br>
      ・<b>「シアター」</b>では、エピソードの再視聴や開始・解放条件を確認できます。<br>
      ・<b>「カスタマイズ」</b>では、人狼ゲーム時のキャラの役職を自由に配役できます。<br>
      ・<b>「解決編未解放時の導入編」</b>が<b>「自動再生」</b>の場合、導入編を視聴済みでも、<br>
      &emsp;開始条件を満たしたエピソードがあると、人狼ゲーム開始時に自動再生されます。<br>
      &emsp;<b>「スキップ」</b>の場合は自動再生しません。（解決編の解放は問題なく可能です）`;
  [endscript]

  [w_openWindow]
  [w_makeClickableAreaOuterWindow storage="window/helpWindow.ks" target="*close"]

  [ptext layer="2" page="back" text="ヘルプ" face="MPLUSRounded" size="36" x="180" y="80" width="920" align="center" name="helpTitle" overwrite="true"]
  [ptext layer="2" page="back" text="&tf.helpText" face="MPLUSRounded" size="24" x="185" y="150" width="920" align="left" name="helpText" overwrite="true"]

  [trans layer="2" time="0"]

  [glink color="&tf.buttonColor" size="24" width="450" x="413" y="595" text="インストラクションを再プレイ" target="*playInstruction"]
  [glink color="&tf.selectedButtonColor" size="26" width="210" x="875" y="80" text="閉じる" target="*close"]
[s]


; インストラクションを開始する
*playInstruction
  [freeimage layer="1"]
  [w_closeWindow waitAnime="false"]
  [stopbgm]
  [endnowait]

  ; [t_setStartingSituation]内で設定する変数をこの場で設定してから、インストラクションありで人狼ゲームを始める
  [iscript]
    // e01のシチュエーションの自動再生は不要で、インストラクションだけ再生したいので、f.startingSituationにはnullを入れる
    f.startingSituation = {
      pageId: null,
      episodeId: null
    }
    f.needPlayIntroChapter = false;

    const episode = episodeData('p01', 'e01');
    const jinroGameDataForTheater = getJinroGameDataForTheater('p01');
    let isMatched = false;
    [isMatched, f.targetJinroGameData] = isMatchEpisodeSituation(episode.situationJinroGameData, jinroGameDataForTheater);
    if (!isMatched) {
      alert('開始条件に合致する人狼ゲームデータを準備できませんでした。getJinroGameDataForTheater()の返却値を確認してください。');
    }
  [endscript]
  [call storage="theater/chapterList.ks" target="*addInstruction"]

  [jump storage="prepareJinro.ks" target="*hasStartingSituationBeenSet"]
[s]


*close
  [w_closeWindow waitAnime="false"]
  [jump storage="title.ks" target="*displayButton"]
[s]
