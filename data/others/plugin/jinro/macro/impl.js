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


function createRoleInfoBox(characterObject, lineNumber) {
  const $roleInfoBox = $('<div>');

  const attrObject = {
    'class': 'infoBox line1 participantsInfo'
  }

  const [cssObject, text] = getCssObjectAndTextForRoleInfoBox(characterObject, lineNumber);

  $roleInfoBox.attr(
    attrObject
  ).css(
    cssObject
  ).text(
    text
  );

  return $roleInfoBox;
}


function getCssObjectAndTextForRoleInfoBox(characterObject, lineNumber) {

  console.log(characterObject);

  const cssObject = getCssHeightForInfoLine(lineNumber);
  let color = '';
  let text = '';

  if (characterObject.isPlayer) {

    if (ROLE_ID_TO_FACTION[characterObject.role.roleId] == FACTION_VILLAGERS) {
      color = 'white';
    } else if (ROLE_ID_TO_FACTION[characterObject.role.roleId] == FACTION_WEREWOLVES) {
      color = 'black';
    } else {
      alert('未定義の役職IDです');
    }
    text += ROLE_ID_TO_NAME[characterObject.role.roleId];

  } else {
    if (characterObject.CORoleId) {
      // 今のところ村役職しかCOしないので、白にする
      color = 'white';
      if (characterObject.isContradicted) {
        // ただし破綻済みの場合は黒にする（TODO ことができるようにしておくが、プレイヤーに有利になりすぎるので有効化しない）
        color = 'black';
      }
    }
  }

  if (characterObject.CORoleId) {
    text += ('（' + ROLE_ID_TO_NAME[characterObject.CORoleId] + '）');
  }

  Object.assign(cssObject, getCssBGColor(color));

  return [cssObject, text];
}



function getCssHeightForInfoLine(totalLineNumber) {
  if (totalLineNumber <= 3) {
    // 総line数が3以下なら、1line分の高さは80px
    return {height: '80px'};
  } else {
    // 総line数が4以上なら、総line分の高さが240pxまでに収まるように、1line分の高さを算出する
    return {height: (240 / totalLineNumber) + 'px'};
  }
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

// TODO テキストだけでなくアイコンでも表示できるようにしたい
function getTextForRoleInfoBox(characterObject) {
  let text = '';

  if (characterObject.isPlayer) {
    text += ROLE_ID_TO_NAME[characterObject.role.roleId];
  }
  
  if (characterObject.CORoleId) {
    text += ('（' + ROLE_ID_TO_NAME[characterObject.CORoleId] + '）');
  }

  return text;
}



function createDeathInfoBox(characterObject, lineNumber) {

  const $deathInfoBox = $('<div>');

  const attrObject = {
    'class': 'infoBox line1 participantsInfo'
  }

  const [cssObject, text] = getCssObjectAndTextForDeathInfoBox(characterObject, lineNumber);
  
  $deathInfoBox.attr(
    attrObject
  ).css(
    cssObject
  ).text(
    text
  );

  return $deathInfoBox;
}


function getCssObjectAndTextForDeathInfoBox(characterObject, lineNumber) {

  const cssObject = getCssHeightForInfoLine(lineNumber);
  let text = '';

  if (!characterObject.isAlive) {
    Object.assign(cssObject, getCssBGColor('black'));

    // 投票で死亡したキャラかを確認する
    let [deathDay, deathActionObject] = findObjectFromHistoryByTargetId(TYRANO.kag.stat.f.executionHistory, characterObject.characterId);
    text = '追放';
    // 襲撃で死亡したキャラか
    if (deathDay === null) {
      [deathDay, deathActionObject] = findObjectFromHistoryByTargetId(TYRANO.kag.stat.f.bitingHistory, characterObject.characterId);
      text = '襲撃';
    }
    text = deathDay + '日目' + text;
  }
  return [cssObject, text];
}

// {day: オブジェクト}形式であるHistoryオブジェクトから、targetIdで検索を行う
function findObjectFromHistoryByTargetId(historyObject, searchTargetId) {
  const day = Object.keys(historyObject).find(day => historyObject[day].targetId === searchTargetId);
  
  if (day !== undefined) {
    return [day, historyObject[day]];
  } else {
    return [null, null];
  }
}



function createRoleHistoryInfoBoxes($infoContainer, characterObjects, targetId, roleId) {

  // その役職をCO済みのキャラクターID配列を取得する。ただしプレイヤーがその役職なら、未COでも取得する
  const COCharacterList = Object.keys(characterObjects).filter(
    cId => (characterObjects[cId].CORoleId === roleId || (characterObjects[cId].isPlayer && characterObjects[cId].role.roleId === roleId))
  );

  for (let lineNum = 1; lineNum <= COCharacterList.length; lineNum++) {

    const roleCharacterId = COCharacterList[lineNum - 1]
    const roleCharacterObject = characterObjects[roleCharacterId];

    const $roleHistoryInfoBox = createRoleHistoryInfoBox(roleCharacterObject, targetId, roleId, lineNum, COCharacterList.length);

    $roleHistoryInfoBox.appendTo($infoContainer);
  }
}


function createRoleHistoryInfoBox(roleCharacterObject, targetId, roleId, lineNum, totalLineNumber) {
  const $roleHistoryInfoBox = $('<div>');

  const cssObject = getCssHeightForInfoLine(totalLineNumber);

  const [$characterImg, $baloonLeft] = getDetailForRoleHistoryInfoBox(roleCharacterObject, targetId, roleId);
  
  if ($characterImg instanceof jQuery) {
    $characterImg.appendTo($roleHistoryInfoBox);
    $baloonLeft.appendTo($roleHistoryInfoBox);
    Object.assign(cssObject, getCssBGColor('white'));
  }

  Object.assign(cssObject, {
    'position': 'relative',
    'display': 'flex',
    'justify-content': 'center',
    'align-items': 'center',
    'flex-direction': 'row'
  });

  $roleHistoryInfoBox.attr({
    'class': 'infoBox line' + lineNum + ' ' + roleId + 'HistoryInfo'
  }).css(
    cssObject
  );
  // 初期状態では非表示
  $roleHistoryInfoBox.hide();

  return $roleHistoryInfoBox;
}

function getCssDisplayNone() {
  return {display: 'none'};
}

function getDetailForRoleHistoryInfoBox(roleCharacterObject, targetId, roleId) {

  let $characterImg = {};
  let $baloonLeft = {}

  const roleHistoryObject = getRoleHistoryObject(roleCharacterObject, roleId);

  const [day, actionObject] = findObjectFromHistoryByTargetId(roleHistoryObject, targetId);

  // アクションが見つかったなら
  if (day !== null) {
    // そのアクションが公開情報である、または（未公開情報であっても）その役職のキャラがプレイヤーなら表示対象とする
    if (actionObject.isPublic || roleCharacterObject.isPlayer) {
      let result = actionObject.result ? '●' : '○';
      let text = day + '日目' + result;

      $characterImg = $('<img>');
      $characterImg.attr({
        'src': './data/image/sdchara/' + roleCharacterObject.characterId + '.png',
        'class': 'sd_' + roleCharacterObject.characterId
      }).css({
        'position': 'relative',
        'display': 'inline-block',
        'height': '100%',
      });

      // フキダシ
      $baloonLeft = $('<div>').addClass('balloonLeft');
      $baloonLeft.html($baloonLeft.html() + text);
    }
  }

  return [$characterImg, $baloonLeft];
}

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
