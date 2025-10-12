; jinro plugin macros

; @param jinroGameData 人狼ゲームデータ。未指定なら sf.jinroGameDataObjects[sf.currentJinroGameDataKey] を使用
[macro name="j_prepareJinroGame"]
  [iscript]
    console.debug('[j_prepareJinroGame] start');

    let jinroGameData = null;
    if (typeof mp.jinroGameData !== 'undefined' && mp.jinroGameData !== null) {
      jinroGameData = mp.jinroGameData;
    } else if (
      sf.jinroGameDataObjects &&
      typeof sf.currentJinroGameDataKey !== 'undefined' &&
      sf.currentJinroGameDataKey !== null &&
      sf.jinroGameDataObjects[sf.currentJinroGameDataKey]
    ) {
      jinroGameData = sf.jinroGameDataObjects[sf.currentJinroGameDataKey];
    }

    if (!jinroGameData) {
      throw new Error('[j_prepareJinroGame] 人狼ゲームデータが取得できませんでした。');
    }

    initializeCharacterObjectsForJinro(jinroGameData);
    initializeTyranoValiableForJinro();
    console.debug('[j_prepareJinroGame] complete');
  [endscript]
[endmacro]

[return]
