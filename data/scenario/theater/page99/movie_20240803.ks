; 人狼ゲームのメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]


[bg storage="living_night_open.jpg" time="300"]

;メッセージウィンドウの設定、文字が表示される領域を調整
[position layer="message0" left="53" top="484" width="1174" height="235" margint="65" marginl="75" marginr="80" marginb="65" opacity="210" page="fore"]

;メッセージウィンドウの表示
[layopt layer="message0" visible="true"]

;キャラクターの名前が表示される文字領域
[ptext name="chara_name_area" layer="message0" face="にくまるフォント" color="0x28332a" size=36 x=175 y=505]

;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
[chara_config ptext="chara_name_area"]
; pos_mode:キャラの初期位置はキャラ宣言時に全指定するのでfalse
[chara_config pos_mode="false" memory="true" time="200"]

;このゲームで登場するキャラクターを宣言、表情登録
[eval exp="tf.registerCharacterList = [CHARACTER_ID_MOCHIKO, CHARACTER_ID_MIKO, CHARACTER_ID_ZUNDAMON]"]
[call storage="./chara/common.ks" target="*registerCharacters"]

[playbgm storage="honwakapuppu.ogg" volume="12" sprite_time="50-75000"]
[m_changeFrameWithId][p]


[m_changeCharacterFrameName name="もち子さん" face="笑顔" side="left"]
[playse storage="theater/p99/movie_20240803/001_もち子さん（ノーマル）_VOICEVOX3….ogg" loop="false" sprite_time="50-20000"]
VOICEVOX3周年、おめでとうございます！[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="笑顔でがおー"]
[playse storage="theater/p99/movie_20240803/002_櫻歌ミコ_そして、おかえりな….ogg" loop="false" sprite_time="50-20000"]
そしておかえりなさい！ニコニコ動画！[p]

[m_changeCharacterFrameName name="もち子さん" face="通常" side="left"]
[playse storage="theater/p99/movie_20240803/003_もち子さん（ノーマル）_お久しぶりです。も….ogg" loop="false" sprite_time="50-20000"]
お久しぶりです。もち子です。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="通常"]
[playse storage="theater/p99/movie_20240803/004_櫻歌ミコ（ノーマル）_ミコだよぉ。.ogg" loop="false" sprite_time="50-20000"]
ミコだよ。[p]

[m_changeCharacterFrameName name="もち子さん" face="紹介" side="left"]
[playse storage="theater/p99/movie_20240803/005_もち子さん（ノーマル）_無料のWinMac….ogg" loop="false" sprite_time="50-20000"]
無料のWin/Mac用ゲーム『ボイボ人狼』の進捗動画、第3回をお届けします。[r]
いやはや、すっかり前回の動画から間が空いてしまいました。[p]

[m_changeCharacterFrameName name="櫻歌ミコ"]
[playse storage="theater/p99/movie_20240803/006_櫻歌ミコ（ノーマル）_前回がVOICEV….ogg" loop="false" sprite_time="50-20000"]
前回がVOICEVOX2周年文化祭のときだから、ちょうど1年前だね。[r]
ちゃんと制作続けてたの？エターナってない？[p]

[m_changeCharacterFrameName name="もち子さん" face="企む" side="left"]
[playse storage="theater/p99/movie_20240803/007_もち子さん（ノーマル）_もちろんですよ！こ….ogg" loop="false" sprite_time="50-20000"]
もちろんですよ！[r]
このペースならボイボ3周年に合わせてリリースができる！[p]

[m_changeCharacterFrameName name="もち子さん" face="げっそり" side="left"]
[playse storage="theater/p99/movie_20240803/008_もち子さん（泣き）_…と思っていた時期….ogg" loop="false" sprite_time="50-20000"]
…と思っていた時期が私にもありました。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="説明"]
[playse storage="theater/p99/movie_20240803/009_櫻歌ミコ（ノーマル）_見積もりが甘いよ。.ogg" loop="false" sprite_time="50-20000"]
見積もりが甘いよ。[p]

[m_changeCharacterFrameName name="もち子さん" face="悲しみ" side="left"]
[playse storage="theater/p99/movie_20240803/010_もち子さん（泣き）_うぅ…面目ありませ….ogg" loop="false" sprite_time="50-20000"]
うぅ…面目ありません。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="通常"]
[m_changeCharacterFrameName name="もち子さん" face="通常" side="left"]
[playse storage="theater/p99/movie_20240803/011_もち子さん（ノーマル）_さて、気を取り直し….ogg" loop="false" sprite_time="50-20000"]
さて、気を取り直しまして。[r]
先ほどから私たちの背後で流れているのが、『ボイボ人狼』の最新のプレイ動画です。[p]

[playse storage="theater/p99/movie_20240803/012_もち子さん（ノーマル）_ここ1年でアップデ….ogg" loop="false" sprite_time="50-20000"]
ここ1年でアップデートした機能をいくつかご紹介していくと…[p]

[m_changeCharacterFrameName name="もち子さん" face="紹介" side="left"]
[playse storage="theater/p99/movie_20240803/013_もち子さん（ノーマル）_ボタンの配置やデザ….ogg" loop="false" sprite_time="50-20000"]
ボタンの配置やデザインなどのUIを調整！[r]
喋り始めるキャラが基本的に左側に表示されるよう統一！[p]

[playse storage="theater/p99/movie_20240803/014_もち子さん（ノーマル）_ポーズメニュー、コ….ogg" loop="false" sprite_time="50-20000"]
ポーズメニュー、コンフィグ画面実装！[r]
各種音量調整のほか、キャラの呼称を色で区別できる機能を実装！[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="笑顔"]
[playse storage="theater/p99/movie_20240803/015_櫻歌ミコ（ノーマル）_確かに、議論中に誰….ogg" loop="false" sprite_time="50-20000"]
確かに、議論中に誰かの名前を呼ぶときに下線が引いてあるね。[p]

[m_changeCharacterFrameName name="もち子さん" face="説明" side="left"]
[playse storage="theater/p99/movie_20240803/016_もち子さん（ノーマル）_こうしないと、将来….ogg" loop="false" sprite_time="50-20000"]
こうしないと、将来困ってしまう人たちがいますからね。[r]
線の太さは「なし」「下線」「塗りつぶし」から選べます。[r]
そして他にも…[p]

[playse storage="theater/p99/movie_20240803/017_もち子さん（ノーマル）_内部処理を効率化！….ogg" loop="false" sprite_time="50-20000"]
内部処理を効率化！[r]
キャラの性格パラメータや信頼度増減システムの見直し！[r]
人狼ゲーム外のやりこみ要素を実装！[p]

[m_changeCharacterFrameName name="もち子さん" face="苦笑" side="left"]
[playse storage="theater/p99/movie_20240803/018_もち子さん（ノーマル）_などなど、ここ1年….ogg" loop="false" sprite_time="50-20000"]
などなど、ここ1年で開発は確実に進んでいるのですが、ゲームの見た目はそんなに変わっていません。[p]

[playse storage="theater/p99/movie_20240803/019_もち子さん（ノーマル）_そういう状態なので….ogg" loop="false" sprite_time="50-20000"]
そういう状態なので、進捗報告としてお出ししにくいんですよね。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="やれやれ"]
[playse storage="theater/p99/movie_20240803/020_櫻歌ミコ（ノーマル）_共感できる人は同類….ogg" loop="false" sprite_time="50-20000"]
共感できる人は同類だね。[p]

[m_changeCharacterFrameName name="もち子さん" face="通常" side="left"]
[playse storage="theater/p99/movie_20240803/021_もち子さん（ノーマル）_現在は人狼ゲーム部….ogg" loop="false" sprite_time="50-20000"]
現在は人狼ゲーム部分のシステムはほとんど完成していて、残りは後回しにしていたタスクを潰していくフェーズに入っています。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="わくわく"]
[playse storage="theater/p99/movie_20240803/022_櫻歌ミコ（ノーマル）_やっと完成が見えて….ogg" loop="false" sprite_time="50-20000"]
やっと完成が見えてきたね！わくわく！[p]

[m_changeCharacterFrameName name="もち子さん" side="left"]
[playse storage="theater/p99/movie_20240803/023_もち子さん（ノーマル）_そうですね、少なく….ogg" loop="false" sprite_time="50-20000"]
そうですね、少なくとも今までほどお待たせすることはありません。[p]

[playse storage="theater/p99/movie_20240803/024_もち子さん_現在の見積もりでは….ogg" loop="false" sprite_time="50-20000"]
現在の見積もりでは、今年中にギリギリ公開できるかどうか…といったところでしょうか。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="がおー"]
[playse storage="theater/p99/movie_20240803/025_櫻歌ミコ_間に合わなかったら….ogg" loop="false" sprite_time="50-20000"]
間に合わなかったら食べちゃうぞ！[l][r]

[m_changeCharacterFrameName name="櫻歌ミコ" face="恥ずかしい"]
[playse storage="theater/p99/movie_20240803/026_櫻歌ミコ_ってそれじゃあごほ….ogg" loop="false" sprite_time="50-20000"]
ってそれじゃあごほうびにしかならないからダメか。[p]

[m_changeCharacterFrameName name="もち子さん" face="げっそり" side="left"]
[playse storage="theater/p99/movie_20240803/027_もち子さん_ぐぬぬ、バレてまし….ogg" loop="false" sprite_time="50-20000"]
ぐぬぬ、バレてましたか。[p]

[m_changeCharacterFrameName name="もち子さん" face="通常" side="left"]
[playse storage="theater/p99/movie_20240803/024_もち子さん（ノーマル）_それでは次は、先ほ….ogg" loop="false" sprite_time="50-20000"]
それでは次は先ほど少し触れた、人狼ゲーム外のやりこみ要素をご紹介します。[p]

[m_changeCharacterFrameName name="もち子さん" face="紹介" side="left"]
[playse storage="theater/p99/movie_20240803/025_もち子さん（ノーマル）_『ボイボ人狼』は人….ogg" loop="false" sprite_time="50-20000"]
『ボイボ人狼』は人狼ゲームを遊べるだけのゲームじゃありません。[r]
このボタンを見てください！[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="通常"]
[playse storage="theater/p99/movie_20240803/026_櫻歌ミコ（ノーマル）_シアター？劇場って….ogg" loop="false" sprite_time="50-20000"]
シアター？劇場ってこと？[p]

[m_changeCharacterFrameName name="もち子さん" face="笑顔" side="left"]
[playse storage="theater/p99/movie_20240803/027_もち子さん（ノーマル）_その通りです！シア….ogg" loop="false" sprite_time="50-20000"]
その通りです！[r]
シアターには、ボイボ寮で起こった様々なエピソードが全8篇収録されています。[p]

[playse storage="theater/p99/movie_20240803/028_もち子さん（ノーマル）_エピソードは導入編….ogg" loop="false" sprite_time="50-20000"]
エピソードは導入編と解決編に分かれていて、解決編は人狼ゲームで特定の条件を満たすと解放されていきます。[p]

[m_changeCharacterFrameName name="櫻歌ミコ"]
[playse storage="theater/p99/movie_20240803/029_櫻歌ミコ（ノーマル）_特定の条件って？.ogg" loop="false" sprite_time="50-20000"]
特定の条件って？[p]

[m_changeCharacterFrameName name="もち子さん" face="紹介" side="left"]
[playse storage="theater/p99/movie_20240803/030_もち子さん（ノーマル）_例えば「引き分けで….ogg" loop="false" sprite_time="50-20000"]
例えば「引き分けでゲームが終了する」「ずんだもん：占い師、波音リツ：人狼でゲームに勝利する」などです。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="やれやれ"]
[playse storage="theater/p99/movie_20240803/031_櫻歌ミコ（ノーマル）_これなんて、既にオ….ogg" loop="false" sprite_time="50-20000"]
これなんて、既にオチが見えるような…。[p]

[m_changeCharacterFrameName name="もち子さん" face="苦笑" side="left"]
[playse storage="theater/p99/movie_20240803/032_もち子さん（ノーマル）_そ、それは見てのお….ogg" loop="false" sprite_time="50-20000"]
そ、それは見てのお楽しみです！[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="説明"]
[playse storage="theater/p99/movie_20240803/033_櫻歌ミコ（ノーマル）_でも、この条件を満….ogg" loop="false" sprite_time="50-20000"]
でも、この条件を満たすのって難しくないの？[r]
配役はランダムなんだよね。[p]

[m_changeCharacterFrameName name="もち子さん" face="通常" side="left"]
[playse storage="theater/p99/movie_20240803/034_もち子さん（ノーマル）_「このシチュエーシ….ogg" loop="false" sprite_time="50-20000"]
「このシチュエーションでプレイする」を選べば、必ずその配役で始めることができますよ。[r]
失敗しても何度でも挑戦できるので、諦めずに頑張りましょう。[p]

[playse storage="theater/p99/movie_20240803/035_もち子さん（ノーマル）_もちろん通常プレイ….ogg" loop="false" sprite_time="50-20000"]
もちろん通常プレイ中に条件を満たしても解放されるので、偶然の出会いを楽しむのもよいですね。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="笑顔"]
[playse storage="theater/p99/movie_20240803/036_櫻歌ミコ（ノーマル）_解放狙いのプレイも….ogg" loop="false" sprite_time="50-20000"]
解放狙いのプレイもできるし、のんびり普通にプレイしても解放されるのは嬉しいね。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="通常"]
[playse storage="theater/p99/movie_20240803/037_櫻歌ミコ（ノーマル）_でも、最初から配役….ogg" loop="false" sprite_time="50-20000"]
でも、最初から配役を知ってるのってちょっとズルいかも。[r]
それって狙い撃ちできちゃうってことだよね。[p]

[m_changeCharacterFrameName name="もち子さん" face="苦笑" side="left"]
[playse storage="theater/p99/movie_20240803/038_もち子さん（ノーマル）_ま、まあそれはゲー….ogg" loop="false" sprite_time="50-20000"]
ま、まあそれはゲームの都合といいますか、そういう「設定」ということでお許しいただければと…。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="驚き"]
[playse storage="theater/p99/movie_20240803/039_櫻歌ミコ（ノーマル）_あっ、もち子ちゃん….ogg" loop="false" sprite_time="50-20000"]
あっ、もち子ちゃん！[r]
そういうメタ発言をしちゃうと――[p]

[bg storage="living_night_open.jpg" time="1" wait="true"]
[playse storage="ufo03.ogg" buf="1" volume="50" sprite_time="100-4100"]
[layopt layer="message0" visible="false"]
[layopt layer="1" opacity="210"]
[image storage="TVStaticColor03.gif" layer="1" width="1280" height="900" visible="true" time="2000" wait="true"]
[fadeoutse buf="1" time="2100"]
; ミコ退場
[m_exitCharacter characterId="miko"]
[freeimage time="2000" wait="true" layer="1"]
[layopt layer="1" opacity="255"]
[layopt layer="message0" visible="true"]

[m_changeCharacterFrameName name="もち子さん" face="悲しみ" side="left"]
[playse storage="theater/p99/movie_20240803/040_もち子さん（ノーマル）_あれ、ミコちゃん？….ogg" loop="false" sprite_time="50-20000"]
あれ、ミコちゃん？[r]
どこに行っちゃったんですか！？[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き"]
[playse storage="theater/p99/movie_20240803/041_ずんだもん（あまあま）_こんな時間に誰なの….ogg" loop="false" sprite_time="50-20000"]
こんな時間に誰なのだ…？[r]
声がうるさくて目が覚めちゃったのだ…。[p]

[m_changeCharacterFrameName name="もち子さん" face="苦笑" side="left"]
[playse storage="theater/p99/movie_20240803/042_もち子さん（ノーマル）_ごめんなさい、ずん….ogg" loop="false" sprite_time="50-20000"]
ごめんなさい、ずんだもんちゃん。[r]
起こしちゃいましたか。[p]

[m_changeCharacterFrameName name="もち子さん" face="通常" side="left"]
[playse storage="theater/p99/movie_20240803/043_もち子さん（ノーマル）_あの、迷惑ついでに….ogg" loop="false" sprite_time="50-20000"]
あの、迷惑ついでにひとつ聞きたいんですけど。[p]

[playse storage="theater/p99/movie_20240803/044_もち子さん（ノーマル）_ミコちゃん知りませ….ogg" loop="false" sprite_time="50-20000"]
ミコちゃん知りませんか？[r]
さっきまでそこにいたんです。[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える"]
[playse storage="theater/p99/movie_20240803/045_ずんだもん（ノーマル）_ミコちゃん？ううん….ogg" loop="false" sprite_time="50-20000"]
ミコちゃん？[r]
ううん、知らないのだ。[p]

[m_changeCharacterFrameName name="もち子さん" face="伏し目" side="left"]
[playse storage="theater/p99/movie_20240803/046_もち子さん（ノーマル）_そうですか…。気を….ogg" loop="false" sprite_time="50-20000"]
そうですか…。[r]
気を悪くさせてしまったなら謝りたいのですが…。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑"]
[playse storage="theater/p99/movie_20240803/047_ずんだもん（ノーマル）_っていうか…お姉さ….ogg" loop="false" sprite_time="50-20000"]
っていうか…お姉さんも、誰なのだ？[p]

[m_changeCharacterFrameName name="もち子さん" face="驚き泣き" side="left"]
[playse storage="theater/p99/movie_20240803/048_もち子さん（ノーマル）_え…っ？.ogg" loop="false" sprite_time="50-20000"]
え…っ？[p]

[mask time="1500" effect="rotateIn" graphic="voivojinrou_title_v4.png" folder="bgimage"]

[m_exitCharacter characterId="&f.displayedCharacter.left.characterId" time="1"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId" time="1"]
[layopt layer="message0" visible="false"]
[bg storage="voivojinrou_title_v4.png" time="1" wait="false"]
[mask_off]

[backlay]
[ptext page="back" layer="1" x="201" y="430" text="To be continued in the Theater" color="#28332a" size="60"]
[trans layer="1" time="1500"]
[wt]
[backlay]
[ptext page="back" layer="1" x="376" y="535" text="2024年内公開！" color="#28332a" size="70"]
[ptext page="back" layer="1" x="900" y="585" text="したい…" color="#28332a" size="30"]
[trans layer="1" time="1500"]
[wt]
[p]

[freeimage layer="1"]

[eval exp="f.quickShowEpisodeWindow = true"]

;[j_clearFixButton]
;[m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
;[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
;[layopt layer="message0" visible="false"]
[jump storage="theater/main.ks" target="*start"]
[s]
