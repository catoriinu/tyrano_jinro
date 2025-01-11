; カスタマイズ画面のメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]

[bg storage="../image/config/voivo_config_bg.png" time="100"]

[iscript]
// 現在の（カスタマイズ対象の）人狼ゲームデータを取得する
f.currentJinroGameData = sf.jinroGameDataObjects[sf.currentJinroGameDataKey];
[endscript]


*hideCustomizeWindow
[iscript]
tf.participantCount = 0;
tf.iconSize = 100;
tf.baseTop = 190;
tf.offsetTop = 102;
tf.clickableWidth = tf.iconSize * 2;

tf.buttonColor = CLASS_GLINK_DEFAULT;
[endscript]

; 画面上部のボタン表示
[button fix="true" graphic="button/button_return_normal.png" enterimg="button/button_return_hover.png" target="*returnTitle" x="1143" y="17" width="114" height="103"]
[glink color="&tf.buttonColor" size="28" width="250" x="850" y="43" text="プレイスタート" target="*startPlay"]

; キャラアイコン、役職アイコンとそのクリッカブル領域を表示
*start_displayParticipantIcon
[call target="*displayParticipantIcon"]
[jump target="*end_displayParticipantIcon" cond="tf.participantCount >= 4"]
[eval exp="tf.participantCount++"]
[jump target="*start_displayParticipantIcon"]
*end_displayParticipantIcon

[trans layer="0" time="1"]
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


*startPlay
[clearfix]
[layopt layer="message0" visible="false"]
[freeimage layer="0"]
[stopbgm]

; 人狼ゲームの準備、導入編自動再生、ゲーム開始
[jump storage="prepareJinro.ks" target="*prepareJinroGame"]
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
; fixボタンをクリア
[clearfix]
[jump storage="customize/customizeWindow.ks" target="*start"]
[s]
