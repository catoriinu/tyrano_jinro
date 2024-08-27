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

[playbgm storage="honwakapuppu.ogg" volume="15" sprite_time="50-75000"]
[m_changeFrameWithId][p]

[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/001_櫻歌ミコ（ノーマル）_ただいまー　.ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
ただいまー[p]


[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/002_もち子さん（ノーマル）_おかえりなさい、ミ….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
おかえりなさい、ミコさん[p]

[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/003_櫻歌ミコ（ノーマル）_あぁ、もち子ちゃん….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
あ、もち子ちゃん。[r]
あっちでりっちゃんたちが集まってたけど、何やってるの？[p]

[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/004_もち子さん（ノーマル）_一期生と二期生のみ….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
1期生と2期生のみなさんで、人狼ゲームをしてるんですよ。[p]

[m_changeCharacter characterId="miko" face="excite"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/005_櫻歌ミコ（ノーマル）_人狼！？ミコもやり….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
人狼！？ミコもやりたい！[p]

[m_changeCharacter characterId="mochiko" face="smile"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/006_もち子さん（ノーマル）_ふふっ。これからゲ….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
ふふっ。[r]
これからゲームが始まるところですからまずは観戦してみましょう。[p]

[playse storage="scenekirikae1.ogg" loop="false"]
[mask time="1000" effect="rotateIn" graphic="voivojinrou_green.png" folder="bgimage"]
#
[m_changeCharacter characterId="mochiko" face="normal"]
;[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="miko"]
; SE
[mask_off]

;;[m_changeCharacter characterId="miko" face="normal"]
[chara_mod name="miko" face="normal" time="50" wait="false"]

[playse storage="chara/miko/007_櫻歌ミコ（ノーマル）_面白かったー！.ogg" loop="false" sprite_time="20-20000"]
# 櫻歌ミコ
面白かったー！[p][p]

[playse storage="chara/miko/008_櫻歌ミコ（ノーマル）_せっかく人狼を見つ….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
せっかく人狼を見つけたのに襲われちゃった、[r]
占い師のめたんちゃんがかわいそうだったね。[p]

[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/009_もち子さん（ノーマル）_再投票になり、リッ….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
再投票になり、リッちゃん先輩を吊れないと分かった瞬間に、[r]
つむぎさんに票を変えたずんだもんちゃんはお見事でした。[p]

[playse storage="chara/mochiko/010_もち子さん（ノーマル）_そして最終日に、ず….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
そして最終日に、[r]
ずんだもんちゃんとはうちゃんが共闘するところも胸熱でしたね。[p]

[m_changeCharacter characterId="miko" face="normal"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/011_櫻歌ミコ（ノーマル）_でも、観戦してたら….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
でも、観戦してたらもっとやりたくなっちゃった。[r]
まだ一緒に遊べないの？[p]

[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeFrameWithId characterId="mochiko"]
[playse storage="chara/mochiko/012_もち子さん（ノーマル）_まずは5人で遊べる….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
まずは5人で遊べるようにするのが優先だそうですが、[r]
そのあとは他の人達も参加できるようにしたいそうですよ。[p]

[m_changeCharacter characterId="mochiko" face="smile"]
[playse storage="chara/mochiko/013_もち子さん（ノーマル）_ミコちゃんはいい子….ogg" loop="false" sprite_time="50-20000"]
# もち子さん
ミコちゃんはいい子だから、もうちょっと待っていましょうね。[p]

[m_changeCharacter characterId="miko" face="gao"]
[m_changeFrameWithId characterId="miko"]
[playse storage="chara/miko/014_櫻歌ミコ（ノーマル）_うー、早く遊ばせて….ogg" loop="false" sprite_time="50-20000"]
# 櫻歌ミコ
うー、早く遊ばせてくれないと食べちゃうぞ！[r]
がおー！[p]

[mask time="1000" effect="rotateIn" graphic="voivojinrou_title.png" folder="bgimage"]
[p]
[mask_off]

[m_changeFrameWithId]
#
おわり。[p]

; TODO タイトル画面または戻る前に、キャラの退場、メッセージ枠の削除、ボタンの削除など必要。
;[jump storage="title.ks"]
[s]
