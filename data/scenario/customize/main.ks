; カスタマイズ画面のメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]

[bg storage="../image/config/voivo_config_bg_v2.png" time="100"]

[iscript]
// カスタマイズ画面を開いた時点の、カスタマイズ対象の人狼ゲームデータとを取得する
f.currentJinroGameData = sf.jinroGameDataObjects[sf.currentJinroGameDataKey];
// 現在の参加者リスト。参加者情報に更新があったらアイコンを更新するという判定に使う。なのでこの時点ではあえて空配列。
f.currentParticipantList = [];
[endscript]


*hideCustomizeWindow
[iscript]
tf.participantCount = 0;
tf.iconSize = 105;
tf.baseTop = 155;
tf.offsetTop = 110;
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
[iscript]
  // カスタマイズウィンドウを閉じて再度メイン画面を表示したときに画像更新判定をするために、現時点での参加者リストを保存しておく
  f.currentParticipantList = clone(f.currentJinroGameData.participantList);
[endscript]
[s]



*displayParticipantIcon
[iscript]
tf.top = tf.baseTop + (tf.offsetTop * tf.participantCount);
tf.targetCharaInfo = '*window_charaInfo_' + tf.participantCount;
tf.targetSelectRole = '*window_selectRole_' + tf.participantCount;

// アイコン画像のnameパラメータ（=class属性）
tf.charaIconName = 'charaIcon_' + tf.participantCount;
tf.roleIconName = 'roleIcon_' + tf.participantCount;

// 参加者情報を取得
const participant = getParticipantWithIndexFromJinroGameData(f.currentJinroGameData, tf.participantCount);
const characterId = participant.characterId;
const roleId = participant.roleId || ROLE_ID_UNKNOWN;

// アイコン画像の更新要否判定。現在表示しているキャラや役職と変わっていたなら画像を更新する（ただし初回なら必ず表示する）
const currentParticipant = f.currentParticipantList[tf.participantCount] || null;
tf.needUpdateCharaIcon = (currentParticipant === null || currentParticipant.characterId !== characterId);
tf.needUpdateRoleIcon = (currentParticipant === null || currentParticipant.roleId !== participant.roleId);

// 画像ファイルパス
tf.sdStorage = 'sdchara/' + characterId + '.png';
tf.roleStorage = 'role/icon_' + roleId + '.png';
[endscript]

; 画像を更新する場合、裏ページ（※）のアイコンを削除しておく。残しておくと、画面上では重なって見えないがimageタグ自体は残り続けたままになってしまうため
; ※[free]タグのpageパラメータはv6タグリファレンスには明記されていないが、ティラノのv600a時点で指定できることを確認した
[free layer="0" page="back" name="&tf.charaIconName" cond="tf.needUpdateCharaIcon"]
[free layer="0" page="back" name="&tf.roleIconName" cond="tf.needUpdateRoleIcon"]

; キャラアイコンと役職アイコン表示
[image folder="image" page="back" storage="&tf.sdStorage" layer="0" width="&tf.iconSize" haight="&tf.iconSize" left="100" top="&tf.top" name="&tf.charaIconName" cond="tf.needUpdateCharaIcon"]
[image folder="image" page="back" storage="&tf.roleStorage" layer="0" width="&tf.iconSize" haight="&tf.iconSize" left="205" top="&tf.top" name="&tf.roleIconName" cond="tf.needUpdateRoleIcon"]

; キャラアイコンには「キャラ情報」への、役職アイコンには「役職設定」へのクリッカブル領域を作成
[clickable width="&tf.iconSize" height="&tf.iconSize" x="100" y="&tf.top" color="0x333333" opacity="0" mouseopacity="40" target="&tf.targetCharaInfo"]
[clickable width="&tf.iconSize" height="&tf.iconSize" x="205" y="&tf.top" color="0x333333" opacity="0" mouseopacity="40" target="&tf.targetSelectRole"]
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



*window_charaInfo_0
[iscript]
  f.selectedParticipantIndex = 0;
  tf.windowElements = 'charaInfo';
[endscript]
[jump target="*jump_customizeWindow"]

*window_charaInfo_1
[iscript]
  f.selectedParticipantIndex = 1;
  tf.windowElements = 'charaInfo';
[endscript]
[jump target="*jump_customizeWindow"]

*window_charaInfo_2
[iscript]
  f.selectedParticipantIndex = 2;
  tf.windowElements = 'charaInfo';
[endscript]
[jump target="*jump_customizeWindow"]

*window_charaInfo_3
[iscript]
  f.selectedParticipantIndex = 3;
  tf.windowElements = 'charaInfo';
[endscript]
[jump target="*jump_customizeWindow"]

*window_charaInfo_4
[iscript]
  f.selectedParticipantIndex = 4;
  tf.windowElements = 'charaInfo';
[endscript]
[jump target="*jump_customizeWindow"]

*window_selectRole_0
[iscript]
  f.selectedParticipantIndex = 0;
  tf.windowElements = 'selectRole';
[endscript]
[jump target="*jump_customizeWindow"]

*window_selectRole_1
[iscript]
  f.selectedParticipantIndex = 1;
  tf.windowElements = 'selectRole';
[endscript]
[jump target="*jump_customizeWindow"]

*window_selectRole_2
[iscript]
  f.selectedParticipantIndex = 2;
  tf.windowElements = 'selectRole';
[endscript]
[jump target="*jump_customizeWindow"]

*window_selectRole_3
[iscript]
  f.selectedParticipantIndex = 3;
  tf.windowElements = 'selectRole';
[endscript]
[jump target="*jump_customizeWindow"]

*window_selectRole_4
[iscript]
  f.selectedParticipantIndex = 4;
  tf.windowElements = 'selectRole';
[endscript]
[jump target="*jump_customizeWindow"]

*jump_customizeWindow
; fixボタンをクリア
[clearfix]
[jump storage="customize/customizeWindow.ks" target="*start"]
[s]
