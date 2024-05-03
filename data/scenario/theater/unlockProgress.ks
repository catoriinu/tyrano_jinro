; 進捗オブジェクト解放サブルーチン

*start
[iscript]
  let tempUnlockProgress = {};
  if (f.pageId === 'p01') {
    if (f.episodeId === 'e01') {
      if (f.chapterId === 'c02') {
        // 「誰がずんだもちを食べたのだ？（解決編）」視聴後にe02-e07の導入編を解放する
        Object.assign(tempUnlockProgress,
          {
            'p01': {
              'e02': {'c01': THEATER_UNLOCKED},
              'e03': {'c01': THEATER_UNLOCKED},
              'e04': {'c01': THEATER_UNLOCKED},
              'e05': {'c01': THEATER_UNLOCKED},
              'e06': {'c01': THEATER_UNLOCKED},
              'e07': {'c01': THEATER_UNLOCKED},
            }
          }
        );
      }
    } else if (['e02', 'e03', 'e04', 'e05', 'e06', 'e07'].includes(f.episodeId)) {
      if (f.chapterId === 'c02') {
        // e02-e07の解決編の視聴後に、e02-e07の解決編をすべて視聴済みなら、e08の導入編を解放する
        if (everyProgressMatch(THEATER_WATCHED,
          ['p01'],
          ['e02', 'e03', 'e04', 'e05', 'e06', 'e07'],
          ['c02']
        )) {
          Object.assign(tempUnlockProgress,
            {
              'p01': {
                'e08': {'c01': THEATER_UNLOCKED},
              }
            }
          );
        }
      }
    }
  }

  // 今から追加しようとしている進捗が、すでに進捗オブジェクト内に存在しているかを確認する
  for (let pageId in tempUnlockProgress) {
    for (let episodeId in tempUnlockProgress[pageId]) {
      for (let chapterId in tempUnlockProgress[pageId][episodeId]) {

        // 進捗が存在しないときのみシステム変数の進捗に追加する。存在しているなら上書きしない
        let tmpTheaterProgress = getTheaterProgress(pageId, episodeId, chapterId, null);
        if (tmpTheaterProgress === null) {
          if (!(pageId in sf.theaterProgress)) {
            Object.assign(sf.theaterProgress,
              {
                [pageId]: {[episodeId]: {[chapterId]: tempUnlockProgress[pageId][episodeId][chapterId]}}
              }
            );
          } else if (!(episodeId in sf.theaterProgress[pageId])) {
            Object.assign(sf.theaterProgress[pageId],
              {
                [episodeId]: {[chapterId]: tempUnlockProgress[pageId][episodeId][chapterId]}
              }
            );
          } else if (!(chapterId in sf.theaterProgress[pageId][chapterId])) {
            Object.assign(sf.theaterProgress[pageId][episodeId],
              {
                [chapterId]: tempUnlockProgress[pageId][episodeId][chapterId]
              }
            );
          }
        }
      }
    }
  }
[endscript]

[return]
[s]
