; シアター用マクロファイル

; シアター一覧画面に表示する、シアターの情報をゲーム変数に格納する
; @param page シアター一覧のページ番号。必須。
[macro name="loadTheaterList"]
[iscript]
  f.theaterList = {};
  if (mp.page == 1) {
    f.theaterList = clone(sf.theater[1]);
  } else if (mp.page == 99) {
    f.theaterList = {
      1: {
        title: '【ゲーム】ボイボ人狼 #2【絶賛開発中】',
        thumbnail: 'theater/紹介動画02サムネ.png',
        unlockCondition: '初めから解放されている',
        situationParticipantsNumber: 0,
        situationParticipants: [
          new Participant('mochiko'),
          new Participant('miko'),
        ],
        introStorage: 'theater/page99/movie_20230814.ks',
        outroStorage: 'theater/page99/movie_20230814.ks',
      },
      2: {
        title: '製作日誌#2',
        thumbnail: 'theater/シアターサムネ仮03.png',
        unlockCondition: '初めから解放されている',
        situationParticipantsNumber: 0,
        situationParticipants: [],
        introStorage: 'theater/page99/movie_20230814.ks',
        outroStorage: 'theater/page99/movie_20230814.ks',
      },
      3: {
        title: '製作日誌#2',
        thumbnail: 'theater/シアターサムネ仮03.png',
        unlockCondition: '初めから解放されている',
        situationParticipantsNumber: 0,
        situationParticipants: [],
        introStorage: 'theater/page99/movie_20230814.ks',
        outroStorage: 'theater/page99/movie_20230814.ks',
      },
      4: {
        title: '製作日誌#2',
        thumbnail: 'theater/シアターサムネ仮03.png',
        unlockCondition: '初めから解放されている',
        situationParticipantsNumber: 0,
        situationParticipants: [],
        introStorage: 'theater/page99/movie_20230814.ks',
        outroStorage: 'theater/page99/movie_20230814.ks',
      },
      5: {
        title: '製作日誌#2',
        thumbnail: 'theater/シアターサムネ仮03.png',
        unlockCondition: '初めから解放されている',
        situationParticipantsNumber: 0,
        situationParticipants: [],
        introStorage: 'theater/page99/movie_20230814.ks',
        outroStorage: 'theater/page99/movie_20230814.ks',
      },
      6: {
        title: '製作日誌#2',
        thumbnail: 'theater/シアターサムネ仮03.png',
        unlockCondition: '初めから解放されている',
        situationParticipantsNumber: 0,
        situationParticipants: [],
        introStorage: 'theater/page99/movie_20230814.ks',
        outroStorage: 'theater/page99/movie_20230814.ks',
      },
      7: {
        title: '製作日誌#2',
        thumbnail: 'theater/シアターサムネ仮03.png',
        unlockCondition: '初めから解放されている',
        situationParticipantsNumber: 0,
        situationParticipants: [],
        introStorage: 'theater/page99/movie_20230814.ks',
        outroStorage: 'theater/page99/movie_20230814.ks',
      },
      8: {
        title: '製作日誌#2',
        thumbnail: 'theater/シアターサムネ仮03.png',
        unlockCondition: '初めから解放されている',
        situationParticipantsNumber: 0,
        situationParticipants: [],
        introStorage: 'theater/page99/movie_20230814.ks',
        outroStorage: 'theater/page99/movie_20230814.ks',
      },
    }
  }

  // TODO テスト用に解放状況を書き換える
  for (let i = 1; i < (Object.keys(f.theaterList).length + 1); i++) {
    console.log(i);
    updateIntroProgress(f.theaterList[i], THEATER_UNLOCKED);
    updateOutroProgress(f.theaterList[i], THEATER_UNLOCKED);
  }

  // 導入編が未解放のシアターは、タイトルとサムネイルを上書きする
  console.log(f.theaterList);
  for (let i = 1; i < (Object.keys(f.theaterList).length + 1); i++) {
    console.log(i);
    if (isIntroProgressLocked(f.theaterList[i])) {
      updateTitle(f.theaterList[i], '？？？？？');
      updateThumbnail(f.theaterList[i], 'theater/TVStaticColor01_10.png');
    }
  }
[endscript]
[endmacro]


; 現在選択中のシアター詳細に紐づいているシチュエーションの参加者オブジェクト配列を一時変数に登録する
; シアター詳細画面では、j_registerParticipantの代わりにこのマクロで登録すること
[macro name="registerSituationParticipants"]
  [iscript]
    tf.tmpParticipantObjectList = clone(f.theaterList[f.theaterDetailNum].situationParticipants);
  [endscript]
[endmacro]

[return]
