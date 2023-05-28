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
