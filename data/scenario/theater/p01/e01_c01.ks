; タイトル：誰がずんだもちを食べたのだ？（導入編）

*start
; ここからチャプターごとに設定が必要な項目
[iscript]
// このチャプターを表す通し番号
f.pageId    = 'p01';
f.episodeId = 'e01';
f.chapterId = 'c01';

// 出演キャラリスト
tf.actorsList = [
    CHARACTER_ID_ZUNDAMON,
    CHARACTER_ID_METAN,
    CHARACTER_ID_TSUMUGI,
    CHARACTER_ID_HAU,
    CHARACTER_ID_RITSU,
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

; 「はじめに」表示
[layopt layer="message0" visible="false"]
[bg storage="black.png" time="1000"]
[playse storage="chime.ogg" buf="1" loop="false" volume="55" sprite_time="50-20000"]

[ptext layer="1" x="90" y="150" text="はじめに" color="#f7f7f7" size="60" time="1000" width="1100" align="center"]
[ptext layer="1" x="90" y="320" text="本作品は、VOICEVOX公式様や<br>各キャラクター運営様とは無関係の個人が制作した、<br>非公式二次創作ゲームです。" color="#f7f7f7" size="44" time="1000" width="1100" align="center"]

[p]
[freeimage layer="1" time="1000" wait="true"]

[ptext layer="1" x="90" y="100" text="本作品は以下の要素を含みます。" color="#f7f7f7" size="44" time="1000" width="1100" align="center"]
[ptext layer="1" x="70" y="200" text="・テキスト読み上げソフトウェアVOICEVOX製の合成音声<br>・公式と異なる独自設定を含むキャラクター描写<br>・既存作品にインスパイアされた表現<br>・人狼ゲーム由来の過激な単語<br>・メタ要素" color="#f7f7f7" size="44" time="1000" width="1140" align="left"]
[ptext layer="1" x="90" y="560" text="以上をご理解のうえ、お楽しみください。" color="#f7f7f7" size="44" time="1000" width="1100" align="center"]

[p]
[freeimage layer="1" time="2000" wait="true"]

[t_setupChapter actorsList="&tf.actorsList" bgParams="&tf.bgParams" playbgmParams="&tf.playbgmParams"]

; ここからチャプター視聴開始


[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="chara/zundamon/01-01/001_ずんだもん（なみだめ）_うわあ！？ない！な….ogg" sprite_time="50-20000"]
うわあああ！？ない！ないのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="通常"]
[playse storage="chara/metan/01-01/002_四国めたん（ノーマル）_どうしたのよずんだ….ogg" sprite_time="50-20000"]
どうしたのよずんだもん、朝から騒々しいわね。[p]

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="chara/zundamon/01-01/003_ずんだもん（なみだめ）_どうもこうもないの….ogg" sprite_time="50-20000"]
どうもこうもないのだ！[r]
僕のずんだもちがないのだ！[p]

[playse storage="chara/zundamon/01-01/004_ずんだもん（なみだめ）_朝ごはんに食べよう….ogg" sprite_time="50-20000"]
朝ごはんに食べようと思って冷蔵庫に入れてたのに、起きたら綺麗さっぱりなくなってたのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="クスクス"]
[playse storage="chara/metan/01-01/005_四国めたん（ノーマル）_ああ、昨日遊びに来….ogg" sprite_time="50-20000"]
ああ、昨日遊びに来たずん子たちのおみやげよね。[r]
まさに翡翠の宝玉…頬が落ちるくらい美味しかったわ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="悲しみ" side="left"]
[playse storage="chara/zundamon/01-01/006_ずんだもん（ノーマル）_…もしかしてめたん….ogg" sprite_time="50-20000"]
…もしかしてめたんが犯人なのだ？[r]
めたんならやりかねないのだ…！[p]

[m_changeCharacterFrameName name="四国めたん" face="恥ずかしい"]
[playse storage="chara/metan/01-01/007_四国めたん（ノーマル）_ご、誤解しないでち….ogg" sprite_time="50-20000"]
ご、誤解しないでちょうだい。[r]
今のはわたくしの分を食べたときの感想よ。[p]

[playse storage="chara/metan/01-01/008_四国めたん（ノーマル）_こうしてボイボ寮に….ogg" sprite_time="50-20000"]
こうしてボイボ寮に住んでいる今、そんな食い意地の張ったことしないわよ。[r]
テント暮らしだったあの頃ならともかくね。[p]

[m_changeCharacterFrameName name="四国めたん" face="目閉じ"]
[playse storage="chara/metan/01-01/009_四国めたん（ささやき）_…たぶん。.ogg" sprite_time="50-20000"]
…たぶん。[p]

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="chara/zundamon/01-01/010_ずんだもん（ノーマル）_のだ！？.ogg" sprite_time="50-20000"]
のだ！？[p]

[m_changeCharacterFrameName name="四国めたん" face="通常"]
[playse storage="chara/metan/01-01/011_四国めたん（ノーマル）_そもそも、ちゃんと….ogg" sprite_time="50-20000"]
そもそも、ちゃんと名前は書いておいたの？[r]
書いてなければ文句は言えないわよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="chara/zundamon/01-01/012_ずんだもん（ノーマル）_…あ。.ogg" sprite_time="50-20000"]
…あ。[p]

[m_changeCharacterFrameName name="四国めたん" face="真剣"]
[playse storage="chara/metan/01-01/013_四国めたん（ノーマル）_はあ…いつも言って….ogg" sprite_time="50-20000"]
はあ…いつも言ってるじゃない。[r]
「自分の物には名前を書くこと。書いてない物はみんなの物」[p]

[playse storage="chara/metan/01-01/014_四国めたん（ノーマル）_ボイボ寮ではそうい….ogg" sprite_time="50-20000"]
ボイボ寮ではそういうルールなのよ。[p]

[playse storage="chara/metan/01-01/015_四国めたん（ノーマル）_わたくしたちはここ….ogg" sprite_time="50-20000"]
わたくしたちはここで共同生活をしてるの。[r]
これだけの人数が一緒に暮らすには、一人ひとりがルールを守る意識が必要だわ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="chara/zundamon/01-01/016_ずんだもん（ノーマル）_だけど、だったら余….ogg" sprite_time="50-20000"]
だけど、だったら余計に誰のかも分からない物を食べるのはよくないのだ！[p]

[playse storage="chara/zundamon/01-01/017_ずんだもん（ノーマル）_犯人は誰なのだ…！….ogg" sprite_time="50-20000"]
犯人は誰なのだ…！？[r]
こたろう？ミコ？はう？それとも――[p]


; TODO 使う箇所が増えたらマクロ化する
[playse storage="ufo03.ogg" buf="1" volume="50" sprite_time="100-4100"]
[layopt layer="message0" visible="false"]
[layopt layer="1" opacity="210"]
[image storage="TVStaticColor03.gif" layer="1" width="1280" height="900" visible="true" time="2000" wait="true"]
[fadeoutse buf="1" time="2100"]
[freeimage time="2000" wait="true" layer="1"]
[layopt layer="1" opacity="255"]
[layopt layer="message0" visible="true"]


[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="chara/zundamon/01-01/018_ずんだもん（ヘロヘロ）_な、なんなのだ…？….ogg" sprite_time="50-20000"]
な、なんなのだ…？[r]
一瞬、目の前がグニャってしたような…。[p]

[playse storage="chara/zundamon/01-01/019_ずんだもん（ヘロヘロ）_それに、誰かの名前….ogg" sprite_time="50-20000"]
それに、誰かの名前を言おうとしてたはずなのだ。[r]
だけど変なのだ。誰のことなのか、全然思い出せないのだ。[p]

[m_changeCharacterFrameName name="四国めたん" face="困惑"]
[playse storage="chara/metan/01-01/020_四国めたん（ノーマル）_何よ、急にブツブツ….ogg" sprite_time="50-20000"]
何よ、急にブツブツ言い始めて。要領を得ないわね。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="テンアゲ"]
[playse storage="chara/tsumugi/01-01/021_春日部つむぎ（ノーマル）_おはよう、ずんだも….ogg" sprite_time="50-20000"]
おはよう、ずんだもん先輩、めたん先輩。[r]
今日は早いね！[p]

[m_changeCharacterFrameName name="雨晴はう" face="通常" side="left"]
[playse storage="chara/hau/01-01/022_雨晴はう（ノーマル）_今、僕たちの名前を….ogg" sprite_time="50-20000"]
今、僕たちの名前を呼びましたか？[p]

[m_changeCharacterFrameName name="波音リツ" face="通常"]
[playse storage="chara/ritsu/01-01/023_波音リツ（ノーマル）_こんな朝から元気に….ogg" sprite_time="50-20000"]
こんな朝から元気に炎上中とは。[r]
ちょっと三行で説明を頼む。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="chara/zundamon/01-01/024_ずんだもん（ノーマル）_そ、そうなのだ！つ….ogg" sprite_time="50-20000"]
そ、そうなのだ！[r]
つむぎ、はう、リツ！聞いてほしいのだ！[p]

[playse storage="chara/zundamon/01-01/025_ずんだもん（ノーマル）_僕のずんだもちが誰….ogg" sprite_time="50-20000"]
僕のずんだもちが誰かに食べられたのだ！[r]
確かに名前は書き忘れたけど、勝手に食べるのは良くないのだ！[p]

[playse storage="chara/zundamon/01-01/026_ずんだもん（ノーマル）_誰か、犯人を知らな….ogg" sprite_time="50-20000"]
誰か、犯人を知らないのだ？[p]

[m_changeCharacterFrameName name="雨晴はう" face="考える"]
[playse storage="chara/hau/01-01/027_雨晴はう（ノーマル）_なるほど、事情は分….ogg" sprite_time="50-20000"]
なるほど、事情は分かりました。[r]
ですが、僕には心当たりないですね…。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="通常" side="left"]
[playse storage="chara/tsumugi/01-01/028_春日部つむぎ（ノーマル）_あーしも違うよ。た….ogg" sprite_time="50-20000"]
あーしも違うよ。[r]
ただこうなると、犯人が名乗り出てくれることはなさそうだよね。[p]

[m_changeCharacterFrameName name="波音リツ" face="通常"]
[playse storage="chara/ritsu/01-01/029_波音リツ（ノーマル）_ああ、それなら私に….ogg" sprite_time="50-20000"]
ああ、それなら私にいい考えがある。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
[playse storage="chara/zundamon/01-01/030_ずんだもん（ノーマル）_もしかして犯人を探….ogg" sprite_time="50-20000"]
もしかして犯人を探す方法があるのだ？[p]

[m_changeCharacterFrameName name="波音リツ" face="煽り"]
[playse storage="chara/ritsu/01-01/031_波音リツ（ノーマル）_人狼ゲームで犯人を….ogg" sprite_time="50-20000"]
人狼ゲームで犯人を決めようじゃないか。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="chara/zundamon/01-01/032_ずんだもん（ノーマル）_えっ？　.ogg" sprite_time="50-20000"]
えっ？[p]

[m_changeCharacterFrameName name="四国めたん" face="通常"]
[playse storage="chara/metan/01-01/033_四国めたん（ノーマル）_それがいいわ。「揉….ogg" sprite_time="50-20000"]
それがいいわ。[r]
「揉め事は人狼ゲームで決すべし」。ボイボ寮の掟よね。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="ワクワク"]
[playse storage="chara/tsumugi/01-01/034_春日部つむぎ（ノーマル）_さんせーい！みんな….ogg" sprite_time="50-20000"]
さんせーい！[r]
みんなで人狼するの久しぶりだね。[p]

[m_changeCharacterFrameName name="雨晴はう" face="安心"]
[playse storage="chara/hau/01-01/035_雨晴はう（ノーマル）_人狼ゲームなら平等….ogg" sprite_time="50-20000"]
人狼ゲームなら平等ですね。[r]
誰が犯人でも恨みっこなしです。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="chara/zundamon/01-01/036_ずんだもん（ノーマル）_ちょ、ちょっと待つ….ogg" sprite_time="50-20000"]
ちょ、ちょっと待つのだ！[r]
そんなルールは初耳なのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="真剣"]
[playse storage="chara/metan/01-01/037_四国めたん（ノーマル）_あなたもボイボ寮の….ogg" sprite_time="50-20000"]
あなたもボイボ寮の住人なら覚悟を決めなさい！[p]

[m_changeCharacterFrameName name="波音リツ" face="笑顔"]
[playse storage="chara/ritsu/01-01/038_波音リツ（ノーマル）_さあ、配役を決めて….ogg" sprite_time="50-20000"]
さあ、配役を決めてゲームスタートだ！[p]


; チャプターここまで
*end

; 初回プレイ時用の特殊処理
[iscript]
  tf.isFirstStartup = (getTheaterProgress('p01', 'e01', 'c01') === THEATER_LOCKED);
[endscript]

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]

; 初回プレイ時は直接チュートリアルモードでシチュエーションプレイを始める
[jump storage="tutorial/tutorialSubroutines.ks" target="*toFirstInstruction" cond="tf.isFirstStartup"]

[jump storage="theater/main.ks" target="*start"]
[s]
