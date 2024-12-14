; 進捗オブジェクト解放サブルーチン

*start
[iscript]
  if (f.pageId === 'p01') {
    if (f.episodeId === 'e01') {
      if (f.chapterId === 'c02') {
        // 「誰がずんだもちを食べたのだ？（解決編）」視聴後にe02-e07を「1：導入編未解放かつ解放可」にする
        if (getTheaterProgress('p01', 'e01') === EPISODE_STATUS.OUTRO_UNLOCKED) {
          const episodeList = ['e02', 'e03', 'e04', 'e05', 'e06', 'e07'];
          for (const episodeId of episodeList) {
            sf.theaterProgress['p01'][episodeId] = advanceEpisodeStatus('p01', episodeId, EPISODE_STATUS.INTRO_LOCKED_AVAILABLE);
          }
        }
      }
    } else if (['e02', 'e03', 'e04', 'e05', 'e06', 'e07'].includes(f.episodeId)) {
      if (f.chapterId === 'c02') {
        // e02-e07の解決編の視聴後に、e02-e07がすべて「3：解決編まで解放済み」なら、e08を「1：導入編未解放かつ解放可」にする
        if (everyProgressMatch(EPISODE_STATUS.OUTRO_UNLOCKED,
          ['p01'],
          ['e02', 'e03', 'e04', 'e05', 'e06', 'e07'],
        )) {
          sf.theaterProgress['p01']['e08'] = advanceEpisodeStatus('p01', 'e08', EPISODE_STATUS.INTRO_LOCKED_AVAILABLE);
        }
      }
    }
  }
[endscript]

[return]
[s]
