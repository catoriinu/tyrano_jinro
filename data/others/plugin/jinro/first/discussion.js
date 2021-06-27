/**
 * そのキャラクターが、役職COを実行刷る可能性があるかを返す
 * NOTE:視点オブジェクトを利用した仕組みに変えるべきなため、廃止したい。
 * @param {String} characterId キャラクターID
 * @returns {Array} [{Number}最終確率, {Boolean}判定結果]
 */
function isCOMyRoll(characterId) {
  // キャラクターオブジェクトを取得する
  const characterObject = TYRANO_VAR_F.characterObjects[characterId];

  // COする可能性がある役職についているか
  if (characterObject.role.roleId in characterObject.personality.roleCOProbability) {
    // randomDecide()に判定させた結果配列を返す
    return randomDecide(characterObject.personality.roleCOProbability[characterObject.role.roleId][ROLE_ID_FORTUNE_TELLER]);
  } else {
    // COの無い役職の場合は、randomDecide()と同じデータ形式で絶対にCOしないようなレスポンスを返却する
    return [0, false];
  }
}


/**
 * 与えられた確率や範囲を元に、trueを返却するか判断する
 * @param {Number} probability 元のtrueになる確率(%)
 * @param {Number} min 確率の最低保証(%)
 * @param {Number} max 確率の最高保証(%)
 * @param {Number} randomRange ランダム補正値(%)
 * @returns {Array} [{Number}最終確率, {Boolean}判定結果]
 */
function randomDecide(probability, min = 0, max = 100, randomRange = 0) {
  
  // randomRangeの範囲でprobabilityをランダムに変動させる
  let resultProbability = probability;
  if (randomRange != 0) {
    const RandomMin = probability - (randomRange / 2);
    const RandomMax = probability + (randomRange / 2);
    resultProbability = Math.floor( Math.random() * (RandomMax + 1 - RandomMin) ) + RandomMin;
  }
  
  // resultProbabilityを指定された保証値の範囲に収める
  if (resultProbability > max) {
    resultProbability = max;
  } else if (resultProbability < min) {
    resultProbability = min;
  }
  
  // resultProbability(%)の確率でtrueを返す。resultProbability自体も判定用に返す。
  const result = Math.random() < resultProbability / 100;
  console.log('確率:' + resultProbability + ' 判定結果:' + result);
  return [resultProbability, result];
}


/**
 * 0確定メソッド
 * 視点オブジェクト内の、指定されたキャラクターの役職の可能性を0で確定していく
 * 0確定したことにより連鎖して別のキャラクターの役職が0確定する場合、このメソッドを再帰呼び出しする
 * @param {Object} perspective 視点オブジェクト
 * @param {String} characterId キャラクターID
 * @param {Array} zeroRoleIds 可能性が0で確定した役職IDの配列
 * @param {Array} distributeCharacterIds 最後に未確定役職の割合で分配する対象となるキャラクターID配列
 * @returns {Array} [再計算された視点オブジェクト, 正規化対象にならなかったため分配対象となるキャラクターID配列]
 */
function zeronize(perspective, characterId, zeroRoleIds, distributeCharacterIds) {
  
  // 0確定配列の役職が、そのキャラクターがすでに0確定している役職にすべて含まれているなら、無駄なzeronizeとなってしまうため即returnする
  // 「視点の全役職を縦に確認」中に無駄にzereonizeしがち
  // NOTE: organizePerspective()の最初のoriginalZeroRoleIds.filter()とは違い、0確定役職を抽出はしない。再帰呼び出し中に抽出するのはまずいケースがありそうなので。
  // が、もしまずくないと判明したらここで抽出をするのがよさそう。今後の課題。
  const alreadyZeroRoleIds = Object.keys(perspective[characterId]).filter(roleId => perspective[characterId][roleId] == 0);
  const noNeedZeronize = zeroRoleIds.every( function (zeroRoleId) {
    return alreadyZeroRoleIds.includes(zeroRoleId);
  });
  if (noNeedZeronize) return [perspective, distributeCharacterIds];
  
  // 指定されたキャラクターの、指定された役職の割合を0確定する
  let sumRolesValue = 0;
  for (let roleId of Object.keys(perspective[characterId])) {
    if (zeroRoleIds.includes(roleId)) {
      perspective[characterId][roleId] = 0;
      continue;
    }
    sumRolesValue += perspective[characterId][roleId];
  }
  
  // 全役職の割合の合計が0になった場合は破綻とし、例外をthrowする
  if (sumRolesValue == 0) {
    throw new Error('zeronize error. all roles are 0.');
  }
  
  console.log('start zeronize');
  console.log(perspective);
  console.log(characterId);
  console.log(zeroRoleIds);
  
  // そのキャラクター内の役職ごとの割合を正規化
  for (let roleId of Object.keys(perspective[characterId])) {
    
    // 割合の合計に占める、現在の割合の比を入れる
    perspective[characterId][roleId] /= sumRolesValue;
    
    // 正規化の結果が1、すなわち役職が1つに確定した場合
    if (perspective[characterId][roleId] == 1) {
      
      // すでにその役職に未確定の枠が存在しない場合は破綻とし、例外をthrowする
      if (perspective.uncertified[roleId] < 1) {
        throw new Error('zeronize error. this role was certified : ' + roleId);
      }
      
      // その役職の未確定の枠を1減らす
      perspective.uncertified[roleId] -= 1;
      
      // それによってその役職の枠が全て確定した場合
      if (perspective.uncertified[roleId] == 0) {
        // その役職が未確定だったキャラクターについて、その役職を0確定する
        // 単に0を入れるのでは0確定が連鎖するケースに対応できないため、必ずこのメソッド自身を再帰呼び出しして0確定すること
        for (let cId of Object.keys(perspective)) {
          if (cId == 'uncertified') continue;
          if (0 < perspective[cId][roleId] && perspective[cId][roleId] < 1) {
            [perspective, distributeCharacterIds] = zeronize(perspective, cId, [roleId], distributeCharacterIds);
          }
        }
      }
      
      // 役職確定したキャラクターの残りの役職配列の割合は全て0なので、早期break
      break;
    }
  }
  
  // 視点の全役職を縦に確認し、「役職の未確定数が残っており、（あるキャラ以外は0か1になっており）あるキャラがその役職で確定する」状態だった場合に、
  // そのキャラの他に未確定状態の役職をzeronize()する。
  // ex: 村人視点で、CO者が3人出たあと、残るもうひとりは村人確定するため、[f,m,w]でzeronize()が必要。
  for (let roleId of Object.keys(perspective.uncertified)) {
    
    if (perspective.uncertified[roleId] > 0) {
      //console.log('縦に確認 : ' + roleId);
      let uncertifiedCharacterIds = [];
      for (let characterId of Object.keys(perspective)) {
        if (characterId == 'uncertified') continue;
        if (0 < perspective[characterId][roleId] && perspective[characterId][roleId] < 1) {
          uncertifiedCharacterIds.push(characterId);
        }
      }
      //console.log(uncertifiedCharacterIds);
      //console.log(perspective.uncertified[roleId]);
      if (uncertifiedCharacterIds.length == perspective.uncertified[roleId]) {
        let noOtherCandidatesRoleIds = Object.keys(perspective.uncertified).filter(rId => rId != roleId);
        for (let i = 0; i < uncertifiedCharacterIds.length; i++) {
          [perspective, distributeCharacterIds] = zeronize(perspective, uncertifiedCharacterIds[i], noOtherCandidatesRoleIds, distributeCharacterIds);
        }
      }
    }
  }
  
  // 0確定処理の中でそのキャラクター内の役職の割合の正規化が済んだため、未確定役職の割合で分配する対象配列から削除する
  distributeCharacterIds = distributeCharacterIds.filter(cId => (cId != characterId));
  
  return [perspective, distributeCharacterIds];
}


/**
 * 視点整理メソッド
 * 「あるキャラクターについて、可能性が0で確定した役職の配列」を与えることで、視点オブジェクト内の各キャラ各役職の割合を再計算する。
 *  呼び元で視点オブジェクトのcloneは不要。
 *  計算だけしたい場合は、呼び元で戻り値の視点オブジェクトを受け取って上書きしなければよい。
 * @param {Object} originalPerspective 元の視点オブジェクト
 * @param {String} characterId キャラクターID
 * @param {Array} originalZeroRoleIds 可能性が0で確定した役職IDの配列
 * @returns 再計算された視点オブジェクト
 */
function organizePerspective(originalPerspective, characterId, originalZeroRoleIds) {
  
  // 0確定対象のキャラの中で、0確定させる必要がある役職だけを抽出する（すでに0確定の役職は削除）
  // この処理はzeronize()内で実行してはいけない。再帰的な0確定処理が中途半端に止まってしまうため。
  let zeroRoleIds = originalZeroRoleIds.filter(roleId => originalPerspective[characterId][roleId] > 0);
  // 0確定させる必要がある役職がない場合は、何もせず終了
  if (zeroRoleIds.length == 0) return originalPerspective;
  
  // zeronize()に参照渡しをして書き換えてられてしまうのを防ぐために、視点オブジェクトをcloneする。
  // 書き換えたperspectiveを取得する目的の場合は、呼び元でreturnを受け取って上書きすること。
  let perspective = clone(originalPerspective);
  
  // 0確定処理の後に未確定役職の割合で分配する対象となるキャラクターID配列を準備する。0確定処理の中で正規化を行ったキャラクターは、順次対象から外していく
  let distributeCharacterIds = Object.keys(perspective).filter( function (cId) {
    if (cId == 'uncertified') return false;
    // 役職が確定しているキャラクターは対象外
    for (let roleId of Object.keys(perspective[cId])) {
      if (perspective[cId][roleId] == 1) return false;
    }
    return true;
  });
  
  // 指定のキャラの指定の役職の割合を0確定する。それによって別のキャラの役職の割合が0確定した場合、続けて0確定していく
  [perspective, distributeCharacterIds] = zeronize(perspective, characterId, zeroRoleIds, distributeCharacterIds);
  
  // 役職未確定のキャラクターの役職ごとの割合を、そのキャラに可能性の残っている未確定役職数をもとに分配する
  for (let i = 0; i < distributeCharacterIds.length; i++) {
    let sumUncertifiedValue = 0;
    for (let roleId of Object.keys(perspective.uncertified)) {
      if (perspective[distributeCharacterIds[i]][roleId] > 0){
        sumUncertifiedValue += perspective.uncertified[roleId];
      }
    }
    
    for (let roleId of Object.keys(perspective[distributeCharacterIds[i]])) {
      // 可能性が0の役職は更新しない
      if (perspective[distributeCharacterIds[i]][roleId] == 0) continue;
      perspective[distributeCharacterIds[i]][roleId] = perspective.uncertified[roleId] / sumUncertifiedValue;
    }
  }
  
  console.log('result organizePerspective');
  console.log(perspective);
  
  return perspective;
}


/**
 * 合法報告生成メソッド
 * 合法報告（「COしない」を除く、自分が破綻しない報告（占い師想定だが、取得するhistoryを変えれば霊能にも使えるはず））のパターンを返却する。
 * @param {Array} candidateIdList 占い候補のキャラクターID配列
 * @param {Object} perspective 視点オブジェクト（書き換えは行われない）
 * @returns {Array} 合法報告オブジェクトの配列。[{characterId, 占い結果(t:●/f:○), 報告後の視点オブジェクト}, ...]
 */
function generateRegalAnnouncements(candidateIdList, perspective) {
  
  let regalAnnouncements = [];
  const boolArray = [true, false];
  for (let i = 0; i < candidateIdList.length; i++) {
    
    // true: ●判定 false:○判定 の両方で合法報告かを確認する
    for (let j = 0; j < boolArray.length; j++) {
      // 合法報告であれば配列に追加し、破綻する報告であれば例外をキャッチする
      try {
        regalAnnouncements.push(
          {
            characterId: candidateIdList[i],
            result: boolArray[j],
            perspective: organizePerspective(perspective, candidateIdList[i], getRoleIdsForOrganizePerspective(boolArray[j]))
          }
        );
      } catch (zeronizeError) {
        console.log('zeronizeError : ' + candidateIdList[i] + ' is ' + boolArray[j]);
        continue;
      }
    }
  }
  
  console.log('regalAnnouncements');
  console.log(regalAnnouncements);
  return regalAnnouncements;
}


/**
 * 視点整理メソッドのzeroRoleIdsに渡すための役職配列を取得する。
 * ●判定：人狼である　＝人狼以外の割合を0にする
 * ○判定：人狼ではない＝人狼の割合を0にする
 * TODO：村役職と合わせること。正確にやるなら、今回の村役職を全て回して、isWerewolvesがあるかを確認していくべき。
 * @param {boolern} color true:●判定 false:○判定
 * @returns {Array} zeroRoleIds
 */
function getRoleIdsForOrganizePerspective(color) {
  return color ? [ROLE_ID_VILLAGER, ROLE_ID_FORTUNE_TELLER, ROLE_ID_MADMAN] : [ROLE_ID_WEREWOLF];
}