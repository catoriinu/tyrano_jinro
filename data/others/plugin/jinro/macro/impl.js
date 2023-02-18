/**
 * m_changeCharacterの実体メソッド
 * キャラクターを、発言者に合わせて切り替える
 * キャラの表示位置は、PC：画面左側、NPC：画面右側とする。同じ側には一人しか出ない（ので、例えばNPC1が右側にいるときNPC2が喋る場合、NPC1が退場してからNPC2が登場する）
 * すでにそのキャラがchara_newで登録,およびその表情がchara_faceで登録済みである前提とする。
 * @param characterId 登場させたいキャラのキャラクターID。必須。
 * @param face 登場させたいキャラのface。（TODO：なければ現在のfaceのまま）
 * @param side 画面内にキャラが登場する位置。right/leftの指定必須。
 */
function changeCharacter(characterId, face, side) {

  if (side == 'right') {
    // 右側のキャラクター
    // すでに右側にキャラが登場しており、それが登場させたいキャラと違うなら、右側のキャラを退場させる
    if (typeof TYRANO.kag.stat.f.rightSideCharacterId != 'undefined' && TYRANO.kag.stat.f.rightSideCharacterId != characterId) {
      exitCharacter(
        TYRANO.kag.stat.f.rightSideCharacterId,
        TYRANO.kag.stat.f.defaultPosition[TYRANO.kag.stat.f.rightSideCharacterId].side,
        TYRANO.kag.stat.f.defaultPosition[TYRANO.kag.stat.f.rightSideCharacterId].left
      );
    }

    if (TYRANO.kag.stat.f.rightSideCharacterId == characterId) {
      // 登場させたいキャラがすでに登場しているなら、表情変更のみ
      // TODO：同じ表情の場合どうなる？
      // [chara_mod name="&mp.characterId" face="&mp.face" time="500" wait="false"]
      TYRANO.kag.ftag.startTag("chara_mod",{name:characterId, face:face, time:500, wait:false});
    } else {
      // 登場させたいキャラがまだ登場していないなら、登場させる
      enterCharacter(characterId, face, side);
    }

  } else if (side == 'left') {
    // 左側のキャラクター
    // 左側にはPCしか登場しないため退場処理はなし（NOTE：左側にも別のキャラが登場するようにするなら、右側と同じように退場処理を入れる）
    if (TYRANO.kag.stat.f.leftSideCharacterId == characterId) {
      // 登場させたいキャラがすでに登場しているなら、表情変更のみ
      // TODO：同じ表情の場合どうなる？
      // [chara_mod name="&mp.characterId" face="&mp.face" time="500" wait="false"]
      TYRANO.kag.ftag.startTag("chara_mod",{name:characterId, face:face, time:500, wait:false});
    } else {
      // 登場させたいキャラがまだ登場していないなら、登場させる
      enterCharacter(characterId, face, side);
    }
  }
}


/**
 * m_enterCharacterの実体メソッド
 * 現在は登場していないキャラを登場させる
 * @param characterId 登場させたいキャラのキャラクターID。必須。
 * @param face 登場させたいキャラのface。必須。（TODO：なければ現在のfaceのままにしてもいいかも）
 * @param side 画面内にキャラが登場する位置。right/leftの指定必須。
 */
function enterCharacter(characterId, face, side) {
  console.log('★enter ' + characterId);

  // キャラクター画像の移動量と、登場させるキャラクターのsideの変数にキャラクターIDを格納する
  let moveLeft = '';
  if (side == 'right') {
    moveLeft = '-=1000';
    TYRANO.kag.stat.f.rightSideCharacterId = characterId;
  } else if (side == 'left') {
    moveLeft = '+=1000';
    TYRANO.kag.stat.f.leftSideCharacterId = characterId;
  }

  // sideがrightなら画面右から右側に、leftなら画面左から左側にスライドインしてくる
  // [chara_move name="&mp.characterId" time="600" anim="true" left="{moveLeft}" wait="false" effect="easeOutExpo"]
  TYRANO.kag.ftag.startTag("chara_move",{
    name:characterId,
    time:600,
    anim:"true",
    left:moveLeft,
    wait:"false",
    effect:"easeOutExpo"
  });
}


/**
 * 退場マクロ
 * 現在登場しているキャラを退場させる
 * TODO 襲撃死時とPCの処刑時の呼び出しで、フェードアウトしない。NPCの処刑時はする。ここというより、呼び出し元の処理順が問題かも。
 * @param characterId 退場させたいキャラのキャラクターID。必須。
 * @param side 画面内にキャラが登場している位置。right/leftの指定必須。
 * @param left 退場させたいキャラのleftの移動先。デフォルト座標のleftを指定すること。必須。
 */
function exitCharacter(characterId, side, left) {

  // 退場させるキャラクターのsideの変数を初期化する
  if (side == 'right') {
    // 現在登場していないなら初期化しないで終了
    if (TYRANO.kag.stat.f.rightSideCharacterId != characterId) return;
    TYRANO.kag.stat.f.rightSideCharacterId = undefined;
  } else if (side == 'left') {
    // 現在登場していないなら初期化しないで終了
    if (TYRANO.kag.stat.f.leftSideCharacterId != characterId) return;
    TYRANO.kag.stat.f.leftSideCharacterId = undefined;
  }

  console.log('★exit ' + characterId);

  TYRANO.kag.ftag.startTag("chara_move",{
    name:characterId,
    time:600,
    left:left,
    wait:"false",
  });
}
