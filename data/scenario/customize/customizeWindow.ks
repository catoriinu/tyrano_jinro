; カスタマイズウィンドウ

*start
[iscript]
    // 現在の人狼ゲームデータから、ウィンドウで開いたキャラの情報を取得する
    tf.currentParticipant = getParticipantWithIndexFromJinroGameData(f.currentJinroGameData, f.selectedParticipantIndex);
    tf.characterId = tf.currentParticipant.characterId;
    tf.currentRoleId = tf.currentParticipant.roleId || ROLE_ID_UNKNOWN;

    // 利用する変数の初期化
    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;
    tf.selectedButton = 'roleSelect';
    tf.needTrans = true;

    // 役職の残り参加可能人数データ
    const roleDataWithRemainingCapacity = getRoleDataWithRemainingCapacity(f.currentJinroGameData);
    // 役職選択ボタン。先頭はランダム固定
    tf.roleButtonList = [
        {
            roleId: ROLE_ID_UNKNOWN,
            name: 'ランダム',
            available: true,
        },
    ];
    // 実装されている全役職リストを回す。表示順番を固定させるため
    for (const roleObj of ROLES_LIST) {
        if (roleObj.roleId in roleDataWithRemainingCapacity) {
            // 参加可能人数が0の前提で一旦、無効なボタンとして初期化する
            const roleButtonObj = {
                roleId: roleObj.roleId,
                name: roleObj.name,
                available: false,
            }
            // 以下のいずれかに該当するならボタンを有効化する
            // ・まだその役職の参加可能人数が残っている
            // ・ウィンドウ表示時点での、自分の参加役職である（参加可能人数が0でも、自分が参加設定しているせいなら再選択可能にすべきなので）
            if (roleDataWithRemainingCapacity[roleObj.roleId] > 0 || roleObj.roleId === tf.currentRoleId) {
                roleButtonObj.available = true;
            }
            tf.roleButtonList.push(roleButtonObj);
        }
    }
    tf.maxRoleButtonCount = tf.roleButtonList.length - 1;
    
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

*return_from_select_role

; ウィンドウ上部のタブボタン
[glink color="&tf.selectedButtonColor" size="28" width="250" x="230" y="100" text="役職設定" target="*start" cond="tf.selectedButton === 'roleSelect'"]
[glink color="&tf.buttonColor" size="28" width="250" x="230" y="100" text="役職設定" target="*start" cond="tf.selectedButton !== 'roleSelect'"]
[glink color="&tf.selectedButtonColor" size="28" width="250" x="513" y="100" text="性格情報" target="*start" cond="tf.selectedButton === 'personalInfo'"]
[glink color="&tf.buttonColor" size="28" width="250" x="513" y="100" text="性格情報" target="*start" cond="tf.selectedButton !== 'personalInfo'"]
[glink color="&tf.buttonColor" size="28" width="250" x="796" y="100" text="閉じる" target="*returnMain"]

; 役職設定ボタン表示用ループ
[eval exp="tf.roleCount = 0"]
*start_displaySelectRoleButton
  [call target="*displaySelectRoleButton"]
  [jump target="*end_displaySelectRoleButton" cond="tf.roleCount >= tf.maxRoleButtonCount"]
  [eval exp="tf.roleCount++"]
  [jump target="*start_displaySelectRoleButton"]
*end_displaySelectRoleButton

; 「役職設定」を押したとき（最初にウィンドウを開いたときも含む）だけ、裏ページからトランジションする
[trans layer="1" time="0" cond="tf.needTrans"]
[eval exp="tf.needTrans = false"]
[s]



; 役職設定ボタン表示用ループのサブルーチン
*displaySelectRoleButton
[iscript]
// ボタンの座標
tf.top = tf.baseTop + (tf.offsetTop * tf.roleCount);
tf.buttonX = 350;
tf.buttonY = tf.top + 15;

// ボタンの情報
const roleButtonObj = tf.roleButtonList[tf.roleCount];
tf.roleId = roleButtonObj.roleId;
tf.roleButtonText = roleButtonObj.name;
tf.roleButtonAvailable = roleButtonObj.available;
tf.roleStorage = 'role/icon_' + tf.roleId + '.png';
[endscript]

; 役職アイコン
[image folder="image" page="back" storage="&tf.roleStorage" layer="1" width="&tf.iconSize" haight="&tf.iconSize" left="250" top="&tf.top"]

; 参加不可能な役職はボタンではなくテキストを表示
[ptext layer="1" page="back" size="26" x="&(tf.buttonX + 25)" y="&(tf.buttonY + 5)" text="人数オーバー" color="#28332a" cond="!tf.roleButtonAvailable"]
; 参加可能な役職のボタン
[glink color="&tf.buttonColor"         size="26" width="200" x="&tf.buttonX" y="&tf.buttonY" text="&tf.roleButtonText" target="*select_role" preexp="tf.roleId" exp="tf.currentRoleId = preexp" cond="tf.roleButtonAvailable && tf.roleId !== tf.currentRoleId"]
; そのキャラの役職として選択中の役職のボタン
[glink color="&tf.selectedButtonColor" size="26" width="200" x="&tf.buttonX" y="&tf.buttonY" text="&tf.roleButtonText" target="*select_role" preexp="tf.roleId" exp="tf.currentRoleId = preexp" cond="tf.roleButtonAvailable && tf.roleId === tf.currentRoleId"]
[return]



; 役職ボタンを押した後の処理
*select_role
[freeimage layer="1" page="back"]
[jump storage="customize/customizeWindow.ks" target="*return_from_select_role"]
[s]


; メイン画面に戻る
*returnMain
[iscript]
    // 現在選択中の役職IDをもとに、人狼ゲームデータを更新する
    // ROLE_ID_UNKNOWNはここでしか使わない定数なので（TODO むしろROLE_ID_UNKNOWNをデフォにできるか？）、デフォルトのnullに戻す
    const newRoleId = (tf.currentRoleId === ROLE_ID_UNKNOWN) ? null : tf.currentRoleId;
    const newParticipant = new Participant(
        tf.characterId,
        newRoleId,
        tf.currentParticipant.personalityName,
        tf.currentParticipant.adjustParameters
    )
    replaceParticipantInJinroGameData(f.currentJinroGameData, f.selectedParticipantIndex, newParticipant);
[endscript]

[m_exitCharacter characterId="&tf.characterId" time="1" wait="true"]
[free_filter layer="0"]
[freeimage layer="1" page="fore"]
[freeimage layer="1" page="back"]
[jump storage="customize/main.ks" target="*hideCustomizeWindow"]
[s]

