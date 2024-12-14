// シアターの解放状況
// 初回起動時のみ、デフォルト設定値を入れる
const THEATER_LOCKED = 0;   // 未解放
const THEATER_UNLOCKED = 1; // 解放済みで未視聴
const THEATER_WATCHED = 2;  // 視聴済み


/**
 * シアター進捗の初期化
 * 初回起動時やリセット時に呼ぶ
 * TODO 後で消す
 */
function resetTheaterProgressToDefault_old() {
  TYRANO.kag.variable.sf.theaterProgress = {
    'p01': {
      'e01': {
        'c01': THEATER_LOCKED,
      }
    }
  }
}


function setTheaterProgressForP99() {
  Object.assign(TYRANO.kag.variable.sf.theaterProgress,
    {
      'p99': {
        'e02': {
          'c01': THEATER_UNLOCKED,
        },
        'e03': {
          'c01': THEATER_UNLOCKED,
        }
      }
    }
  )
}

/**
 * 表示したいページ配下のエピソード情報を取得する
 * この時点では「シアター進捗に存在するエピソード」をすべて取得するので、チャプターごとに非表示にするのは別で行うこと
 * @param {*} pageId 
 * @param {*} theaterProgress 
 * @returns 
 */
function getEpisodes(
  pageId,
  theaterProgress = TYRANO.kag.variable.sf.theaterProgress
) {
  const pageData = {};
  const pageProgress = theaterProgress[pageId];
  if (pageProgress == null) {
    console.log('未定義のpageIdのためスキップします。pageId='+ pageId);
    return pageData;
  }

  for (let episodeId of Object.keys(pageProgress)) {
    pageData[episodeId] = episodeData(pageId, episodeId);
  }
  return pageData;
}


// TODO getTheaterProgress()の利用箇所全てで、第3引数chapterIdを削除する必要がある
/**
 * 指定されたチャプターのエピソード解放ステータスを返却する
 * @param {String} pageId ページID
 * @param {String} episodeId エピソードID
 * @param {any} defaultProgress 進捗が存在しない場合に返却する値
 * @returns {Number} エピソード解放ステータス
 */
function getTheaterProgress(pageId, episodeId, defaultProgress = EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE) {
  // 進捗状況内に進捗があればそれを、なければデフォルト値を返却する
  const theaterProgress = TYRANO.kag.variable.sf.theaterProgress;
  if (
    pageId in theaterProgress &&
    episodeId in theaterProgress[pageId]
  ) {
    return theaterProgress[pageId][episodeId];
  }
  return defaultProgress;
}


/**
 * 指定された複数のチャプターの進捗が、すべて指定の進捗状況である場合にのみtrueを返す
 * ※2重ループで全パターンチェックする実装なので、要素を渡しすぎた場合はパフォーマンスが落ちるので注意
 * @param {Number} シアター進捗定数
 * @param {Array} pageIdList ページID配列
 * @param {Array} episodeIdList エピソードID配列
 * @returns {Boolean} true: 全チャプターが満たしている / false: 満たしていないチャプターがある
 */
function everyProgressMatch(targetEpisodeStatus, pageIdList, episodeIdList) {
  console.log('everyProgressMatch targetEpisodeStatus=' + targetEpisodeStatus);
  for (let pageId of pageIdList) {
    for (let episodeId of episodeIdList) {
      const currentProgress = getTheaterProgress(pageId, episodeId);
      console.log(pageId + '_' + episodeId + '=' + currentProgress);
      if (currentProgress !== targetEpisodeStatus) return false;
    }
  }
  return true;
}


// エピソード解放ステータス
const EPISODE_STATUS = {
  INTRO_LOCKED_UNAVAILABLE: 0,    // 導入編未解放かつ現時点では解放不可
  INTRO_LOCKED_AVAILABLE: 1,      // 導入編未解放かつ解放可
  INTRO_UNLOCKED_OUTRO_LOCKED: 2, // 導入編解放済みで解決編未解放
  OUTRO_UNLOCKED: 3               // 解決編まで解放済み
};

const PARTICIPATION = {
  CONFIRMED: 0, // 参加確定
  CANDIDATE: 1, // 参加候補
  DECLINED: 2,  // 不参加
}


/**
 * シアター進捗の初期化
 * 初回起動時やリセット時に呼ぶ
 */
function resetTheaterProgressToDefault() {
  TYRANO.kag.variable.sf.theaterProgress = {
    'p01': {
      'e01': EPISODE_STATUS.INTRO_LOCKED_AVAILABLE,
      'e02': EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE,
      'e03': EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE,
      'e04': EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE,
      'e05': EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE,
      'e06': EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE,
      'e07': EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE,
      'e08': EPISODE_STATUS.INTRO_LOCKED_UNAVAILABLE,
    }
  }
}


/**
 * 指定されたエピソードのエピソード進捗ステータスを、進めたいステータスに進めることができればそれを返す
 * 進められない場合は元々のステータスを返す
 * @param {String} pageId 
 * @param {String} episodeId 
 * @param {Number} targetStatus 進めたいエピソード進捗ステータス
 * @returns 更新結果となるエピソード進捗ステータス
 */
function advanceEpisodeStatus(pageId, episodeId, targetStatus) {
  const currentStatus = getTheaterProgress(pageId, episodeId);
  // 現在のステータスが、指定のステータスの1つ前の場合のみ、1つ進めることができると判定する
  if (currentStatus === (targetStatus - 1)) {
    return targetStatus;
  }
  // 1つ前ではない場合は進められないので元々のステータスを返す（ステータスを飛ばしたり、巻き戻ったりはさせないという意味）
  return currentStatus;
}


/**
 * 現在のエピソード解放ステータスが、引数のそれと一致しているエピソードIDの一覧を返却する
 * @param {Number} episodeStatus 抽出したいエピソード解放ステータス
 * @param {Object} theaterProgress シアター進捗オブジェクト
 * @returns {Array} [[pageId, episodeId], ...]
 */
function getEpisodesByStatus(episodeStatus, theaterProgress = TYRANO.kag.variable.sf.theaterProgress) {

  const episodes = [];

  for (const [pageId, episodeProgress] of Object.entries(theaterProgress)) {
    // 引数で指定されたエピソード解放ステータスであるエピソードIDを抽出
    const matchedEpisodeIdList = Object.keys(episodeProgress).filter(
      episodeId => episodeProgress[episodeId] === episodeStatus
    );

    // pageIdとepisodeIdをペアとしてepisodes配列に追加
    for (const episodeId of matchedEpisodeIdList) {
      episodes.push([pageId, episodeId]);
    }
  }

  return episodes;
}


/**
 * 指定されたエピソード一覧のシチュエーションの中に、現在の人狼ゲームデータに合致するエピソードがあるかをチェックする
 * 合致するエピソードがあった場合、合致させるために書き換えを行った状態の人狼ゲームデータを返却する
 * @param {Array} episodes チェック対象のエピソード一覧 [[pageId, episodeId], ...]
 * @param {JinroGameData} targetJinroGameData 現在の人狼ゲームデータ
 * @returns {Array} [true, pageId, episodeId, JinroGameData]: チェックOK | [false, null, null, JinroGameData]: チェックNG
 */
function checkMatchingEpisodeSituation(episodes, targetJinroGameData) {

  for (const [pageId, episodeId] of episodes) {
    // このエピソードのシチュエーションを表す人狼ゲームデータを取得し、現在の人狼ゲームデータがそれに合致するかをチェックする
    const episode = episodeData(pageId, episodeId);
    const situationJinroGameData = episode.situationJinroGameData;
    const [matchResult, matchedJinroGameData] = isMatchEpisodeSituation(situationJinroGameData, targetJinroGameData)
    if (matchResult) {
      // シチュエーションに合致するエピソードがあった場合
      return [true, pageId, episodeId, matchedJinroGameData];
    }
  }

  // シチュエーションに合致するエピソードがなかった場合
  return [false, null, null, targetJinroGameData];
}

/**
 * このシチュエーションで指定されている人狼ゲームデータを基準として、現在の人狼ゲームデータが全ての条件に合致しているかを判定する
 * 合致していた場合、合致させるために書き換えを行った状態の人狼ゲームデータを返却する
 * @param {JinroGameData} situationJinroGameData このシチュエーションで指定されている人狼ゲームデータ
 * @param {JinroGameData} targetJinroGameData 現在の人狼ゲームデータ
 * @returns {Array} [true, JinroGameData]: チェックOK | [false, null]: チェックNG
 */
function isMatchEpisodeSituation(situationJinroGameData, targetJinroGameData) {

  // 元々の人狼ゲームデータを書き換えないようにするため、cloneする
  const tmpTargetJinroGameData = clone(targetJinroGameData);

  // プレイヤーキャラクターの条件チェック
  if (situationJinroGameData.playerCharacterId) {
    // プレイヤーキャラクターが合致していなければNG
    if (tmpTargetJinroGameData.playerCharacterId !== situationJinroGameData.playerCharacterId) {
      console.log('★false playerCharacterId');
      return [false, null];
    }
  }

  // このシチュエーションと、人狼ゲームデータ側の参加者オブジェクトリストを取得
  const situationParticipantList = situationJinroGameData.participantList;
  const tmpTargetParticipantList = tmpTargetJinroGameData.participantList;

  // このシチュエーションの参加者チェック
  for (const situationParticipant of situationParticipantList) {
    // 人狼ゲームデータ側の、同一キャラクターの参加者オブジェクトを取得
    const tmpTargetParticipant = tmpTargetParticipantList.find(
      participant => participant.characterId === situationParticipant.characterId
    );

    // 「このシチュエーションで不参加であること」が条件である参加者の、参加ステータスのチェック
    if (situationParticipant.participationStatus === PARTICIPATION.DECLINED) {

      if (!tmpTargetParticipant || tmpTargetParticipant.participationStatus === PARTICIPATION.DECLINED) {
        // 「不参加」（参加者オブジェクトが存在しない場合も含む）なら条件合致。次の参加者のチェックへ
        break;

      } else if (tmpTargetParticipant.participationStatus === PARTICIPATION.CANDIDATE) {
        // 「参加候補」なら「不参加」に更新したうえで条件合致とする。次の参加者のチェックへ
        setParticipationStatusInParticipant(tmpTargetParticipant, PARTICIPATION.DECLINED);
        break;

      } else {
        // 上記以外（=「参加必須」）ならNG
        console.log('★false declined Participant');
        return [false, null];
      }

    } else {
      // このシチュエーションで参加する参加者のチェック

      // 人狼ゲームデータ側に参加者オブジェクトが存在しなかった場合はNG
      if (!tmpTargetParticipant) {
        console.log('★false undefined Participant');
        return [false, null];
      }

      // 参加者の参加ステータスを「参加確定」に更新する
      updateParticipationStatusInParticipant(tmpTargetParticipant, PARTICIPATION.CONFIRMED);

      // 「役職候補」が設定されている参加者の、役職チェック
      if (situationParticipant.candidateRoleIds.length >= 1) {

        // 参加者の現在の役職がランダムなら
        if (tmpTargetParticipant.roleId === null) {
          // 残り役職候補の中に、指定されている役職が残っているか
          const remainRoleData = getRoleDataWithRemainingCapacity(tmpTargetJinroGameData);
          const tmpCandidateRoleIds = situationParticipant.candidateRoleIds.filter(
            roleId => (roleId in remainRoleData && remainRoleData[roleId] >= 1)
          );
          if (tmpCandidateRoleIds.length <= 0) {
            // 指定されている役職が残っていなければNG
            console.log('★false remainRoleData');
            return [false, null];
          }

          // 参加者に役職IDを割り当てる（割り当て可能な候補が複数ある場合に備えてシャッフルし、0要素目を割り当てる）
          const assignedRoleId = shuffleElements(tmpCandidateRoleIds)[0];
          updateRoleIdInParticipant(tmpTargetParticipant, assignedRoleId);
        }

        // その参加者に、役職候補に含まれていない役職IDが設定されていた場合はNG
        if (!situationParticipant.candidateRoleIds.includes(tmpTargetParticipant.roleId)) {
          console.log('★false roleCandidate');
          return [false, null];
        }
      }
    }
  }

  // 参加人数チェック
  // このシチュエーションで参加確定している人数
  const situationConfirmedNumber = situationParticipantList.filter(
    participant => (participant.participationStatus !== PARTICIPATION.DECLINED)
  ).length;
  // 現在の参加確定人数
  const tmpTargetComfirmedNumber = tmpTargetParticipantList.filter(
    participant => (participant.participationStatus === PARTICIPATION.CONFIRMED)
  ).length;
  // 現在の参加候補人数
  const tmpTargetCandidateNumber = tmpTargetParticipantList.filter(
    participant => (participant.participationStatus === PARTICIPATION.CANDIDATE)
  ).length;
  // 以下のどちらかに該当する場合はNG
  // 1. 現在の参加確定人数が、このシチュエーションで参加確定している人数を上回っている場合（余りが出るためNG）
  // 2. このシチュエーションで参加確定している人数が、現在の参加確定人数と参加候補人数の合計を超えている場合（人数が不足するためNG）
  if (
    tmpTargetComfirmedNumber > situationConfirmedNumber &&
    situationConfirmedNumber > (tmpTargetComfirmedNumber + tmpTargetCandidateNumber)
  ) {
    console.log('★false ComfirmedNumber');
    return [false, null];
  }

  // 全てのチェックを満たした場合、このメソッド内で書き換えられた人狼ゲームデータを返却する
  return [true, tmpTargetJinroGameData];
}
