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
        'c01': THEATER_UNLOCKED
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


function setSituationsForAchievement(keys = []) {
  const situations = [];

  if (keys.includes('page01')) {
    situations.push(
      getSituationPage01_01(),
      getSituationPage01_02(),
      getSituationPage01_03(),
      getSituationPage01_04(),
      getSituationPage01_05(),
      getSituationPage01_06(),
      getSituationPage01_07(),
      getSituationPage01_08(),
    );
  }

  TYRANO.kag.variable.sf.situationsForAchievement = situations;
}
