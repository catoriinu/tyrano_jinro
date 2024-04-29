/**
 * 1キャラ分のキャラ情報コンテナを生成する
 * @param {*} characterObjects TODO 夜時間ならここで夜オブジェクトを渡してくること
 * @param {*} characterId 
 * @param {*} boxWidth 
 * @param {boolean} shouldOpenRoleInfo
 * @returns $infoContainer
 */
function createInfoContainer(characterObjects, characterId, boxWidth, shouldOpenRoleInfo) {

  // キャラ情報コンテナオブジェクト生成
  const $infoContainer = $('<div>').attr({
    'class': 'infoContainer'
  }).css({
    'width': boxWidth + 'px', // 1box分の幅を設定する
  });

  // 役職情報、死因情報
  $infoContainer.append(createParticipantsInfoBoxes(characterObjects, characterId, shouldOpenRoleInfo));

  // 投票情報
  $infoContainer.append(createVoteHistoryInfoBoxes(characterObjects, characterId));

  // 占い履歴情報
  $infoContainer.append(createRoleHistoryInfoBoxes(characterObjects, characterId, ROLE_ID_FORTUNE_TELLER));

  return $infoContainer;
}


/**
 * 「住民一覧」として表示する情報ボックスを一括生成する
 * @param {*} characterObjects 
 * @param {*} characterId 
 * @param {boolean} shouldOpenRoleInfo
 * @returns 
 */
function createParticipantsInfoBoxes(characterObjects, characterId, shouldOpenRoleInfo) {

  // 役職情報と死因情報の2行
  const totalLineNumber = 2;
  const characterObject = characterObjects[characterId];

  // 役職情報表示
  // 公開してよい状況なら、役職を常時表示する
  // それ以外なら、CO済み役職がある場合に表示する（未COでも要素は生成し、スペースを確保する）
  const $roleInfoBox = createRoleInfoBox(characterObject, totalLineNumber, shouldOpenRoleInfo);

  // 死因情報表示
  // TODO 夜時間はどうする？
  const $deathInfoBox = createDeathInfoBox(characterObject, totalLineNumber);

  return [$roleInfoBox, $deathInfoBox];
}


/**
 * 役職情報ボックスを生成する
 * @param {*} characterObject 
 * @param {*} totalLineNumber 
 * @param {boolean} shouldOpenRoleInfo
 * @returns 
 */
function createRoleInfoBox(characterObject, totalLineNumber, shouldOpenRoleInfo) {

  const $roleInfoBox = $('<div>').attr({
    'class': 'infoBox roleInfoBox participantsInfo'
  }).css(
    getCssObjectForRoleInfoBox(characterObject, totalLineNumber, shouldOpenRoleInfo)
  );

  // 役職を公開してよい場合
  if (shouldOpenRoleInfo) {
    // 役職情報ボックスの中に自役職の画像を入れる
    $roleInfoBox.append(getRoleIconImgObject(characterObject.role.roleId));
  }

  // 役職CO済みなら
  if (characterObject.CORoleId) {
    // 上向きフキダシ用のクラスを作る
    const $balloonTop = $('<div>').addClass('balloonTop');
    // フキダシの中にCO役職の画像を入れる
    $balloonTop.append(getRoleIconImgObject(characterObject.CORoleId));
    // 役職情報ボックスの中にフキダシを入れる
    $roleInfoBox.append($balloonTop);
  }

  return $roleInfoBox;
}


/**
 * 役職情報ボックス用のCSSオブジェクトを取得する
 * @param {*} characterObject 
 * @param {*} totalLineNumber 
 * @param {boolean} shouldOpenRoleInfo
 * @returns 
 */
function getCssObjectForRoleInfoBox(characterObject, totalLineNumber, shouldOpenRoleInfo) {

  // デフォルトは空文字（Boxに色を付けない）
  let color = '';
  if (shouldOpenRoleInfo) {
    // 役職を公開してよい場合、役職COしているかに関わらず、自分の役職の陣営の色とする
    if (ROLE_ID_TO_FACTION[characterObject.role.roleId] == FACTION_WEREWOLVES) {
      color = 'black';
    } else {
      color = 'white';
    }

  } else {
    // 役職を公開しない場合
    if (characterObject.CORoleId) {
      // CO済みなら灰色にする
      color = 'gray';
    }
  }

  const cssObject = Object.assign(
    getCssHeightForInfoLine(totalLineNumber),
    getCssBGColor(color)
  );

  return cssObject;
}


/**
 * 役職を公開してよい状況かを判定する
 * @param {*} characterObjects 
 * @param {*} characterId 
 * @param {*} winnerFaction 
 * @param {*} commonPerspective 
 * @returns {boolean} true: 公開してよい | false: 公開しない
 */
function isShouldOpenRoleInfo(characterObjects, characterId, winnerFaction, commonPerspective = {}) {
  // 開発者モードなら公開する？

  // プレイヤーである場合は公開する
  if (characterObjects[characterId].isPlayer) {
    return true;
  }

  // 勝利陣営が確定済み（ゲームが終了している）場合は公開する
  if (winnerFaction != null) {
    return true;
  }

  // 共通視点で、そのキャラの役職が1つに確定済みの場合は公開する
  // …ことができるようにしておくが、プレイヤーが正解にたどり着く前に公開する可能性があるので無効化しておく。ヒントモードならありかもしれない
  /*
  const possibleRoleList = Object.keys(commonPerspective[characterId]).filter(rId => commonPerspective[characterId][rId] !== 0);
  if (possibleRoleList.length === 1) {
    return true;
  }
  */
  return false;
}


/**
 * 一度に表示するBoxの総行数をもとに1Box分のheightを算出し、オブジェクト形式で返却する
 * @param {*} totalLineNumber 
 * @returns 
 */
function getCssHeightForInfoLine(totalLineNumber) {
  // 1Box分として指定できる最大のheight（1Box分を、これを超える高さにはしない）
  const maxSingleHeight = 80;
  // 全Box分として指定できる最大のheight（infoContainer自体を、これを超える高さにはしない）
  const maxTotalHeight = 240;
  // 1Box分のheightを算出
  const tmpSingleHeight = maxTotalHeight / totalLineNumber;

  if (tmpSingleHeight > maxSingleHeight) {
    // maxSingleHeightよりも高ければ、maxSingleHeight(px)に抑えて返却
    return {height: (maxSingleHeight + 'px')};
  }
  // そうでなければ、算出結果をそのまま返却
  return {height: (tmpSingleHeight + 'px')};
}


/**
 * 背景色と文字色のセットを、オブジェクト形式で返却する
 * @param {string} bgColor 背景色
 * @param {string} letterColor 文字色。ただし、文字色そのものを指定するのではないことに注意。指定しない場合はbgColorが入る（つまり背景色に適した色になる）
 * @returns 
 */
function getCssBGColor(bgColor, letterColor = bgColor) {
  const bgColorObject = {}
  // 背景色
  switch (bgColor) {
    case 'black':
      bgColorObject['background-color'] = 'rgba(36, 36, 36, 0.9)'; // #242424 黒
      break;
    case 'white':
      bgColorObject['background-color'] = 'rgba(247, 247, 247, 0.9)'; // #f7f7f7 白
      break;
    case 'gray':
      bgColorObject['background-color'] = 'rgba(173, 173, 173, 0.9)'; // #adadad 灰
      break;
  }
  // （その背景色に適した）文字色
  switch (letterColor) {
    case 'black':
      bgColorObject['color'] = 'rgba(247, 247, 247, 0.9)'; // #f7f7f7 白
      break;
    case 'white':
      bgColorObject['color'] = 'rgba(36, 36, 36, 0.9)'; // #242424 黒
      break;
    case 'gray':
      bgColorObject['color'] = 'rgba(36, 36, 36, 0.9)'; // #242424 黒
      break;
  }
  return bgColorObject;
}


/**
 * 役職アイコンのimg要素を表示するためのJQueryオブジェクトを取得する
 * @param {*} roleId 
 * @returns 
 */
function getRoleIconImgObject(roleId) {
  $roleIconImg = $('<img>').attr({
    'src': './data/image/role/icon_' + roleId + '.png',
    'class': 'roleIconImg role_' + roleId
  });
  return $roleIconImg;
}


/**
 * 死因情報ボックスを生成する
 * @param {*} characterObject 
 * @param {*} totalLineNumber 
 * @returns 
 */
function createDeathInfoBox(characterObject, totalLineNumber) {

  const [cssObject, text] = getDetailForDeathInfoBox(characterObject, totalLineNumber);
  
  // 生死問わずBoxは生成する
  const $deathInfoBox = $('<div>').attr({
    'class': 'infoBox deathInfoBox participantsInfo'
  }).css(
    cssObject
  ).text(
    text
  );

  return $deathInfoBox;
}


/**
 * 死因情報ボックスの詳細情報を取得する
 * @param {*} characterObject 
 * @param {*} totalLineNumber 
 * @returns 
 */
function getDetailForDeathInfoBox(characterObject, totalLineNumber) {

  const cssObject = getCssHeightForInfoLine(totalLineNumber);
  let text = '';

  // 退場済みか
  if (!characterObject.isAlive) {
    Object.assign(cssObject, getCssBGColor('black'));

    // 投票で退場したキャラかを確認する
    let [deathDay, deathActionObject] = findObjectFromHistoryByTargetId(TYRANO.kag.stat.f.executionHistory, characterObject.characterId);
    text = '追放';

    // そうでない場合、襲撃で退場したキャラかを確認する
    if (deathDay === null) {
      [deathDay, deathActionObject] = findObjectFromHistoryByTargetId(TYRANO.kag.stat.f.bitingHistory, characterObject.characterId);
      text = '襲撃';
    }
    text = deathDay + '日目' + text;
  }
  return [cssObject, text];
}


/**
 * {day: オブジェクト}形式であるHistoryオブジェクトから、targetIdで検索を行う
 * @param {*} historyObject 
 * @param {*} searchTargetId 
 * @returns 
 */
function findObjectFromHistoryByTargetId(historyObject, searchTargetId) {
  const day = Object.keys(historyObject).find(day => historyObject[day].targetId === searchTargetId);
  
  if (day !== undefined) {
    return [day, historyObject[day]];
  } else {
    return [null, null];
  }
}


/**
 * 「投票履歴」として表示する情報ボックスを一括生成する
 * @param {*} characterObjects 
 * @param {*} characterId 
 * @returns 
 */
function createVoteHistoryInfoBoxes(characterObjects, characterId) {

  const voteHistory = characterObjects[characterId].voteHistory;
  let voteHistoryInfoBoxes = [];
  // 一日ごとにループを回す
  for (let day of Object.keys(voteHistory)) {
    console.log(characterId + day);
    voteHistoryInfoBoxes = voteHistoryInfoBoxes.concat(createVoteDayInfoBoxes(day, voteHistory[day]));
  }
  // TODO 被投票数は表示する？するならどうやって？

  return voteHistoryInfoBoxes;
}


/**
 * 「投票履歴」として表示する情報ボックスの、1日分（複数回答票があった分は一括で）を生成する
 * @param {*} day 
 * @param {*} voteHistoryList 
 * @returns 
 */
function createVoteDayInfoBoxes(day, voteHistoryList) {

  const voteDayInfoBoxes = [];
  const cssObject = Object.assign(
    getCssHeightForInfoLine(voteHistoryList.length),
    getCssBGColor('white')
  );
  for (let i = 0; i < voteHistoryList.length; i++) {
    const $voteInfoBox = $('<div>').attr({
      'class': 'infoBox voteHistoryInfoBox voteHistoryInfo voteDay' + day + ' voteCount' + (i+1)
    }).css(
      cssObject
    );
    // 上向きフキダシ用のクラスを作る
    const $balloonTop = $('<div>').addClass('balloonTop');
    // フキダシの中にキャラクターアイコン画像を入れる
    $balloonTop.append(getSdCharaIconImgObject(voteHistoryList[i]));
    // 投票履歴ボックスの中にフキダシを入れる
    $voteInfoBox.append($balloonTop);

    // 初期状態では非表示
    $voteInfoBox.hide();
    voteDayInfoBoxes.push($voteInfoBox);
  }
  return voteDayInfoBoxes;
}


/**
 * SDキャラアイコンのimg要素を表示するためのJQueryオブジェクトを取得する
 * @param {*} characterId 
 * @returns 
 */
function getSdCharaIconImgObject(characterId) {
  const $characterImg = $('<img>').attr({
    'src': './data/image/sdchara/' + characterId + '.png',
    'class': 'sdCharaImg sd_' + characterId
  });
  return $characterImg;
}


/**
 * 役職履歴（「占い履歴」や「霊能履歴」）として表示する情報ボックスを一括生成する
 * @param {*} characterObjects 
 * @param {*} targetId 
 * @param {*} roleId 
 * @returns 
 */
function createRoleHistoryInfoBoxes(characterObjects, targetId, roleId) {

  // その役職をCO済みのキャラクターID配列を取得する。ただしプレイヤーがその役職なら、未COでも取得する
  const COCharacterList = Object.keys(characterObjects).filter(
    cId => (characterObjects[cId].CORoleId === roleId || (characterObjects[cId].isPlayer && characterObjects[cId].role.roleId === roleId))
  );

  // その役職をCO済みのキャラクターごとに、情報ボックスを生成する
  // 表示する情報は「このキャラクターに対してその役職のキャラたちがどのような結果をCOしているか」という情報
  const roleHistoryInfoBoxes = [];
  for (let i = 0; i < COCharacterList.length; i++) {
    const roleCharacterId = COCharacterList[i];
    const roleCharacterObject = characterObjects[roleCharacterId];
    // （アクション対象のキャラではなく、）アクション実行者のキャラの役職情報を公開してもよいかのフラグ
    const shouldOpenRoleInfo = isShouldOpenRoleInfo(characterObjects, roleCharacterId, TYRANO.kag.stat.f.winnerFaction); // FIXME status.jsはティラノ変数を参照しない思想なので、winnerFactionも直したい。引数で渡してくるのではなくもっとよいリファクタを望む
    const $roleHistoryInfoBox = createRoleHistoryInfoBox(roleCharacterObject, targetId, roleId, COCharacterList.length, shouldOpenRoleInfo);
    roleHistoryInfoBoxes.push($roleHistoryInfoBox);
  }

  return roleHistoryInfoBoxes;
}


/**
 * 役職履歴情報ボックスを生成する
 * @param {*} roleCharacterObject 
 * @param {*} targetId 
 * @param {*} roleId 
 * @param {*} totalLineNumber 
 * @param {boolean} shouldOpenRoleInfo
 * @returns 
 */
function createRoleHistoryInfoBox(roleCharacterObject, targetId, roleId, totalLineNumber, shouldOpenRoleInfo) {

  const $roleHistoryInfoBox = $('<div>').attr({
    'class': 'infoBox roleHistoryInfoBox ' + roleId + 'HistoryInfo'
  });

  const cssObject = getCssHeightForInfoLine(totalLineNumber);

  const roleHistoryObject = getRoleHistoryObject(roleCharacterObject, roleId);
  const [day, actionObject] = findObjectFromHistoryByTargetId(roleHistoryObject, targetId);
  // アクションが見つかったなら
  if (day !== null) {
    // そのアクションが公開情報である、または（未公開情報であっても）その役職のキャラがプレイヤーなら表示対象とする
    if (actionObject.isPublic || roleCharacterObject.isPlayer) {
      $roleHistoryInfoBox.append(getDetailForRoleHistoryInfoBox(roleCharacterObject, day, actionObject));

      let bgColor = 'gray';
      if (shouldOpenRoleInfo) {
        // 役職を公開してよい場合、そのキャラの役職が本当にその役職であるなら背景色は白とする
        if (roleCharacterObject.role.roleId == roleId) {
          bgColor = 'white';
        } else {
          bgColor = 'black';
        }
      }
      Object.assign(cssObject, getCssBGColor(bgColor, 'white')); // 実際に文字の背景色となるフキダシは白なので、boxの背景色に関わらず文字色は黒にする。
    }
  }

  $roleHistoryInfoBox.css(
    cssObject
  );
  // 初期状態では非表示
  $roleHistoryInfoBox.hide();

  return $roleHistoryInfoBox;
}


/**
 * 役職履歴情報ボックスの詳細情報を取得する
 * @param {*} roleCharacterObject 
 * @param {*} day 
 * @param {*} actionObject 
 * @returns 
 */
function getDetailForRoleHistoryInfoBox(roleCharacterObject, day, actionObject) {

  // キャラクター画像
  const $characterImg = getSdCharaIconImgObject(roleCharacterObject.characterId);

  // フキダシとその中身
  const $baloonLeft = $('<div>').addClass('balloonLeft');
  let result = actionObject.result ? '●' : '○';
  let text = day + '日目' + result;
  $baloonLeft.html($baloonLeft.html() + text);

  return [$characterImg, $baloonLeft];
}


/**
 * 指定した役職の履歴オブジェクトを取得する。真なら真の、騙りなら騙りのものを返却する
 * @param {*} characterObject 
 * @param {*} roleId 
 * @returns 
 */
function getRoleHistoryObject(characterObject, roleId) {
  if (roleId == ROLE_ID_FORTUNE_TELLER) {
    // 真占い師
    if (characterObject.role.roleId == ROLE_ID_FORTUNE_TELLER) {
      return characterObject.role.fortuneTellingHistory;
    }
    // 騙り占い師
    return characterObject.fakeRole.fortuneTellingHistory;
  }
  return {};
}
