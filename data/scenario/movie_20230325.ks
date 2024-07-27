; 人狼ゲームのメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]


[bg storage="living_day_nc238325.jpg" time="500"]

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
[eval exp="tf.registerCharacterList = array(CHARACTER_ID_MOCHIKO, CHARACTER_ID_MIKO)"]
[call storage="./chara/common.ks" target="*registerCharacters"]

; ゲーム準備js読み込み
[loadjs storage="plugin/jinro/macro/prepareGame.js"]

;[playbgm storage="honwakapuppu.ogg" volume="12" sprite_time="50-75000"]
[m_changeFrameWithId][p]

;[jump target="movie_test"]

[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/001_もち子さん（ノーマル）_こんにちは、もち子….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
こんにちは、もち子です。[p]

[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/002_櫻歌ミコ（ノーマル）_ミコだよ。.ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
ミコだよ。[p]

[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/003_もち子さん（ノーマル）_今日は現在開発中の….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
今日は現在開発中のゲーム、ボイボ人狼のご紹介をいたします。[p]

;[image storage="人狼ゲームやりたいミコ.png" layer="1" visible="true" wait="false" time="300" left="350" top="160"]
[m_changeCharacter characterId="miko" face="excite"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/004_櫻歌ミコ（ノーマル）_人狼！？ミコ、ボイ….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
人狼！？ミコ、ボイボ寮のみんなで人狼ゲームやりたかったんだ！[p]

[m_changeCharacter characterId="mochiko" face="smile"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/005_もち子さん（ノーマル）_ふふっ。ミコさん、….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
ふふっ。ミコさん、前にもそう言ってましたよね。[p]

[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/006_櫻歌ミコ（ノーマル）_だってミコは狼だも….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
だってミコは狼だもん。[r]
ミコより人狼にぴったりな子はいないと思うな。[p]

[m_changeCharacter characterId="mochiko" face="wry_smile"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/007_もち子さん（ノーマル）_ゲーム内でも人狼だ….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
ゲーム内でも人狼だったら吊られちゃいますけどね。[p]

;[freeimage layer="1" wait="false" time="300"]
[m_changeCharacter characterId="mochiko" face="introduce"]
[playse storage="chara/mochiko/movie_20230325/008_もち子さん（ノーマル）_とにかく、まずはど….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
とにかく、まずはテストプレイ動画をご覧ください。[r]
なお、[p]

[m_changeCharacter characterId="miko" face="smile"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/009_櫻歌ミコ（ノーマル）_画面は開発中のもの….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
画面は開発中のものです！[p]

[m_changeCharacter characterId="mochiko" face="surprise"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/010_もち子さん（ノーマル）_そのセリフ、一度言….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
そのセリフ、一度言ってみたかったのに……。[p]


[playse storage="シーン切り替え1.ogg" loop="false"]
[mask time="1000" effect="rotateIn" graphic="voivojinrou_green.png" folder="bgimage"]
#
[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeCharacter characterId="miko" face="excite"]
[m_changeFrameWithId characterId="miko"]

[wait time="2000"]

; SE
[mask_off]

;;[m_changeCharacter characterId="miko" face="normal"]
[chara_mod name="miko" face="normal" time="50" wait="false"]

[playse storage="chara/miko/movie_20230325/011_櫻歌ミコ（ノーマル）_すごい！もんちゃん….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
すごい！もんちゃん勝っちゃったね！[p]

[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/012_もち子さん（ノーマル）_2日目にリッちゃん….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
2日目にリッちゃん先輩とつむぎさんがお互いを信じてしまったときは、どうなるかと思いましたよ。[p]

[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/013_櫻歌ミコ（ノーマル）_最後は負けちゃった….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
最後は負けちゃったけど、つむぎちゃんの動きがいい意味で人狼っぽかったね。[p]

[playse storage="chara/miko/movie_20230325/014_櫻歌ミコ（ノーマル）_1日目からはうちゃ….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
1日目からはうちゃんと一緒にりっちゃんに票合わせをしたり、[r]
もんちゃんを疑って人狼をなすりつけようとしたり。[p]

[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/015_もち子さん（ノーマル）_確かにつむぎさんは….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
確かにつむぎさんは、はうさんを狂人の偽占い師COだと見抜いていましたね。[p]

[playse storage="chara/mochiko/movie_20230325/016_もち子さん（ノーマル）_NPCの思考プロセ….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
NPCの思考プロセスにはまだまだ改良が必要ですが、[r]
現時点でもちゃんと考えている風に動いてくれることが多いですね。[p]

[m_changeCharacter characterId="mochiko" face="introduce"]
[playse storage="chara/mochiko/movie_20230325/017_もち子さん（ノーマル）_ということで改めま….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
ということで改めまして、ボイボ人狼のご紹介です。[p]

[playse storage="chara/mochiko/movie_20230325/018_もち子さん（ノーマル）_ボイボ人狼は、VO….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
ボイボ人狼は、VOICEVOXのキャラクターで人狼ゲームを遊べる、[r]
ティラノスクリプト製のノベルゲームです。[p]

[m_changeCharacter characterId="mochiko" face="normal"]
[playse storage="chara/mochiko/movie_20230325/019_もち子さん（ノーマル）_登場キャラクターは….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
登場キャラクターは、無料で使えるテキスト読み上げソフトウェア、VOICEVOXでおなじみのボイボ寮の面々。[p]

[playse storage="chara/mochiko/movie_20230325/020_もち子さん（ノーマル）_もちろんセリフはフ….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
もちろんセリフはフルボイス。[p]

[m_changeCharacter characterId="miko" face="excite"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/021_櫻歌ミコ（ノーマル）_フルボイボイス！.ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
フルボイボイス！[p]

[m_changeCharacter characterId="mochiko" face="smile"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/022_もち子さん（ノーマル）_そして価格は完全無….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
そして価格は完全無料！[r]
PC（Windows版/Mac版）用のフリーゲームとして公開します。[p]

[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/023_櫻歌ミコ（ノーマル）_お金がかかってるの….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
お金がかかってるのは電気代くらいだもんね。[p]

[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/024_もち子さん（ノーマル）_こうしてゲームが無….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
こうしてゲームが無料で制作、公開できるのも、[r]
VOICEVOXやティラノスクリプトといった制作ツールや、[r]
立ち絵を始めとした各種素材の製作者様方のおかげです。[p]

[m_changeCharacter characterId="miko" face="smile"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/025_櫻歌ミコ（ノーマル）_ありがとうございま….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
ありがとうございます！[p]

[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/026_もち子さん（ノーマル）_さらに、ボイボ人狼….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
さらに、ボイボ人狼の人狼ゲーム部分のシステムは、[r]
ティラノスクリプトのプラグインとして組み込める形で開発しています。[p]

[playse storage="chara/mochiko/movie_20230325/027_もち子さん（ノーマル）_つまり、キャラやセ….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
つまり、キャラやセリフを入れ替えるだけで、誰でもお好みのキャラで人狼ゲームを作れるようにしたいと思っています。[p]

[playse storage="chara/mochiko/movie_20230325/028_もち子さん（ノーマル）_ソースコードはGi….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
ソースコードはGitHub上で公開していますので、ボイボ人狼がどんな仕組みで動いているかもご覧になることができますよ。[p]

[m_changeCharacter characterId="mochiko" face="wry_smile"]
[playse storage="chara/mochiko/movie_20230325/029_もち子さん（ノーマル）_オープンソースとは….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
オープンソースとは言っても、私一人で細々と開発しているだけですが……。[p]

[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/030_櫻歌ミコ（ノーマル）_それで、このゲーム….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
それで、このゲームはいつ遊べるようになるの？[p]

[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/031_もち子さん（ノーマル）_申し訳ございません….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
申し訳ございませんが、ボイボ人狼の公開時期は今のところ未定です。[p]

[playse storage="chara/mochiko/movie_20230325/032_もち子さん（ノーマル）_人狼ゲームとしての….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
人狼ゲームとしての基本システムはほぼ完成しましたが、[r]
バグ修正、演出、ストーリー、機能、役職追加など、やりたいことはまだまだたくさんあります。[p]

[m_changeCharacter characterId="miko" face="introduce"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/033_櫻歌ミコ（ノーマル）_ミコ知ってるよ。そ….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
ミコ知ってるよ。そういうの、エターナるフラグって言うんだよ。[p]

[m_changeCharacter characterId="mochiko" face="surprise"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/034_もち子さん（ノーマル）_分かってますよ！.ogg" loop="false" sprite_time="50-20000"]
# もち子さん
分かってますよ！[p]

[m_changeCharacter characterId="mochiko" face="normal"]
[playse storage="chara/mochiko/movie_20230325/035_もち子さん（ノーマル）_ですからひとまず、….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
ですからひとまず、最低限フリーゲームとして成り立つレベルの完成度になったら公開することを目指しています。[p]

[playse storage="chara/mochiko/movie_20230325/036_もち子さん（ノーマル）_初期実装キャラは動….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
初期実装キャラは動画の通り、1期生と2期生の5人の予定です。[p]

[playse storage="chara/mochiko/movie_20230325/037_もち子さん（ノーマル）_開発状況の進捗は、….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
開発状況の進捗は、動画かツイッターで報告していきますね。[p]

[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/038_櫻歌ミコ（ノーマル）_じゃあ、6期生のミ….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
じゃあ、6期生のミコはいつ人狼できるようになるの？[p]

[m_changeCharacter characterId="mochiko" face="smile"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/movie_20230325/039_もち子さん（ノーマル）_もちろんいつかは登….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
もちろんいつかは登場させたいと思っていますよ。[r]
ミコちゃんはいい子だから、もうちょっと待っていましょうね。[p]

[m_changeCharacter characterId="miko" face="gao"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/movie_20230325/040_櫻歌ミコ（ノーマル）_うー、早く遊ばせて….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
うー、早く遊ばせてくれないと食べちゃうぞ！[r]
がおー！[p]


[mask time="1000" effect="rotateIn" graphic="voivojinrou_title_upper70.png" folder="bgimage"]
[wait time="5000"]
[p]
[mask_off]

*movie_test
[bg storage="voivojinrou_title_upper70.png" time="500"]
[m_executed characterId="zundamon"]
[image storage="人狼ゲームやりたいミコ.png" layer="0" visible="true" time="300" left="370" top="190"]
;[image storage="紹介.png" layer="0" visible="true" time="500" left="700" top="400"]


[m_changeFrameWithId]
#
おわり。[p]

; TODO タイトル画面または戻る前に、キャラの退場、メッセージ枠の削除、ボタンの削除など必要。
;[jump storage="title.ks"]
[s]
