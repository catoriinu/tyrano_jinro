/**
 * m_changeCharacterマクロのjsポーティング版メソッド
 * ※基本的にはマクロの方を使うべき。jsから呼び出したいときのみこのメソッドを使うことを許容。
 * 　jsでティラノタグを呼び出し実行すると、ページ送りが行われてしまうことに注意すること。
 * 登場しているキャラクターを交代する。既に登場しているキャラクターの場合は表情のみ変える。
 * キャラの表示位置は、PC：画面左側、NPC：画面右側とする。同じ側には一人しか出ない（ので、例えばNPC1が右側にいるときNPC2が喋る場合、NPC1が退場してからNPC2が登場する）
 * すでにそのキャラがchara_newで登録,およびその表情がchara_faceで登録済みである前提とする。
 * @param characterId 登場させたいキャラのキャラクターID。必須。
 * @param face 登場させたいキャラのface。基本的に必須。
 */
function changeCharacter(characterId, face = null) {

  // そのキャラがデフォルトで登場する位置を格納する（マクロ側と違い、単に変数名の短縮のため）
  let side = TYRANO.kag.stat.f.defaultPosition[characterId].side;

  // その位置に既に登場しているキャラがいる場合
  if (TYRANO.kag.stat.f.displayedCharacter[side].isDisplay) {

    // それが登場させたいキャラ自身の場合
    if (TYRANO.kag.stat.f.displayedCharacter[side].characterId == characterId) {
      // 表情の指定があり、かつ今の表情と違う場合、表情を変える
      if (face && TYRANO.kag.stat.f.displayedCharacter[side].face != face) {
        TYRANO.kag.ftag.startTag('chara_mod', {
          name: characterId,
          face: face,
          time: 500,
          wait: 'false'
        });
        // 表示キャラオブジェクトを更新する
        TYRANO.kag.stat.f.displayedCharacter[side].face = face;
      }

    } else {
      // 今登場している別のキャラを退場させてから、そのキャラを登場させる
      exitCharacter(TYRANO.kag.stat.f.displayedCharacter[side].characterId);
      enterCharacter(characterId, face, side);
    }

  } else {
    // 登場しているキャラがいないなら、そのキャラを登場させる
    enterCharacter(characterId, face, side);
  }
}

/**
 * m_enterCharacterマクロのjsポーティング版メソッド
 * ※基本的にはマクロの方を使うべき。jsから呼び出したいときのみこのメソッドを使うことを許容。
 * 　jsでティラノタグを呼び出し実行すると、ページ送りが行われてしまうことに注意すること。
 * 現在は登場していないキャラを登場させる
 * @param characterId 登場させたいキャラのキャラクターID。必須。
 * @param face 登場させたいキャラのface。必須。
 * @param side 画面内にキャラが登場する位置。必須。
 */
function enterCharacter(characterId, face, side) {

  console.log('★enter ' + characterId);

  // 表情を変える
  // MEMO 「そのキャラの今の表情」を取得可能であれば、「今の表情と違う場合のみ」にしたい。が、HTML要素内に表情の情報がimgのパスくらいしかなかったので無理そう。
  TYRANO.kag.ftag.startTag('chara_mod', {
    name: characterId,
    face: face,
    time: 1,
    wait: 'false'
  });

  // sideに合わせて、キャラクター画像を移動させるべき量を格納する
  let moveLeft = '-=1000';
  if (side == 'left') {
    moveLeft = '+=1000';
  }

  // sideがrightなら画面右から右側に、leftなら画面左から左側にスライドインしてくる
  TYRANO.kag.ftag.startTag("chara_move",{
    name: characterId,
    time: 600,
    anim: "true",
    left: moveLeft,
    wait: "false",
    effect: "easeOutExpo"
  });

  // 表示キャラオブジェクトを更新する
  TYRANO.kag.stat.f.displayedCharacter[side] = new DisplayedCharacterSingle(true, characterId, face);
}


/**
 * m_exitCharacterマクロのjsポーティング版メソッド
 * ※基本的にはマクロの方を使うべき。jsから呼び出したいときのみこのメソッドを使うことを許容。
 * 　jsでティラノタグを呼び出し実行すると、ページ送りが行われてしまうことに注意すること。
 * 退場マクロ
 * 現在登場しているキャラを退場させる
 * @param characterId 退場させたいキャラのキャラクターID。必須。
 */
function exitCharacter(characterId) {

  // そのキャラがどちらのサイドに表示されているかを取得する
  let side = (function(){
    if (TYRANO.kag.stat.f.displayedCharacter.right != null && TYRANO.kag.stat.f.displayedCharacter.right.characterId == characterId) return 'right';
    if (TYRANO.kag.stat.f.displayedCharacter.left  != null && TYRANO.kag.stat.f.displayedCharacter.left.characterId  == characterId) return 'left';
    return null;
  })();
  // 現在そのキャラが表示されていないなら、何もせず終了
  if (side === null) return;

  console.log('★exit ' + characterId);

  // そのキャラをデフォルトの位置に移動させる
  TYRANO.kag.ftag.startTag('chara_move', {
    name: characterId,
    time: 600,
    left: TYRANO.kag.stat.f.defaultPosition[characterId].left,
    wait: 'false',
  });

  // 表示キャラオブジェクトを更新する
  TYRANO.kag.stat.f.displayedCharacter[side] = new DisplayedCharacterSingle();
}


// TODO 別の場所に移動したい。このファイル自体も改名したい。
/**
 * @classdec 表示キャラオブジェクト（f.displayedCharacter）のleft/rightの値として格納する、一人分のキャラクター情報クラス
 * @param {Boolean} isDisplay 表示中か true:表示中 | false:表示されていない
 * @param {String} characterId キャラクターID
 * @param {String} face 表情
 */
function DisplayedCharacterSingle(isDisplay = false, characterId = null, face = null) {
  this.isDisplay = isDisplay;
  this.characterId = characterId;
  this.face = face;
}


/**
 * 横並びでキャラクター画像を表示するサブルーチン(displayCharactersHorizontally)用の情報オブジェクト
 * 生成したオブジェクトはf.dchに格納しておくこと
 * @param {Array} characterList 表示するキャラクター情報（DisplayCharactersHorizontallySingleオブジェクト）を値に持つ配列
 * @param {Number} displacedPxToRight キャラクター画像の左側からの表示位置を、標準からどれだけ右にずらしたいか(px)(負の値なら左にずれる)
 * @param {Number} displacedPxToTop キャラクター画像の上側からの表示位置を、標準からどれだけ下にずらしたいか(px)(負の値なら上にずれる)
 */
function DisplayCharactersHorizontally(characterList = [], displacedPxToRight = 0, displacedPxToTop = 0) {
  this.characterList = characterList;
  this.displacedPxToRight = displacedPxToRight;
  this.displacedPxToTop = displacedPxToTop;
}


/**
 * 横並びでキャラクター画像を表示する際のキャラクター単体についての情報オブジェクト
 * 生成したオブジェクトは、DisplayCharactersHorizontallyオブジェクトのcharacterList配列の値として格納すること
 * @param {String} characterId キャラクターID
 * @param {String} fileName 表示する画像のファイルパス。拡張子も必要。最終的には[image storage="chara/{characterId}/{fileName}"]形式で渡される。
 * @param {String} bgColor 背景色のカラーコード
 * @param {String} topText box上部に横書きで表示するテキスト。表示不要なら引数不要
 * @param {String} leftText box左部に縦書きで表示するテキスト。表示不要なら引数不要
 */
function DisplayCharactersHorizontallySingle(characterId, fileName, bgColor, topText = '', leftText = '') {
  this.characterId = characterId;
  this.fileName = fileName;
  this.bgColor = bgColor;
  this.topText = topText;
  this.leftText = leftText;
}



/**
 * ここからステータス画面用
 */


/**
 * 1キャラ分のキャラ情報コンテナを生成する
 * @param {*} characterObjects TODO 夜時間ならここで夜オブジェクトを渡してくること
 * @param {*} characterId 
 * @param {*} boxWidth 
 * @returns $infoContainer
 */
function createInfoContainer(characterObjects, characterId, boxWidth) {

  // キャラ情報コンテナオブジェクト生成
  const $infoContainer = $('<div>').attr({
    'class': 'infoContainer'
  }).css({
    'width': boxWidth + 'px', // 1box分の幅を設定する
  });

  // 役職情報、死因情報
  $infoContainer.append(createParticipantsInfoBoxes(characterObjects, characterId));

  // 投票情報

  // 占い履歴情報
  $infoContainer.append(createRoleHistoryInfoBoxes(characterObjects, characterId, ROLE_ID_FORTUNE_TELLER));

  return $infoContainer;
}


/**
 * 「住民一覧」として表示する情報ボックスを一括生成する
 * @param {*} characterObjects 
 * @param {*} characterId 
 * @returns 
 */
function createParticipantsInfoBoxes(characterObjects, characterId) {

  // 役職情報と死因情報の2行
  const totalLineNumber = 2;
  const characterObject = characterObjects[characterId];

  // 役職情報表示
  // PCは、自分の役職を常時表示する
  // NPCは、CO済み役職がある場合に表示する（未COでも要素は生成し、スペースを確保する）
  const $roleInfoBox = createRoleInfoBox(characterObject, totalLineNumber);

  // 死因情報表示
  // TODO 夜時間はどうする？
  const $deathInfoBox = createDeathInfoBox(characterObject, totalLineNumber);

  return [$roleInfoBox, $deathInfoBox];
}


/**
 * 役職情報ボックスを生成する
 * @param {*} characterObject 
 * @param {*} totalLineNumber 
 * @returns 
 */
function createRoleInfoBox(characterObject, totalLineNumber) {

  const $roleInfoBox = $('<div>').attr({
    'class': 'infoBox roleInfoBox participantsInfo'
  }).css(
    getCssObjectForRoleInfoBox(characterObject, totalLineNumber)
  );

  // プレイヤーの場合
  if (characterObject.isPlayer) {
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
  // TODO 共通視点で役職確定済みなら、その役職の画像を入れる

  return $roleInfoBox;
}


/**
 * 役職情報ボックス用のCSSオブジェクトを取得する
 * @param {*} characterObject 
 * @param {*} totalLineNumber 
 * @returns 
 */
function getCssObjectForRoleInfoBox(characterObject, totalLineNumber) {

  // デフォルトは空文字（Boxに色を付けない）
  let color = '';
  if (characterObject.isPlayer) {
    // プレイヤーの場合、役職COしているかに関わらず、自分の役職の陣営の色とする
    if (ROLE_ID_TO_FACTION[characterObject.role.roleId] == FACTION_WEREWOLVES) {
      color = 'black';
    } else {
      color = 'white';
    }

  } else {
    // NPCの場合
    if (characterObject.CORoleId) {
      // 今のところ村役職しかCOしないので、白のまま
      color = 'white';
      if (characterObject.isContradicted) {
        // ただし破綻済みの場合は黒にする（TODO ことができるようにしておくが、プレイヤーに有利になりすぎるので有効化しない）
        color = 'black';
      }
    }
    // TODO 共通視点で役職確定済みなら、その役職の色を入れる
  }

  const cssObject = Object.assign(
    getCssHeightForInfoLine(totalLineNumber),
    getCssBGColor(color)
  );

  return cssObject;
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
 * 
 */
function getCssBGColor(color) {
  const bgColorObject = {}
  switch (color) {
    case 'black':
      bgColorObject['background-color'] = 'rgba(36, 36, 36, 0.9)'; // #242424
      bgColorObject['color'] = 'rgba(247, 247, 247, 0.9)'; // #f7f7f7
      break;
    case 'white':
      bgColorObject['background-color'] = 'rgba(247, 247, 247, 0.9)'; // #f7f7f7
      bgColorObject['color'] = 'rgba(36, 36, 36, 0.9)'; // #242424
      break;
  }
  return bgColorObject;
}


// 役職アイコンのimg要素を表示するためのJQueryオブジェクトを取得する
function getRoleIconImgObject(roleId) {
  $roleIconImg = $('<img>');
  $roleIconImg.attr({
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
 * 役職履歴（「占い履歴」や霊能履歴）として表示する情報ボックスを一括生成する
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
    const $roleHistoryInfoBox = createRoleHistoryInfoBox(roleCharacterObject, targetId, roleId, COCharacterList.length);
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
 * @returns 
 */
function createRoleHistoryInfoBox(roleCharacterObject, targetId, roleId, totalLineNumber) {

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
      $roleHistoryInfoBox.append(getDetailForRoleHistoryInfoBox(roleCharacterObject, day, actionObject))
      Object.assign(cssObject, getCssBGColor('white'));
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
  const $characterImg = $('<img>').attr({
    'src': './data/image/sdchara/' + roleCharacterObject.characterId + '.png',
    'class': 'sdCharaImg sd_' + roleCharacterObject.characterId
  });

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
