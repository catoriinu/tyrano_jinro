; カスタマイズウィンドウ
; 事前準備：
; tf.windowElementsにウィンドウに表示する要素を入れておくこと（役職設定='selectRole', プロフィール='profile'）

*start
[iscript]
    // 現在の人狼ゲームデータから、ウィンドウで開いたキャラの情報を取得する
    tf.currentParticipant = getParticipantWithIndexFromJinroGameData(f.currentJinroGameData, f.selectedParticipantIndex);
    tf.characterId = tf.currentParticipant.characterId;
    tf.currentRoleId = tf.currentParticipant.roleId || ROLE_ID_UNKNOWN;
    tf.characterName = getNameByCharacterId(tf.characterId);

    // 利用する変数の初期化
    tf.buttonColor = CLASS_GLINK_DEFAULT;
    tf.selectedButtonColor = CLASS_GLINK_DEFAULT + " " + CLASS_GLINK_SELECTED;

    // トランジション要否（elementPageは、トランジションするなら'back'に、トランジションしないなら'fore'にすること）
    tf.needTrans = true;
    tf.elementPage = 'back';

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
[m_changeCharacter characterId="&tf.characterId" face="通常"]

; layer2にキャラ立ち絵を表示したいため、ウィンドウはlayer1に表示する
[w_openWindow layer="1"]

; キャラ名表示
[ptext layer="1" page="back" text="&tf.characterName" face="MPLUSRounded" size="36" x="180" y="130" width="920" align="center" name="characterName" overwrite="true"]
[iscript]
  // キャラ名に下線で色をつける。ティラノの[mark]の内部処理を参考にした
  tf.characterColor = getBgColorFromCharacterId(tf.characterId);
  $('.characterName').html(function (_, html) {
    return `<mark style="margin-right:-1px; background-color:${tf.characterColor}; color:#28332a; background:linear-gradient(transparent 80%, ${tf.characterColor} 0%); padding-top:4px; padding-bottom:4px;">${html}</mark>`;
  });
[endscript]

*show
[glink color="&tf.selectedButtonColor" size="26" width="210" x="875" y="80" text="閉じる" target="*returnMain"]
[w_makeClickableAreaOuterWindow storage="customize/customizeWindow.ks" target="*returnMain"]

; これから表示する要素以外は消す
[call target="*hideElements"]

; 「役職設定」を表示する
[call target="*selectRole" cond="tf.windowElements === 'selectRole'"]
; 「プロフィール」を表示する
[call target="*profile" cond="tf.windowElements === 'profile'"]

; 最初にウィンドウを開いたときだけ、裏ページからトランジションする。トランジションするたびにウィンドウの[kanim]が実行されてしまうので、内容切り替え時にトランジションするのは諦める
[trans layer="1" time="1" cond="tf.needTrans"]
[iscript]
  tf.needTrans = false;
  tf.elementPage = 'fore';
[endscript]
[s]



; 要素削除サブルーチン
*hideElements
  ; これから表示する要素ではない要素は消す
  ; windowTitleは上書きされるため、characterNameは共通のため、消さなくてよい
  [free layer="1" name="selectRoleElement" cond="tf.windowElements !== 'selectRole'"]
  [free layer="1" name="profileElement" cond="tf.windowElements !== 'profile'"]

  ; トランジションしないときのみ、消した状態の表ページの要素を裏ページにコピーする
  ; トランジションするとき=[kanim]を実行するときにコピーが行われると、アニメーションが中断されてウィンドウが表示できなくなるので避ける
  [backlay layer="1" cond="!tf.needTrans"]
[return]



; 役職設定用サブルーチン
*selectRole
  [glink color="&tf.buttonColor" size="26" width="210" x="192" y="80" text="←プロフィール" target="*show" preexp="'profile'" exp="tf.windowElements = preexp"]
  [ptext layer="1" page="&tf.elementPage" text="役職設定" face="MPLUSRounded" size="36" x="180" y="80" width="920" align="center" name="windowTitle" overwrite="true"]

  ; 役職設定ボタン表示用ループ
  [eval exp="tf.roleCount = 0"]
  *start_displaySelectRoleButton
    [call target="*displaySelectRoleButton"]
    [jump target="*end_displaySelectRoleButton" cond="tf.roleCount >= tf.maxRoleButtonCount"]
    [eval exp="tf.roleCount++"]
    [jump target="*start_displaySelectRoleButton"]
  *end_displaySelectRoleButton
[return]



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
[image folder="image" page="&tf.elementPage" storage="&tf.roleStorage" layer="1" width="&tf.iconSize" haight="&tf.iconSize" left="250" top="&tf.top" name="selectRoleElement"]

; 参加不可能な役職はボタンではなくテキストを表示
[ptext layer="1" page="&tf.elementPage" size="26" x="&(tf.buttonX + 25)" y="&(tf.buttonY + 5)" text="人数オーバー" color="#28332a" cond="!tf.roleButtonAvailable" name="selectRoleElement"]
; 参加可能な役職のボタン
[glink color="&tf.buttonColor"         size="26" width="200" x="&tf.buttonX" y="&tf.buttonY" text="&tf.roleButtonText" target="*returnMain" preexp="tf.roleId" exp="tf.currentRoleId = preexp" cond="tf.roleButtonAvailable && tf.roleId !== tf.currentRoleId"]
; そのキャラの役職として選択中の役職のボタン
[glink color="&tf.selectedButtonColor" size="26" width="200" x="&tf.buttonX" y="&tf.buttonY" text="&tf.roleButtonText" target="*returnMain" preexp="tf.roleId" exp="tf.currentRoleId = preexp" cond="tf.roleButtonAvailable && tf.roleId === tf.currentRoleId"]
[return]



; プロフィール用サブルーチン
*profile
  [glink color="&tf.buttonColor" size="26" width="210" x="192" y="80" text="役職設定→" target="*show" preexp="'selectRole'" exp="tf.windowElements = preexp"]
  [ptext layer="1" page="&tf.elementPage" text="プロフィール" face="MPLUSRounded" size="36" x="180" y="80" width="920" align="center" name="windowTitle" overwrite="true"]

  ; プロフィールテキストをサブルーチン内で変数に格納してから、表示する
  [call storage="customize/profile.ks" target="&tf.characterId"]
  [ptext layer="1" page="&tf.elementPage" text="&tf.infoText" face="MPLUSRounded" size="26" x="180" y="200" width="920" align="left" name="profileElement" overwrite="true"]
[return]



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
; chara_showした立ち絵を退場させる。ここだけレイヤー2を使っているので登場させたままだと他で不具合が起きる
[chara_hide_all layer="&tf.layer" time="1" wait="true"]
[w_closeWindow waitAnime="false"]
[jump storage="customize/main.ks" target="*hideCustomizeWindow"]
[s]

