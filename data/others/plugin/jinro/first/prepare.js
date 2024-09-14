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
}


/**
 * 参加者の総人数と既に確定済みの参加者オブジェクト配列をもとに、配役される役職ID配列を返却する
 * MEMO:現状5人でこの役職しかないので固定で返す
 * @param {Number} participantsNumber 参加者の総人数
 * @param {Array} participantObjectList 参加者オブジェクト配列 TODO:そこにroleIdがある場合は確定で格納する
 * @return {Array} 配役する役職ID配列（要素数＝参加者の総人数）
 */
function getVillagersRoleIdList(participantsNumber, participantObjectList = []) {
  let villagersRoleIdList = [
    ROLE_ID_WEREWOLF,
    ROLE_ID_MADMAN,
    ROLE_ID_VILLAGER,
    ROLE_ID_FORTUNE_TELLER,
    ROLE_ID_VILLAGER,
  ];
  return villagersRoleIdList;
}


/**
 * 人狼ゲームの参加キャラクターを決める
 * 参加者オブジェクト配列のうち未確定の参加者を、総人数に達するまで実装済みキャラの中からランダムに埋め、規定の順番にソートしなおす
 * @param {Number} participantsNumber 参加者の総人数
 * @param {Array} participantObjectList 確定済みの参加者オブジェクト配列（0要素目はプレイヤーキャラクターになる）
 * @returns {Array} 参加者オブジェクト配列（0要素目はプレイヤーキャラクターになる）
 */
function fillAndSortParticipantObjectList(participantsNumber, participantObjectList = []) {

  // 未確定の参加者の人数
  const unconfirmedParticipantsNumber = participantsNumber - participantObjectList.length;

  // すでに全参加者が確定しているなら、ランダム埋めは不要
  if (unconfirmedParticipantsNumber <= 0) return participantObjectList;

  // 以下の各オブジェクトから、扱いやすくするためにキャラクターID配列にして取り出す
  const confirmedParticipantsIdList = participantObjectList.map(obj => obj.characterId); // 引数時点で参加確定済みの参加者
  const allCharacterIdList = PARTICIPANTS_LIST.map(obj => obj.characterId); // 実装済みの全キャラクター
  const candidatesIdList = allCharacterIdList.filter(cId => 
    // 全キャラのうちから、参加確定済みを除いた残り
    !confirmedParticipantsIdList.includes(cId) &&
    // かつ、参加ステータスがNPCであるキャラ
    cId in TYRANO.kag.variable.sf.participantStatus &&
    TYRANO.kag.variable.sf.participantStatus[cId] === PARTICIPATE_AS_NPC
  );

  // 未確定の参加者の人数分、候補者のうちからランダムに参加者として選出する
  for (let i = 0; i < unconfirmedParticipantsNumber; i++) {
    const tmpIndex = Math.floor(Math.random() * candidatesIdList.length);
    participantObjectList.push(new Participant(candidatesIdList[tmpIndex]));

    // 参加することになったキャラは、候補者配列から取り除く
    candidatesIdList.splice(tmpIndex, 1);
  }

  // 参加者オブジェクト配列の先頭のオブジェクトを、ソートに巻き込まないようにするため退避する（プレイヤーキャラなので0要素目にいなければならないため）
  const firstParticipantObject = participantObjectList.shift();

  // 参加者オブジェクト配列の並び順を、実装済みの全キャラクター配列が定めている通りの順番にソートする
  const sortedParticipantObjectList = [];
  for (let i = 0; i < allCharacterIdList.length; i++) {
    // 今回参加していないキャラクターなら処理不要
    const tmpIndex = participantObjectList.findIndex(obj => obj.characterId === allCharacterIdList[i]);
    if (tmpIndex === -1) continue;

    sortedParticipantObjectList.push(participantObjectList[tmpIndex]);
  }

  // 退避していたオブジェクトを先頭に戻す
  sortedParticipantObjectList.unshift(firstParticipantObject);
  return sortedParticipantObjectList;
}


/**
 * 人狼ゲームで利用するキャラクターオブジェクト配列を生成し、ティラノのゲーム変数に格納する
 * 人狼ゲーム開始前に毎回呼び出すこと
 * @param {Array} villagersRoleIdList 配役する役職ID配列（要素数＝参加者の総人数）
 * @param {Array} participantObjectList 参加者オブジェクト配列（0要素目はプレイヤーキャラクターになる）。参加者の総人数よりも多くても許容されるが、余ったキャラは不参加となる
 */
function initializeCharacterObjectsForJinro(villagersRoleIdList, participantObjectList) {

  if (villagersRoleIdList.length > participantObjectList.length) {
    alert('参加者オブジェクト配列の要素数は、配役する役職ID配列の要素数（＝参加者の総人数）と同数かそれ以上にしてください');
    return;
  }

  // 開発者モード：「NPCの思考方針」によってlogicalを調整する。logicalを上書きすることで仲間度の算出結果が変わる。
  const adjustlogicalObject = {};
  if (TYRANO.kag.variable.sf.j_development.thinking === DECISION_LOGICAL) {
    // 「論理的」の場合、全キャラクターのlogicalを0.9999に上書きする（1だと仲間度の計算に全く信頼度が反映されなくなってしまうため）
    adjustlogicalObject.logical = 0.9999;
  } else if (TYRANO.kag.variable.sf.j_development.thinking === DECISION_EMOTIONAL) {
    // 「感情的」の場合、全キャラクターのlogicalを0.0001に上書きする（0だと仲間度の計算に全く同陣営割合が反映されなくなってしまうため）
    adjustlogicalObject.logical = 0.0001;
  }

  // 引数をcloneし、未確定の役職配列、未確定の参加者オブジェクト配列とする。オリジナルの引数も後で必要となるため
  let unconfirmedRoleIdList = clone(villagersRoleIdList);
  let unconfirmedParticipantObjectList = clone(participantObjectList);

  const tmpCharacterObjects = {};

  // 最初に、配役される役職が確定しているキャラのキャラクターオブジェクトを生成する
  for (let i = 0; i < participantObjectList.length; i++) {
    const characterId = participantObjectList[i].characterId;
    const roleId = participantObjectList[i].roleId;
    const personalityName = participantObjectList[i].personalityName;
    const adjustParameters = Object.assign(participantObjectList[i].adjustParameters, adjustlogicalObject);
  
    if (roleId) {
      if (!unconfirmedRoleIdList.includes(roleId)) {
        alert(characterId + 'に' + roleId + 'を配役しようとしましたが、配役する役職ID配列の中に不足しています');
        return;
      }

      // キャラクターオブジェクトを生成。配役した役職IDと参加者オブジェクトは、それぞれ未確定用の配列から取り除く
      tmpCharacterObjects[characterId] = new Character(characterId, roleId, personalityName, adjustParameters);
      unconfirmedRoleIdList.splice(unconfirmedRoleIdList.findIndex(rId => rId === roleId), 1);
      unconfirmedParticipantObjectList.splice(unconfirmedParticipantObjectList.findIndex(obj => obj.characterId === characterId), 1);
    }
  }

  // 開発者用設定：役職シャッフル「する」なら、未確定の参加者配列の方をシャッフルする
  // 未確定の役職よりも未確定の参加者オブジェクトの方が多いケースを考慮してみると、
  // 役職配列をシャッフルしてもこの後選ばれるキャラクターは固定だが、参加者配列をシャッフルすればどのキャラが出るかもランダムにできるため
  if (TYRANO.kag.variable.sf.j_development.doShuffle) {
    unconfirmedParticipantObjectList = shuffleElements(unconfirmedParticipantObjectList);
  }

  // この時点で未確定の役職を、配役が未確定の参加者に振り分けていく
  // 配役に対して参加者の方が多くて余ってしまった場合は登場させない
  for (let i = 0; i < unconfirmedRoleIdList.length; i++) {
    const characterId = unconfirmedParticipantObjectList[i].characterId;
    const roleId = unconfirmedRoleIdList[i]; // participant.roleIdがnullなので、未確定の役職配列から取得する
    const personalityName = unconfirmedParticipantObjectList[i].personalityName;
    const adjustParameters = Object.assign(unconfirmedParticipantObjectList[i].adjustParameters, adjustlogicalObject);

    // キャラクターオブジェクトを生成。これ以降未確定の役職配列と参加者配列は参照しないので、取り除く処理は省略する
    tmpCharacterObjects[characterId] = new Character(characterId, roleId, personalityName, adjustParameters);
  }

  // 参加者のキャラクターID配列（並び順の基準になるので、この後の並び替えと同時にキャラクターIDをpushしていく）
  TYRANO.kag.stat.f.participantsIdList = [];

  // 元々の参加者オブジェクト配列に入っていた順番に、キャラクターオブジェクトを並び替える
  const characterObjects = {};
  for (let i = 0; i < participantObjectList.length; i++) {
    const characterId = participantObjectList[i].characterId;
    if (!(characterId in tmpCharacterObjects)) continue; // 登場しないことになったキャラならスキップ

    characterObjects[characterId] = tmpCharacterObjects[characterId];
    TYRANO.kag.stat.f.participantsIdList.push(characterId);

    // 配列先頭のキャラは、プレイヤーキャラとする
    if (TYRANO.kag.stat.f.participantsIdList.length == 1) {
      characterObjects[characterId].isPlayer = true;
      TYRANO.kag.stat.f.playerCharacterId = characterId;
    }
  }

  // 共通の視点オブジェクトをティラノ変数に、各キャラの視点オブジェクトを各自のcharacterObject.perspectiveに格納する
  setDefaultPerspective(characterObjects, TYRANO.kag.stat.f.participantsIdList, villagersRoleIdList);

  // 信頼度オブジェクトを各自のcharacterObject.reliabilityに格納する
  setDefaultReliability(characterObjects, TYRANO.kag.stat.f.participantsIdList);

  // 現在のフラストレーションオブジェクトを各自のcharacterObject.currentFrustrationに格納する
  setDefaultCurrentFrustration(characterObjects, TYRANO.kag.stat.f.participantsIdList);

  // キャラクターオブジェクト配列と役職ID配列をティラノのゲーム変数に格納する
  TYRANO.kag.stat.f.characterObjects = characterObjects;
  TYRANO.kag.stat.f.villagersRoleIdList = villagersRoleIdList;
}


/**
 * 初期状態の、共通の視点オブジェクト、各キャラの視点オブジェクト（自分の役職分を考慮する）を生成する
 * @param {Array} characterObjects キャラクターオブジェクト配列。このメソッド内でperspectiveを更新する。
 * @param {Array} participantsIdList 参加者のキャラクターID配列
 * @param {Array} villagersRoleIdList この村の役職のID配列
 */
function setDefaultPerspective(characterObjects, participantsIdList, villagersRoleIdList) {
  // 役職数をカウントしてオブジェクトに入れる
  let roleCountObject = {};
  for (let i = 0; i < villagersRoleIdList.length; i++) {
    let key = villagersRoleIdList[i];
    roleCountObject[key] = roleCountObject[key] ? roleCountObject[key] + 1 : 1;
  }
  // 重複のない、村の役職ID配列をティラノ変数に入れておく
  TYRANO.kag.stat.f.uniqueRoleIdList = Object.keys(roleCountObject);

  // 役職の割合をオブジェクトに入れる
  let roleRatioObject = {};
  for (let rId of Object.keys(roleCountObject)) {
    roleRatioObject[rId] = roleCountObject[rId] / villagersRoleIdList.length;
  }

  // 共通視点オブジェクトを生成する
  // このとき格納するオブジェクトは必ずcloneでディープコピーすること。単に格納してしまうと、参照渡しなので中身がorganizePerspectiveで書き換えられてしまう
  let commonPerspective = {};
  for (let i = 0; i < participantsIdList.length; i++) {
    commonPerspective[participantsIdList[i]] = clone(roleRatioObject);
  }
  commonPerspective.uncertified = clone(roleCountObject);
  // 共通視点オブジェクトはティラノ変数に格納する
  TYRANO.kag.stat.f.commonPerspective = commonPerspective;

  // 各キャラクターの自分視点オブジェクトを生成し、更新する
  for (let characterId of Object.keys(characterObjects)) {
    // 役職ごとに処理を分ける。
    // perspectiveはCO状態に合わせた視点
    characterObjects[characterId].perspective = organizePerspective(
      commonPerspective,
      characterId,
      TYRANO.kag.stat.f.uniqueRoleIdList.filter(rId => (rId != ROLE_ID_VILLAGER)) // COなしのうちは村人を入れておく
    );

    characterObjects[characterId].role.rolePerspective = organizePerspective(
      commonPerspective,
      characterId,
      TYRANO.kag.stat.f.uniqueRoleIdList.filter(rId => (rId != characterObjects[characterId].role.roleId)) // roleCountObjectのキーはroleIdで一意なので利用する。そこから自身のroleId以外を0確定させる。
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

  // 発話者の名前オブジェクト。ksファイル内で、# &f.speaker['名前'] の形式で使う。
  TYRANO.kag.stat.f.speaker = setSpeakersName(TYRANO.kag.stat.f.characterObjects);

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


/**
 * 発話者の名前オブジェクトに、表示名を格納していく
 * @param {Array} characterObjects キャラクターオブジェクト配列
 * @return {Array} 発話者の名前オブジェクト [{name: 表示名},...]
 */
function setSpeakersName(characterObjects) {
  const speaker = {}
  for (let k of Object.keys(characterObjects)) {
    let tmpName = characterObjects[k].name;
    // 開発者用設定：独裁者モードなら後ろに役職名を追加する
    if (TYRANO.kag.variable.sf.j_development.dictatorMode) {
      tmpName += '（' + ROLE_ID_TO_NAME[characterObjects[k].role.roleId] + '）';
    }
    console.log(tmpName);
    speaker[characterObjects[k].name] = tmpName;
  }
  return speaker;
}
