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
[playse storage="theater/p01/e01/001.ogg"]
うわあああ！？ない！ないのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="通常"]
[playse storage="theater/p01/e01/002.ogg"]
どうしたのよずんだもん、朝から騒々しいわね。[p]

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="theater/p01/e01/003.ogg"]
どうもこうもないのだ！[r]
僕のずんだもちがないのだ！[p]

[playse storage="theater/p01/e01/004.ogg"]
朝ごはんに食べようと思って冷蔵庫に入れてたのに、起きたら綺麗さっぱりなくなってたのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="クスクス"]
[playse storage="theater/p01/e01/005.ogg"]
ああ、昨日遊びに来たずん子たちのおみやげよね。[r]
まさに翡翠の宝玉…頬が落ちるくらい美味しかったわ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="悲しみ" side="left"]
[playse storage="theater/p01/e01/006.ogg"]
…もしかしてめたんが犯人なのだ？[r]
めたんならやりかねないのだ…！[p]

[m_changeCharacterFrameName name="四国めたん" face="恥ずかしい"]
[playse storage="theater/p01/e01/007.ogg"]
ご、誤解しないでちょうだい。[r]
今のはわたくしの分を食べたときの感想よ。[p]

[playse storage="theater/p01/e01/008.ogg"]
こうしてボイボ寮に住んでいる今、そんな食い意地の張ったことしないわよ。[r]
テント暮らしだったあの頃ならともかくね。[p]

[m_changeCharacterFrameName name="四国めたん" face="目閉じ"]
[playse storage="theater/p01/e01/009.ogg"]
…たぶん。[p]

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="theater/p01/e01/010.ogg"]
のだ！？[p]

[m_changeCharacterFrameName name="四国めたん" face="通常"]
[playse storage="theater/p01/e01/011.ogg"]
そもそも、ちゃんと名前は書いておいたの？[r]
書いてなければ文句は言えないわよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/012.ogg"]
…あ。[p]

[m_changeCharacterFrameName name="四国めたん" face="真剣"]
[playse storage="theater/p01/e01/013.ogg"]
はあ…いつも言ってるじゃない。[r]
「自分の物には名前を書くこと。書いてない物はみんなの物」[p]

[playse storage="theater/p01/e01/014.ogg"]
ボイボ寮ではそういうルールなのよ。[p]

[playse storage="theater/p01/e01/015.ogg"]
わたくしたちはここで共同生活をしてるの。[r]
これだけの人数が一緒に暮らすには、一人ひとりがルールを守る意識が必要だわ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="theater/p01/e01/016.ogg"]
だけど、だったら余計に誰のかも分からない物を食べるのはよくないのだ！[p]

[playse storage="theater/p01/e01/017.ogg"]
犯人は誰なのだ…！？[r]
こたろう？ミコ？はう？それとも――[p]

[stopse buf="0"]

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
[playse storage="theater/p01/e01/018.ogg"]
な、なんなのだ…？[r]
一瞬、目の前がグニャってしたような…。[p]

[playse storage="theater/p01/e01/019.ogg"]
それに、誰かの名前を言おうとしてたはずなのだ。[r]
だけど変なのだ。誰のことなのか、全然思い出せないのだ。[p]

[m_changeCharacterFrameName name="四国めたん" face="困惑"]
[playse storage="theater/p01/e01/020.ogg"]
何よ、急にブツブツ言い始めて。要領を得ないわね。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="テンアゲ"]
[playse storage="theater/p01/e01/021.ogg"]
おはよう、ずんだもん先輩、めたん先輩。[r]
今日は早いね！[p]

[m_changeCharacterFrameName name="雨晴はう" face="通常" side="left"]
[playse storage="theater/p01/e01/022.ogg"]
今、僕たちの名前を呼びましたか？[p]

[m_changeCharacterFrameName name="波音リツ" face="通常"]
[playse storage="theater/p01/e01/023.ogg"]
こんな朝から元気に炎上中とは。[r]
ちょっと三行で説明を頼む。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="theater/p01/e01/024.ogg"]
そ、そうなのだ！[r]
つむぎ、はう、リツ！聞いてほしいのだ！[p]

[playse storage="theater/p01/e01/025.ogg"]
僕のずんだもちが誰かに食べられたのだ！[r]
確かに名前は書き忘れたけど、勝手に食べるのは良くないのだ！[p]

[playse storage="theater/p01/e01/026.ogg"]
誰か、犯人を知らないのだ？[p]

[m_changeCharacterFrameName name="雨晴はう" face="考える"]
[playse storage="theater/p01/e01/027.ogg"]
なるほど、事情は分かりました。[r]
ですが、僕には心当たりないですね…。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="通常" side="left"]
[playse storage="theater/p01/e01/028.ogg"]
あーしも違うよ。[r]
ただこうなると、犯人が名乗り出てくれることはなさそうだよね。[p]

[m_changeCharacterFrameName name="波音リツ" face="通常"]
[playse storage="theater/p01/e01/029.ogg"]
ああ、それなら私にいい考えがある。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
[playse storage="theater/p01/e01/030.ogg"]
もしかして犯人を探す方法があるのだ？[p]

[m_changeCharacterFrameName name="波音リツ" face="煽り"]
[playse storage="theater/p01/e01/031.ogg"]
人狼ゲームで犯人を決めようじゃないか。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="theater/p01/e01/032.ogg"]
えっ？[p]

[m_changeCharacterFrameName name="四国めたん" face="通常"]
[playse storage="theater/p01/e01/033.ogg"]
それがいいわ。[r]
「揉め事は人狼ゲームで決すべし」。ボイボ寮の掟よね。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="ワクワク"]
[playse storage="theater/p01/e01/034.ogg"]
さんせーい！[r]
みんなで人狼するの久しぶりだね。[p]

[m_changeCharacterFrameName name="雨晴はう" face="安心"]
[playse storage="theater/p01/e01/035.ogg"]
人狼ゲームなら平等ですね。[r]
誰が犯人でも恨みっこなしです。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="theater/p01/e01/036.ogg"]
ちょ、ちょっと待つのだ！[r]
そんなルールは初耳なのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="真剣"]
[playse storage="theater/p01/e01/037.ogg"]
あなたもボイボ寮の住人なら覚悟を決めなさい！[p]

[m_changeCharacterFrameName name="波音リツ" face="笑顔"]
[playse storage="theater/p01/e01/038.ogg"]
さあ、配役を決めてゲームスタートだ！[p]


; チャプターここまで
*end

; 初回プレイ時用の特殊処理
[iscript]
  tf.isFirstStartup = (getTheaterProgress('p01', 'e01') === EPISODE_STATUS.INTRO_LOCKED_AVAILABLE);
[endscript]

[t_teardownChapter pageId="&f.pageId" episodeId="&f.episodeId" chapterId="&f.chapterId"]

; 初回プレイ時は直接チュートリアルモードでシチュエーションプレイを始める
[jump storage="tutorial/tutorialSubroutines.ks" target="*toFirstInstruction" cond="tf.isFirstStartup"]

[jump storage="theater/main.ks" target="*start"]
[s]
