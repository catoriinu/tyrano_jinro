; シアター用マクロファイル

; シアター一覧画面に表示する、シアターの情報をゲーム変数に格納する
; @param page シアター一覧のページ番号。必須。
[macro name="loadTheaterList"]
[iscript]
  f.theaterList = {};
  if (mp.page == 1) {
    f.theaterList = {
      1: {
        title: '誰がずんだもちを食べたのだ？',
        thumbnail: 'theater/シアターサムネ仮03.png',
        unlockCondition: '初めから解放されている',
        situationParticipantsNumber: 5,
        situationParticipants: [
          new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_WEREWOLF),
          new Participant(CHARACTER_ID_METAN, ROLE_ID_MADMAN),
        ],
        introStorage: 'theater/page01/01-1_darega.ks',
        outroStorage: 'theater/page01/01-2_darega.ks',
      },
      2: {
        title: 'わたくしの千里眼―サウザンドアイ―に死角なし！',
        thumbnail: 'theater/シアターサムネ仮01.png',
        unlockCondition: '【解放条件】<br>ずんだもん：村人、四国めたん：占い師でゲームに勝利する',
        situationParticipantsNumber: 5,
        situationParticipants: [
          new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_VILLAGER),
          new Participant(CHARACTER_ID_METAN, ROLE_ID_FORTUNE_TELLER),
        ],
        introStorage: '',
        outroStorage: '',
      },
      3: {
        title: 'ずんだカレーを布教するのだ！',
        thumbnail: 'theater/シアターサムネ仮01.png',
        unlockCondition: '【解放条件】<br>ずんだもん：狂人、春日部つむぎ：人狼でゲームに勝利する',
        situationParticipantsNumber: 5,
        situationParticipants: [
          new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_MADMAN),
          new Participant(CHARACTER_ID_TSUMUGI, ROLE_ID_WEREWOLF),
        ],
        introStorage: '',
        outroStorage: '',
      },
      4: {
        title: '入れれば入れる程幸せになれるもの',
        thumbnail: 'theater/シアターサムネ仮02.png',
        unlockCondition: '【解放条件】<br>ずんだもん：占い師、雨晴はう：人狼でゲームに勝利する',
        situationParticipantsNumber: 5,
        situationParticipants: [
          new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_FORTUNE_TELLER),
          new Participant(CHARACTER_ID_HAU, ROLE_ID_WEREWOLF),
        ],
        introStorage: '',
        outroStorage: '',
      },
      5: {
        title: '欠陥住宅？',
        thumbnail: 'theater/シアターサムネ仮01.png',
        unlockCondition: '【解放条件】<br>ずんだもん：占い師、波音リツ：人狼でゲームに勝利する',
        situationParticipantsNumber: 5,
        situationParticipants: [
          new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_FORTUNE_TELLER),
          new Participant(CHARACTER_ID_RITSU, ROLE_ID_WEREWOLF),
        ],
        introStorage: '',
        outroStorage: '',
      },
      6: {
        title: 'ボイボ寮の噂話#1',
        thumbnail: 'theater/シアターサムネ仮01.png',
        cantSituationPlay: '特定のシチュエーションではないためプレイできません',
        unlockCondition: '【解放条件】<br>ずんだもんが投票で追放された状態でゲームに勝利する',
        situationParticipantsNumber: 5,
        situationParticipants: [
          new Participant(CHARACTER_ID_ZUNDAMON),
        ],
        introStorage: '',
        outroStorage: '',
      },
      7: {
        title: '寮長争奪決定戦',
        thumbnail: 'theater/シアターサムネ仮01.png',
        cantSituationPlay: '特定のシチュエーションではないためプレイできません',
        unlockCondition: '【解放条件】<br>引き分けでゲームが終了する',
        situationParticipantsNumber: 5,
        situationParticipants: [
          new Participant(CHARACTER_ID_ZUNDAMON),
        ],
        introStorage: '',
        outroStorage: '',
      },
      8: {
        title: '誰が人狼ゲームを始めたのだ？',
        thumbnail: 'theater/シアターサムネ仮01.png',
        cantSituationPlay: '特定のシチュエーションではないためプレイできません',
        unlockCondition: '【解放条件】<br>他の1期・2期のシアターを全て解放してからゲームに勝利する',
        situationParticipantsNumber: 5,
        situationParticipants: [
          new Participant(CHARACTER_ID_ZUNDAMON),
        ],
        introStorage: '',
        outroStorage: '',
      },
    }
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

  // 導入編が未解放のシアターは、タイトルとサムネイルを上書きする
  console.log(f.theaterList);
  for (let i = 1; i < (Object.keys(f.theaterList).length + 1); i++) {
    console.log(i);
    if (sf.theaterProgress[mp.page][i].intro == THEATER_LOCKED) {
      f.theaterList[i].title = '？？？？？';
      f.theaterList[i].thumbnail = 'theater/TVStaticColor01_10.png';
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
