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

;このゲームで登場する全キャラクターを宣言、表情登録
[call storage="./chara/common.ks" target="*registerAllCharacters"]

[playbgm storage="honwakapuppu.ogg" volume="12" sprite_time="50-75000"]
[m_changeFrameWithId][p]


[m_changeCharacterFrameName name="もち子さん" face="normal"]
[playse storage="chara/mochiko/movie_20230814/001_もち子さん（ノーマル）_こんにちは、もち子….mp3"]
こんにちは、もち子です。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="normal"]
[playse storage="chara/miko/movie_20230814/002_櫻歌ミコ（ノーマル）_ミコだよ。.mp3"]
ミコだよ。[p]

[m_changeCharacterFrameName name="もち子さん" face="introduce"]
[playse storage="chara/mochiko/movie_20230814/003_もち子さん（ノーマル）_今日は、VOICE….mp3"]
今日は、VOICEVOXのキャラクターたちによる人狼ゲーム、[r]
ボイボ人狼の開発状況をお届けいたします。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="introduce"]
[playse storage="chara/miko/movie_20230814/004_櫻歌ミコ（ノーマル）_前回の動画から結構….mp3"]
前回の動画から結構時間が経ったけど、どうなったの？[p]

[m_changeCharacterFrameName name="もち子さん" face="wry_smile"]
[playse storage="chara/mochiko/movie_20230814/005_もち子さん（ノーマル）_もちろん絶賛開発中….mp3"]
もちろん絶賛開発中ですよ。けど仕事が忙しくて…。[p]

[m_changeCharacterFrameName name="櫻歌ミコ"]
[playse storage="chara/miko/movie_20230814/006_櫻歌ミコ（ノーマル）_どれくらい？.mp3"]
どれくらい？[p]

[m_changeCharacterFrameName name="もち子さん" face="tired"]
[playse storage="chara/mochiko/movie_20230814/007_もち子さん（ノーマル）_はうちゃんよりはち….mp3"]
はうちゃんよりはちょっとマシなくらい…。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="sad"]
[playse storage="chara/miko/movie_20230814/008_櫻歌ミコ（ノーマル）_あっ….mp3"]
あっ…（察し）[p]

[m_changeCharacterFrameName name="もち子さん" face="smile"]
[playse storage="chara/mochiko/movie_20230814/009_もち子さん（ノーマル）_そんなことよりこれ….mp3"]
そんなことよりこれ見てください！[r]
少し前に大ニュースがあったんですよ！[p]

; 表情差分戻すだけ
[m_changeCharacter characterId="miko" face="normal"]

[playse storage="chara/mochiko/movie_20230814/010_もち子さん（ノーマル）_なんと私もち子、規….mp3"]
なんと私もち子、[r]
規約改定によりゲームに登場できるようになりました！[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="excite"]
[playse storage="chara/miko/movie_20230814/011_櫻歌ミコ（ノーマル）_ってことはもち子ち….mp3"]
ってことはもち子ちゃんも一緒に、[r]
本当にボイボ寮のみんなで人狼ゲームできるんだね！[p]

[playse storage="chara/miko/movie_20230814/012_櫻歌ミコ（ノーマル）_これには投稿主も大….mp3"]
これには投稿主も大喜び！[l]

[m_changeCharacterFrameName name="櫻歌ミコ" face="surprised"]
[playse storage="chara/miko/movie_20230814/013_櫻歌ミコ（ノーマル）_…って泣いちゃった….mp3"]
…って泣いちゃった！？[p]

[m_changeCharacterFrameName name="もち子さん" face="normal"]
[playse storage="chara/mochiko/movie_20230814/014_もち子さん（ノーマル）_嬉し泣きももちろん….mp3"]
嬉し泣きももちろんあるのですが、[r]
もう一つの理由はいいねに書いておきます。[p]

; 表情差分戻すだけ
[m_changeCharacter characterId="miko" face="normal"]

[playse storage="chara/mochiko/movie_20230814/015_もち子さん（ノーマル）_さて、本題の開発状….mp3"]
さて、本題の開発状況のご報告に入ります。[p]

[playse storage="chara/mochiko/movie_20230814/016_もち子さん（ノーマル）_ボイボ人狼および人….mp3"]
ボイボ人狼および人狼プラグインのバージョンは、[r]
前回時点のver0.6からver0.9にアップデートされました！[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="normal"]
[playse storage="chara/miko/movie_20230814/017_櫻歌ミコ（ノーマル）_バージョンって言っ….mp3"]
バージョンって言っても適当だから、数字に意味はないんだよね。[r]
具体的にはどこが変わったの？[p]

[m_changeCharacterFrameName name="もち子さん" face="wry_smile"]
[playse storage="chara/mochiko/movie_20230814/018_もち子さん（ノーマル）_裏側では完成版リリ….mp3"]
裏側では完成版リリースに向けた機能追加をしたり、[r]
シナリオを書いたりしてますが、まだ詳しくは見せられません。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="astonished"]
[playse storage="chara/miko/movie_20230814/019_櫻歌ミコ（ノーマル）_勿体ぶるね。.mp3"]
勿体ぶるね。[p]

[m_changeCharacterFrameName name="もち子さん" face="plotting"]
[playse storage="chara/mochiko/movie_20230814/020_もち子さん（ノーマル）_（まあGitHub….mp3"]
（まあGitHubに行けばほぼ全部見られますけど）[p]

[m_changeCharacterFrameName name="もち子さん"]
[playse storage="chara/mochiko/movie_20230814/021_もち子さん（ノーマル）_代わりに、見た目に….mp3"]
代わりに、[r]
見た目にも聞いた耳にも分かりやすい更新箇所を紹介します！[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="surprised"]
[playse storage="chara/miko/movie_20230814/022_櫻歌ミコ（ノーマル）_「聞いた耳」なんて….mp3"]
「聞いた耳」なんて聞いたことないよ！？[p]

[m_changeCharacterFrameName name="もち子さん" face="introduce"]
[playse storage="chara/mochiko/movie_20230814/023_もち子さん（ノーマル）_まあまあ、とにかく….mp3"]
まあまあ、とにかく大きく変わったのはこちらです。[p]

[playse storage="chara/mochiko/movie_20230814/024_もち子さん（ノーマル）_昼時間夜時間開始時….mp3"]
昼時間夜時間開始時の演出強化！[l][r]

[playse storage="chara/mochiko/movie_20230814/025_もち子さん（ノーマル）_セリフ、立ち絵差分….mp3"]
セリフ、立ち絵差分を大幅追加！[l][r]

[playse storage="chara/mochiko/movie_20230814/026_もち子さん（ノーマル）_ゲーム内情報が確認….mp3"]
ゲーム内情報が確認できるステータス画面実装！[p]

[playse storage="chara/mochiko/movie_20230814/027_もち子さん（ノーマル）_という情報を知って….mp3"]
という情報を知っていただいたうえで、[r]
最新のテストプレイ動画をご覧ください。[p]

[playse storage="シーン切り替え1.ogg" loop="false" volume="50"]
[mask time="1000" effect="rotateIn" graphic="voivojinrou_green.png" folder="bgimage"]
#
[m_changeCharacter characterId="mochiko" face="normal"]
[m_changeCharacter characterId="miko" face="gao_smile"]
[m_changeFrameWithId characterId="miko"]

[wait time="2000"]

; SE
[mask_off]

[m_changeCharacterFrameName name="櫻歌ミコ" face="gao_smile"]
[playse storage="chara/miko/movie_20230814/028_櫻歌ミコ（ノーマル）_人狼陣営の勝利！が….mp3"]
人狼陣営の勝利！がうがう！[p]

[m_changeCharacterFrameName name="もち子さん" face="wry_smile"]
[playse storage="chara/mochiko/movie_20230814/029_もち子さん（ノーマル）_2日目になってから….mp3"]
2日目になってから初COすることもできる、と紹介しようとしたら、[r]
狂人のめたんさんを破綻させてしまいました。[p]

[playse storage="chara/mochiko/movie_20230814/030_もち子さん（ノーマル）_とはいえリツさんは….mp3"]
とはいえリツさんはめたんさんの方に投票してしまったので、[r]
結果的には1期生の連携プレイが決まったと言える…かも？[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="normal"]
[playse storage="chara/miko/movie_20230814/031_櫻歌ミコ（ノーマル）_立ち絵とセリフのパ….mp3"]
立ち絵とセリフのパターンが増えたおかげで、[r]
みんなの議論がすごく活き活きして見えたよ。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="introduce"]
[playse storage="chara/miko/movie_20230814/032_櫻歌ミコ（ノーマル）_1日目にはうちゃん….mp3"]
1日目にはうちゃんが、つむぎちゃんともんちゃんに疑われたけど、[r]
はうちゃんのリアクションが違ったよね？[p]

[m_changeCharacterFrameName name="もち子さん" face="normal"]
[playse storage="chara/mochiko/movie_20230814/033_もち子さん（ノーマル）_キャラクターたちは….mp3"]
キャラクターたちは信頼度というパラメータを持っています。[r]
相手への信頼度によってセリフが変わるんです。[p]

[playse storage="chara/mochiko/movie_20230814/034_もち子さん（ノーマル）_あの時点で占い師の….mp3"]
あの時点で占い師のはうさん視点では、[r]
つむぎさんは村人、ずんだもんちゃんは人狼で確定していました。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="normal"]
[playse storage="chara/miko/movie_20230814/035_櫻歌ミコ（ノーマル）_だから、味方のつむ….mp3"]
だから、味方のつむぎちゃんに疑われたら悲しんで、[r]
敵のずんちゃんに疑われたら呆れてたんだ。[p]

[m_changeCharacterFrameName name="もち子さん"]
[playse storage="chara/mochiko/movie_20230814/036_もち子さん（ノーマル）_信頼度はゲーム中の….mp3"]
信頼度はゲーム中の行動で増減して、[r]
キャラクターの思考にも影響します。[p]

[playse storage="chara/mochiko/movie_20230814/037_もち子さん（ノーマル）_相手が論理的に敵陣….mp3"]
相手が論理的に敵陣営でも信頼度が高ければ、[r]
味方陣営だと信じようとすることもあるんですよ。[p]

[m_changeCharacterFrameName name="櫻歌ミコ"]
[playse storage="chara/miko/movie_20230814/038_櫻歌ミコ（ノーマル）_人狼ゲーム的には正….mp3"]
人狼ゲーム的には正解ではないかもしれないけど、[r]
信頼度があるから人間っぽさが生まれるんだね。[p]

[m_changeCharacterFrameName name="もち子さん" face="introduce"]
[playse storage="chara/mochiko/movie_20230814/039_もち子さん（ノーマル）_それから、ステータ….mp3"]
それから、ステータス画面の実装も完了しました。[r]
前回はステータスボタンを押しても何も起きなかったんです。[p]

[playse storage="chara/mochiko/movie_20230814/040_もち子さん（ノーマル）_推理に必要な生存者….mp3"]
推理に必要な生存者や投票先、占い結果などの情報は、[r]
この画面で確認することができますよ。[p]

[m_changeCharacterFrameName name="櫻歌ミコ"]
[playse storage="chara/miko/movie_20230814/041_櫻歌ミコ（ノーマル）_あれ、このずんちゃ….mp3"]
あれ、このずんちゃんたちのアイコンは…！[p]

[m_changeCharacterFrameName name="もち子さん" face="smile"]
[playse storage="chara/mochiko/movie_20230814/042_もち子さん（ノーマル）_はい、VOICEV….mp3"]
はい、VOICEVOXのエイプリルフール企画、[r]
ぼいばけで配布されたSDキャラ立ち絵をお借りしました！[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="smile"]
[playse storage="chara/miko/movie_20230814/043_櫻歌ミコ（ノーマル）_画像がちっちゃくて….mp3"]
画像がちっちゃくても誰が誰だか分かりやすいね。[p]

[m_changeCharacterFrameName name="もち子さん" face="normal"]
[playse storage="chara/mochiko/movie_20230814/044_もち子さん（ノーマル）_こうして沢山の素材….mp3"]
こうして沢山の素材をお借りして作成しているボイボ人狼、[r]
まだまだ開発中ですが、確実に公開に近づいています。[p]

[playse storage="chara/mochiko/movie_20230814/045_もち子さん（ノーマル）_公開まで、今しばら….mp3"]
公開まで、今しばらく待っていただけると嬉しいです。[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="gao"]
[playse storage="chara/miko/movie_20230814/046_櫻歌ミコ（ノーマル）_ミコも早く人狼にな….mp3"]
ミコも早く人狼になりたい！[p]

[m_changeCharacterFrameName name="もち子さん" face="smile"]
[playse storage="chara/mochiko/movie_20230814/047_もち子さん（ノーマル）_ミコちゃんに食べて….mp3"]
ミコちゃんに食べてもらうためにも頑張ります！[p]

[m_changeCharacterFrameName name="櫻歌ミコ" face="embarrassed"]
[playse storage="chara/miko/movie_20230814/048_櫻歌ミコ（ロリ）_…あのね、もち子ち….mp3"]
…あのね、もち子ちゃんとは一緒に人狼になりたい…かも。[p]

[m_changeCharacterFrameName name="もち子さん" face="heart"]
[playse storage="chara/mochiko/movie_20230814/049_もち子さん（ノーマル）_ふおあああ！絶対や….mp3"]
ふああああっ！絶対やりましょう！何回でも！がおー！[p]

[m_changeFrameWithId]
#
[p]

[eval exp="f.quickShowDetail = true"]

[j_clearFixButton]
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[layopt layer="message0" visible="false"]
[jump storage="theater/main.ks" target="*start"]
[s]
