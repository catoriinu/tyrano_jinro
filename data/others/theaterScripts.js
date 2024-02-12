// シアターの解放状況
// 初回起動時のみ、デフォルト設定値を入れる
const THEATER_LOCKED = 0;   // 未解放
const THEATER_UNLOCKED = 1; // 解放済みで未視聴
const THEATER_WATCHED = 2;  // 視聴済み

// TODO テスト用に起動ごとにシステム変数theaterを初期化する
delete TYRANO.kag.variable.sf.theater;
if (!('theater' in TYRANO.kag.variable.sf)) {
  TYRANO.kag.variable.sf.theater = {
    1: { // 1期・2期
      1: getSituationPage01_01(),
      2: getSituationPage01_02(),
      3: getSituationPage01_03(),
      4: getSituationPage01_04(),
      5: getSituationPage01_05(),
      6: getSituationPage01_06(),
      7: getSituationPage01_07(),
      8: getSituationPage01_08(),
    },
    99: { // もち子ミコ
      1: {intro: THEATER_WATCHED, end: THEATER_WATCHED},
      2: {intro: THEATER_LOCKED, end: THEATER_LOCKED},
      3: {intro: THEATER_LOCKED, end: THEATER_LOCKED},
      4: {intro: THEATER_LOCKED, end: THEATER_LOCKED},
      5: {intro: THEATER_LOCKED, end: THEATER_LOCKED},
      6: {intro: THEATER_LOCKED, end: THEATER_LOCKED},
      7: {intro: THEATER_LOCKED, end: THEATER_LOCKED},
      8: {intro: THEATER_LOCKED, end: THEATER_LOCKED}
    }
  };
}
// TODO テスト用
for (let situationKey of Object.keys(TYRANO.kag.variable.sf.theater["1"])) {
  updateIntroProgress(TYRANO.kag.variable.sf.theater["1"][situationKey], THEATER_UNLOCKED, true);
  updateOutroProgress(TYRANO.kag.variable.sf.theater["1"][situationKey], THEATER_LOCKED, true);
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
