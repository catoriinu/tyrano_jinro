; 初回プレイ用チュートリアル開始用ラベル
; ※サブルーチンではない
*toFirstInstruction

[iscript]
  // 本当の初回起動時のみ、tf.isFirstStartupが立っている。2回目以降は折れている。
  const needFirstInstruction = ('isFirstStartup' in tf) ? tf.isFirstStartup : false;

  // 初回プレイ用チュートリアルリストを格納する
  f.tmpTutorialList = {
    needFirstInstruction: needFirstInstruction,
    jinroInstruction: false,
    COPhase: false,
    discussionPhase: false,
    votePhase: false,
    firstDayNightPhase: false,
    secondDayDayPhase: false,
    thankStatusButton: false,
    forceStatusButton: false,
    statusButton: false,
    endInstruction: false,
    secondInstruction: false,
    encourageRetry: false,
  }

  // 「誰がずんだもちを食べたのだ？」のエピソード情報から参加者情報を取得して、人狼ゲームの準備に利用する
  const tmpEpisodeData = episodeData('p01', 'e01');
  tf.tmpParticipantsNumber = tmpEpisodeData.situation.participantsNumber;
  tf.tmpParticipantObjectList = tmpEpisodeData.situation.participantsList;
[endscript]

[j_prepareJinroGame participantsNumber="&tf.tmpParticipantsNumber" preload="true"]

[jump storage="playJinro.ks"]
[s]
