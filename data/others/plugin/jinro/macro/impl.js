/**
 * m_changeCharacterの実体メソッド
 * キャラクターを、発言者に合わせて切り替える
 * キャラの表示位置は、PC：画面左側、NPC：画面右側とする。同じ側には一人しか出ない（ので、例えばNPC1が右側にいるときNPC2が喋る場合、NPC1が退場してからNPC2が登場する）
 * すでにそのキャラがchara_newで登録,およびその表情がchara_faceで登録済みである前提とする。
 * @param characterId 登場させたいキャラのキャラクターID。必須。
 * @param face 登場させたいキャラのface。（TODO：なければ現在のfaceのまま）
 */
function changeCharacter(characterId, face) {

  console.log('changeCharacter:' + characterId);
  if (TYRANO_VAR_F.characterObjects[characterId].characterId == TYRANO_VAR_F.playerCharacterId) {
    // 左側のキャラクター
    // 左側にはPCしか登場しないため退場処理はなし（NOTE：左側にも別のキャラが登場するようにするなら、右側と同じように退場処理を入れる）
    if (TYRANO_VAR_F.leftSideCharacterId == characterId) {
      // 登場させたいキャラがすでに登場しているなら、表情変更のみ
      // TODO：同じ表情の場合どうなる？
      // [chara_mod name="&mp.characterId" face="&mp.face" time="500" wait="false"]
      TYRANO.kag.ftag.startTag("chara_mod",{name:characterId,face:face,time:500,wait:false});
    } else {
      // 登場させたいキャラがまだ登場していないなら、登場させる
      enterCharacter(characterId, face);
    }
  } else {
    // 右側のキャラクター
    // すでに右側にキャラが登場しており、それが登場させたいキャラと違うなら、右側のキャラを退場させる
    if (typeof TYRANO_VAR_F.rightSideCharacterId !== 'undefined' && TYRANO_VAR_F.rightSideCharacterId != characterId) {
      exitCharacter(TYRANO_VAR_F.rightSideCharacterId);
    }

    if (TYRANO_VAR_F.rightSideCharacterId == characterId) {
      // 登場させたいキャラがすでに登場しているなら、表情変更のみ
      // TODO：同じ表情の場合どうなる？
      // [chara_mod name="&mp.characterId" face="&mp.face" time="500" wait="false"]
      TYRANO.kag.ftag.startTag("chara_mod",{name:characterId,face:face,time:500,wait:false});
    } else {
      // 登場させたいキャラがまだ登場していないなら、登場させる
      enterCharacter(characterId, face);
    }
  }
}


/**
 * m_enterCharacterの実体メソッド
 * 現在は登場していないキャラを登場させる
 * @param characterId 登場させたいキャラのキャラクターID。必須。
 * @param face 登場させたいキャラのface。必須。（TODO：なければ現在のfaceのままにしてもいいかも）
 */
function enterCharacter(characterId, face) {
  console.log('enter ' + characterId);
  if (characterId == TYRANO_VAR_F.playerCharacterId) {
    // PCなら画面左から左側にスライドしてくる。左側の変数をキャラクターIDに更新
    // [chara_move name="&mp.characterId" time="600" anim="true" left="+=1000" wait="false" effect="easeOutExpo"]
    TYRANO.kag.ftag.startTag("chara_move",{
      name:characterId,
      time:600,
      anim:"true",
      left:"+=1000",
      wait:"false",
      effect:"easeOutExpo"
    });
    TYRANO_VAR_F.leftSideCharacterId = characterId;
  } else {
    // NPCなら画面右から右側にスライドしてくる。右側の変数をキャラクターIDに更新
    // [chara_move name="&mp.characterId" time="600" anim="true" left="-=1000" wait="false" effect="easeOutExpo"]
    TYRANO.kag.ftag.startTag("chara_move",{
      name:characterId,
      time:600,
      anim:"true",
      left:"-=1000",
      wait:"false",
      effect:"easeOutExpo"
    });
    TYRANO_VAR_F.rightSideCharacterId = characterId;
  }
}


/**
 * 退場マクロ
 * 現在登場しているキャラを退場させる
 * TODO 襲撃死時とPCの処刑時の呼び出しで、フェードアウトしない。NPCの処刑時はする。ここというより、呼び出し元の処理順が問題かも。
 * @param characterId 退場させたいキャラのキャラクターID。必須。
 */
function exitCharacter(characterId) {
  // TODO enterしたぶん元に戻すというより、「そのキャラのデフォルトの位置に戻す」にすべき。そうすると、デフォルトの位置をjs内か変数内に持っておく必要があるが……。
  console.log('exit '+ characterId);
  if (characterId == TYRANO_VAR_F.playerCharacterId) {
    TYRANO.kag.ftag.startTag("chara_move",{
      name:characterId,
      time:600,
      left:"-=1000",
      wait:"false",
    });
    TYRANO_VAR_F.leftSideCharacterId = undefined;
  } else {
    TYRANO.kag.ftag.startTag("chara_move",{
      name:characterId,
      time:600,
      left:"+=1000",
      wait:"false",
    });
    TYRANO_VAR_F.rightSideCharacterId = undefined;
  }
}
