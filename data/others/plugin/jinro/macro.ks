; jinro plugin macros

; @param jinroGameData 人狼ゲームデータ。未指定の場合は sf.jinroGameDataObjects[sf.currentJinroGameDataKey] を利用
[macro name="j_prepareJinroGame"]
  [iscript]
    const jinroGameData = mp.jinroGameData || sf.jinroGameDataObjects[sf.currentJinroGameDataKey];

    console.debug('jinroGameData');
    console.debug(jinroGameData);

    initializeCharacterObjectsForJinro(jinroGameData);
    initializeTyranoValiableForJinro();
  [endscript]
[endmacro]

[return]
