; カスタマイズ画面のメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]

[bg storage="../image/config/voivo_config_bg_v2.png" time="100"]


*return_from_resetToDefault
[iscript]
// カスタマイズ画面を開いた時点の、カスタマイズ対象の人狼ゲームデータとを取得する
f.currentJinroGameData = sf.jinroGameDataObjects[sf.currentJinroGameDataKey];
// 現在の参加者リスト。参加者情報に更新があったらアイコンを更新するという判定に使う。なのでこの時点ではあえて空配列。
f.currentParticipantList = [];
// 参加者編集モードの後処理要否フラグ
tf.needTeardownEditMode = false;
[endscript]


*hideCustomizeWindow
*return_from_EditMode
[iscript]
tf.participantCount = 0;
tf.participantMaxCount = 4; // TODO:実装キャラが増えたら可変にすること
tf.iconSize = 105;
tf.baseTop = 155;
tf.offsetTop = 110;

tf.buttonColor = CLASS_GLINK_DEFAULT;
[endscript]

; 画面上部のボタン表示
[button fix="true" graphic="button/button_return_normal.png" enterimg="button/button_return_hover.png" target="*returnTitle" x="1143" y="17" width="114" height="103"]
[glink color="&tf.buttonColor" size="26" width="220" x="395" y="22" text="デフォルト設定" target="*resetToDefault"]
[glink color="&tf.buttonColor" size="26" width="220" x="645" y="22" text="参加者編集" target="*startEditMode"]
[glink color="&tf.buttonColor" size="26" width="220" x="895" y="22" text="プレイスタート" target="*startPlay"]

; タイトルバーのテキスト表示
[ptext layer="0" page="back" name="titleText" x="25" y="16" text="カスタマイズ" color="#28332a" size="44" overwrite="true"]
[ptext layer="0" page="back" name="explainText" x="25" y="85" text="キャラアイコン：プロフィール　役職アイコン：役職設定" color="#28332a" size="28" overwrite="true"]

; キャラアイコン、役職アイコンとそのクリッカブル領域を表示
*start_displayParticipantIcon
[call target="*displayParticipantIcon"]
[jump target="*end_displayParticipantIcon" cond="tf.participantCount >= tf.participantMaxCount"]
[eval exp="tf.participantCount++"]
[jump target="*start_displayParticipantIcon"]
*end_displayParticipantIcon

; キャラアイコン、役職アイコンを裏ページからトランジションしてくる
; 補足：time="1"と[wt]は必須。完全にトランジションが終わってから[free_draglayer]しないと、裏ページが可視化されてしまうことがある。
; またtime="0"だと[wt]する前にトランジションが終わってしまい、[wt]で完了済みのトランジション完了を待ち続けてしまうことがある。
[trans layer="0" time="1"]
[wt]

; 参加者編集完了後のみ実行する後処理
; 新しいアイコンのトランジションが完了してからドラッグレイヤーを消す
[free_draglayer cond="tf.needTeardownEditMode"]

[iscript]
  // 現時点での参加者リストを保存しておく。
  // カスタマイズウィンドウを閉じたり、参加者編集が完了して、再度メイン画面を表示したときに画像更新判定をするため
  f.currentParticipantList = clone(f.currentJinroGameData.participantList);

  tf.needTeardownEditMode = false;
[endscript]
[s]



; 参加者のキャラアイコン、役職アイコン、クリッカブル領域を表示するサブルーチン
*displayParticipantIcon
[iscript]
tf.top = tf.baseTop + (tf.offsetTop * tf.participantCount);
tf.targetprofile = '*window_profile_' + tf.participantCount;
tf.targetSelectRole = '*window_selectRole_' + tf.participantCount;

// 参加者情報を取得
const participant = getParticipantWithIndexFromJinroGameData(f.currentJinroGameData, tf.participantCount);
const characterId = participant.characterId;
const roleId = participant.roleId || ROLE_ID_UNKNOWN;

// アイコン画像の更新要否判定。現在表示しているキャラや役職と変わっていたなら画像を更新する（ただし初回なら必ず表示する）
const currentParticipant = f.currentParticipantList[tf.participantCount] || null;
tf.needUpdateCharaIcon = (currentParticipant === null || currentParticipant.characterId !== characterId);
tf.needUpdateRoleIcon = (currentParticipant === null || currentParticipant.roleId !== participant.roleId);

// アイコン画像のnameパラメータ（=class属性）
// キャラクターIDそのものを含めておくことで扱いやすくする（一意になる、そのままキャラクターIDとして参照できる）
tf.charaIconName = 'charaIcon ' + characterId;
tf.roleIconName = 'roleIcon roleIcon_' + tf.participantCount;

// 画像ファイルパス
tf.sdStorage = 'sdchara/' + characterId + '.png';
tf.roleStorage = 'role/icon_' + roleId + '.png';
[endscript]

; 画像を更新する場合、裏ページ（※）のアイコンを削除しておく。残しておくと、画面上では重なって見えないがimageタグ自体は残り続けたままになってしまうため
; ※[free]タグのpageパラメータはv6タグリファレンスには明記されていないが、ティラノのv600beta5時点で指定できることを確認した
[free layer="0" page="back" name="&tf.charaIconName" cond="tf.needUpdateCharaIcon"]
[free layer="0" page="back" name="&tf.roleIconName" cond="tf.needUpdateRoleIcon"]

; キャラアイコンと役職アイコン表示
[image folder="image" page="back" storage="&tf.sdStorage" layer="0" width="&tf.iconSize" height="&tf.iconSize" left="100" top="&tf.top" name="&tf.charaIconName" cond="tf.needUpdateCharaIcon"]
[image folder="image" page="back" storage="&tf.roleStorage" layer="0" width="&tf.iconSize" height="&tf.iconSize" left="205" top="&tf.top" name="&tf.roleIconName" cond="tf.needUpdateRoleIcon"]

; キャラアイコンには「プロフィール」への、役職アイコンには「役職設定」へのクリッカブル領域を作成
[clickable width="&tf.iconSize" height="&tf.iconSize" x="100" y="&tf.top" color="0x333333" opacity="0" mouseopacity="40" target="&tf.targetprofile"]
[clickable width="&tf.iconSize" height="&tf.iconSize" x="205" y="&tf.top" color="0x333333" opacity="0" mouseopacity="40" target="&tf.targetSelectRole"]
[return]



; タイトル画面に戻る
*returnTitle
; fixボタンをクリア
[clearfix]
[layopt layer="message0" visible="false"]
[freeimage layer="0" page="fore"]
[freeimage layer="0" page="back"]
[jump storage="title.ks"]
[s]


; 人狼ゲームを開始する
*startPlay
[clearfix]
[layopt layer="message0" visible="false"]
[freeimage layer="0" page="fore"]
[freeimage layer="0" page="back"]
[stopbgm]

; 人狼ゲームの準備、導入編自動再生、ゲーム開始
[jump storage="prepareJinro.ks" target="*prepareJinroGame"]
[s]



; カスタマイズウィンドウを表示する
; メモ：最大クリッカブル領域の数（＝最大参加キャラクター数）だけ事前に実装しておくこと
*window_profile_0
[iscript]
  f.selectedParticipantIndex = 0;
  tf.windowElements = 'profile';
[endscript]
[jump target="*jump_customizeWindow"]

*window_profile_1
[iscript]
  f.selectedParticipantIndex = 1;
  tf.windowElements = 'profile';
[endscript]
[jump target="*jump_customizeWindow"]

*window_profile_2
[iscript]
  f.selectedParticipantIndex = 2;
  tf.windowElements = 'profile';
[endscript]
[jump target="*jump_customizeWindow"]

*window_profile_3
[iscript]
  f.selectedParticipantIndex = 3;
  tf.windowElements = 'profile';
[endscript]
[jump target="*jump_customizeWindow"]

*window_profile_4
[iscript]
  f.selectedParticipantIndex = 4;
  tf.windowElements = 'profile';
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



; 参加者編集モードを開始する
*startEditMode
  [iscript]
    // ループ用カウントリセット
    tf.participantCount = 0;
  [endscript]

  [clearfix]

  ; タイトルバーのテキスト表示
  [ptext layer="0" page="fore" name="titleText" x="25" y="16" text="参加者編集" color="#28332a" size="44" overwrite="true"]
  [ptext layer="0" page="fore" name="explainText" x="25" y="85" text="緑：プレイヤー　青：NPC　ドラッグ＆ドロップで並び替え" color="#28332a" size="28" overwrite="true"]

  ; キャラアイコンは裏ページからは消しておかないとドラッグアイテム生成時に問題が起きる（表の画像も裏の画像も同じnameなので、ドラッグアイテムが2つ生成されてしまう）
  [free layer="0" page="back" name="charaIcon"]
  ; 参加者編集時に役職は関係ないので消してスペース確保。参加者編集完了後には全アイコン必ず再表示するので、今のうちに表からも裏からも消しておく
  ; メモ：将来的には確保したスペースに、「不参加者エリア」を作りたい
  [free layer="0" page="fore" name="roleIcon"]
  [free layer="0" page="back" name="roleIcon"]

  *start_prepareDragDrop
    [call target="*prepareDragDrop"]
    [jump target="*end_prepareDragDrop" cond="tf.participantCount >= tf.participantMaxCount"]
    [eval exp="tf.participantCount++"]
    [jump target="*start_prepareDragDrop"]
  *end_prepareDragDrop

  ; 編集完了ボタン
  [glink color="&tf.buttonColor" size="26" width="220" x="645" y="22" text="編集完了" target="*endEditMode"]
[s]



; 「ドラッグ＆ドロップ」プラグインで、キャラアイコンをドラッグアイテムとして、キャラアイコンがあった場所をドロップエリアとして定義する
*prepareDragDrop
  [iscript]
    tf.top = tf.baseTop + (tf.offsetTop * tf.participantCount);

    const participant = f.currentParticipantList[tf.participantCount];

    // アイコン画像のnameパラメータ（=class属性）
    tf.charaIconName = participant.characterId;
    tf.dropAreaName = 'dropArea_' + tf.participantCount;
    // ドロップエリアの色。0=PCのエリアのみ色を変える。
    tf.dropAreaColor = (tf.participantCount === 0) ? 'green' : 'blue';
  [endscript]

  ; ドロップエリアとドラッグアイテムの定義
  [droparea name="&tf.dropAreaName" width="&tf.iconSize" height="&tf.iconSize" left="100" top="&tf.top" oneonly="true" color="&tf.dropAreaColor" opacity="100"]
  [dragitem name="&tf.charaIconName" return="true" fit="true" dropout="false" grabpos="center"]
  ; 初期状態では、ドロップエリアとドラッグアイテムの位置は一致しているので、アイコンの位置は変えずに両者の紐づけだけする
  ; メモ：left, topはタグリファレンスには書いていないが必須パラメータ（両方指定しないと紐づけ処理まで辿り着けない）。明示的に"home"を指定することで今の位置のままにすることができる実装になっていた。
  [move_dragitem name="&tf.charaIconName" area="&tf.dropAreaName" left="home" top="home"]
[return]



; 参加者編集モードを終了する
*endEditMode
  [iscript]
    /*
    * プラグインによってf.dragitemに、{characterId: 属するドロップエリア名, ...}形式で値が入っている状態。
    * f.currentParticipantListを回し、参加者の順番が編集で更新されていた場合はf.currentJinroGameDataに入れ直す。
    */
    let currentIndex = 0;
    for (const participant of f.currentParticipantList) {
      // ドロップエリア名のsuffix部分が、更新後のインデックス
      const dropAreaName = f.dragitem[participant.characterId];
      const afterIndex = parseInt(dropAreaName.split('_')[1]);

      // 順番が更新されていたら、参加者オブジェクトを人狼ゲームデータに入れ直す
      if (afterIndex !== currentIndex) {
        replaceParticipantInJinroGameData(f.currentJinroGameData, afterIndex, participant);

        // dragArea_0が更新されていた場合、プレイヤーキャラクターを変更する
        if (afterIndex === 0) {
          f.currentJinroGameData.playerCharacterId = participant.characterId;
        }
      }
      currentIndex++;
    }
    // 全キャラアイコンと全役職アイコンを更新させるため、f.currentParticipantListを空配列に上書きする
    // FIXME: [fix_dragitem layer="0"]をうまく使えば、こうしない実装もできそうな気がする
    f.currentParticipantList = [];

    // 後処理フラグを立てておく
    tf.needTeardownEditMode = true;
  [endscript]

  [jump target="*return_from_EditMode"]
[s]



; デフォルト設定に戻す
*resetToDefault
  [iscript]
    resetJinroGameDataObjectsToDefault();
    f.currentParticipantList = [];
  [endscript]

  [free layer="0" page="back" name="charaIcon"]
  [free layer="0" page="back" name="roleIcon"]
  [jump target="*return_from_resetToDefault"]
[s]
