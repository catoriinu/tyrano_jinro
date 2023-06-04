// シアターの解放状況
// 初回起動時のみ、デフォルト設定値を入れる
const THEATER_LOCKED = 0;   // 未解放
const THEATER_UNLOCKED = 1; // 解放済みで未視聴
const THEATER_WATCHED = 2;  // 視聴済み
if (!('theaterProgress' in sf)) {
  sf.theaterProgress = {
    1: { // 1期・2期
      1: {intro: THEATER_WATCHED, end: THEATER_WATCHED}, // シアター自体が解放されるのがオープニング完了後のため、ここは初期状態から視聴済みにしておく
      2: {intro: THEATER_UNLOCKED, end: THEATER_LOCKED},
      3: {intro: THEATER_UNLOCKED, end: THEATER_LOCKED},
      4: {intro: THEATER_UNLOCKED, end: THEATER_LOCKED},
      5: {intro: THEATER_UNLOCKED, end: THEATER_LOCKED},
      6: {intro: THEATER_UNLOCKED, end: THEATER_LOCKED},
      7: {intro: THEATER_UNLOCKED, end: THEATER_LOCKED},
      8: {intro: THEATER_LOCKED, end: THEATER_LOCKED}
    }
  };
}
