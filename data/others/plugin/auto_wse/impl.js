function isSePlaying() {
  // @see https://github.com/ShikemokuMK/tyranoscript/blob/0196f95f96adcb76fc633a7e7a13ca9f3e2e21ae/tyrano/plugins/kag/kag.tag_audio.js#L549C1-L560C30
  // SEマップを走査してほかに再生中の効果音がないかどうかをチェック
  // ただしループSE（環境音などが想定される）は除外する必要がある
  for (const key in TYRANO.kag.tmp.map_se) {
  const howl = TYRANO.kag.tmp.map_se[key];
    if (!howl._loop) {
      if (howl.playing()) {
        return true;
      }
    }
  }
  return false;
}


async function waitSeStopAndInterval(interval = 5000) {
  const pollInterval = 50; // 50ms ごとに isSePlaying() をチェック

  // いずれかの SE が再生中である限りループ
  while (isSePlaying()) {
    await new Promise(resolve => setTimeout(resolve, pollInterval));
  }

  // 全ての SE 停止を検知したら、interval ミリ秒だけ待機
  await new Promise(resolve => setTimeout(resolve, interval));

  // 改ページ（次命令）を実行
  //TYRANO.kag.ftag.nextOrder();
}
