; シアター画面のメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]

[bg storage="../image/config/voivo_config_bg.png" time="100"]

[button fix="true" graphic="button/button_return_normal.png" enterimg="button/button_return_hover.png" target="*returnTitle" x="1143" y="17" width="114" height="103"]

[iscript]
f.currentJinroGameData = new JinroGameData(
    {
        ROLE_ID_VILLAGER: 2,
        ROLE_ID_FORTUNE_TELLER: 1,
        ROLE_ID_WEREWOLF: 1,
        ROLE_ID_MADMAN: 1
    },
    [
        new Participant(CHARACTER_ID_ZUNDAMON),
        new Participant(CHARACTER_ID_METAN),
        new Participant(CHARACTER_ID_TSUMUGI),
        new Participant(CHARACTER_ID_HAU),
        new Participant(CHARACTER_ID_RITSU),
    ]
);
[endscript]


*hideCustomizeWindow
[iscript]
tf.participantCount = 0;
tf.iconSize = 100;
tf.baseTop = 190;
tf.offsetTop = 102;
tf.clickableWidth = tf.iconSize * 2;
[endscript]


*start_displayParticipantIcon
[call target="*displayParticipantIcon"]
[jump target="*end_displayParticipantIcon" cond="tf.participantCount >= 4"]
[eval exp="tf.participantCount++"]
[jump target="*start_displayParticipantIcon"]
*end_displayParticipantIcon

[trans layer="0" time="0"]


[s]




*displayParticipantIcon
[iscript]
tf.top = tf.baseTop + (tf.offsetTop * tf.participantCount);
tf.target = '*customize_window_' + tf.participantCount;

const participant = getParticipantWithIndexFromJinroGameData(f.currentJinroGameData, tf.participantCount);
const characterId = participant.characterId;
const roleId = participant.roleId || ROLE_ID_UNKNOWN;

tf.sdStorage = 'sdchara/' + characterId + '.png';
tf.roleStorage = 'role/icon_' + roleId + '.png';
[endscript]

[image folder="image" page="back" storage="&tf.sdStorage" layer="0" width="&tf.iconSize" haight="&tf.iconSize" left="100" top="&tf.top"]
[image folder="image" page="back" storage="&tf.roleStorage" layer="0" width="&tf.iconSize" haight="&tf.iconSize" left="200" top="&tf.top"]
[clickable width="&tf.clickableWidth" height="&tf.iconSize" x="100" y="&tf.top" color="0x333333" opacity="0" mouseopacity="40" target="&tf.target"]

[return]





*returnTitle
; fixボタンをクリア
[clearfix]
[layopt layer="message0" visible="false"]
[freeimage layer="0"]
[jump storage="title.ks"]
[s]



*customize_window_0
[eval exp="f.selectedParticipantIndex = 0"]
[jump target="*jump_customizeWindow"]

*customize_window_1
[eval exp="f.selectedParticipantIndex = 1"]
[jump target="*jump_customizeWindow"]

*customize_window_2
[eval exp="f.selectedParticipantIndex = 2"]
[jump target="*jump_customizeWindow"]

*customize_window_3
[eval exp="f.selectedParticipantIndex = 3"]
[jump target="*jump_customizeWindow"]

*customize_window_4
[eval exp="f.selectedParticipantIndex = 4"]
[jump target="*jump_customizeWindow"]

*jump_customizeWindow
[jump storage="customize/customizeWindow.ks" target="*start"]
[s]
