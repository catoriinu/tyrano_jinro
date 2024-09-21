/**
 * レコードの初期化
 * 初回起動時やリセット時に呼ぶ
 */
function resetRecordToDefault() {
  TYRANO.kag.variable.sf.record = {
    playHistories: {},
    winningStreak: new WinningStreak()
  }
  fillDefaultPlayHistores(TYRANO.kag.variable.sf.record.playHistories);
}

/**
 * プレイ履歴オブジェクト配列のうち、現時点で未定義の役職のプレイ履歴オブジェクトを初期状態で埋める
 * 初回起動時に呼ぶのはもちろん、役職が増えた場合にも呼ぶ想定
 * @param {Array} playHistories TYRANO.kag.variable.sf.record.playHistories。中身はPlayHistoryオブジェクトの配列
 */
function fillDefaultPlayHistores(playHistories) {
  // NOTE: すべての役職IDを記載しておくこと
  const roleIds = [
    ROLE_ID_VILLAGER,
    ROLE_ID_WEREWOLF,
    ROLE_ID_FORTUNE_TELLER,
    ROLE_ID_MADMAN
  ];

  for (const roleId of roleIds) {
    if (!(roleId in playHistories)) {
      playHistories[roleId] = new PlayHistory();
    }
  }
}

/**
 * プレイ履歴オブジェクト
 * その役職でのプレイ履歴を記録しておく
 */
function PlayHistory() {
  this.play = 0; // 総プレイ回数
  this.win = 0;  // 勝利回数
  this.draw = 0; // 引き分け回数
  this.lose = 0; // 敗北回数
}

/**
 * 連勝記録オブジェクト
 */
function WinningStreak() {
  this.longest = 0; // 最長連勝記録
  this.current = 0; // 現在の連勝記録
}

/**
 * ゲームの結果に応じてプレイ履歴オブジェクト内のプレイ回数を1増やす
 * @param {Chacacter} characterObject プレイヤーのキャラクターオブジェクト
 * @param {String} winnerFaction 勝利陣営
 */
function incrementPlayHistoryCount(characterObject, winnerFaction) {
  const playerFaction = characterObject.role.faction;
  const playerRoleId = characterObject.role.roleId;
  const playHistory = TYRANO.kag.variable.sf.record.playHistories[playerRoleId];

  if (isResultDraw(winnerFaction)) {
    // 引き分けの場合、連勝記録は変化させない
    playHistory.draw++;
  } else if (isResultPlayersWin(winnerFaction, playerFaction)) {
    // 勝利した場合、連勝記録を伸ばす
    playHistory.win++;
    incrementWinningStreakCount();
  } else {
    // 敗北した場合、現在の連勝記録をリセットする
    playHistory.lose++;
    TYRANO.kag.variable.sf.record.winningStreak.current = 0;
  }
  playHistory.play++;
  console.log(TYRANO.kag.variable.sf.record);
}

/**
 * 連勝記録オブジェクトの連勝記録を伸ばす
 */
function incrementWinningStreakCount() {
  const winningStreak = TYRANO.kag.variable.sf.record.winningStreak;
  winningStreak.current++;
  if (winningStreak.current > winningStreak.longest) {
    winningStreak.longest = winningStreak.current;
  }
}
