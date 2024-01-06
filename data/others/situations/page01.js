function getSituationPage01_01() {
    return new Situation(
        '誰がずんだもちを食べたのだ？',
        'theater/シアターサムネ仮03.png',
        '初めから解放されている',
        null,
        'theater/page01/01-1_darega.ks',
        'theater/page01/01-2_darega.ks',
        {},
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_WEREWOLF),
            new Participant(CHARACTER_ID_METAN, ROLE_ID_MADMAN),
        ],
    );
}

function getSituationPage01_02() {
    return new Situation(
        'わたくしの千里眼―サウザンドアイ―に死角なし！',
        'theater/シアターサムネ仮01.png',
        '【解放条件】<br>ずんだもん：村人、四国めたん：占い師でゲームに勝利する',
        null,
        '',
        '',
        {},
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_VILLAGER),
            new Participant(CHARACTER_ID_METAN, ROLE_ID_FORTUNE_TELLER),
        ],

    );
}

function getSituationPage01_03() {
    return new Situation(
        'ずんだカレーを布教するのだ！',
        'theater/シアターサムネ仮01.png',
        '【解放条件】<br>ずんだもん：狂人、春日部つむぎ：人狼でゲームに勝利する',
        null,
        '',
        '',
        {},
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_MADMAN),
            new Participant(CHARACTER_ID_TSUMUGI, ROLE_ID_WEREWOLF),
        ],
    );
}

function getSituationPage01_04() {
    return new Situation(
        '入れれば入れる程幸せになれるもの',
        'theater/シアターサムネ仮02.png',
        '【解放条件】<br>ずんだもん：占い師、雨晴はう：人狼でゲームに勝利する',
        null,
        '',
        '',
        {},
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_FORTUNE_TELLER),
            new Participant(CHARACTER_ID_HAU, ROLE_ID_WEREWOLF),
        ],
    );
}

function getSituationPage01_05() {
    return new Situation(
        '欠陥住宅？',
        'theater/シアターサムネ仮01.png',
        '【解放条件】<br>ずんだもん：占い師、波音リツ：人狼でゲームに勝利する',
        null,
        '',
        '',
        {},
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_FORTUNE_TELLER),
            new Participant(CHARACTER_ID_RITSU, ROLE_ID_WEREWOLF),
        ],
    );
}

function getSituationPage01_06() {
    return new Situation(
        'ボイボ寮の噂話#1',
        'theater/シアターサムネ仮01.png',
        '【解放条件】<br>ずんだもんが投票で追放された状態でゲームに勝利する',
        '特定のシチュエーションではないためプレイできません',
        '',
        '',
        {},
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON),
        ],
    );
}

function getSituationPage01_07() {
    return new Situation(
        '寮長争奪決定戦',
        'theater/シアターサムネ仮01.png',
        '【解放条件】<br>引き分けでゲームが終了する',
        '特定のシチュエーションではないためプレイできません',
        '',
        '',
        {},
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON),
        ],
    );
}

function getSituationPage01_08() {
    return new Situation(
        '誰が人狼ゲームを始めたのだ？',
        'theater/シアターサムネ仮01.png',
        '【解放条件】<br>他の1期・2期のシアターを全て解放してからゲームに勝利する',
        '特定のシチュエーションではないためプレイできません',
        '',
        '',
        {},
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON),
        ],
    );
}

