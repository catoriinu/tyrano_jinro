/**
 * そのキャラクターが、役職COを実行する可能性があるかを返す
 * NOTE:視点オブジェクトや性格を利用した仕組みに変えるべきなため、廃止したい。
 * @param {String} characterId キャラクターID
 * @returns {Array} [{Number}最終確率, {Boolean}判定結果]
 */
function isCOMyRoll(characterId) {
  // キャラクターオブジェクトを取得する
  const characterObject = TYRANO.kag.stat.f.characterObjects[characterId];

  // COする可能性がある役職についているか
  if (characterObject.role.roleId in characterObject.personality.roleCOProbability) {
    let probability = characterObject.personality.roleCOProbability[characterObject.role.roleId][ROLE_ID_FORTUNE_TELLER];

    // 初日以降に初COする確率は大幅に下げる
    if (TYRANO.kag.stat.f.day > 1) {
      probability /= 5;
    }

    // randomDecide()に判定させた結果配列を返す
    return randomDecide(probability);
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
      console.log(cId + 'の視点が破綻しました！');
      // 破綻したときの処理を行う
      updateCharacterObjectToContradicted(cId);
    }
  }
}


/**
 * 破綻したときの処理をまとめて実行する
 * @param {String} characterId 破綻したキャラクターID
 */
function updateCharacterObjectToContradicted(characterId) {
  // 破綻フラグを立てる
  TYRANO.kag.stat.f.characterObjects[characterId].isContradicted = true;

  // これ以上破綻を起こさないように、視点オブジェクトを表裏どちらも共通視点オブジェクトで上書きする
  TYRANO.kag.stat.f.characterObjects[characterId].perspective = clone(TYRANO.kag.stat.f.commonPerspective);
  TYRANO.kag.stat.f.characterObjects[characterId].role.rolePerspective= clone(TYRANO.kag.stat.f.commonPerspective);

  // 破綻したキャラは、嘘がつける役職（TODO:「嘘をつかない役職配列」をメソッドで取り出せるようにする）だったということで確定する。
  // updateCommonPerspectiveを呼び出して共通および全員の視点オブジェクトを更新する
  updateCommonPerspective(characterId, [ROLE_ID_VILLAGER, ROLE_ID_FORTUNE_TELLER]);
}


/**
 * その視点オブジェクトの中で、そのキャラクターが「その役職の最後の生存者だった」ことが確定するかを判定する。
 * @param {String} characterId キャラクターID
 * @param {String} roleId 役職ID
 * @param {Object} perspective 視点オブジェクト
 * @returns 
 */
function isLastOneInPerspective(characterId, roleId, perspective) {

  // その視点オブジェクトの中で、
  for (let cId of Object.keys(perspective)) {
    if (cId == characterId) {
      // そのキャラクターがその役職で確定しているか。確定していなければ即false
      if (perspective[cId][roleId] < 1) return false;

    } else if (cId == 'uncertified') {
      // その役職に就いているキャラがすでに全員確定しているか。未確定が1人でもいれば即false
      if (perspective.uncertified[roleId] > 0) return false;

    } else {
      // そのキャラクター以外のキャラに関しては、現在の生存者の中で、
      // （すでに死亡済みのキャラの中にその役職で確定していたキャラがいても、「最後の生存者」の判定には関係ないためスルーする）
      if (TYRANO.kag.stat.f.characterObjects[cId].isAlive) {
        // その役職に就いている可能性があるキャラが他にいないか。まだ可能性が残っているキャラが生存していれば即false
        if (perspective[cId][roleId] > 0) return false;
      }
    }
  }
  // 以上の条件に当てはまらなかった場合のみ、そのキャラクターが「その役職の最後の生存者だった」ことが確定する
  return true;
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

  // 得票数オブジェクトを初期化（0票だったキャラはキー自体入らないままとなる）（投票結果テキスト表示用。↓とは別にあった方が計算量が少なく済む）
  TYRANO.kag.stat.f.votedCountObject = {};
  // 投票結果オブジェクト（アクションオブジェクトの配列）を初期化（投票結果画面表示用）
  TYRANO.kag.stat.f.voteResultObjects = [];

  for (let characterId of Object.keys(characterObjects)) {
    // 投票履歴オブジェクトのその日の投票先配列を確認
    // 配列でなければ、投票していないのでスルー
    if (!Array.isArray(characterObjects[characterId].voteHistory[day])) continue;

    // 投票先のキャラクターID（＝その日のvoteHistoryの末尾のID。最新の再投票先は末尾に追加されているため）を取得
    let voteTargetId = characterObjects[characterId].voteHistory[day].slice(-1)[0];
    // 1票追加
    if (voteTargetId in TYRANO.kag.stat.f.votedCountObject) {
      TYRANO.kag.stat.f.votedCountObject[voteTargetId]++;
    } else {
      TYRANO.kag.stat.f.votedCountObject[voteTargetId] = 1;
    }
    // 投票結果オブジェクトに投票のアクションオブジェクトとして追加
    const actionObject = new Action(characterId, ACTION_VOTE, voteTargetId)
    TYRANO.kag.stat.f.voteResultObjects.push(actionObject);

    // 投票による信頼度増減を行う
    updateReliabirityForAction(characterObjects, actionObject);
  }

  // 最多得票者のキャラクターIDを配列に格納
  TYRANO.kag.stat.f.electedIdList = getMaxKeys(TYRANO.kag.stat.f.votedCountObject);
  // 最多得票者が1人で確定すれば、処刑を実行する（同票なら要素が複数入っているので再投票）
  TYRANO.kag.stat.f.doExecute = (TYRANO.kag.stat.f.electedIdList.length == 1) ? true : false;
};


/**
 * 未使用メソッド
 * 渡されたアクションオブジェクトの配列の中で、targetIdに指定されている回数が最多のtargetIdを返却する（複数個の場合もあるため配列形式）
 * 最多得票者の取得などに利用
 * @param {Array} actionObjects アクションオブジェクトの配列
 * @returns {Array} targetIdの配列
 */
function getMaxTargetedIds(actionObjects) {

  let targetIdObject = {};
  for (let i = 0; i < actionObjects.length; i++) {
    let targetId = actionObjects[i].targetId;
    if (targetId in targetIdObject) {
      targetIdObject[targetId]++;
    } else {
      targetIdObject[targetId] = 1;
    }
  }
  let maxTrgetedIds = getMaxKeys(targetIdObject);
  return maxTrgetedIds;
}


/**
 * 未使用メソッド
 * 渡されたアクションオブジェクトの配列の中で、countIdがtargetIdに指定されている回数を返却する
 * 得票数の取得などに利用
 * @param {Array} actionObjects アクションオブジェクトの配列
 * @returns {Number} countIdがtargetIdに指定されている回数
 */
function countTargetedId(actionObjects, countId) {

  let count = 0;
  for (let i = 0; i < actionObjects.length; i++) {
    if (actionObjects[i].targetId == countId) {
      count++;
    }
  }
  return count;
}


/**
 * ボタンオブジェクトクラス
 * TODO 別のファイルに移動すること
 * @param {*} id ボタンのID（ボタン要素のclass名に利用）
 * @param {*} text ボタンに表示するテキスト
 * @param {*} side ボタンの表示位置 'left','right'のいずれか（省略した場合center）
 * @param {*} color ボタンの色
 * @param {*} addClasses ボタンに追加したいクラス名配列。以下補足
 * ・glinkのnameに追加され、ボタンのclass属性になる。colorのclass属性より後ろに追加されるので、より優先される。
 * ・glink生成時にカンマ区切りにするので、追加したいクラス名1つにつき配列の1要素ずつ格納すること。
 * @param {*} target ボタン押下時にジャンプするラベル名
 * @param {*} storage ボタン押下時にジャンプするファイル名
 */
function Button (id, text, side = 'center', color = '', addClasses = [], target = '', storage = '') {
  this.id = id;
  this.text = text;
  this.side = side;
  this.color = color;
  this.addClasses = addClasses;
  //this.target = target;
  //this.storage = storage;
}


/**
 * アクションオブジェクトクラス
 * @param {String} characterId アクション実行者のキャラクターID（特定の実行者がいないアクションなら不要。例：処刑）
 * @param {String} actionId 実行したアクションID
 * @param {String} targetId アクションの対象者のキャラクターID（対象をとらないアクションなら不要）
 * @param {Boolean} result アクションの結果。意味はアクションによって異なる。（占い=t:●/f:○, 処刑・襲撃=t:死亡/f:死亡せず）
 * @param {Boolean} isPublic 公開されたアクションか（例：占い=t:CO済み/f:未CO）
 * @param {String} decision そのアクションを実行した判断基準（任意）
 */
function Action (characterId = '', actionId = '', targetId = '', result = null, isPublic = false, decision = '') {
  this.characterId = characterId;
  this.actionId = actionId;
  this.targetId = targetId;
  this.result = result;
  this.isPublic = isPublic;
  this.decision = decision;
}



/**
 * アクション実行による、NPC全員の信頼度の更新を行う
 * @param {Array} characterObjects キャラクターオブジェクト配列（メソッド内で更新する）
 * @param {Object} actionObject アクションオブジェクト
 */
function updateReliabirityForAction(characterObjects, actionObject) {

  console.log('updateReliabirityForAction actionObject:');
  console.log(actionObject);

  // アクションの実行者の影響力倍率を計算する（以降の処理で共通の値なので最初に行う）
  // NOTE:実行者のいないアクションの場合は1（今のところ実行者のいないアクションはここに来ない）
  const influenceMultiplier = calcInfluenceMultiplier(characterObjects[actionObject.characterId], actionObject);

  for (let cId of Object.keys(characterObjects)) {

    // 死亡済みキャラクターはスキップ（プレイヤーはスキップしない。リアクションのために信頼度更新が必要なので）
    if (!characterObjects[cId].isAlive) continue;

    console.log('character:' + characterObjects[cId].name);

    if (actionObject.actionId == ACTION_SUSPECT) {
      updateReliabirityForSucpect(characterObjects[cId], actionObject, influenceMultiplier);
    } else if (actionObject.actionId == ACTION_TRUST) {
      updateReliabirityForTrust(characterObjects[cId], actionObject, influenceMultiplier);
    } else if (actionObject.actionId == ACTION_ASK) {
      // TODO
    } else if (actionObject.actionId == ACTION_VOTE) {
      updateReliabirityForVote(characterObjects[cId], actionObject, influenceMultiplier);
    } else if (actionObject.actionId == ACTION_FORTUNE_TELLING) {
      
      if (actionObject.result === true) {
        updateReliabirityForFortuneTellingToWerewolves(characterObjects[cId], actionObject, influenceMultiplier);
      } else if (actionObject.result === false) {
        updateReliabirityForFortuneTellingToVillagers(characterObjects[cId], actionObject, influenceMultiplier);
      } else {
        // バグって占えておらず、resultにnullが入っていることがあった場合のために厳密比較にしておく
        alert('actionObject.resultに値が入っていません');
      }

    }
    // TODO ここで投票の場合の信頼度更新も集約したい。
    // そのためには投票もアクションオブジェクトを流用する必要がありそう。
    // →占いは集約完了、破綻は集約しない（相手がいるアクションについての信頼度集約のみにする方針。破綻は相手がいないため）
  }
  // ログ出力
  loggingObjects(characterObjects, actionObject);
}


/**
 * 「占う」で「人狼陣営（●）」とCOされた場合の信頼度更新を行う
 * @param {Object} character 信頼度更新を行うキャラクターオブジェクト
 * @param {Object} action 実行されたアクションオブジェクト
 * @param {Number} influenceMultiplier アクションの実行者の影響力倍率
 */
function updateReliabirityForFortuneTellingToWerewolves(character, action, influenceMultiplier) {

  const utility = new calcReliabilityUtility(
    character,
    action,
    influenceMultiplier
  );

  if (character.characterId === action.characterId) {
    // 占ったキャラである場合
    // 占われたキャラへの信頼度を下げる
    utility.updateReliability(-1, action.targetId);
    // TODO 占った瞬間に下げてないか？COしたときじゃなくないか？

  } else if (character.characterId === action.targetId) {
    // 占われたキャラである場合
    // 占ったキャラへの信頼度を下げる
    utility.updateReliability(-1, action.characterId);

  } else {
    // 第三者である場合
    // 占ったキャラと占われたキャラへの仲間度と感情を取得
    const feelingForCharacter = getFeeling(character, utility.sameFactionPossivility[action.characterId]);
    const feelingForTarget = getFeeling(character, utility.sameFactionPossivility[action.targetId]);

    // 感情による特殊処理
    if (feelingForCharacter === FEELING_LOVE && feelingForTarget !== FEELING_LOVE) {
      // 占ったキャラへの感情がloveである、かつ占われたキャラへの感情がloveではないなら
      // 占われたキャラへの信頼度を下げる
      utility.updateReliability(-0.2, action.targetId);

    } else if (feelingForCharacter !== FEELING_LOVE && feelingForTarget === FEELING_LOVE) {
      // 占ったキャラへの感情がloveではない、かつ占われたキャラへの感情がloveであるなら
      // 占ったキャラへの信頼度を下げる
      utility.updateReliability(-0.2, action.characterId);
    }

    if (utility.sameFactionPossivility[action.characterId] > utility.sameFactionPossivility[action.targetId]) {
      // 占ったキャラの仲間度の方が高いなら
      // 占ったキャラへの信頼度を上げる
      utility.updateReliability(0.2, action.characterId);
      // 占われたキャラへの信頼度を下げる
      utility.updateReliability(-0.4, action.targetId);

    } else {
      // 占われたキャラの仲間度の方が高いなら
      // 占ったキャラへの信頼度を下げる
      utility.updateReliability(-0.4, action.characterId);
      // 占われたキャラへの信頼度を上げる
      utility.updateReliability(0.2, action.targetId);
    }
  }
}


/**
 * 「占う」で「村人陣営（○）」とCOされた場合の信頼度更新を行う
 * @param {Object} character 信頼度更新を行うキャラクターオブジェクト
 * @param {Object} action 実行されたアクションオブジェクト
 * @param {Number} influenceMultiplier アクションの実行者の影響力倍率
 */
function updateReliabirityForFortuneTellingToVillagers(character, action, influenceMultiplier) {

  const utility = new calcReliabilityUtility(
    character,
    action,
    influenceMultiplier
  );

  if (character.characterId === action.characterId) {
    // 占ったキャラである場合
    // 占われたキャラへの信頼度を上げる
    utility.updateReliability(0.3, action.targetId);
    // TODO 占った瞬間に上げてないか？COしたときじゃなくないか？

  } else if (character.characterId === action.targetId) {
    // 占われたキャラである場合
    // 占ったキャラへの信頼度を上げる
    utility.updateReliability(0.3, action.characterId);

  } else {
    // 第三者である場合
    // 占ったキャラと占われたキャラへの仲間度と感情を取得
    const feelingForCharacter = getFeeling(character, utility.sameFactionPossivility[action.characterId]);
    const feelingForTarget = getFeeling(character, utility.sameFactionPossivility[action.targetId]);

    let bonusValueForCharacter = 0;
    let bonusValueForTarget = 0;

    // 感情による特殊処理
    if (feelingForCharacter === FEELING_LOVE && feelingForTarget !== FEELING_LOVE) {
      // 占ったキャラへの感情がloveである、かつ占われたキャラへの感情がloveではないなら
      // 占われたキャラへの信頼度を上げる
      bonusValueForTarget += 0.1;

    } else if (feelingForCharacter !== FEELING_LOVE && feelingForTarget === FEELING_LOVE) {
      // 占ったキャラへの感情がloveではない、かつ占われたキャラへの感情がloveであるなら
      // 占ったキャラへの信頼度を上げる
      bonusValueForCharacter += 0.1;
    }

    // 占ったキャラへの信頼度を上げる
    utility.updateReliability((0.1 + bonusValueForCharacter), action.characterId);
    // 占われたキャラへの信頼度を上げる
    utility.updateReliability((0.2 + bonusValueForTarget), action.targetId);
  }
}


/**
 * 「疑う」による信頼度更新を行う
 * @param {Object} character 信頼度更新を行うキャラクターオブジェクト
 * @param {Object} action 実行されたアクションオブジェクト
 * @param {Number} influenceMultiplier アクションの実行者の影響力倍率
 */
function updateReliabirityForSucpect(character, action, influenceMultiplier) {
  const utility = new calcReliabilityUtility(
    character,
    action,
    influenceMultiplier
  );

  if (character.characterId === action.characterId) {
    // プレイヤーの場合だけ下げる。
    // NPCは、既に仲間度が低いから疑ったので下げる必要はないが、プレイヤーはリアクション判定時に仲間度を参照するため下げておく必要がある。
    if (character.isPlayer) {
      utility.updateReliability(-0.2, action.targetId);
    }

  } else if (character.characterId === action.targetId) {
    // 疑われたキャラである場合
    // 疑ったキャラへの信頼度を下げる
    utility.updateReliability(-0.3, action.characterId);

  } else {
    console.log('第三者である場合');
    // 第三者である場合
    // 疑ったキャラと疑われたキャラへの仲間度と感情を取得
    const feelingForCharacter = getFeeling(character, utility.sameFactionPossivility[action.characterId]);
    const feelingForTarget = getFeeling(character, utility.sameFactionPossivility[action.targetId]);

    // 感情による特殊処理
    if (feelingForTarget === FEELING_HATE && feelingForCharacter !== FEELING_HATE) {
      // 対象者がHATEであり、実行者がHATEでないなら、実行者への信頼度を上げる
      utility.updateReliability(0.1, action.characterId);

    } else if (feelingForTarget === FEELING_LOVE && feelingForCharacter !== FEELING_LOVE) {
      // 対象者がLOVEであり、実行者がLOVEでないなら、実行者への信頼度を下げる
      utility.updateReliability(-0.1, action.characterId);
    }

    if (utility.sameFactionPossivility[action.characterId] > utility.sameFactionPossivility[action.targetId]) {
      // 疑ったキャラの仲間度の方が高いなら
      // 疑ったキャラへの信頼度を上げる
      utility.updateReliability(0.1, action.characterId);
      // 疑われたキャラへの信頼度を下げる
      utility.updateReliability(-0.2, action.targetId);

    } else {
      // 疑われたキャラの仲間度の方が高いなら
      // 疑ったキャラへの信頼度を下げる
      utility.updateReliability(-0.2, action.characterId);
      // 疑われたキャラへの信頼度を上げる
      utility.updateReliability(0.1, action.targetId);
    }
  }
}


/**
 * 「信じる」による信頼度更新を行う
 * @param {Object} character 信頼度更新を行うキャラクターオブジェクト
 * @param {Object} action 実行されたアクションオブジェクト
 * @param {Number} influenceMultiplier アクションの実行者の影響力倍率
 */
function updateReliabirityForTrust(character, action, influenceMultiplier) {

  const utility = new calcReliabilityUtility(
    character,
    action,
    influenceMultiplier
  );

  if (character.characterId === action.characterId) {
    // プレイヤーの場合だけ上げる。
    // NPCは、既に仲間度が高いから信じたので上げる必要はないが、プレイヤーはリアクション判定時に仲間度を参照するため上げておく必要がある。
    if (character.isPlayer) {
      utility.updateReliability(0.2, action.targetId);
    }

  } else if (character.characterId === action.targetId) {
    // 信じられたキャラである場合
    // 信じたキャラへの信頼度を上げる
    utility.updateReliability(0.3, action.characterId);

  } else {
    console.log('第三者である場合');
    // 第三者である場合
    // 信じたキャラと信じられたキャラへの仲間度と感情を取得
    const feelingForCharacter = getFeeling(character, utility.sameFactionPossivility[action.characterId]);
    const feelingForTarget = getFeeling(character, utility.sameFactionPossivility[action.targetId]);

    let bonusValueForCharacter = 0;
    let bonusValueForTarget = 0;

    // 感情による特殊処理
    if (feelingForCharacter === FEELING_LOVE && feelingForTarget !== FEELING_LOVE) {
      // 信じたキャラへの感情がloveである、かつ信じられたキャラへの感情がloveではないなら
      // 信じられたキャラへの信頼度を上げる
      bonusValueForTarget += 0.1;

    } else if (feelingForCharacter !== FEELING_LOVE && feelingForTarget === FEELING_LOVE) {
      // 信じたキャラへの感情がloveではない、かつ信じられたキャラへの感情がloveであるなら
      // 信じたキャラへの信頼度を上げる
      bonusValueForCharacter += 0.1;
    }

    // 信じたキャラへの信頼度を上げる
    utility.updateReliability((0.1 + bonusValueForCharacter), action.characterId);
    // 信じられたキャラへの信頼度を上げる
    utility.updateReliability((0.2 + bonusValueForTarget), action.targetId);
  }
}


/**
 * 「投票」による信頼度更新を行う
 * @param {Object} character 信頼度更新を行うキャラクターオブジェクト
 * @param {Object} action 実行されたアクションオブジェクト
 * @param {Number} influenceMultiplier アクションの実行者の影響力倍率
 */
function updateReliabirityForVote(character, action, influenceMultiplier) {

  const utility = new calcReliabilityUtility(
    character,
    action,
    influenceMultiplier
  );

  if (character.characterId === action.characterId) {
    // プレイヤーの場合だけ下げる。
    // 信頼度や仲間度が低いから投票したのであって、それ以上下げる必要はないため
    if (character.isPlayer) {
      utility.updateReliability(-0.1, action.targetId);
    }

  } else if (character.characterId === action.targetId) {
    // 投票されたキャラである場合
    // 投票したキャラへの信頼度を下げる
    utility.updateReliability(-0.15, action.characterId);

  } else {
    // 第三者である場合
    // 投票したキャラと投票されたキャラへの仲間度と感情を取得

    // 投票先のキャラクターID（＝その日のvoteHistoryの末尾のID。最新の再投票先は末尾に追加されているため）を取得
    let voteTargetId = character.voteHistory[TYRANO.kag.stat.f.day].slice(-1)[0];

    if (voteTargetId === action.targetId) {
      // 投票したキャラが自分と同じキャラに投票したなら、
      // 投票したキャラへの信頼度を上げる
      utility.updateReliability(0.1, action.characterId);
    }

    if (utility.sameFactionPossivility[action.characterId] > utility.sameFactionPossivility[action.targetId]) {
      // 投票したキャラの仲間度の方が高いなら
      // 投票したキャラへの信頼度を上げ、
      // 投票されたキャラへの信頼度を下げる
      utility.updateReliability(0.05, action.characterId);
      utility.updateReliability(-0.1, action.targetId);

    } else {
      // 投票されたキャラの仲間度の方が高いなら
      // 投票されたキャラへの信頼度を上げ、
      // 投票したキャラへの信頼度を下げる
      utility.updateReliability(0.05, action.targetId);
      utility.updateReliability(-0.1, action.characterId);
    }
  }
}


function loggingObjects(characterObjects, actionObject) {
  console.log('loggingCharacterObjects...');

  // アクションオブジェクトの中身をログ用配列に格納
  //const actionObjectForLog = [actionObject.characterId, actionObject.actionId, actionObject.targetId];

  const logObject = {};
  const logArray = [];
  if (!('logArrayList' in TYRANO.kag.stat.f)) {
    TYRANO.kag.stat.f.logArrayList = [];
  }

  // アクションオブジェクトの情報をログオブジェクトに格納
  logObject.action = [actionObject.characterId, actionObject.actionId, actionObject.targetId, actionObject.result];
  logArray.push(actionObject.characterId, actionObject.actionId, actionObject.targetId, actionObject.result)

  for (let cId of TYRANO.kag.stat.f.participantsIdList) {
    const characterObject = characterObjects[cId];
  
    // 仲間度
    //logArray.push(cId, 'sameFactionPossivility');
    const sameFactionPossivility = calcSameFactionPossivility(
      characterObject,
      characterObject.perspective
    );
    const sameFactionPossivilityLogObject = Object.assign({}, sameFactionPossivility);

    for (let cId1 of TYRANO.kag.stat.f.participantsIdList) {
      logArray.push(sameFactionPossivilityLogObject[cId1]);
    }

    // 信頼度
    //logArray.push( 'reliability');
    const reliabilityLogObject = Object.assign({}, characterObject.reliability);
    for (let cId2 of TYRANO.kag.stat.f.participantsIdList) {
      logArray.push(reliabilityLogObject[cId2]);
    }

    // 視点
    //const perspectiveObject = Object.assign({}, characterObject.perspective);
    //logArray.push(...(Object.values(perspectiveObject)));

    // ログオブジェクトに格納
    logObject[cId] = {
      sameFactionPossivility: sameFactionPossivilityLogObject,
      reliability: reliabilityLogObject,
      //perspective: perspectiveObject
    };
  }
  console.log(logObject);
  TYRANO.kag.stat.f.logArrayList.push(logArray.join(','));
  //const logString = logArray.join(',');
  //console.log(logString);
}

function outputLog(){
  console.log('実行者,アクション,対象者,結果,【仲間度】ずんだもん→ずんだもん,【仲間度】ずんだもん→四国めたん,【仲間度】ずんだもん→春日部つむぎ,【仲間度】ずんだもん→雨晴はう,【仲間度】ずんだもん→波音リツ,【信頼度】ずんだもん→ずんだもん,【信頼度】ずんだもん→四国めたん,【信頼度】ずんだもん→春日部つむぎ,【信頼度】ずんだもん→雨晴はう,【信頼度】ずんだもん→波音リツ,【仲間度】四国めたん→ずんだもん,【仲間度】四国めたん→四国めたん,【仲間度】四国めたん→春日部つむぎ,【仲間度】四国めたん→雨晴はう,【仲間度】四国めたん→波音リツ,【信頼度】四国めたん→ずんだもん,【信頼度】四国めたん→四国めたん,【信頼度】四国めたん→春日部つむぎ,【信頼度】四国めたん→雨晴はう,【信頼度】四国めたん→波音リツ,【仲間度】春日部つむぎ→ずんだもん,【仲間度】春日部つむぎ→四国めたん,【仲間度】春日部つむぎ→春日部つむぎ,【仲間度】春日部つむぎ→雨晴はう,【仲間度】春日部つむぎ→波音リツ,【信頼度】春日部つむぎ→ずんだもん,【信頼度】春日部つむぎ→四国めたん,【信頼度】春日部つむぎ→春日部つむぎ,【信頼度】春日部つむぎ→雨晴はう,【信頼度】春日部つむぎ→波音リツ,【仲間度】雨晴はう→ずんだもん,【仲間度】雨晴はう→四国めたん,【仲間度】雨晴はう→春日部つむぎ,【仲間度】雨晴はう→雨晴はう,【仲間度】雨晴はう→波音リツ,【信頼度】雨晴はう→ずんだもん,【信頼度】雨晴はう→四国めたん,【信頼度】雨晴はう→春日部つむぎ,【信頼度】雨晴はう→雨晴はう,【信頼度】雨晴はう→波音リツ,【仲間度】波音リツ→ずんだもん,【仲間度】波音リツ→四国めたん,【仲間度】波音リツ→春日部つむぎ,【仲間度】波音リツ→雨晴はう,【仲間度】波音リツ→波音リツ,【信頼度】波音リツ→ずんだもん,【信頼度】波音リツ→四国めたん,【信頼度】波音リツ→春日部つむぎ,【信頼度】波音リツ→雨晴はう,【信頼度】波音リツ→波音リツ');
  for (let logString of TYRANO.kag.stat.f.logArrayList) {
    console.log(logString);
  }
}


/**
 * 自分の相手への感情を取得する
 * @param {Object} characterObject 自分自身のキャラクターオブジェクト
 * @param {Number} sameFactionPossivility 感情を確認したい相手のキャラクターの仲間度の数値（0～1）
 * @returns {String} 感情定数
 */
function getFeeling(characterObject, sameFactionPossivility) {

  if (sameFactionPossivility < characterObject.personality.feelingBorder.hate) {
    return FEELING_HATE;
  } else if (sameFactionPossivility > characterObject.personality.feelingBorder.love) {
    return FEELING_LOVE;
  } else {
    return FEELING_NEUTRAL;
  }
}


/**
 * 自分自身の視点オブジェクトを確認し、最も同陣営割合が高い（低い）キャラクターIDを返却する
 * @param {Object} characterObject キャラクターオブジェクト
 * @param {Object} perspective 視点オブジェクト（perspectiveを使うか、rolePerspectiveを使うかは呼び元に任せる）
 * @param {String} roleId 同陣営判定を行う役職ID
 * @param {Boolean} needsMax true:最大値のキャラクターIDを取得したい / false:最小値のキャラクターIDを取得したい
 * @returns {String} targetCharacterId 対象のキャラクターID
 */
function getCharacterIdBySameFactionPerspective(characterObject, perspective, roleId, needsMax) {

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
      if (ROLE_ID_TO_FACTION[rId] == ROLE_ID_TO_FACTION[roleId]) {
        sumSameFactionPerspective += perspective[cId][rId];
      }
    }
    console.log('★SameFactionPerspective targetCharacterId:' + cId + ' sumSameFactionPerspective:' + sumSameFactionPerspective);

    // 同陣営割合の合計の値を確認し、キャラクターIDを格納するか判定する
    if (sumSameFactionPerspective == maxOrMinValue) {
      // 値が、現在の比較用の値と同値なら候補配列に追加する（取得したいのが最大値でも最小値でも、ここの処理は共通でよい）
      targetCharacterIdList.push(cId);
    } else if (
      (needsMax && (sumSameFactionPerspective > maxOrMinValue)) ||
      (!needsMax && (sumSameFactionPerspective < maxOrMinValue))
    ) {
      // 値が現在の比較用の値超過または未満（取得したいのが最大値か最小値かで判定し分ける）ならば、候補配列に格納する
      targetCharacterIdList = [cId];
      maxOrMinValue = sumSameFactionPerspective;
    }
  }

  // 候補者配列から最終的な候補者を決める
  // 候補が1人なら即確定し、0人なら空文字を返す
  let targetCharacterId = '';
  if (targetCharacterIdList.length == 1) {
    targetCharacterId = targetCharacterIdList[0];

  } else if (targetCharacterIdList.length >= 2) {
    // 候補が複数なら、候補の中で最も仲間度が高い（低い）キャラクターを候補とする
    // 基本的には、信頼度の差の影響で仲間度にも差が出る。ただしlogicalが1の場合だけは差が出ないことに注意。
    let sameFactionPossivility = calcSameFactionPossivility(characterObject, perspective, targetCharacterIdList);
    console.log('★SameFactionPerspective sameFactionPossivility:');
    console.log(sameFactionPossivility);

    targetCharacterIdList = [];
    // 比較用の値の初期値を格納。最大値が必要なら0、最小値が必要なら1
    maxOrMinValue = needsMax ? 0 : 1;
    for (let cId of Object.keys(sameFactionPossivility)) {
      // 仲間度の合計の値を確認し、キャラクターIDを格納するか判定する
      if (sameFactionPossivility[cId] == maxOrMinValue) {
        // 値が、現在の比較用の値と同値なら候補配列に追加する（取得したいのが最大値でも最小値でも、ここの処理は共通でよい）
        targetCharacterIdList.push(cId);
      } else if (
        (needsMax && (sameFactionPossivility[cId] > maxOrMinValue)) ||
        (!needsMax && (sameFactionPossivility[cId] < maxOrMinValue))
      ) {
        // 値が現在の比較用の値超過または未満（取得したいのが最大値か最小値かで判定し分ける）ならば、候補配列に格納する
        targetCharacterIdList = [cId];
        maxOrMinValue = sameFactionPossivility[cId];
      }
    }

    // 候補が1人なら即確定し、ここまでやっても候補が複数ならランダムで決める
    if (targetCharacterIdList.length == 1) {
      targetCharacterId = targetCharacterIdList[0];
    } else if (targetCharacterIdList.length >= 2) {
      targetCharacterId = getRandomElement(targetCharacterIdList);
    }
  }
  console.log('★getCharacterIdBySameFactionPerspective targetCharacterId:' + targetCharacterId);

  return targetCharacterId;
}


/**
 * 自分自身の信頼度を確認し、最も信頼度が高い（低い）キャラクターIDを返却する
 * @param {Object} characterObject キャラクターオブジェクト
 * @param {Boolean} needsMax true:最大値のキャラクターIDを取得したい / false:最小値のキャラクターIDを取得したい
 * @returns {String} targetCharacterId 対象のキャラクターID
 */
function getCharacterIdByReliability(characterObject, needsMax) {

  let targetCharacterIdList = [];
  // 比較用の値の初期値を格納。最大値が必要なら0、最小値が必要なら1
  let maxOrMinValue = needsMax ? 0 : 1;

  for (let cId of Object.keys(characterObject.reliability)) {
    // 自分自身と死亡済みのキャラは除外
    // MEMO そうしたくないときが来たら引数で処理し分けるようにする
    if (cId == characterObject.characterId) continue;
    if (!TYRANO.kag.stat.f.characterObjects[cId].isAlive) continue;

    let tmpReliability = characterObject.reliability[cId]
    console.log('★Reliability targetCharacterId:' + cId + ' Reliability:' + tmpReliability);

    // 同陣営割合の合計の値を確認し、キャラクターIDを格納するか判定する
    if (tmpReliability == maxOrMinValue) {
      // 値が、現在の比較用の値と同値なら候補配列に追加する（取得したいのが最大値でも最小値でも、ここの処理は共通でよい）
      targetCharacterIdList.push(cId);
    } else if (
      (needsMax && (tmpReliability > maxOrMinValue)) ||
      (!needsMax && (tmpReliability < maxOrMinValue))
    ) {
      // 値が現在の比較用の値超過または未満（取得したいのが最大値か最小値かで判定し分ける）ならば、候補配列に格納する
      targetCharacterIdList = [cId];
      maxOrMinValue = tmpReliability;
    }
  }

  // 候補者配列から最終的な候補者を決める
  // 候補が1人なら即確定し、0人なら空文字を返す
  let targetCharacterId = '';
  if (targetCharacterIdList.length == 1) {
    targetCharacterId = targetCharacterIdList[0];

  } else if (targetCharacterIdList.length >= 2) {
    // 候補が複数なら、候補の中で最も仲間度が高い（低い）キャラクターを候補とする
    // 基本的には、同陣営割合の差の影響で仲間度にも差が出る。ただしlogicalが0の場合だけは差が出ないことに注意。
    let sameFactionPossivility = calcSameFactionPossivility(
      characterObject,
      characterObject.perspective, // 発言は嘘をつくため、perspectiveを渡す
      targetCharacterIdList
    );
    console.log('★Reliability sameFactionPossivility:');
    console.log(sameFactionPossivility);

    targetCharacterIdList = [];
    // 比較用の値の初期値を格納。最大値が必要なら0、最小値が必要なら1
    maxOrMinValue = needsMax ? 0 : 1;
    for (let cId of Object.keys(sameFactionPossivility)) {
      // 仲間度の合計の値を確認し、キャラクターIDを格納するか判定する
      if (sameFactionPossivility[cId] == maxOrMinValue) {
        // 値が、現在の比較用の値と同値なら候補配列に追加する（取得したいのが最大値でも最小値でも、ここの処理は共通でよい）
        targetCharacterIdList.push(cId);
      } else if (
        (needsMax && (sameFactionPossivility[cId] > maxOrMinValue)) ||
        (!needsMax && (sameFactionPossivility[cId] < maxOrMinValue))
      ) {
        // 値が現在の比較用の値超過または未満（取得したいのが最大値か最小値かで判定し分ける）ならば、候補配列に格納する
        targetCharacterIdList = [cId];
        maxOrMinValue = sameFactionPossivility[cId];
      }
    }

    // 候補が1人なら即確定し、ここまでやっても候補が複数ならランダムで決める
    if (targetCharacterIdList.length == 1) {
      targetCharacterId = targetCharacterIdList[0];
    } else if (targetCharacterIdList.length >= 2) {
      targetCharacterId = getRandomElement(targetCharacterIdList);
    }
  }
  console.log('getCharacterIdByReliability targetCharacterId:' + targetCharacterId);

  return targetCharacterId;
}
