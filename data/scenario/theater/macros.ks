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
        unlockCondition: '初めから解放されている'
      },
      2: {
        title: 'わたくしの千里眼―サウザンドアイ―に死角なし！',
        thumbnail: 'theater/シアターサムネ仮01.png',
        unlockCondition: '【解放条件】<br>ずんだもん：村人、四国めたん：占い師でゲームに勝利する',
      },
      3: {
        title: 'ずんだカレーを布教するのだ！',
        thumbnail: 'theater/シアターサムネ仮01.png',
        unlockCondition: '【解放条件】<br>ずんだもん：狂人、春日部つむぎ：人狼でゲームに勝利する'
      },
      4: {
        title: '入れれば入れる程幸せになれるもの',
        thumbnail: 'theater/シアターサムネ仮02.png',
        unlockCondition: '【解放条件】<br>ずんだもん：占い師、雨晴はう：人狼でゲームに勝利する'
      },
      5: {
        title: '欠陥住宅？',
        thumbnail: 'theater/シアターサムネ仮01.png',
        unlockCondition: '【解放条件】<br>ずんだもん：占い師、波音リツ：人狼でゲームに勝利する'
      },
      6: {
        title: 'ボイボ寮の噂話#1',
        thumbnail: 'theater/シアターサムネ仮01.png',
        cantSituationPlay: '特定のシチュエーションではないためプレイできません',
        unlockCondition: '【解放条件】<br>ずんだもんが投票で追放された状態でゲームに勝利する'
      },
      7: {
        title: '寮長争奪決定戦',
        thumbnail: 'theater/シアターサムネ仮01.png',
        cantSituationPlay: '特定のシチュエーションではないためプレイできません',
        unlockCondition: '【解放条件】<br>引き分けでゲームが終了する'
      },
      8: {
        title: '誰が人狼ゲームを始めたのだ？',
        thumbnail: 'theater/シアターサムネ仮01.png',
        cantSituationPlay: '特定のシチュエーションではないためプレイできません',
        unlockCondition: '【解放条件】<br>他の1期・2期のシアターを全て解放してからゲームに勝利する',
      },
    }
  }
  // TODO intro: THEATER_LOCKEDならサムネを「？」画像に入れ替える
[endscript]
[endmacro]


[return]
