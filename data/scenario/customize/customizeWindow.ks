; カスタマイズウィンドウ

*start
[iscript]
    const participant = getParticipantWithIndexFromJinroGameData(f.currentJinroGameData, f.selectedParticipantIndex);
    tf.characterId = participant.characterId;
    tf.currentRoleId = participant.roleId || ROLE_ID_UNKNOWN;

    // 利用する変数の初期化
    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;
    tf.selectedButton = 'roleSelect';

    tf.roleList = [
        {
            roleId: ROLE_ID_UNKNOWN,
            text: 'ランダム'
        },
        {
            roleId: ROLE_ID_VILLAGER,
            text: '村人'
        },
        {
            roleId: ROLE_ID_FORTUNE_TELLER,
            text: '占い師'
        },
        {
            roleId: ROLE_ID_WEREWOLF,
            text: '人狼'
        },
        {
            roleId: ROLE_ID_MADMAN,
            text: '狂人'
        }
    ];
    tf.roleCount = 0;
    tf.iconSize = 80;
    tf.baseTop = 200;
    tf.offsetTop = 90;
    // キャラ立ち絵表示用の変数設定
    tf.registerCharacterList = [tf.characterId];
    // キャラ表示レイヤー
    tf.layer = 2;
[endscript]
[call storage="./chara/common.ks" target="*registerCharacters"]

[filter layer="0" blur="10"]

[image storage="theater/episodeWindow_rectangle.png" layer="1" page="back" name="episodeWindow" x="158.5" y="38"]
[kanim name="episodeWindow" keyframe="open_episodeWindow" time="150" easing="ease-out"]

[m_changeCharacter characterId="&tf.characterId" face="通常"]

;[glink color="&tf.buttonColor" size="28" width="250" x="230" y="100" text="役職・参加" target="*start"]
[glink color="&tf.selectedButtonColor" size="28" width="250" x="230" y="100" text="役職設定" target="*start" cond="tf.selectedButton === 'roleSelect'"]
[glink color="&tf.buttonColor" size="28" width="250" x="230" y="100" text="役職設定" target="*start" cond="tf.selectedButton !== 'roleSelect'"]
[glink color="&tf.selectedButtonColor" size="28" width="250" x="513" y="100" text="性格情報" target="*start" cond="tf.selectedButton === 'personalInfo'"]
[glink color="&tf.buttonColor" size="28" width="250" x="513" y="100" text="性格情報" target="*start" cond="tf.selectedButton !== 'personalInfo'"]
[glink color="&tf.buttonColor" size="28" width="250" x="796" y="100" text="閉じる" target="*returnMain"]

*start_displaySelectRoleButton
[call target="*displaySelectRoleButton"]
[jump target="*end_displaySelectRoleButton" cond="tf.roleCount >= 4"]
[eval exp="tf.roleCount++"]
[jump target="*start_displaySelectRoleButton"]
*end_displaySelectRoleButton

[trans layer="1" time="0"]
[s]



*displaySelectRoleButton
[iscript]
tf.top = tf.baseTop + (tf.offsetTop * tf.roleCount);
tf.glinkTop = tf.top + 15;
tf.roleId = tf.roleList[tf.roleCount].roleId;
tf.roleText = tf.roleList[tf.roleCount].text;
tf.roleStorage = 'role/icon_' + tf.roleId + '.png';

[endscript]

; TODO 更新差分があった画像だけ削除して書き換える。それ以外はそのまま
; または、裏面を全て消したうえでここに入ってくる
[image folder="image" page="back" storage="&tf.roleStorage" layer="1" width="&tf.iconSize" haight="&tf.iconSize" left="250" top="&tf.top"]
[glink color="&tf.buttonColor" size="26" width="200" x="350" y="&tf.glinkTop" text="&tf.roleText" target="*start" cond="tf.roleId !== tf.currentRoleId"]
[glink color="&tf.selectedButtonColor" size="26" width="200" x="350" y="&tf.glinkTop" text="&tf.roleText" target="*start" cond="tf.roleId === tf.currentRoleId"]
[return]




*returnMain
[m_exitCharacter characterId="&tf.characterId" time="1" wait="true"]
[free_filter layer="0"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[jump storage="customize/main.ks" target="*hideCustomizeWindow"]
[s]

