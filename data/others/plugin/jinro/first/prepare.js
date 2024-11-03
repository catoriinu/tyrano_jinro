/**
 * 参加者オブジェクト
 * 人狼ゲームの準備段階で生成する、参加者としての最低限の情報のみを格納できるオブジェクト。人狼ゲーム内では用いない
 * @param {String} characterId キャラクターID。必須
 * @param {String} roleId 役職ID。指定しない場合、役職はランダムに決定される
 * @param {String} personalityName 性格名。指定しない場合、キャラクターのデフォルトの性格になる
 * @param {Object} adjustParameters 性格調整用のパラメータオブジェクト。なければ無調整。
 */
function Participant(characterId, roleId = null, personalityName = null, adjustParameters = {}) {
  this.characterId = characterId;
  this.roleId = roleId;
  this.personalityName = personalityName;
  this.adjustParameters = adjustParameters;
  // this.participationStatus = PARTICIPATION_CONFIRMED、PARTICIPATION_DECLINED、PARTICIPATION_CANDIDATE
}


/**
 * 人狼ゲームで利用するキャラクターオブジェクト配列を生成し、ティラノのゲーム変数に格納する
 * 人狼ゲーム開始前に毎回呼び出すこと
 * @param {JinroGameData} jinroGameDataParam 人狼ゲームデータ
 */
function initializeCharacterObjectsForJinro(jinroGameDataParam) {
  // 渡し元のjinroGameDataを更新してしまわないようにディープコピー
  const jinroGameData = clone( jinroGameDataParam);

  // 開発者モード：「NPCの思考方針」によってlogicalを調整する。logicalを上書きすることで仲間度の算出結果が変わる。
  const adjustlogicalObject = {};
  if (TYRANO.kag.variable.sf.j_development.thinking === DECISION_LOGICAL) {
    // 「論理的」の場合、全キャラクターのlogicalを0.9999に上書きする（1だと仲間度の計算に全く信頼度が反映されなくなってしまうため）
    adjustlogicalObject.logical = 0.9999;
  } else if (TYRANO.kag.variable.sf.j_development.thinking === DECISION_EMOTIONAL) {
    // 「感情的」の場合、全キャラクターのlogicalを0.0001に上書きする（0だと仲間度の計算に全く同陣営割合が反映されなくなってしまうため）
    adjustlogicalObject.logical = 0.0001;
  }

  // 残り役職人数の把握のために、現在のroleDataをコピーする
  const roleDataWithRemainingCapacity = Object.assign({}, jinroGameData.roleData);

  // 最初に、参加確定かつ役職確定している参加者のキャラクターオブジェクトを生成する
  const tmpCharacterObjects = {};
  const participantList = jinroGameData.participantList;
  for (const participant of participantList) {
    // 役職が未確定の参加者は後回し
    if (!participant.roleId) continue;

    // 開発者モード用のlogical上書き処理
    participant.adjustParameters = Object.assign(participant.adjustParameters, adjustlogicalObject);

    // キャラクターオブジェクトを生成
    tmpCharacterObjects[participant.characterId] = new Character(participant);

    // 配役した役職IDは残り役職人数オブジェクトから減らしていく
    roleDataWithRemainingCapacity[participant.roleId]--;
    if (roleDataWithRemainingCapacity[participant.roleId] < 0) {
      alert('役職人数不足エラー: 役職人数不足のため、' + participant.characterId + 'に' + participant.roleId + 'を配役できませんでした');
    }
  }

  // 未確定の役職配列を、シャッフルした状態で取得する
  let unconfirmedRoleIdList = shuffleElements(convertNumberValueObjectToArray(roleDataWithRemainingCapacity));
  let roleIdListIndex = 0;

  // 次に、参加確定かつ役職未確定の参加者のキャラクターオブジェクトを生成する
  for (const participant of participantList) {
    // 役職確定の参加者はスキップ（前のループで生成済み）
    if (participant.roleId) continue;
    // TODO: 参加未確定の参加者もスキップ。初期リリースではあり得ないパターンなので実装後回し

    // 未確定の役職配列からroleIdを取得し、上書きする
    const roleId = unconfirmedRoleIdList[roleIdListIndex];
    participant.roleId = roleId;
    participant.adjustParameters = Object.assign(participant.adjustParameters, adjustlogicalObject);
    roleIdListIndex++;

    // キャラクターオブジェクトを生成
    tmpCharacterObjects[participant.characterId] = new Character(participant);

    // 配役した役職IDは残り役職人数オブジェクトから減らしていく
    roleDataWithRemainingCapacity[participant.roleId]--;
    if (roleDataWithRemainingCapacity[participant.roleId] < 0) {
      alert('役職人数不足エラー: 役職人数不足のため、' + participant.characterId + 'に' + participant.roleId + 'を配役できませんでした');
    }
  }

  // 最後に、参加未確定かつ役職未確定の参加者のキャラクターオブジェクトを生成する
  // TODO: 初期リリースではあり得ないパターンなので実装後回し
  // 役職未確定の参加者を抽出してシャッフルする
  // もう一度unconfirmedRoleIdList = shuffleElements(convertNumberValueObjectToArray(roleDataWithRemainingCapacity));を取得し、ループしてキャラクターオブジェクトを生成する。
  // 最後までループしきったら終了（配役に対して参加者の方が多くて余ってしまった場合は登場させない）
  // 役職未確定の参加者の方が先に終わってしまった場合は人数不足エラー

  // 元々の参加者オブジェクト配列に入っていた順番に、キャラクターオブジェクトを並び替える
  const characterObjects = {};
  for (const participant of participantList) {
    const characterId = participant.characterId;
    if (!(characterId in tmpCharacterObjects)) continue; // 参加しないことになったキャラならスキップ

    characterObjects[characterId] = tmpCharacterObjects[characterId];

    // 人狼ゲームデータで指定されていたキャラをプレイヤーキャラとする
    if (characterId === jinroGameData.playerCharacterId) {
      characterObjects[characterId].isPlayer = true;
      TYRANO.kag.stat.f.playerCharacterId = characterId;
    }
  }

  // 参加者のキャラクターID配列をティラノ変数に格納する（ゲーム内での並び順の基準になる）
  TYRANO.kag.stat.f.participantsIdList = Object.keys(characterObjects);

  // 共通の視点オブジェクトをティラノ変数に、各キャラの視点オブジェクトを各自のcharacterObject.perspectiveに格納する
  setDefaultPerspective(characterObjects, TYRANO.kag.stat.f.participantsIdList, jinroGameData.roleData);

  // 信頼度オブジェクトを各自のcharacterObject.reliabilityに格納する
  setDefaultReliability(characterObjects, TYRANO.kag.stat.f.participantsIdList);

  // 現在のフラストレーションオブジェクトを各自のcharacterObject.currentFrustrationに格納する
  setDefaultCurrentFrustration(characterObjects, TYRANO.kag.stat.f.participantsIdList);

  // キャラクターオブジェクト配列と役職ID配列をティラノのゲーム変数に格納する
  TYRANO.kag.stat.f.characterObjects = characterObjects;
  TYRANO.kag.stat.f.villagersRoleIdList = convertNumberValueObjectToArray(jinroGameData.roleData);
}


/**
 * 初期状態の、共通の視点オブジェクト、各キャラの視点オブジェクト（自分の役職分を考慮する）を生成する
 * @param {Array} characterObjects キャラクターオブジェクト配列。このメソッド内でperspectiveを更新する。
 * @param {Array} participantsIdList 参加者のキャラクターID配列
 * @param {Object} roleData 役職データ {役職ID: 人数, ...}
 */
function setDefaultPerspective(characterObjects, participantsIdList, roleData) {

  // 重複のない、村の役職ID配列をティラノ変数に入れておく
  TYRANO.kag.stat.f.uniqueRoleIdList = Object.keys(roleData);

  // 役職の割合をオブジェクトに入れる
  const roleRatioObject = {};
  for (let rId of Object.keys(roleData)) {
    roleRatioObject[rId] = roleData[rId] / TYRANO.kag.stat.f.uniqueRoleIdList.length;
  }

  // 共通視点オブジェクトを生成する
  // このとき格納するオブジェクトは必ずcloneでディープコピーすること。単に格納してしまうと、参照渡しなので中身がorganizePerspectiveで書き換えられてしまう
  const commonPerspective = {};
  for (let i = 0; i < participantsIdList.length; i++) {
    commonPerspective[participantsIdList[i]] = clone(roleRatioObject);
  }
  commonPerspective.uncertified = clone(roleData);
  // 共通視点オブジェクトはティラノ変数に格納する
  TYRANO.kag.stat.f.commonPerspective = commonPerspective;

  // 各キャラクターの自分視点オブジェクトを生成し、更新する
  for (let characterId of Object.keys(characterObjects)) {
    // 役職ごとに処理を分ける。
    // perspectiveはCO状態に合わせた視点
    characterObjects[characterId].perspective = organizePerspective(
      commonPerspective,
      characterId,
      TYRANO.kag.stat.f.uniqueRoleIdList.filter(rId => (rId !== ROLE_ID_VILLAGER)) // COなしのうちは村人を入れておく
    );

    characterObjects[characterId].role.rolePerspective = organizePerspective(
      commonPerspective,
      characterId,
      TYRANO.kag.stat.f.uniqueRoleIdList.filter(rId => (rId !== characterObjects[characterId].role.roleId)) // roleCountObjectのキーはroleIdで一意なので利用する。そこから自身のroleId以外を0確定させる。
    );

    console.log(characterObjects[characterId].role.rolePerspective);
  }
}


/**
 * 初期状態の、各キャラの信頼度オブジェクトを生成する
 * @param {Array} characterObjects キャラクターオブジェクト配列。このメソッド内でreliabilityを更新する。
 * @param {Array} participantsIdList 参加者のキャラクターID配列
 */
function setDefaultReliability(characterObjects, participantsIdList) {
  for (let characterId of Object.keys(characterObjects)) {
    let reliabilityObject = {};
    for (let i = 0; i < participantsIdList.length; i++) {
      reliabilityObject[participantsIdList[i]] = setReliability();
    }
    characterObjects[characterId].reliability = reliabilityObject;
  }
}


/**
 * 信頼度を取得する
 * NOTE:仮に完全ランダムとする。何かの法則性を持たせたいならこのあたりに実装する。例）キャラAはキャラBに対してのみ信頼度が0.9以上で確定する
 * @return {Number} 
 */
function setReliability() {
  // 0以上1未満の浮動小数点数
  //return Math.round(Math.random()*100)/100;
  // min以上、max未満
  let max = 0.7;
  let min = 0.3;
  return Math.random() * (max - min) + min;
}


/**
 * 初期状態の、各キャラの現在のフラストレーションオブジェクトを生成する
 * @param {Array} characterObjects キャラクターオブジェクト配列。このメソッド内でcurrentFrustrationを更新する。
 * @param {Array} participantsIdList 参加者のキャラクターID配列
 */
function setDefaultCurrentFrustration(characterObjects, participantsIdList) {
  for (let characterId of Object.keys(characterObjects)) {
    let currentFrustrationObject = {};
    for (let i = 0; i < participantsIdList.length; i++) {
      currentFrustrationObject[participantsIdList[i]] = 0;
    }
    characterObjects[characterId].currentFrustration = currentFrustrationObject;
  }
}


/**
 * 人狼ゲームで利用するティラノのゲーム変数を初期化する
 * 人狼ゲーム開始前に毎回呼び出すこと
 */
function initializeTyranoValiableForJinro() {
  // 人狼ゲーム中フラグ
  // 人狼ゲームを終了、中断する場合は必ずfalseに戻すこと（タイトル画面に戻る場合はそこで初期化しているので不要）
  TYRANO.kag.stat.f.inJinroGame = true;

  // 開票オブジェクトの初期化 {"開票日": その日の開票回数, ...}
  TYRANO.kag.stat.f.openedVote = {};
  // 噛み先履歴オブジェクトの初期化
  TYRANO.kag.stat.f.bitingHistory = {};
  // 処刑履歴オブジェクトの初期化
  TYRANO.kag.stat.f.executionHistory = {};
  // 勝利陣営の初期化
  TYRANO.kag.stat.f.winnerFaction = null;

  // 全占い結果履歴オブジェクトの初期化
  TYRANO.kag.stat.f.allFortuneTellingHistoryObject = {};

  // アクション履歴オブジェクトの初期化
  TYRANO.kag.stat.f.doActionHistory = {};

  // ログ用配列の初期化
  TYRANO.kag.stat.f.logArrayList = [];

  // アクション実行オブジェクトを初期化する
  // MEMO:昼開始時に初期化しているが、ゲームが夜から始まる場合に夜の間にアクション実行できるようにするためここでも初期化しておく
  TYRANO.kag.stat.f.pcActionObject = {};
  TYRANO.kag.stat.f.npcActionObject = {};
  TYRANO.kag.stat.f.doActionObject = {};
  // これは夜にも使うのでここで初期化
  TYRANO.kag.stat.f.originalSelectedCharacterId = '';

  // アクションボタン用アクションリストの初期化（全アクションを定義しておき、j_setActionToButtonObjectsマクロ内で非表示にしたいボタンを選ぶ）
  TYRANO.kag.stat.f.actionButtonList = {
    [ACTION_SUSPECT]: new Button(
        ACTION_SUSPECT,
        '疑う'
    ),
    [ACTION_TRUST]: new Button(
        ACTION_TRUST,
        '信じる',
    ),
    [ACTION_ASK]: new Button(
        ACTION_ASK,
        '聞き出す',
    ),
    [ACTION_CANCEL]: new Button(
        ACTION_CANCEL,
        "発言しない"
    )
  }

  // 日時の初期化（初日の夜から始める）
  // ※いわゆる初日占いや初日襲撃ありにする場合は、夜から始めるようにした上でシナリオを修正すること）
  TYRANO.kag.stat.f.day = 0;
  TYRANO.kag.stat.f.isDaytime = false;
}
