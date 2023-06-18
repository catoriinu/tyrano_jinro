[cm  ]
[clearfix]
[start_keyconfig]


[bg storage="living_day_nc238325.jpg" time="300"]

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


; バックログボタン表示
[j_displayFixButton backlog="true"]


[m_changeCharacterFrameName name="ずんだもん"]
うわあああ！？ない！ないのだ！[p]
/*
[m_changeCharacterFrameName name="四国めたん"]
どうしたのよずんだもん、朝から騒々しい。[p]

[m_changeCharacterFrameName name="ずんだもん"]
どうもこうもないのだ！[r]
僕のずんだもちがないのだ！[p]

朝ごはんに食べようと思って冷蔵庫に入れてたのに[r]
起きたら綺麗さっぱりなくなってたのだ！[p]

[m_changeCharacterFrameName name="四国めたん"]
ああ、昨日遊びに来たずん子たちのおみやげよね。[r]
まさに翡翠の宝玉…頬が落ちるくらい美味しかったわ。[p]

[m_changeCharacterFrameName name="ずんだもん"]
…もしかしてめたんが犯人なのだ？[r]
めたんならやりかねないのだ…！[p]

[m_changeCharacterFrameName name="四国めたん"]
ご、誤解しないでちょうだい。[r]
今のはわたくしがもらった分を食べた感想よ。[p]

テント暮らしだったあの頃ならともかく、[r]
今はそんな食い意地の張ったことしないわよ。[p]

…たぶん。[p]

[m_changeCharacterFrameName name="ずんだもん"]
のだ！？[p]

[m_changeCharacterFrameName name="四国めたん"]
そもそも、ちゃんと名前は書いてあったの？[r]
書いてなければ文句は言えないわよ。[p]

[m_changeCharacterFrameName name="ずんだもん"]
…あ。[p]

[m_changeCharacterFrameName name="四国めたん"]
はあ…いつも言ってるじゃない。[p]

「自分の物には名前を書くこと。書いてない物はみんなの物」[r]
これはボイボ寮の鉄の掟よ。[p]

これだけの人数が一緒に共同生活をしてるのだから、[r]
一人ひとりがルールを守る意識が必要だわ。[p]

[m_changeCharacterFrameName name="ずんだもん"]
だけど、だったら余計に[r]
誰のかも分からない物を食べるのはよくないのだ！[p]

犯人は誰なのだ…！？[r]
こたろう？ミコ？はう？それとも(もち子)ーー[p]

[m_changeFrameWithId]
#
zapzapzap[p]

[m_changeCharacterFrameName name="春日部つむぎ"]
おはようずんだもん先輩、めたん先輩。[r]
今日は早いねー。[p]

[m_changeCharacterFrameName name="雨晴はう"]
今、僕たちの名前を呼びましたか？[p]

[m_changeCharacterFrameName name="波音リツ"]
こんな朝から元気に炎上中とは。[r]
ちょっと三行で説明を頼む。[p]

[m_changeCharacterFrameName name="ずんだもん"]
つむぎ、はう、リツ！聞いてほしいのだ！[p]

僕のずんだもちが誰かに食べられたのだ！[r]
確かに名前は書き忘れたけど、勝手に食べるのは良くないのだ！[r]
誰か、犯人を知らないのだ？[p]

[m_changeCharacterFrameName name="雨晴はう"]
なるほど、事情は分かりました。[r]
ですが、僕には心当たりないですね…。[p]

[m_changeCharacterFrameName name="春日部つむぎ"]
あーしも違うよ。[r]
ただこうなると、犯人が名乗り出てくれることはなさそうだよね。[p]

[m_changeCharacterFrameName name="波音リツ"]
ああ、それなら私にいい考えがある。[p]

[m_changeCharacterFrameName name="ずんだもん"]
もしかして犯人を探す方法があるのだ？[p]

[m_changeCharacterFrameName name="波音リツ"]
人狼ゲームで犯人を決めようじゃないか。[p]

[m_changeCharacterFrameName name="ずんだもん"]
えっ？[p]

[m_changeCharacterFrameName name="四国めたん"]
それがいいわ。[r]
「揉め事は人狼ゲームで決すべし」。ボイボ寮の掟よね。[p]

[m_changeCharacterFrameName name="春日部つむぎ"]
さんせーい！[r]
みんなで人狼するの久しぶりだね。[p]

[m_changeCharacterFrameName name="雨晴はう"]
人狼ゲームなら平等ですね。[r]
誰が犯人でも恨みっこなしです。[p]

[m_changeCharacterFrameName name="ずんだもん"]
ちょ、ちょっと待つのだ！[r]
そんなルールは初耳なのだ！[p]

[m_changeCharacterFrameName name="四国めたん"]
問答無用よ！[p]
*/


[m_changeCharacterFrameName name="波音リツ"]
さあ、配役を決めてゲームスタートだ！[p]

#

[eval exp="f.quickShowDetail = true"]

[j_clearFixButton]
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[layopt layer="message0" visible="false"]
[jump storage="theater/main.ks" target="*start"]
