/**
 * 人狼ゲームの準備をするマクロ
 * 人狼ゲーム開始前に呼び出す 
 */
function prepareGameMain() {

  // 今回の参加者のキャラクターID配列と、配役される役職ID配列を取得する
  TYRANO.kag.stat.f.participantsIdList = getParticipantsIdList();
  // TODO 役職選択画面で役職を選択済みなら、既に配列に値が入っているのでここでは役職を割り当てない
  if (!TYRANO.kag.stat.f.isSelectedMyRole) {
    TYRANO.kag.stat.f.villagersRoleIdList = getVillagersRoleIdList();
  }
  
  // 参加者数と役職数が等しいことをチェックしてから先に進む
  if (TYRANO.kag.stat.f.participantsIdList.length != TYRANO.kag.stat.f.villagersRoleIdList.length) {
    alert('参加者数(' + participantsIdList.length + ')と役職数(' + TYRANO.kag.stat.f.villagersRoleIdList.length + ')が合っていません！');
  }

  // キャラクターに役職を割り当てた状態の、キャラクターオブジェクト配列を取得する
  const characterObjects = {};
  for (let i = 0; i < TYRANO.kag.stat.f.participantsIdList.length; i++) {
    const characterId = TYRANO.kag.stat.f.participantsIdList[i];
    characterObjects[characterId] = new Character(characterId, TYRANO.kag.stat.f.villagersRoleIdList[i]);

    // 配列先頭のキャラは、プレイヤーキャラとする
    if (i == 0) {
      characterObjects[characterId].isPlayer = true;
      TYRANO.kag.stat.f.playerCharacterId = characterId
    }

    // 開発者モード：「NPCの思考方針」によるlogicalの上書き処理。logicalを上書きすることで仲間度の算出結果が変わる。
    // 「性格準拠」の場合、何もしない（最初にcontinueすることを明示しておく）
    if (TYRANO.kag.variable.sf.j_development.thinking == 'default') continue
    if (TYRANO.kag.variable.sf.j_development.thinking == 'logical') {
      // 「論理的」の場合、全キャラクターのlogicalを0.9999に上書きする（1だと仲間度の計算に全く信頼度が反映されなくなってしまうため）
      characterObjects[characterId].personality.logical = 0.9999;
    } else if (TYRANO.kag.variable.sf.j_development.thinking == 'emotional') {
      // 「感情的」の場合、全キャラクターのlogicalを0.0001に上書きする（0だと仲間度の計算に全く同陣営割合が反映されなくなってしまうため）
      characterObjects[characterId].personality.logical = 0.0001;
    }
  }
  // 共通の視点オブジェクトをティラノ変数に、各キャラの視点オブジェクトを各自のcharacterObject.perspectiveに格納する
  setDefaultPerspective(characterObjects, TYRANO.kag.stat.f.participantsIdList, TYRANO.kag.stat.f.villagersRoleIdList);

  // 信頼度オブジェクトを各自のcharacterObject.reliabilityに格納する
  setDefaultReliability(characterObjects, TYRANO.kag.stat.f.participantsIdList);

  // 以下のデータは、ティラノの変数にも格納しておく
  // キャラクターオブジェクト配列をティラノのキャラクターオブジェクト変数に格納する
  TYRANO.kag.stat.f.characterObjects = characterObjects;

  // TODO 投票履歴オブジェクトの初期化
  // 開票オブジェクトの初期化 {"開票日": その日の開票回数, ...}
  TYRANO.kag.stat.f.openedVote = {};
  // 噛み先履歴オブジェクトの初期化
  TYRANO.kag.stat.f.bitingHistory = {};
  // 処刑履歴オブジェクトの初期化
  TYRANO.kag.stat.f.executionHistory = {};

  // 全占い結果履歴オブジェクトの初期化
  TYRANO.kag.stat.f.allFortuneTellingHistoryObject = {};

  // アクション履歴オブジェクトの初期化
  TYRANO.kag.stat.f.doActionHistory = {};

  // 発話者の名前オブジェクト。ksファイル内で、# &f.speaker['名前'] の形式で使う。
  TYRANO.kag.stat.f.speaker = setSpeakersName(characterObjects);

  // 画面上に表示中のキャラクターを表すオブジェクト（表示キャラオブジェクト）の初期化
  TYRANO.kag.stat.f.displayedCharacter = {
    left: new DisplayedCharacterSingle(),
    right: new DisplayedCharacterSingle()
  }

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



// メイン関数実行
prepareGameMain();
