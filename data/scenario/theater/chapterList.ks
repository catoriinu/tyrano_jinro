; 「はじめに」用のChapterオブジェクトをチャプターリストに追加する
*addNotice
  [iscript];
    Object.assign(
      f.chapterList,
      {
        notice: new Chapter(
          'theater/p01/notice.ks',
        ),
      }
    );
  [endscript]
  [return]
[s]


; インストラクション用のChapterオブジェクトをチャプターリストに追加する
*addInstruction
  [iscript]
    const instructionStorage = 'instruction.ks';
    Object.assign(
      f.chapterList,
      {
        startInstruction: new Chapter(
          instructionStorage,
          '*startInstruction'
        ),
        COPhase: new Chapter(
          instructionStorage,
          '*COPhase'
        ),
        discussionPhase: new Chapter(
          instructionStorage,
          '*discussionPhase'
        ),
        votePhase: new Chapter(
          instructionStorage,
          '*votePhase'
        ),
        firstDayNightPhase: new Chapter(
          instructionStorage,
          '*firstDayNightPhase'
        ),
        secondDayDayPhase: new Chapter(
          instructionStorage,
          '*secondDayDayPhase',
          false, // 1日目昼には呼び出されても再生したくない。なので1日目夜のfirstDayNightPhaseのシナリオ内でtrueにする
        ),
        statusButton: new Chapter(
          instructionStorage,
          '*statusButton'
        ),
        encourageRetry: new Chapter(
          instructionStorage,
          '*encourageRetry'
        ),
        flags: {
          isFirstContact: (getTheaterProgress('p01', 'e01') === EPISODE_STATUS.INTRO_LOCKED_AVAILABLE), // 本当の初回起動時のみtrue
          thankStatusButton: false,
          forceStatusButton: false,
        }
      }
    );
  [endscript]
  [return]
[s]
