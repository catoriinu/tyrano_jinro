// シアターの解放状況
// 初回起動時のみ、デフォルト設定値を入れる
const THEATER_LOCKED = 0;   // 未解放
const THEATER_UNLOCKED = 1; // 解放済みで未視聴
const THEATER_WATCHED = 2;  // 視聴済み


// 初回起動時のみ、シアター進捗の初期化
if (!('theaterProgress' in TYRANO.kag.variable.sf)) {
  TYRANO.kag.variable.sf.theaterProgress = {
    'p01': {
      'e01': {
        'c01': THEATER_UNLOCKED,
      }
    }
  }
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


/**
 * 指定されたチャプターの進捗を返却する
 * @param {String} pageId ページID
 * @param {String} episodeId エピソードID
 * @param {String} chapterId チャプターID
 * @param {any} defaultProgress 進捗が存在しない場合に返却する値
 * @returns {Number} シアター進捗定数
 */
function getTheaterProgress(pageId, episodeId, chapterId, defaultProgress = THEATER_LOCKED) {
  // 進捗状況内に進捗があればそれを、なければデフォルト値を返却する
  const theaterProgress = TYRANO.kag.variable.sf.theaterProgress;
  if (
    pageId in theaterProgress &&
    episodeId in theaterProgress[pageId] &&
    chapterId in theaterProgress[pageId][episodeId]
  ) {
    return theaterProgress[pageId][episodeId][chapterId];
  }
  return defaultProgress;
}


/**
 * 指定された複数のチャプターの進捗が、すべて指定の進捗状況である場合にのみtrueを返す
 * ※3重ループで全パターンチェックする実装なので、要素を渡しすぎた場合はパフォーマンスが落ちるので注意
 * @param {Number} シアター進捗定数
 * @param {Array} pageIdList ページID配列
 * @param {Array} episodeIdList エピソードID配列
 * @param {Array} chapterIdList チャプターID配列
 * @returns {Boolean} true: 全チャプターが満たしている / false: 満たしていないチャプターがある
 */
function everyProgressMatch(targetProgress, pageIdList, episodeIdList, chapterIdList) {
  console.log('everyProgressMatch targetProgress=' + targetProgress);
  for (let pageId of pageIdList) {
    for (let episodeId of episodeIdList) {
      for (let chapterId of chapterIdList) {
        let progress = getTheaterProgress(pageId, episodeId, chapterId);
        console.log(pageId + '_' + episodeId + '_' + chapterId + '=' + progress);
        if (progress !== targetProgress) return false;
      }
    }
  }
  return true;
}
