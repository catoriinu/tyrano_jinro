; インストラクション用の幕間オブジェクトを格納する
*addInstruction
  [iscript]
    const instructionStorage = 'instruction.ks';
    f.interludeList = {
      jinroInstruction: new Interlude(
        instructionStorage,
        '*jinroInstruction'
      ),
      COPhase: new Interlude(
        instructionStorage,
        '*COPhase'
      ),
      discussionPhase: new Interlude(
        instructionStorage,
        '*discussionPhase'
      ),
      votePhase: new Interlude(
        instructionStorage,
        '*votePhase'
      ),
      firstDayNightPhase: new Interlude(
        instructionStorage,
        '*firstDayNightPhase'
      ),
      secondDayDayPhase: new Interlude(
        instructionStorage,
        '*secondDayDayPhase',
        false, // 1日目昼には呼び出されても再生したくない。なので1日目夜のfirstDayNightPhaseのシナリオ内でtrueにする
      ),
      statusButton: new Interlude(
        instructionStorage,
        '*statusButton'
      ),
      encourageRetry: new Interlude(
        instructionStorage,
        '*encourageRetry'
      ),
      flags: {
        isFirstContact: (getTheaterProgress('p01', 'e01') === EPISODE_STATUS.INTRO_LOCKED_AVAILABLE), // 本当の初回起動時のみtrue
        thankStatusButton: false,
        forceStatusButton: false,
      }
    }
  [endscript]
  [return]
[s]
