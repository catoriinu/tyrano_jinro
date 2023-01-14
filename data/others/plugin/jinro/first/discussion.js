/**
 * そのキャラクターが、役職COを実行する可能性があるかを返す
 * NOTE:視点オブジェクトを利用した仕組みに変えるべきなため、廃止したい。
 * @param {String} characterId キャラクターID
 * @returns {Array} [{Number}最終確率, {Boolean}判定結果]
 */
function isCOMyRoll(characterId) {
  // キャラクターオブジェクトを取得する
  const characterObject = TYRANO.kag.stat.f.characterObjects[characterId];

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
 * @param {Number} originalProbability 元のtrueになる確率(0～1)
 * @param {Number} randomRange ランダム補正値（TODO）
 * @returns {Array} [{Number}最終確率, {Boolean}判定結果]
 */
function randomDecide(originalProbability, randomRange = 0) {
  
  let probability = originalProbability;

  // randomRangeの範囲でprobabilityをランダムに変動させる
  // TODO probabilityが0～100だったときの実装のまま。利用箇所ができたときに修正する
  if (randomRange != 0) {
    const RandomMin = originalProbability - (randomRange / 2);
    const RandomMax = originalProbability + (randomRange / 2);
    probability = Math.floor( Math.random() * (RandomMax + 1 - RandomMin) ) + RandomMin;
  }
  
  // probabilityを0～1の範囲に収める
  if (probability > 1) {
    probability = 1;
  } else if (probability < 0) {
    probability = 0;
  }
  
  // probabilityの確率でtrueを返す。判定時の乱数も呼び元で優先度を判定するために返す。
  const randomValue = Math.random();
  const result = randomValue < probability;
  console.log('判定結果:' + result + ' 元の確率:' + probability + ' 判定時の乱数:' + randomValue);
  return [randomValue, result];
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
  // ここで破綻した場合はErrorをthrowする
  [perspective, distributeCharacterIds] = zeronize(perspective, characterId, zeroRoleIds, distributeCharacterIds);
  
  // 役職未確定のキャラクターの役職ごとの割合を、そのキャラに可能性の残っている未確定役職数をもとに分配する
  for (let i = 0; i < distributeCharacterIds.length; i++) {
    let sumUncertifiedValue = 0;
    for (let roleId of Object.keys(perspective.uncertified)) {
      if (perspective[distributeCharacterIds[i]][roleId] > 0) {
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


function updateCommonPerspective(characterId, zeroRoleIds) {
  console.log('j_updateCommonPerspective');
  // 共通視点オブジェクトを更新する
  console.log('【共通視点】');
  try {
    TYRANO.kag.stat.f.commonPerspective = organizePerspective(TYRANO.kag.stat.f.commonPerspective, characterId, zeroRoleIds);
  } catch (error) {
    console.log('共通視点オブジェクトが破綻しました美味しい水そうめん');
    console.log(characterId);
    console.log(zeroRoleIds);
    console.log(TYRANO.kag.stat.f.commonPerspective);
    alert('共通視点オブジェクトが破綻しました美味しい水そうめん');
    return;
  }

  // 各キャラの視点オブジェクトも更新する
  for (let cId of Object.keys(TYRANO.kag.stat.f.characterObjects)) {
    console.log('【' + cId + 'の視点】');
    console.log(TYRANO.kag.stat.f.characterObjects[cId].perspective);
    
    try {
      TYRANO.kag.stat.f.characterObjects[cId].perspective = organizePerspective(TYRANO.kag.stat.f.characterObjects[cId].perspective, characterId, zeroRoleIds);
      TYRANO.kag.stat.f.characterObjects[cId].role.rolePerspective = organizePerspective(TYRANO.kag.stat.f.characterObjects[cId].role.rolePerspective, characterId, zeroRoleIds);
    } catch (error) {
      if (TYRANO.kag.stat.f.developmentMode) {
        alert(cId + 'の視点が破綻しました！');
      }
      // 破綻フラグを立てる
      TYRANO.kag.stat.f.characterObjects[cId].isContradicted = true;
      // ここで破綻したら、共通視点オブジェクトで上書きする&自分自身を嘘がつける役職（TODO:「嘘をつかない役職配列」をメソッドで取り出せるようにする）だったということで確定する。
      // （試しに）updateCommonPerspectiveを再帰呼び出しして共通および全員の視点オブジェクトを更新する
      TYRANO.kag.stat.f.characterObjects[cId].perspective = clone(TYRANO.kag.stat.f.commonPerspective);
      TYRANO.kag.stat.f.characterObjects[cId].role.rolePerspective= clone(TYRANO.kag.stat.f.commonPerspective);
      updateCommonPerspective(cId, [ROLE_ID_VILLAGER, ROLE_ID_FORTUNE_TELLER]);
    }
  }
}


/**
 * 投票先を投票履歴オブジェクトに格納する
 * @param {Array} characterObjects キャラクターオブジェクト配列。このメソッド内でvoteHistoryを更新する。
 * @param {Number} day 投票実行日
 */
function decideVote(characterObjects, day) {
  // 先に、投票時点での仲間度オブジェクトを生成する
  for (let characterId of Object.keys(characterObjects)) {
    // TODO:直後の処理と共通化できればする
    // プレイヤーは別の処理で投票先を決める
    if (characterObjects[characterId].isPlayer) continue;
    // 死亡済みキャラは投票を行わない
    if (!characterObjects[characterId].isAlive) continue;

    // rolePerspectiveをもとに仲間度を決める（役職騙り中の人狼や狂人も自分の役職の視点オブジェクトで判定する。投票は嘘をつかないということ）
    characterObjects[characterId].sameFactionPossivility = calcSameFactionPossivility(
      characterObjects[characterId],
      characterObjects[characterId].role.rolePerspective
    );
  }

  for (let characterId of Object.keys(characterObjects)) {
    // プレイヤーは別の処理で投票先を決める
    if (characterObjects[characterId].isPlayer) continue;
    // 死亡済みキャラは投票を行わない
    if (!characterObjects[characterId].isAlive) continue;

    // TODO 各キャラは各役職ごとのロジックと、仲間度を元に投票先を決定していく
    // 仮に仲間度のみをもとに投票先を決定する
    let voteCandidates = [];
    let voteSameFactionPossivility = 100; // 十分に大きい値を入れておき、1人でも投票候補配列に入るようにする
    for (let cId of Object.keys(characterObjects[characterId].sameFactionPossivility)) {
      // 自分自身は投票対象外
      if (characterObjects[characterId].characterId == cId) continue;
      // 死亡済みキャラも投票対象外
      if (!characterObjects[cId].isAlive) continue;
      // そのキャラの仲間度が現在最小の仲間度より高ければ投票対象外
      if (characterObjects[characterId].sameFactionPossivility[cId] > voteSameFactionPossivility) continue;

      // そのキャラの仲間度が現在最小の仲間度より低ければ投票候補配列を上書く
      if (characterObjects[characterId].sameFactionPossivility[cId] < voteSameFactionPossivility) {
        voteCandidates = [cId];
        voteSameFactionPossivility = characterObjects[characterId].sameFactionPossivility[cId];
      } else {
        // 現在最小の仲間度と同値なら投票候補配列に追加する
        voteCandidates.push(cId);
      }
    }

    let voteTargetId = '';
    if (voteCandidates.length == 1) {
      // 投票候補者が1人ならそのまま確定
      voteTargetId = voteCandidates[0];
    } else if (voteCandidates.length == 0) {
      alert('投票候補者がいません：' + characterObjects[characterId].characterId);
    } else {
      // 投票候補者が複数いるならランダムに選ぶ
      voteTargetId = voteCandidates[Math.floor(Math.random() * voteCandidates.length)]
    }

    // 投票対象者をその日の投票履歴に格納する
    characterObjects[characterId].voteHistory[day] = pushElement(characterObjects[characterId].voteHistory[day], voteTargetId);
    TYRANO.kag.stat.f.characterObjects = characterObjects;
    //console.log('【voteHistory】');
    //console.log(characterId);
    //console.log(characterObjects[characterId].voteHistory);
  }
}


/**
 * 仲間度オブジェクトを生成する
 * @param {Object} characterObject キャラクターオブジェクト
 * @param {Object} perspective 視点オブジェクト（perspectiveを使うか、rolePerspectiveを使うかは呼び元に任せる）
 * @param {Array} characterIdList 仲間度を取得したいキャラクターIDリスト。省略した場合全員分取得する。
 * @return {Object} sameFactionPossivility 仲間度オブジェクト {characterId:仲間度,...}
 */
function calcSameFactionPossivility(characterObject, perspective, characterIdList = TYRANO.kag.stat.f.participantsIdList) {

  let sameFactionPossivility = {};
  for (let i = 0; i < characterIdList.length; i++) {
    let cId = characterIdList[i];
    // 自分自身は1で確定
    if (characterObject.characterId == cId) {
      sameFactionPossivility[cId] = 1;
      continue;
    }

    let sumSameFactionPerspective = 0;
    // 全役職をループ
    for (let rId of Object.keys(perspective[cId])) {
      // 自分と同陣営の役職のperspectiveの割合値を合計する（自分視点で必ず同陣営なら1、必ず敵陣営なら0になる）
      if (ROLE_ID_TO_FACTION[rId] == ROLE_ID_TO_FACTION[characterObject.role.roleId]) {
        sumSameFactionPerspective += perspective[cId][rId];
      }
    }
    
    // 対象キャラへの仲間度を算出する
    // その際、自分の論理力の高さによって、対象キャラへの信頼度と同陣営割合値の合計のどちらに重きを置くかを決める
    // →論理力が低いほど、対象キャラへの信頼度が「仲間度」になる（＝感情的な判断）
    //  論理力が高いほど、同陣営割合値の合計が「仲間度」になる（＝論理的な判断）
    // MEMO:信頼度と同陣営割合値は、本来は単純に足せばよい値ではない。役職や陣営が増えたり、ゲーム上で信頼度が増減するようになったあと、計算方法を再検討すること
    sameFactionPossivility[cId] = (1 - characterObject.personality.logical) * characterObject.reliability[cId] +
                                  characterObject.personality.logical       * sumSameFactionPerspective;
  }
  return sameFactionPossivility;
}


/**
 * キャラクターオブジェクト内の投票履歴オブジェクトを元に、その日の処刑先を決める
 * @param {Array} characterObjects キャラクターオブジェクト配列
 * @param {Number} day 投票実行日
 */
function countVote(characterObjects, day) {

  // 投票結果オブジェクトを初期化（0票だったキャラはキー自体入らないままとなる）
  TYRANO.kag.stat.f.voteResult = {};
  for (let characterId of Object.keys(characterObjects)) {
    // 投票履歴オブジェクトのその日の投票先配列を確認
    // 配列でなければ、投票していないのでスルー
    if (!Array.isArray(characterObjects[characterId].voteHistory[day])) continue;

    // 末尾のキャラクターIDを取得（最新の再投票先は末尾に追加されているため）
    let voteTargetId = characterObjects[characterId].voteHistory[day].slice(-1)[0];
    // 1票追加
    if (voteTargetId in TYRANO.kag.stat.f.voteResult) {
      TYRANO.kag.stat.f.voteResult[voteTargetId]++;
    } else {
      TYRANO.kag.stat.f.voteResult[voteTargetId] = 1;
    }

    // 投票されたキャラクターの、投票したキャラクターへの信頼度を下げる
    characterObjects[voteTargetId].reliability[characterId] = calcUpdatedReliability(
      characterObjects[voteTargetId],
      characterId,
      REASON_WAS_VOTED
    );
  }

  // 最多得票者のキャラクターIDを配列に格納
  TYRANO.kag.stat.f.electedIdList = getMaxKeys(TYRANO.kag.stat.f.voteResult);
  // 最多得票者が1人で確定すれば、処刑を実行する（同票なら要素が複数入っているので再投票）
  TYRANO.kag.stat.f.doExecute = (TYRANO.kag.stat.f.electedIdList.length == 1) ? true : false;
};

  // TODO ここまでのロジックだけだと、再投票でも同じ結果になりうる。
  // 再投票前に「自分に投票したキャラの信頼度をガクッと下げる」「仲間が投票したキャラの信頼度を下げる」「自分と同じ投票先に投票したキャラの信頼度を上げる」などはどうか。


/**
 * 票を公開するためのメッセージを作成する
 * @param {Array} characterObjects キャラクターオブジェクト配列
 * @param {Number} day 開票日
 * @param {Object} voteResult 投票結果オブジェクト
 * @param {Array} electedIdList 最多得票者配列
 */
function openVote(characterObjects, day, voteResult, electedIdList) {
  TYRANO.kag.stat.f.voteResultMessage = '';

  for (let i = 0; i < TYRANO.kag.stat.f.participantsIdList.length; i++) {
    let characterId = TYRANO.kag.stat.f.participantsIdList[i];

    let isElected = electedIdList.includes(characterId) ? '★' : '';
    let numbers = displayIsElected(characterId, voteResult);
    let name = characterObjects[characterId].name;
    let voteTargetName = displayVoteTargetName(characterId, characterObjects, day);

    TYRANO.kag.stat.f.voteResultMessage += (
      isElected + '' + 
      numbers + '　' + 
      name + '→' + 
      voteTargetName + ' / '
    )
  }
   // TODO:改行できるようにする。無理やりJS内でやるのではなく、ksファイルに戻って出力させた方が楽かも
   // あと、通常のメッセージ枠に出力ではなく、専用のレイヤーに出力するなどしないと、人数が多いと行数が足りない。
}


/**
 * openVote()から呼び出す用
 * @param {*} characterId 
 * @param {*} voteResult 
 * @returns テキスト
 */
function displayIsElected(characterId, voteResult) {
  if (characterId in voteResult) {
    return voteResult[characterId] + '票';
  }
  return '0票';
}


/**
 * openVote()から呼び出す用
 * @param {*} characterId 
 * @param {*} characterObjects 
 * @param {*} day 
 * @returns テキスト
 */
function displayVoteTargetName(characterId, characterObjects, day) {
  // 配列でなければ、投票していない
  if (!Array.isArray(characterObjects[characterId].voteHistory[day])) return 'なし';
  // 末尾のキャラクターIDを取得（最新の再投票先は末尾に追加されているため）
  let voteTargetId = characterObjects[characterId].voteHistory[day].slice(-1)[0];
  return characterObjects[voteTargetId].name;
}


/**
 * 更新後の信頼度を計算、返却する
 * @param {Object} characterObject キャラクターオブジェクト
 * @param {String} targetCharacterId 信頼度を更新する相手
 * @param {String} reason どのような理由で信頼度を更新するのか
 * @returns {Number} updateTargetReliability 更新後の、相手の信頼度の値
 */
function calcUpdatedReliability(characterObject, targetCharacterId, reason) {

  // 更新前の、相手の信頼度の値
  let originalTargetReliability = characterObject.reliability[targetCharacterId];
  // 更新後の、相手の信頼度の値
  let updateTargetReliability = 0;
  // 信頼度に影響を与える理由リストのうち、今回計算に用いる理由とその値のオブジェクト
  let impressiveReasonObject = null;
  // MEMO:本当はnull合体演算子を使いたいが、ティラノのJSのバージョンが古くて未対応だった
  if (Object.keys(characterObject.personality.impressiveReasonList[reason]).length !== 0) {
    impressiveReasonObject = characterObject.personality.impressiveReasonList[reason];
  }

  // 信頼度に影響を与える理由をもとに、信頼度の更新差分を算出する
  if (impressiveReasonObject !== null) {
    if (impressiveReasonObject.arithmetic == ARITHMETIC_ADDITION) {
      // 加算
      updateTargetReliability = originalTargetReliability + impressiveReasonObject.value;
    } else if (impressiveReasonObject.arithmetic == ARITHMETIC_MULTIPLICATION) {
      // 乗算
      updateTargetReliability = originalTargetReliability * impressiveReasonObject.value;
    }
  } else {
    alert(characterObject.name  + 'のimpressiveReasonListに' + reason + 'が未定義です');
  }

  console.log(characterObject.name + 'の' + targetCharacterId + 'への信頼度を' + reason + 'のため、' +
    originalTargetReliability + 'から' + updateTargetReliability + 'に更新する');

  // 更新後の値が1より大きくなる場合は1に、0より小さくなる場合は0にする。信頼度が取りうる値は0～1のため
  if (updateTargetReliability > 1) {
    updateTargetReliability = 1;
  } else if (updateTargetReliability < 0) {
    updateTargetReliability = 0;
  }
  return updateTargetReliability;
}


/**
 * アクションオブジェクトクラス
 * @param {String} characterId アクション実行者のキャラクターID
 * @param {String} actionId 実行したアクションID
 * @param {String} targetId アクションの対象者のキャラクターID（対象をとらないアクションなら不要）
 * @param {Boolean} result TODO 占い等実行時の結果
 */
function Action (characterId, actionId, targetId = '', result = null) {
  this.characterId = characterId;
  this.actionId = actionId;
  this.targetId = targetId;
  this.result = result;
}



/**
 * アクション実行による、NPC全員の信頼度の更新を行う
 * @param {Array} characterObjects キャラクターオブジェクト配列（メソッド内で更新する）
 * @param {Object} actionObject アクションオブジェクト
 */
function updateReliabirityForAction(characterObjects, actionObject) {

  console.log('execute testUpdateReliabirity actionObject:');
  console.log(actionObject);
  for (let cId of Object.keys(characterObjects)) {

    // 死亡済みキャラクターはスキップ（プレイヤーはスキップしない。リアクションのために信頼度更新が必要なので）
    if (!characterObjects[cId].isAlive) continue;

    console.log('character:' + characterObjects[cId].name);

    if (actionObject.actionId == ACTION_SUSPECT) {
      updateReliabirityForSucpect(characterObjects, cId, actionObject);
    } else if (actionObject.actionId == ACTION_TRUST) {
      updateReliabirityForTrust(characterObjects, cId, actionObject);
    } else if (actionObject.actionId == ACTION_ASK) {
      // TODO
    }
    // TODO ここで占い、投票、破綻などの場合の信頼度更新も集約したい。
    // そのためには、占いや投票もアクションオブジェクトを流用する必要がありそう。

  }
}


/**
 * 「疑う」による信頼度更新を行う
 * @param {Array} characterObjects キャラクターオブジェクト配列（メソッド内で更新する）
 * @param {String} cId 信頼度更新を行うキャラクターID
 * @param {Object} actionObject 実行されたアクションオブジェクト
 */
function updateReliabirityForSucpect(characterObjects, cId, actionObject) {

  // キャラクター自身がそのアクションで受ける影響の情報
  const impressiveReason = characterObjects[cId].personality.impressiveReasonList[actionObject.actionId];

  if (cId == actionObject.characterId) {
    console.log('疑ったキャラである場合' + actionObject.targetId + 'への信頼度を下げる');
    // 疑ったキャラである場合
    // 疑われたキャラへの信頼度を下げる
    characterObjects[cId].reliability[actionObject.targetId] = testCalcUpdatedReliability(
      characterObjects[cId].reliability[actionObject.targetId],
      impressiveReason,
      false,
      0.3
    );

  } else if (cId == actionObject.targetId) {
    console.log('疑われたキャラである場合' + actionObject.characterId + 'への信頼度を下げる');
    // 疑われたキャラである場合
    // 疑ったキャラへの信頼度を下げる
    characterObjects[cId].reliability[actionObject.characterId] = testCalcUpdatedReliability(
      characterObjects[cId].reliability[actionObject.characterId],
      impressiveReason,
      false,
      1
    );

  } else {
    console.log('第三者である場合');
    // 第三者である場合
    // 疑ったキャラと疑われたキャラへの仲間度と感情を取得
    const sameFactionPossivility = calcSameFactionPossivility(
      characterObjects[cId],
      characterObjects[cId].perspective,
      [actionObject.characterId, actionObject.targetId]
    );
    const feelingForCharacter = getFeeling(characterObjects[cId], sameFactionPossivility[actionObject.characterId]);
    const feelingForTarget = getFeeling(characterObjects[cId], sameFactionPossivility[actionObject.targetId]);

    if (feelingForCharacter == FEELING_HATE && feelingForTarget != FEELING_HATE) {
      console.log(actionObject.characterId + 'への感情がhateである、かつ' + actionObject.targetId + 'への感情がhateではないなら、' + actionObject.characterId + 'への信頼度を上げる');
      // 疑ったキャラへの感情がhateである、かつ疑われたキャラへの感情がhateではないなら
      // 疑われたキャラへの信頼度を上げる
      characterObjects[cId].reliability[actionObject.targetId] = testCalcUpdatedReliability(
        characterObjects[cId].reliability[actionObject.targetId],
        impressiveReason,
        true,
        0.5
      );

    } else if (feelingForCharacter == FEELING_LOVE && feelingForTarget != FEELING_LOVE) {
      console.log(actionObject.characterId + 'への感情がloveである、かつ' + actionObject.targetId + 'への感情がloveではないなら、' + actionObject.targetId + 'への信頼度を下げる');
      // 疑ったキャラへの感情がloveである、かつ疑われたキャラへの感情がloveではないなら
      // 疑われたキャラへの信頼度を下げる
      characterObjects[cId].reliability[actionObject.targetId] = testCalcUpdatedReliability(
        characterObjects[cId].reliability[actionObject.targetId],
        impressiveReason,
        false,
        0.5
      );

    } else if (feelingForCharacter != FEELING_LOVE && feelingForTarget == FEELING_LOVE) {
      console.log(actionObject.characterId + 'への感情がloveではない、かつ' + actionObject.targetId + 'への感情がloveであるなら、' + actionObject.characterId + 'への信頼度を下げる');
      // 疑ったキャラへの感情がloveではない、かつ疑われたキャラへの感情がloveであるなら
      // 疑ったキャラへの信頼度を下げる
      characterObjects[cId].reliability[actionObject.characterId] = testCalcUpdatedReliability(
        characterObjects[cId].reliability[actionObject.characterId],
        impressiveReason,
        false,
        0.5
      );

    } else {

      if (sameFactionPossivility[actionObject.characterId] > sameFactionPossivility[actionObject.targetId]) {
        console.log(actionObject.characterId + 'の仲間度の方が高いなら、' + actionObject.characterId + 'への信頼度を上げ、' + actionObject.targetId + 'への信頼度を下げる');
        // 疑ったキャラの仲間度の方が高いなら
        // 疑ったキャラへの信頼度を上げる
        characterObjects[cId].reliability[actionObject.characterId] = testCalcUpdatedReliability(
          characterObjects[cId].reliability[actionObject.characterId],
          impressiveReason,
          true,
          0.3
        );
        // 疑われたキャラへの信頼度を下げる
        characterObjects[cId].reliability[actionObject.targetId] = testCalcUpdatedReliability(
          characterObjects[cId].reliability[actionObject.targetId],
          impressiveReason,
          false,
          0.3
        );

      } else {
        console.log(actionObject.targetId + 'の仲間度の方が高いなら、' + actionObject.characterId + 'への信頼度を下げ、' + actionObject.targetId + 'への信頼度を上げる');
        // 疑われたキャラの仲間度の方が高いなら
        // 疑ったキャラへの信頼度を下げる
        characterObjects[cId].reliability[actionObject.characterId] = testCalcUpdatedReliability(
          characterObjects[cId].reliability[actionObject.characterId],
          impressiveReason,
          false,
          0.3
        );
        // 疑われたキャラへの信頼度を上げる
        characterObjects[cId].reliability[actionObject.targetId] = testCalcUpdatedReliability(
          characterObjects[cId].reliability[actionObject.targetId],
          impressiveReason,
          true,
          0.3
        );
      }
    }
  }
}


/**
 * 「信じる」による信頼度更新を行う
 * @param {Array} characterObjects キャラクターオブジェクト配列（メソッド内で更新する）
 * @param {String} cId 信頼度更新を行うキャラクターID
 * @param {Object} actionObject 実行されたアクションオブジェクト
 */
function updateReliabirityForTrust(characterObjects, cId, actionObject) {

  // キャラクター自身がそのアクションで受ける影響の情報
  const impressiveReason = characterObjects[cId].personality.impressiveReasonList[actionObject.actionId];

  if (cId == actionObject.characterId) {
    console.log('信じたキャラである場合' + actionObject.targetId + 'への信頼度を上げる');
    // 信じたキャラである場合
    // 信じられたキャラへの信頼度を上げる
    characterObjects[cId].reliability[actionObject.targetId] = testCalcUpdatedReliability(
      characterObjects[cId].reliability[actionObject.targetId],
      impressiveReason,
      true,
      0.3
    );

  } else if (cId == actionObject.targetId) {
    console.log('信じられキャラである場合' + actionObject.characterId + 'への信頼度を上げる');
    // 信じられたキャラである場合
    // 信じたキャラへの信頼度を上げる
    characterObjects[cId].reliability[actionObject.characterId] = testCalcUpdatedReliability(
      characterObjects[cId].reliability[actionObject.characterId],
      impressiveReason,
      true,
      1
    );

  } else {
    console.log('第三者である場合');
    // 第三者である場合
    // 信じたキャラと信じられたキャラへの仲間度と感情を取得
    const sameFactionPossivility = calcSameFactionPossivility(
      characterObjects[cId],
      characterObjects[cId].perspective,
      [actionObject.characterId, actionObject.targetId]
    );
    const feelingForCharacter = getFeeling(characterObjects[cId], sameFactionPossivility[actionObject.characterId]);
    const feelingForTarget = getFeeling(characterObjects[cId], sameFactionPossivility[actionObject.targetId]);

    if (feelingForCharacter == FEELING_HATE && feelingForTarget == FEELING_HATE) {
      console.log(actionObject.characterId + 'への感情がhateである、かつ' + actionObject.targetId + 'への感情がhateであるなら、何もしない');
      // 信じたキャラへの感情がhateである、かつ信じられたキャラへの感情がhateであるなら
      // 何もしない

    } else if (feelingForCharacter == FEELING_LOVE && feelingForTarget != FEELING_LOVE) {
      console.log(actionObject.characterId + 'への感情がloveである、かつ' + actionObject.targetId + 'への感情がloveではないなら、' + actionObject.targetId + 'への信頼度を上げる');
      // 信じたキャラへの感情がloveである、かつ信じられたキャラへの感情がloveではないなら
      // 信じられたキャラへの信頼度を上げる
      characterObjects[cId].reliability[actionObject.targetId] = testCalcUpdatedReliability(
        characterObjects[cId].reliability[actionObject.targetId],
        impressiveReason,
        true,
        0.5
      );

    } else if (feelingForCharacter != FEELING_LOVE && feelingForTarget == FEELING_LOVE) {
      console.log(actionObject.characterId + 'への感情がloveではない、かつ' + actionObject.targetId + 'への感情がloveであるなら、' + actionObject.characterId + 'への信頼度を上げる');
      // 信じたキャラへの感情がloveではない、かつ信じられたキャラへの感情がloveであるなら
      // 信じたキャラへの信頼度をあげる
      characterObjects[cId].reliability[actionObject.characterId] = testCalcUpdatedReliability(
        characterObjects[cId].reliability[actionObject.characterId],
        impressiveReason,
        true,
        0.5
      );

    } else {
      console.log(actionObject.characterId + 'への信頼度を上げ、' + actionObject.targetId + 'への信頼度を上げる');
      // 上記以外
      // 信じたキャラへの信頼度を上げる
      characterObjects[cId].reliability[actionObject.characterId] = testCalcUpdatedReliability(
        characterObjects[cId].reliability[actionObject.characterId],
        impressiveReason,
        true,
        0.3
      );
      // 信じられたキャラへの信頼度を上げる
      characterObjects[cId].reliability[actionObject.targetId] = testCalcUpdatedReliability(
        characterObjects[cId].reliability[actionObject.targetId],
        impressiveReason,
        true,
        0.3
      );
    }
  }
}


/**
 * 更新後の信頼度を算出する
 * @param {Number} reliability 
 * @param {Object} impressiveReason 信頼度に影響を与える理由オブジェクト
 * @param {Boolean} isIncrease 信頼度を増加させるか。true:増加 / false:減少（デフォルト）
 * @param {Number} coeficient impressiveReason.valueを補正する係数（デフォルトは補正しない）
 * @returns updatedReliability 更新後の、相手の信頼度の値
 */
function testCalcUpdatedReliability(reliability, impressiveReason, isIncrease = false, coeficient = 1) {

  // 更新後の、相手の信頼度の値
  let updatedReliability = 0;
  // 信頼度を更新する計算に使う値（信頼度に影響を与える理由の値に係数を掛ける。減少させる場合は負の値にする）
  const value = isIncrease ? (impressiveReason.value * coeficient) : (-1 * impressiveReason.value * coeficient);

  // 信頼度に影響を与える理由をもとに、信頼度の更新差分を算出する
  if (impressiveReason.arithmetic == ARITHMETIC_ADDITION) {
    // 加算
    updatedReliability = reliability + value;
  } else if (impressiveReason.arithmetic == ARITHMETIC_MULTIPLICATION) {
    // 乗算
    updatedReliability = reliability * value;
  }

  console.log('before:' + reliability + ' after:' + updatedReliability);

  // 更新後の値が1より大きくなる場合は1に、0より小さくなる場合は0にする。信頼度が取りうる値は0～1のため
  if (updatedReliability > 1) {
    updatedReliability = 1;
  } else if (updatedReliability < 0) {
    updatedReliability = 0;
  }
  return updatedReliability;
}


/**
 * 自分の相手への感情を取得する
 * @param {Object} characterObject 自分自身のキャラクターオブジェクト
 * @param {Number} sameFactionPossivility 感情を確認したい相手のキャラクターの仲間度の数値（0～1）
 * @returns {String} 感情定数
 */
function getFeeling(characterObject, sameFactionPossivility) {

  // TODO 性格ごとに持つ
  const feelingBorderValue = 0.1;

  if (sameFactionPossivility < feelingBorderValue) {
    return FEELING_HATE;
  } else if (sameFactionPossivility > (1 - feelingBorderValue)) {
    return FEELING_LOVE;
  } else {
    return FEELING_NORMAL;
  }
}


/**
 * 自分自身の視点オブジェクトを確認し、最も同陣営割合が高い（低い）キャラクターIDを返却する
 * @param {Object} characterObject キャラクターオブジェクト
 * @param {Object} perspective 視点オブジェクト（perspectiveを使うか、rolePerspectiveを使うかは呼び元に任せる）
 * @param {Boolean} needsMax true:最大値のキャラクターIDを取得したい / false:最小値のキャラクターIDを取得したい
 * @returns {String} targetCharacterId 対象のキャラクターID
 */
function getCharacterIdBySameFactionPerspective(characterObject, perspective, needsMax) {

  let targetCharacterIdList = [];
  // 比較用の値の初期値を格納。最大値が必要なら0、最小値が必要なら1
  let maxOrMinValue = needsMax ? 0 : 1;

  for (let cId of Object.keys(perspective)) {
    // 未確定役職の割合は判定に使わないため除外
    if (cId == 'uncertified') continue;
    // 自分自身と死亡済みのキャラは除外
    // MEMO そうしたくないときが来たら引数で処理し分けるようにする
    if (cId == characterObject.characterId) continue;
    if (!TYRANO.kag.stat.f.characterObjects[cId].isAlive) continue;

    let sumSameFactionPerspective = 0;
    // 全役職をループ
    for (let rId of Object.keys(perspective[cId])) {
      // 自分と同陣営の役職のperspectiveの割合値を合計する（自分視点で必ず同陣営なら1、必ず敵陣営なら0になる）
      if (ROLE_ID_TO_FACTION[rId] == ROLE_ID_TO_FACTION[characterObject.role.roleId]) {
        sumSameFactionPerspective += perspective[cId][rId];
      }
    }

    // 同陣営割合の合計の値を確認し、キャラクターIDを格納するか判定する
    if (sumSameFactionPerspective == maxOrMinValue) {
      // 値が、現在の比較用の値と同値なら候補配列に追加する（取得したいのが最大値でも最小値でも、ここの処理は共通でよい）
      targetCharacterIdList.push(cId);
    } else if (
      (needsMax && sumSameFactionPerspective > maxOrMinValue) ||
      (!needsMax && sumSameFactionPerspective < maxOrMinValue)
    ) {
      // 値が現在の比較用の値超過または未満（取得したいのが最大値か最小値かで判定し分ける）ならば、候補配列に格納する
      targetCharacterIdList = [cId];
      maxOrMinValue = sumSameFactionPerspective;
    }
  }

  // 候補配列に候補が1人ならその対象を、複数ならランダムで、候補者に決定する。0人の場合は空文字を返す。
  // MEMO 同値のキャラが複数いた場合にその全員分の配列が欲しいときが来たら引数で処理し分けるようにすること
  let targetCharacterId = '';
  if (targetCharacterIdList.length == 1) {
    targetCharacterId = targetCharacterIdList[0];
  } else if (targetCharacterIdList.length >= 2) {
    targetCharacterId = getRandomElement(targetCharacterIdList);
  }
  console.log('getCharacterIdBySameFactionPerspective targetCharacterId:' + targetCharacterId);

  return targetCharacterId;
}
