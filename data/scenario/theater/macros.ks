; シアター用マクロファイル


; @param pageId シアター一覧のページID。必須。
[macro name="loadEpisodeList"]
[iscript]
  f.episodeList = getEpisodes(mp.pageId);

  // （現在の）ボイボ人狼ではエピソード数は1ページにつき8つ（e01-e08）
  const episodeIdList = ['e01', 'e02', 'e03', 'e04', 'e05', 'e06', 'e07', 'e08']
  // 導入編が未解放（＝getEpisodesで取得できなかった）のエピソードは、代わりに未解放用のエピソードを格納する
  console.log(f.episodeList);
  for (let episodeId of episodeIdList) {
    if (!(episodeId in f.episodeList)){
      f.episodeList[episodeId] = new Episode(
        mp.pageId,
        episodeId,
        '？？？？？',
        'theater/TVStaticColor01_10.png',
        '',
        null,
        null,
        null,
        null,
       );
    }
  }
[endscript]
[endmacro]

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
    //updateIntroProgress(f.theaterList[i], THEATER_UNLOCKED);
    //updateOutroProgress(f.theaterList[i], THEATER_UNLOCKED);
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
[macro name="t_registerSituationParticipants"]
  [iscript]
    tf.tmpParticipantObjectList = clone(f.displayEpisode.situation.participantsList);
  [endscript]
[endmacro]


; TODO 削除予定
; @param pageKey
; @param situationKey
[macro name="t_watchIntroProgress"]
  [iscript]
    sf.theater[mp.pageKey][mp.situationKey] = updateIntroProgress(sf.theater[mp.pageKey][mp.situationKey], THEATER_WATCHED);
  [endscript]
[endmacro]


; TODO 削除予定
; @param pageKey
; @param situationKey
[macro name="t_watchOutroProgress"]
  [iscript]
    sf.theater[mp.pageKey][mp.situationKey] = updateOutroProgress(sf.theater[mp.pageKey][mp.situationKey], THEATER_WATCHED);
  [endscript]
[endmacro]


; 指定されたチャプターの進捗が「未解放」なら一時変数にtrueを格納する
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_isProgressLocked"]
  [iscript]
    tf.isProgressLocked = (getTheaterProgress(mp.pageId, mp.episodeId, mp.chapterId) === THEATER_LOCKED);
  [endscript]
[endmacro]


; 指定されたチャプターの進捗が「解放済みだが未視聴」なら一時変数にtrueを格納する
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_isProgressUnlocked"]
  [iscript]
    tf.isProgressUnlocked = (getTheaterProgress(mp.pageId, mp.episodeId, mp.chapterId) === THEATER_UNLOCKED);
  [endscript]
[endmacro]


; 指定されたチャプターの進捗が「視聴済み」なら一時変数にtrueを格納する
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_isProgressWatched"]
  [iscript]
    tf.isProgressWatched = (getTheaterProgress(mp.pageId, mp.episodeId, mp.chapterId) === THEATER_WATCHED);
  [endscript]
[endmacro]


; 指定されたチャプターの進捗を「視聴済み」に更新する
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_updateProgressWatched"]
  [iscript]
    sf.theaterProgress[mp.pageId][mp.episodeId][mp.chapterId] = THEATER_WATCHED;
  [endscript]
[endmacro]


; チャプター視聴開始時の準備用マクロ
; @param actorsList
; @param bgParams
; @param playbgmParams
[macro name="t_setupChapter"]

  [cm]
  [clearfix]
  [start_keyconfig]

  ; 背景
  [bg storage="&mp.bgParams.storage" time="300"]

  ; BGM
  [playbgm storage="&mp.playbgmParams.storage" loop="true" volume="&mp.playbgmParams.volume" restart="false"]

  ;メッセージウィンドウの設定、文字が表示される領域を調整
  [position layer="message0" left="53" top="484" width="1174" height="235" margint="65" marginl="75" marginr="80" marginb="65" opacity="220" page="fore"]

  ;メッセージウィンドウの表示
  [layopt layer="message0" visible="true"]

  ;キャラクターの名前が表示される文字領域
  [ptext name="chara_name_area" layer="message0" face="にくまるフォント" color="0x28332a" size="36" x="175" y="505"]

  ;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
  [chara_config ptext="chara_name_area"]
  ; pos_mode:キャラの初期位置はキャラ宣言時に全指定するのでfalse
  [chara_config pos_mode="false" memory="true" time="200"]

  ;このシナリオで登場する全キャラクターを宣言、表情登録
  [eval exp="f.participantsIdList = mp.actorsList"]
  [call storage="./chara/common.ks" target="*registerAllCharacters"]

  ; ボタン表示
  ;[j_displayFixButton backlog="true"]

[endmacro]


; チャプター視聴終了時の後片付け用マクロ
; @param pageId
; @param episodeId
; @param chapterId
[macro name="t_teardownChapter"]

  ; キャラ名を消すための#
  # 

  ; 視聴済みに更新する
  [t_updateProgressWatched pageId="&mp.pageId" episodeId="&mp.episodeId" chapterId="&mp.chapterId"]

  [eval exp="f.quickShowEpisodeWindow = true"]

  [j_clearFixButton]
  [m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
  [m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
  [layopt layer="message0" visible="false"]

[endmacro]
