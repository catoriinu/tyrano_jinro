[cm  ]
[clearfix]
[start_keyconfig]


[bg storage="living_day_nc238325.jpg" time="300"]

;メッセージウィンドウの設定、文字が表示される領域を調整
[position layer="message0" left="53" top="484" width="1174" height="235" margint="65" marginl="75" marginr="80" marginb="65" opacity="220" page="fore"]

;メッセージウィンドウの表示
[layopt layer="message0" visible="true"]

;キャラクターの名前が表示される文字領域
[ptext name="chara_name_area" layer="message0" face="にくまるフォント" color="0x28332a" size=36 x=175 y=505]

;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
[chara_config ptext="chara_name_area"]
; pos_mode:キャラの初期位置はキャラ宣言時に全指定するのでfalse
[chara_config pos_mode="false" memory="true" time="200"]

;このシナリオで登場する全キャラクターを宣言、表情登録
[call target="*registerTheaterParticipants"]
[call storage="./chara/common.ks" target="*registerAllCharacters"]


; バックログボタン表示
;[j_displayFixButton backlog="true"]


[m_changeCharacterFrameName name="ずんだもん" face="deny"]
[playse storage="chara/zundamon/01-01/001_ずんだもん（なみだめ）_うわあ！？ない！な….ogg" sprite_time="50-20000"]
うわあああ！？ない！ないのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="normal"]
[playse storage="chara/metan/01-01/002_四国めたん（ノーマル）_どうしたのよずんだ….ogg" sprite_time="50-20000"]
どうしたのよずんだもん、朝から騒々しいわね。[p]

[m_changeCharacterFrameName name="ずんだもん" face="deny"]
[playse storage="chara/zundamon/01-01/003_ずんだもん（なみだめ）_どうもこうもないの….ogg" sprite_time="50-20000"]
どうもこうもないのだ！[r]
僕のずんだもちがないのだ！[p]

[playse storage="chara/zundamon/01-01/004_ずんだもん（なみだめ）_朝ごはんに食べよう….ogg" sprite_time="50-20000"]
朝ごはんに食べようと思って冷蔵庫に入れてたのに、起きたら綺麗さっぱりなくなってたのだ！[p]

[m_changeCharacterFrameName name="四国めたん" face="smug"]
[playse storage="chara/metan/01-01/005_四国めたん（ノーマル）_ああ、昨日遊びに来….ogg" sprite_time="50-20000"]
ああ、昨日遊びに来たずん子たちのおみやげよね。[r]
まさに翡翠の宝玉…頬が落ちるくらい美味しかったわ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="sad"]
[playse storage="chara/zundamon/01-01/006_ずんだもん（ノーマル）_…もしかしてめたん….ogg" sprite_time="50-20000"]
…もしかしてめたんが犯人なのだ？[r]
めたんならやりかねないのだ…！[p]

[m_changeCharacterFrameName name="四国めたん" face="embarrassed"]
[playse storage="chara/metan/01-01/007_四国めたん（ノーマル）_ご、誤解しないでち….ogg" sprite_time="50-20000"]
ご、誤解しないでちょうだい。[r]
今のはわたくしの分を食べたときの感想よ。[p]

[playse storage="chara/metan/01-01/008_四国めたん（ノーマル）_こうしてボイボ寮に….ogg" sprite_time="50-20000"]
こうしてボイボ寮に住んでいる今、そんな食い意地の張ったことしないわよ。[r]
テント暮らしだったあの頃ならともかくね。[p]

[m_changeCharacterFrameName name="四国めたん" face="blank"]
[playse storage="chara/metan/01-01/009_四国めたん（ささやき）_…たぶん。.ogg" sprite_time="50-20000"]
…たぶん。[p]

[m_changeCharacterFrameName name="ずんだもん" face="deny"]
[playse storage="chara/zundamon/01-01/010_ずんだもん（ノーマル）_のだ！？.ogg" sprite_time="50-20000"]
のだ！？[p]

[m_changeCharacterFrameName name="四国めたん" face="normal"]
[playse storage="chara/metan/01-01/011_四国めたん（ノーマル）_そもそも、ちゃんと….ogg" sprite_time="50-20000"]
そもそも、ちゃんと名前は書いておいたの？[r]
書いてなければ文句は言えないわよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="troubled"]
[playse storage="chara/zundamon/01-01/012_ずんだもん（ノーマル）_…あ。.ogg" sprite_time="50-20000"]
…あ。[p]

[m_changeCharacterFrameName name="四国めたん" face="serious"]
[playse storage="chara/metan/01-01/013_四国めたん（ノーマル）_はあ…いつも言って….ogg" sprite_time="50-20000"]
はあ…いつも言ってるじゃない。[r]
「自分の物には名前を書くこと。書いてない物はみんなの物」[p]

[playse storage="chara/metan/01-01/014_四国めたん（ノーマル）_ボイボ寮ではそうい….ogg" sprite_time="50-20000"]
ボイボ寮ではそういうルールなのよ。[p]

[playse storage="chara/metan/01-01/015_四国めたん（ノーマル）_わたくしたちはここ….ogg" sprite_time="50-20000"]
わたくしたちはここで共同生活をしてるの。[r]
これだけの人数が一緒に暮らすには、一人ひとりがルールを守る意識が必要だわ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="surprised"]
[playse storage="chara/zundamon/01-01/016_ずんだもん（ノーマル）_だけど、だったら余….ogg" sprite_time="50-20000"]
だけど、だったら余計に誰のかも分からない物を食べるのはよくないのだ！[p]

[playse storage="chara/zundamon/01-01/017_ずんだもん（ノーマル）_犯人は誰なのだ…！….ogg" sprite_time="50-20000"]
犯人は誰なのだ…！？[r]
こたろう？ミコ？はう？それとも[p]

[playse storage="ufo03.mp3" buf="1" volume="50" sprite_time="100-4100"]
[layopt layer="message0" visible="false"]
[layopt layer="1" opacity="200"]
[image storage="TVStaticColor03.gif" layer="1" width="1280" height="900" visible="true" time="2000" wait="true"]
[fadeoutse buf="1" time="2100"]
[freeimage time="2000" wait="true" layer="1" ]
[layopt layer="message0" visible="true"]


[m_changeCharacterFrameName name="ずんだもん" face="troubled"]
[playse storage="chara/zundamon/01-01/018_ずんだもん（ヘロヘロ）_な、なんなのだ…？….ogg" sprite_time="50-20000"]
な、なんなのだ…？[r]
一瞬、目の前がグニャってしたような…。[p]

[playse storage="chara/zundamon/01-01/019_ずんだもん（ヘロヘロ）_それに、誰かの名前….ogg" sprite_time="50-20000"]
それに、誰かの名前を言おうとしてたはずなのだ。[r]
だけど変なのだ。誰のことなのか、全然思い出せないのだ。[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="chara/metan/01-01/020_四国めたん（ノーマル）_何よ、急にブツブツ….ogg" sprite_time="50-20000"]
何よ、急にブツブツ言い始めて。要領を得ないわね。[p]

[m_changeCharacterFrameName name="春日部つむぎ"]
[playse storage="chara/tsumugi/01-01/021_春日部つむぎ（ノーマル）_おはよう、ずんだも….ogg" sprite_time="50-20000"]
おはよう、ずんだもん先輩、めたん先輩。[r]
今日は早いね！[p]

[m_changeCharacterFrameName name="雨晴はう"]
[playse storage="chara/hau/01-01/022_雨晴はう（ノーマル）_今、僕たちの名前を….ogg" sprite_time="50-20000"]
今、僕たちの名前を呼びましたか？[p]

[m_changeCharacterFrameName name="波音リツ"]
[playse storage="chara/ritsu/01-01/023_波音リツ（ノーマル）_こんな朝から元気に….ogg" sprite_time="50-20000"]
こんな朝から元気に炎上中とは。[r]
ちょっと三行で説明を頼む。[p]

[m_changeCharacterFrameName name="ずんだもん" face="surprised"]
[playse storage="chara/zundamon/01-01/024_ずんだもん（ノーマル）_そ、そうなのだ！つ….ogg" sprite_time="50-20000"]
そ、そうなのだ！[r]
つむぎ、はう、リツ！聞いてほしいのだ！[p]

[playse storage="chara/zundamon/01-01/025_ずんだもん（ノーマル）_僕のずんだもちが誰….ogg" sprite_time="50-20000"]
僕のずんだもちが誰かに食べられたのだ！[r]
確かに名前は書き忘れたけど、勝手に食べるのは良くないのだ！[p]

[playse storage="chara/zundamon/01-01/026_ずんだもん（ノーマル）_誰か、犯人を知らな….ogg" sprite_time="50-20000"]
誰か、犯人を知らないのだ？[p]

[m_changeCharacterFrameName name="雨晴はう" face="thinking"]
[playse storage="chara/hau/01-01/027_雨晴はう（ノーマル）_なるほど、事情は分….ogg" sprite_time="50-20000"]
なるほど、事情は分かりました。[r]
ですが、僕には心当たりないですね…。[p]

[m_changeCharacterFrameName name="春日部つむぎ"]
[playse storage="chara/tsumugi/01-01/028_春日部つむぎ（ノーマル）_あーしも違うよ。た….ogg" sprite_time="50-20000"]
あーしも違うよ。[r]
ただこうなると、犯人が名乗り出てくれることはなさそうだよね。[p]

[m_changeCharacterFrameName name="波音リツ"]
[playse storage="chara/ritsu/01-01/029_波音リツ（ノーマル）_ああ、それなら私に….ogg" sprite_time="50-20000"]
ああ、それなら私にいい考えがある。[p]

[m_changeCharacterFrameName name="ずんだもん" face="normal"]
[playse storage="chara/zundamon/01-01/030_ずんだもん（ノーマル）_もしかして犯人を探….ogg" sprite_time="50-20000"]
もしかして犯人を探す方法があるのだ？[p]

[m_changeCharacterFrameName name="波音リツ" face="scorn"]
[playse storage="chara/ritsu/01-01/031_波音リツ（ノーマル）_人狼ゲームで犯人を….ogg" sprite_time="50-20000"]
人狼ゲームで犯人を決めようじゃないか。[p]

[m_changeCharacterFrameName name="ずんだもん" face="troubled"]
[playse storage="chara/zundamon/01-01/032_ずんだもん（ノーマル）_えっ？　.ogg" sprite_time="50-20000"]
えっ？[p]

[m_changeCharacterFrameName name="四国めたん" face="normal"]
[playse storage="chara/metan/01-01/033_四国めたん（ノーマル）_それがいいわ。「揉….ogg" sprite_time="50-20000"]
それがいいわ。[r]
「揉め事は人狼ゲームで決すべし」。ボイボ寮の掟よね。[p]

[m_changeCharacterFrameName name="春日部つむぎ" face="excited"]
[playse storage="chara/tsumugi/01-01/034_春日部つむぎ（ノーマル）_さんせーい！みんな….ogg" sprite_time="50-20000"]
さんせーい！[r]
みんなで人狼するの久しぶりだね。[p]

[m_changeCharacterFrameName name="雨晴はう" face="relieved"]
[playse storage="chara/hau/01-01/035_雨晴はう（ノーマル）_人狼ゲームなら平等….ogg" sprite_time="50-20000"]
人狼ゲームなら平等ですね。[r]
誰が犯人でも恨みっこなしです。[p]

[m_changeCharacterFrameName name="ずんだもん" face="surprised"]
[playse storage="chara/zundamon/01-01/036_ずんだもん（ノーマル）_ちょ、ちょっと待つ….ogg" sprite_time="50-20000"]
ちょ、ちょっと待つのだ！[r]
そんなルールは初耳なのだ！[p]

[m_changeCharacterFrameName name="四国めたん"]
[playse storage="chara/metan/01-01/037_四国めたん（ノーマル）_あなたもボイボ寮の….ogg" sprite_time="50-20000"]
あなたもボイボ寮の住人なら覚悟を決めなさい！[p]

[m_changeCharacterFrameName name="波音リツ"]
[playse storage="chara/ritsu/01-01/038_波音リツ（ノーマル）_さあ、配役を決めて….ogg" sprite_time="50-20000"]
さあ、配役を決めてゲームスタートだ！[p]

#


; 視聴済みに更新する
[t_watchIntroProgress pageKey="1" situationKey="1"]


[eval exp="f.quickShowDetail = true"]

[j_clearFixButton]
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[layopt layer="message0" visible="false"]
[jump storage="theater/main.ks" target="*start"]
[s]


*registerTheaterParticipants
[iscript]
    f.participantsIdList = [
        CHARACTER_ID_ZUNDAMON,
        CHARACTER_ID_METAN,
        CHARACTER_ID_TSUMUGI,
        CHARACTER_ID_HAU,
        CHARACTER_ID_RITSU,
        //'mochiko'),
    ];
[endscript]
[return]
[s]
