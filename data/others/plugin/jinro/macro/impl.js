/**
 * m_changeCharacterマクロのjsポーティング版メソッド
 * ※基本的にはマクロの方を使うべき。jsから呼び出したいときのみこのメソッドを使うことを許容。
 * 　jsでティラノタグを呼び出し実行すると、ページ送りが行われてしまうことに注意すること。
 * 登場しているキャラクターを交代する。既に登場しているキャラクターの場合は表情のみ変える。
 * キャラの表示位置は、PC：画面左側、NPC：画面右側とする。同じ側には一人しか出ない（ので、例えばNPC1が右側にいるときNPC2が喋る場合、NPC1が退場してからNPC2が登場する）
 * すでにそのキャラがchara_newで登録,およびその表情がchara_faceで登録済みである前提とする。
 * @param characterId 登場させたいキャラのキャラクターID。必須。
 * @param face 登場させたいキャラのface。基本的に必須。
 * @param side 画面のどちら側に登場させるか。'left'で左側。それ以外または未指定の場合は右側。
 */
function changeCharacter(characterId, face = null, side = 'right') {

  // そのキャラがデフォルトで登場する位置を格納する（'left'か'right'しか許容しない）
  let counterSide = 'right'
  if (side != 'left') {
    side = 'right';
    counterSide = 'left';
  }
  
  // 自分自身がすでに登場済み、かつ逆側に登場させる場合、まず自分自身を退場させる
  if (TYRANO.kag.stat.f.displayedCharacter[counterSide].characterId === characterId) {
    exitCharacter(characterId);
  }

  // その位置に既に登場しているキャラがいる場合
  if (TYRANO.kag.stat.f.displayedCharacter[side].isDisplay) {

    // それが登場させたいキャラ自身の場合
    if (TYRANO.kag.stat.f.displayedCharacter[side].characterId === characterId) {
      // 表情の指定があり、かつ今の表情と違う場合、表情を変える
      if (face && TYRANO.kag.stat.f.displayedCharacter[side].face != face) {

        // スキップ中は表情切り替え時間を0にする。そうしないとフリーズする危険がある
        const time = TYRANO.kag.stat.is_skip ? 0 : 500;

        TYRANO.kag.ftag.startTag('chara_mod', {
          name: characterId,
          face: face,
          time: time,
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

  console.debug('★enter ' + characterId);

  // sideに合わせて、キャラクター画像を移動させるべき量を格納する（左側の場合は次のif文で書き換える）
  let left = TYRANO.kag.stat.f.defaultPosition[characterId].leftOnRight;

  // sideがleftの場合のみ、一度leftOnDefautLeftの位置に移動させる。デフォルトの待機位置がleftOnDefautRightなので。
  if (side === 'left') {
    TYRANO.kag.ftag.startTag("chara_move",{
      name: characterId,
      time: 1,
      left: TYRANO.kag.stat.f.defaultPosition[characterId].leftOnDefautLeft,
      wait: "true",
    });
    left = TYRANO.kag.stat.f.defaultPosition[characterId].leftOnLeft;
  }

  // 表情を変える
  // MEMO 「そのキャラの今の表情」を取得可能であれば、「今の表情と違う場合のみ」にしたい。が、HTML要素内に表情の情報がimgのパスくらいしかなかったので無理そう。
  TYRANO.kag.ftag.startTag('chara_mod', {
    name: characterId,
    face: face,
    time: 0,
    wait: 'false'
  });

  // そのキャラ立ち絵の反転フラグを取得。左向きならfalse, 右向きならtrue
  const reflect = TYRANO.kag.stat.f.defaultPosition[characterId].reflect;
  // 反転フラグとsideを考慮して画像の向きを決める
  const reflectForMod = ((!reflect && side === 'left') || (reflect && side === 'right')) ? 'true' : 'false';
  // 画面の内側向きになるように画像の向きを変える 
  TYRANO.kag.ftag.startTag('chara_mod', {
    name: characterId,
    reflect: reflectForMod,
    time: 0,
    wait: 'false'
  });

  // sideがrightなら画面右から右側に、leftなら画面左から左側にスライドインしてくる
  TYRANO.kag.ftag.startTag("chara_move",{
    name: characterId,
    time: 600,
    anim: "true",
    left: left,
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
 * @param time 退場にかかる時間（[chara_move]のtime）。指定しなければデフォルト600ミリ秒
 */
function exitCharacter(characterId, time = 600) {

  // そのキャラがどちらのサイドに表示されているかを取得する
  let side = (function(){
    if (TYRANO.kag.stat.f.displayedCharacter.right != null && TYRANO.kag.stat.f.displayedCharacter.right.characterId == characterId) return 'right';
    if (TYRANO.kag.stat.f.displayedCharacter.left  != null && TYRANO.kag.stat.f.displayedCharacter.left.characterId  == characterId) return 'left';
    return null;
  })();
  // 現在そのキャラが表示されていないなら、何もせず終了
  if (side === null) return;

  console.debug('★exit ' + characterId);

  // そのキャラをデフォルトの位置に移動させる
  TYRANO.kag.ftag.startTag('chara_move', {
    name: characterId,
    time: time,
    left: TYRANO.kag.stat.f.defaultPosition[characterId].leftOnDefautRight,
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
 * [m_COFortuneTelling]からのジャンプ先のtargetに指定するラベルを判定、返却する。
 * @param {Object} actionObject アクションオブジェクト
 * @returns {String} _{占い結果}_{ターゲットへの感情}_{ターゲットの生死}
 */
function getLabelForCOFortuneTelling(actionObject) {
  let characterId = actionObject.characterId;
  let targetId = actionObject.targetId;

  let resultLabel = '_';
  let feelingLabel = '_';
  let aliveLabel = '_';

  if (actionObject.result === true) {
    // 占い結果が●(=人狼)の場合
    resultLabel += 'true';
    feelingLabel += getFeelingLabel(characterId, targetId);
    aliveLabel += 'alive';
    // NOTE: 本来はここでも生死判定したほうがいい。しかし人狼数が1人の場合に「●判定を出した相手が昨夜襲撃死していた」という占い結果をCOしたら即破綻となる。
    // 作業量削減のためセリフパターンを作成していないので、一旦alive固定にする。
  } else {
    // 占い結果が○(=人狼ではない)の場合
    resultLabel += 'false';
    feelingLabel += getFeelingLabel(characterId, targetId);
    if (!TYRANO.kag.stat.f.characterObjects[targetId].isAlive) {
      // NOTE: 本来は「前日襲撃死した相手なら」が正しいが、単純にするために「発言時点で死亡済みなら」判定する。もし問題が発生したら直すこと。
      aliveLabel += 'died';
    } else {
      aliveLabel += 'alive';
    }
  }

  return resultLabel + feelingLabel + aliveLabel;
}


/**
 * [m_doAction]からのジャンプ先のtargetに指定するラベルを判定、返却する。
 * @param {Action} actionObject アクションオブジェクト
 * @param {Action} triggerActionObject トリガーアクションオブジェクト
 * @returns {String} _{アクションID}_{アクションによる}
 */
function getLabelForDoAction(actionObject, triggerActionObject) {

  const actionId = actionObject.actionId;
  const actionLabel = '_' + actionId;

  if (actionId === ACTION_SUSPECT || actionId === ACTION_TRUST) {
    // 「疑う」「信じる」
    // _{アクションID}_{判断基準}
    const decisionLabel = '_' + actionObject.decision;
    return actionLabel + decisionLabel;

  } else if (actionId === ACTION_REACTION) {
    // 「リアクション」
    // _{アクションID}_{トリガーアクションID}_{対象者への感情}
    const triggerActionLabel = '_' + triggerActionObject.actionId;
    // リアクションなので、トリガーアクションの対象者から実行者への感情を取得する
    const feelingLabel = '_' + getFeelingLabel(
      triggerActionObject.targetId,
      triggerActionObject.characterId
    );
    return actionLabel + triggerActionLabel + feelingLabel;
  }

  // 上記以外
  // _{アクションID}
  return actionLabel;
}


/**
 * characterIdのキャラクターが抱いている、対象者への感情を取得する
 * @param {String} characterId キャラクターID
 * @param {String} targetId 対象者のキャラクターID
 * @returns {String} {対象者への感情}
 */
function getFeelingLabel(characterId, targetId) {
  let characterObject = TYRANO.kag.stat.f.characterObjects[characterId];

  let sameFactionPossivility = calcSameFactionPossivility(
    characterObject,
    characterObject.perspective, // 発言は嘘をつくため、perspectiveを渡す
    [targetId]
  );

  return getFeeling(characterObject, sameFactionPossivility[targetId]);
}


/**
 * [m_doAction]実行時のキャラの立ち絵が登場するsideを判定、返却する。
 * MEMO アクションやカウンターアクションが増えてきたらより詳細に実装する
 * @param {Action} actionObject アクションオブジェクト
 * @param {Action} triggerActionObject トリガーアクションオブジェクト
 * @returns {String} 'left'または'right'
 */
function getSideForDoAction(actionObject, triggerActionObject) {

  const actionId = actionObject.actionId;

  if (actionId === ACTION_SUSPECT || actionId === ACTION_TRUST) {
    // 「疑う」「信じる」
    return 'left';

  }

  // 上記以外
  return 'right';
}
