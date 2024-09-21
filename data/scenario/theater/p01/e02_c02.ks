; タイトル：わたくしの千里眼―サウザンドアイ―に死角なし！（解決編）

*start
; ここからチャプターごとに設定が必要な項目
[iscript]
// このチャプターを表す通し番号
f.pageId    = 'p01';
f.episodeId = 'e02';
f.chapterId = 'c02';

// 出演キャラリスト
tf.actorsList = [
    CHARACTER_ID_ZUNDAMON,
    CHARACTER_ID_METAN,
    CHARACTER_ID_HAU,
];

// 初期背景用パラメータ
tf.bgParams = {
    storage: "living_day_nc238325.jpg",
}

// 初期BGM用パラメータ
tf.playbgmParams = {
    storage: "honwakapuppu.ogg",
    volume: "12",
}
[endscript]
[t_setupChapter actorsList="&tf.actorsList" bgParams="&tf.bgParams" playbgmParams="&tf.playbgmParams"]

; ここからチャプター視聴開始

; TODO
注意：このエピソードは開発中につき、最低限のテキストと立ち絵しか実装されていません。[p]

[m_changeCharacterFrameName name="四国めたん"]
ほら見たでしょう！？[r]
さあ、わたくしの力のお陰で勝てたと言いなさい！[p]

[m_changeCharacterFrameName name="ずんだもん"]
ゲームはゲームなのだ。[r]
占い師の能力と千里眼は関係ないのだ。[p]

[m_changeCharacterFrameName name="四国めたん"]
なっ…！[r]
あんた、味方だったのに裏切るつもり！？[p]

それなら、はうさんの件はどうなの？[r]
部屋に来るタイミングを完璧に言い当てたじゃない！[p]

[m_changeCharacterFrameName name="ずんだもん"]
そもそも、はうが起きてくる時間は毎週大体この時間なのだ。[r]
千里眼なんて使わなくたって、僕でも知ってるのだ。[p]

[m_changeCharacterFrameName name="四国めたん"]
ぐ…ぐぬぬ…！[p]

[m_changeCharacterFrameName name="雨晴はう"]
まあまあ、落ち着いてください、ずんだもん。[r]
あんまり否定するのは良くないですよ。[p]

それじゃあめたんさん。[r]
今日の僕が何時に帰って来られるか、見てもらってもいいですか？[p]

[m_changeCharacterFrameName name="四国めたん"]
ふ、ふふっ。そのくらいなら造作もないわ。[r]
さあ、全てを見通す千里眼よ、わたくしに時の壁を超える力を…！[p]

[m_changeCharacterFrameName name="ずんだもん"]
……。[p]

[m_changeCharacterFrameName name="雨晴はう"]
……。[p]

[m_changeCharacterFrameName name="四国めたん"]
ぐ…！[r]
ぐぬぬぬぬ…！[p]

くっ…どうして…？はうさんの帰宅時間が見えない…！[r]
まだまだ力不足だとでも言うの…！？[p]

[m_changeCharacterFrameName name="雨晴はう"]
はうう…やっぱり…。[r]
めたんさんの千里眼…本物かもしれません…！[p]

[m_changeCharacterFrameName name="ずんだもん"]
はう、今日のお仕事も頑張れなのだ…。[p]


; チャプターここまで
*end

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]
[jump storage="theater/main.ks" target="*start"]
[s]
