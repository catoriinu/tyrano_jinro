*start
[layopt layer="message0" visible="false"]
[filter layer="0" blur="10"]

[image storage="theater/detail_rectangle.png" layer="1" name="detail" x="158.5" y="38"]
[image storage="&f.theaterList[f.theaterDetailNum].thumbnail" layer="1" left="432" top="80" height="234" name="thumbnail"]
[ptext layer="1" text="&f.theaterList[f.theaterDetailNum].title" face="MPLUSRounded" size="36" x="180" y="325" width="920" align="center"]

[eval exp="tf.buttonColor = CLASS_GLINK_DEFAULT"]

; ✕ボタンまたは枠外（左右上下）のクリックで一覧に戻る
[glink color="&tf.buttonColor" size="35" width="70" x="1005" y="85" text="✕" target="*returnMain"]
[clickable width="174" height="720" x="0" y="0" target="*returnMain"]
[clickable width="174" height="720" x="1105" y="0" target="*returnMain"]
[clickable width="1280" height="55" x="0" y="0" target="*returnMain"]
[clickable width="1280" height="55" x="0" y="665" target="*returnMain"]

; 「導入編を見る」ボタン
[glink color="&tf.buttonColor" size="26" width="300" x="487" y="395" text="導入編を見る" target="*returnMain"]

; 「このシチュエーションでプレイする」ボタンまたはプレイできない理由
[if exp="('cantSituationPlay' in f.theaterList[f.theaterDetailNum])"]
  [ptext layer="1" text="&f.theaterList[f.theaterDetailNum].cantSituationPlay" face="MPLUSRounded" size="30" x="180" y="480" width="920" align="center"]
[else]
  [glink color="&tf.buttonColor" size="26" width="450" x="412.9" y="480" text="このシチュエーションでプレイする" target="*startSituationPlay"]
[endif]

; 「解決編を見る」ボタンまたは解放条件
[if exp="sf.theaterProgress[f.theaterListPage][f.theaterDetailNum].end == THEATER_LOCKED"]
  [ptext layer="1" text="&f.theaterList[f.theaterDetailNum].unlockCondition" face="MPLUSRounded" size="30" x="180" y="555" width="920" align="center"]
[else]
  [glink color="&tf.buttonColor" size="26" width="300" x="487" y="565" text="解決編を見る" target="*returnMain"]
[endif]

[s]


*returnMain
[free_filter layer="0"]
[freeimage layer="1"]
[layopt layer="message0" visible="true"]
[jump storage="theater/main.ks" target="*hideDetail"]
[s]



*startSituationPlay
[free_filter layer="0"]
[freeimage layer="1"]
[freeimage layer="0"]
[stopbgm]
[endnowait]
[layopt layer="message0" visible="true"]

[iscript]
  let participantObjectList = [
    new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_VILLAGER),
    new Participant(CHARACTER_ID_METAN, ROLE_ID_FORTUNE_TELLER)
  ];

  const villagersRoleIdList = getVillagersRoleIdList(5, participantObjectList);
  participantObjectList = fillAndSortParticipantObjectList(5, participantObjectList);

  initializeCharacterObjectsForJinro(villagersRoleIdList, participantObjectList);
  initializeTyranoValiableForJinro();
[endscript]

[jump storage="playJinro.ks"]

[s]
