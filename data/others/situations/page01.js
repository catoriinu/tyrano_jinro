function getSituationPage01_01() {
    return new Situation(
        '誰がずんだもちを食べたのだ？',
        'theater/p01_01_darega.png',
        '初めから解放されている',
        null,
        'theater/page01/01-1_darega.ks',
        'theater/page01/01-2_darega.ks',
        new AchievementCondition(
            null,
            null,
            null,
        ),
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
        'theater/p01_02_watakushino.png',
        '【解放条件】<br>ずんだもん：村人、四国めたん：占い師でゲームに勝利する',
        null,
        '',
        '',
        new AchievementCondition(
            true,
            null,
            {
                [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_VILLAGER], null),
                [CHARACTER_ID_METAN]: new CharacterCondition([ROLE_ID_FORTUNE_TELLER], null),
            },
        ),
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_VILLAGER),
            new Participant(CHARACTER_ID_METAN, ROLE_ID_FORTUNE_TELLER),
        ],

    );
}

function getSituationPage01_03() {
    return new Situation(
        'えだまめカレーを布教するのだ！',
        'theater/p01_03_zundacurry.png',
        '【解放条件】<br>ずんだもん：狂人、春日部つむぎ：人狼でゲームに勝利する',
        null,
        '',
        '',
        new AchievementCondition(
            true,
            null,
            {
                [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_MADMAN], null),
                [CHARACTER_ID_TSUMUGI]: new CharacterCondition([ROLE_ID_WEREWOLF], null),
            },
        ),
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_MADMAN),
            new Participant(CHARACTER_ID_TSUMUGI, ROLE_ID_WEREWOLF),
        ],
    );
}

function getSituationPage01_04() {
    return new Situation(
        'ニンニクマシマシ幸せマシマシ',
        'theater/p01_04_irereba.png',
        '【解放条件】<br>ずんだもん：占い師、雨晴はう：人狼でゲームに勝利する',
        null,
        '',
        '',
        new AchievementCondition(
            true,
            null,
            {
                [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_FORTUNE_TELLER], null),
                [CHARACTER_ID_HAU]: new CharacterCondition([ROLE_ID_WEREWOLF], null),
            },
        ),
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
        'theater/p01_05_kekkan.png',
        '【解放条件】<br>ずんだもん：占い師、波音リツ：人狼でゲームに勝利する',
        null,
        '',
        '',
        new AchievementCondition(
            true,
            null,
            {
                [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_FORTUNE_TELLER], null),
                [CHARACTER_ID_RITSU]: new CharacterCondition([ROLE_ID_WEREWOLF], null),
            },
            null,
        ),
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
        'theater/01_06_uwasa1.png',
        '【解放条件】<br>ずんだもんと春日部つむぎが人狼陣営かつ退場した状態で敗北する',
        '特定のシチュエーションではないためプレイできません',
        '',
        '',
        new AchievementCondition(
            false,
            FACTION_VILLAGERS,
            {
                [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_WEREWOLF, ROLE_ID_MADMAN], false),
                [CHARACTER_ID_TSUMUGI]: new CharacterCondition([ROLE_ID_WEREWOLF, ROLE_ID_MADMAN], false),
            },
        ),
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
        new AchievementCondition(
            null,
            FACTION_DRAW_BY_REVOTE,
            null,
        ),
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
        new AchievementCondition(
            true,
            null,
            null,
        ),
        5,
        [
            new Participant(CHARACTER_ID_ZUNDAMON),
        ],
    );
}


/**
 * エピソードオブジェクトを返却する
 * すべてのエピソードの情報はここで管理する
 * @param {String} pageId ページID
 * @param {String} episodeId エピソードID
 */
function episodeData(pageId, episodeId) {
    switch (pageId) {
        // 1期・2期
        case 'p01':
            switch (episodeId) {
                case 'e01':
                    return new Episode(
                        'e01',
                        '誰がずんだもちを食べたのだ？',
                        'theater/p01_01_darega.png',
                        '初めから解放されている',
                        null,
                        new Chapter(
                            'c01',
                            'theater/page01/01-1_darega.ks',
                            null,
                        ),
                        new Chapter(
                            'c02',
                            'theater/page01/01-2_darega.ks',
                            null,
                        ),
                        new Situation_new(
                            5,
                            [
                                new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_WEREWOLF),
                                new Participant(CHARACTER_ID_METAN, ROLE_ID_MADMAN),
                            ],
                        ),
                    );
                case 'e02':
                    return new Episode(
                        'e01',
                        '誰がずんだもちを食べたのだ？',
                        'theater/p01_01_darega.png',
                        '初めから解放されている',
                        null,
                        new Chapter(
                            'c01',
                            'theater/page01/01-1_darega.ks',
                            null,
                        ),
                        new Chapter(
                            'c02',
                            'theater/page01/01-2_darega.ks',
                            null,
                        ),
                        new Situation_new(
                            5,
                            [
                                new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_VILLAGER),
                                new Participant(CHARACTER_ID_METAN, ROLE_ID_FORTUNE_TELLER),
                            ],
                        ),
                    );
                default:
                    alert('存在しないepisodeIdが指定されました episodeId=' + episodeId);
                    return;
            }
        default:
            alert('存在しないpageIdが指定されました pageId' + pageId);
            return;
    }
}
