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
                        pageId,
                        episodeId,
                        '誰がずんだもちを食べたのだ？',
                        'theater/p01_e01_thumb.png',
                        '【解放条件】<br>チュートリアルで勝利する',
                        'チュートリアルをプレイする',
                        new Chapter(
                            'c01',
                            'theater/p01/e01_c01.ks'
                        ),
                        new Chapter(
                            'c02',
                            'theater/p01/e01_c02.ks',
                            new AchievementCondition(
                                true,
                                null,
                                {
                                    [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_WEREWOLF], null),
                                    [CHARACTER_ID_METAN]: new CharacterCondition([ROLE_ID_MADMAN], null),
                                },
                            ),
                        ),
                        new Situation(
                            5,
                            [
                                new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_WEREWOLF, null,
                                    {influenceMultiplier: 1.5, registanceMultiplier: 1.2}
                                ),
                                new Participant(CHARACTER_ID_METAN, ROLE_ID_MADMAN),
                            ],
                        ),
                    );
                case 'e02':
                    return new Episode(
                        pageId,
                        episodeId,
                        'わたくしの千里眼―サウザンドアイ―に死角なし！',
                        'theater/p01_e02_thumb.png',
                        '【解放条件】<br>ずんだもん：村人、四国めたん：占い師でゲームに勝利する',
                        'このシチュエーションでプレイする',
                        new Chapter(
                            'c01',
                            'theater/p01/e02_c01.ks'
                        ),
                        new Chapter(
                            'c02',
                            'theater/p01/e02_c02.ks',
                            new AchievementCondition(
                                true,
                                null,
                                {
                                    [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_VILLAGER], null),
                                    [CHARACTER_ID_METAN]: new CharacterCondition([ROLE_ID_FORTUNE_TELLER], null),
                                },
                            ),
                        ),
                        new Situation(
                            5,
                            [
                                new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_VILLAGER),
                                new Participant(CHARACTER_ID_METAN, ROLE_ID_FORTUNE_TELLER),
                            ],
                        ),
                    );
                case 'e03':
                    return new Episode(
                        pageId,
                        episodeId,
                        'えだまめカレーを布教するのだ！',
                        'theater/p01_e03_thumb.png',
                        '【解放条件】<br>ずんだもん：狂人、春日部つむぎ：人狼でゲームに勝利する',
                        'このシチュエーションでプレイする',
                        new Chapter(
                            'c01',
                            'theater/p01/e03_c01.ks'
                        ),
                        new Chapter(
                            'c02',
                            'theater/p01/e03_c02.ks',
                            new AchievementCondition(
                                true,
                                null,
                                {
                                    [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_MADMAN], null),
                                    [CHARACTER_ID_TSUMUGI]: new CharacterCondition([ROLE_ID_WEREWOLF], null),
                                },
                            ),
                        ),
                        new Situation(
                            5,
                            [
                                new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_MADMAN),
                                new Participant(CHARACTER_ID_TSUMUGI, ROLE_ID_WEREWOLF),
                            ],
                        ),
                    );
                case 'e04':
                    return new Episode(
                        pageId,
                        episodeId,
                        'ニンニクマシマシ幸せマシマシ',
                        'theater/p01_e04_thumb.png',
                        '【解放条件】<br>ずんだもん：占い師、雨晴はう：人狼でゲームに勝利する',
                        'このシチュエーションでプレイする',
                        new Chapter(
                            'c01',
                            'theater/p01/e04_c01.ks'
                        ),
                        new Chapter(
                            'c02',
                            'theater/p01/e04_c02.ks',
                            new AchievementCondition(
                                true,
                                null,
                                {
                                    [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_FORTUNE_TELLER], null),
                                    [CHARACTER_ID_HAU]: new CharacterCondition([ROLE_ID_WEREWOLF], null),
                                },
                            ),
                        ),
                        new Situation(
                            5,
                            [
                                new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_FORTUNE_TELLER),
                                new Participant(CHARACTER_ID_HAU, ROLE_ID_WEREWOLF),
                            ],
                        ),
                    );
                case 'e05':
                    return new Episode(
                        pageId,
                        episodeId,
                        '欠陥住宅？',
                        'theater/p01_e05_thumb.png',
                        '【解放条件】<br>ずんだもん：占い師、波音リツ：人狼でゲームに勝利する',
                        'このシチュエーションでプレイする',
                        new Chapter(
                            'c01',
                            'theater/p01/e05_c01.ks'
                        ),
                        new Chapter(
                            'c02',
                            'theater/p01/e05_c02.ks',
                            new AchievementCondition(
                                true,
                                null,
                                {
                                    [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_FORTUNE_TELLER], null),
                                    [CHARACTER_ID_RITSU]: new CharacterCondition([ROLE_ID_WEREWOLF], null),
                                },
                            ),
                        ),
                        new Situation(
                            5,
                            [
                                new Participant(CHARACTER_ID_ZUNDAMON, ROLE_ID_FORTUNE_TELLER),
                                new Participant(CHARACTER_ID_RITSU, ROLE_ID_WEREWOLF),
                            ],
                        ),
                    );
                case 'e06':
                    return new Episode(
                        pageId,
                        episodeId,
                        'ボイボ寮の噂話#1',
                        'theater/p01_e06_thumb.png',
                        '【解放条件】<br>ずんだもんと春日部つむぎが人狼陣営かつ退場した状態で敗北する',
                        '特定のシチュエーションではないためプレイできません', // 「人狼陣営」なのでどちらがどちらでもよいのでシチュを作れない。かつe03で代用できるため問題なし
                        new Chapter(
                            'c01',
                            'theater/p01/e06_c01.ks'
                        ),
                        new Chapter(
                            'c02',
                            'theater/p01/e06_c02.ks',
                            new AchievementCondition(
                                false,
                                FACTION_VILLAGERS,
                                {
                                    [CHARACTER_ID_ZUNDAMON]: new CharacterCondition([ROLE_ID_WEREWOLF, ROLE_ID_MADMAN], false),
                                    [CHARACTER_ID_TSUMUGI]: new CharacterCondition([ROLE_ID_WEREWOLF, ROLE_ID_MADMAN], false),
                                },
                            ),
                        ),
                        null,
                    );
                case 'e07':
                    return new Episode(
                        pageId,
                        episodeId,
                        '寮長争奪決定戦',
                        'theater/p01_e07_thumb.png',
                        '【解放条件】<br>引き分けでゲームが終了する',
                        '特定のシチュエーションではないためプレイできません',
                        new Chapter(
                            'c01',
                            'theater/p01/e07_c01.ks'
                        ),
                        new Chapter(
                            'c02',
                            'theater/p01/e07_c02.ks',
                            new AchievementCondition(
                                null,
                                FACTION_DRAW_BY_REVOTE,
                                null,
                            ),
                        ),
                        null,
                    );
                case 'e08':
                    return new Episode(
                        pageId,
                        episodeId,
                        '誰が人狼ゲームを始めたのだ？',
                        'theater/p01_e08_thumb.png',
                        '【解放条件】<br>他の1期・2期のシアターを全て解放してからゲームに勝利する',
                        '特定のシチュエーションではないためプレイできません',
                        new Chapter(
                            'c01',
                            'theater/p01/e08_c01.ks'
                        ),
                        new Chapter(
                            'c02',
                            'theater/p01/e08_c02.ks',
                            new AchievementCondition(
                                true,
                                null,
                                null,
                            ),
                        ),
                        null,
                    );
                default:
                    alert('存在しないepisodeIdが指定されました episodeId=' + episodeId);
                    return;
            }
        // おまけ
        case 'p99':
            switch (episodeId) {
                case 'e02':
                    return new Episode(
                        pageId,
                        episodeId,
                        '【ゲーム】ボイボ人狼 #2【絶賛開発中】',
                        'theater/紹介動画02サムネ.png',
                        '解決編はありません',
                        '紹介動画の元ネタです',
                        new Chapter(
                            'c01',
                            'theater/page99/movie_20230814.ks'
                        ),
                        null,
                        null,
                    );
                case 'e03':
                    return new Episode(
                        pageId,
                        episodeId,
                        '【ゲーム】ボイボ人狼 #3【開発終盤！】',
                        'theater/シアターサムネ仮01.png',
                        '解決編はありません',
                        '紹介動画の元ネタです',
                        new Chapter(
                            'c01',
                            'theater/page99/movie_20240803.ks'
                        ),
                        null,
                        null,
                    );
            }
        default:
            alert('存在しないpageIdが指定されました pageId' + pageId);
            return;
    }
}
