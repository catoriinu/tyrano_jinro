*instruction

[iscript]
  // もち子さんの立ち絵を追加で登録する
  tf.registerCharacterList = [CHARACTER_ID_MOCHIKO];
[endscript]
[call storage="./chara/common.ks" target="*addRegisterCharacters"]
; もち子さんにフィルターをかける
; MEMO: フィルターをかけた責任としてチュートリアルが完了する箇所でfree_filterしておくこと。
; ただしプレイヤー途中でゲームを抜けてしまうことを防ぐことはできないので、次に立ち絵を読み込んだタイミングでもfree_filterしておくこと。
[filter name="mochiko" brightness="30"]

; 本当の初回起動時以外は2回目以降用のシナリオにジャンプさせる
[jump target="*secondInstruction" cond="!f.tutorialList.needFirstInstruction"]


[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
…って、人狼って悪者なんじゃないのだ！？[r]
このままだと僕が犯人ってことにされるのだ！[p]

; もち子さんのセリフ。立ち絵はまだ出さない
[m_changeFrameWithId characterId="mochiko"]
# ？？？
いいえ、それは違います。[r]
人狼ゲームで勝てばいいんですよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
この声は！[p]

; ずんだもんのセリフ。もち子さん立ち絵だけ登場
[m_enterCharacter characterId="mochiko" face="通常"]
[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
…どちら様なのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
…私は…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
私はインストラクターのお姉さんです。[r]
あなたに人狼ゲームのルールと、「ボイボ人狼」の遊び方を説明しにきました。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
今回の村の内訳は「人狼1人、狂人1人、占い師1人、村人2人」です。[r]
…だけで理解できるなら、人狼ゲームの説明はスキップしますね。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
ちなみにこの説明を含めたオープニングは見返せますからね。[r]
後ほどシアターモードから「誰がずんだもちを食べたのだ？」の「チュートリアルをプレイする」を選べばOKです。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
お姉さんは誰に向かって喋ってるのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="苦笑"]
まあまあ、気にしないでください。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
ということで、あなたに人狼ゲームのルール説明をしてもよろしいでしょうか？[p]

[iscript]
  // ボタン生成（初回用）
  f.buttonObjects = [];
  f.buttonObjects.push(new Button(
    'continueInstruction',
    '説明して',
    'center',
    CLASS_GLINK_DEFAULT
  ));
  f.buttonObjects.push(new Button(
    'skipInstruction',
    'スキップして',
    'center',
    CLASS_GLINK_DEFAULT,
    CLASS_GLINK_SELECTED
  ));
[endscript]
[call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]
[jump target="&f.selectedButtonId"]
[s]

*continueInstruction

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
了解です！[r]
それではインストラクションを始めますね！[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
よろしくなのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
こほん…[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
「私たちの村に恐ろしい人狼が忍び込みました！[r]
人狼は村人と見分けが付きませんが、毎朝見つかる無惨な死体が、人狼が紛れ込んでいる証拠です。[p]

村人たちは人狼を追放するために議論と投票を行うことにしました。[r]
彼らはこの村に平和を取り戻せるのか、それとも人狼の餌食と成り果ててしまうのか！」[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
…という設定で、村人陣営と人狼陣営に分かれて戦う会話型サバイバルゲーム、それが人狼ゲームなのです！[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える" side="left"]
「設定」なんて言っちゃっていいのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
いいんです。あくまでこのゲームはそういう「設定」なんですよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
わ、分かったのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
さて、もう少し詳しいルール説明に移りますね。[p]

人狼ゲームは、生存者が議論と投票をする「昼」と、役職の能力を使用する「夜」を繰り返して進みます。[p]

村人陣営と人狼陣営、いずれかの勝利条件を満たしたらゲーム終了となります。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
今回の場合、村人陣営の勝利条件は「2日目の投票までに人狼を追放すること」。[r]
それが達成されなかった場合は人狼陣営の勝利です。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
僕は人狼って言われたのだ。[r]
人狼は、投票から2回逃げ延びられれば勝ちってことでいいのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
はい、その通りです。[p]

; 役職説明画像を出す
[image storage="icon_instruction_v2.png" layer="1" visible="true" left="310" top="30" width="660" height="440" time="600" wait="false"]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
次に、役職について説明します。[r]
今回の参加者は5人なので、人狼陣営は人狼1人と狂人1人、村人陣営は村人2人と占い師1人、という配役になっています。[p]

「村人」は他の役職と違って何の能力も持ちません。だからこそ村人同士で団結して、誰が人狼かを突き止めなくてはなりません。[p]

「占い師」は夜、生存者から一人を選び、その人が[ruby text="クロ"]⚫︎（人狼である）か[ruby text="シロ"]⚪︎（人狼ではない）かを知ることができる能力を持っています。[p]

昼には「自分は占い師だ」と宣言して占い結果を公開できます。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
なお、自分の役職を公開する、または役職の能力の結果を公開することを「[ruby text="カミング"]C[ruby text="アウト"]O」と言います。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
そんな能力ズルいのだ！[r]
占い師に占われて人狼ってバレたらおしまいなのだ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
ずんだもんちゃんの言う通りですね。[r]
だから人狼陣営には対抗手段があります。[p]

「人狼」には、夜時間に生存者を一人襲撃する能力があります。襲撃された人はゲームから脱落します。[r]
そして人狼も、占い師COをすることができます。[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える" side="left"]
あれ？人狼も占いができるのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="苦笑"]
いいえ、人狼は占いの能力は持っていません。[r]
ですから必然的に嘘の占い結果をCOすることになります。[p]

上手く嘘をつけば、逆に本当の占い師の方を偽者だと信じ込ませられるかもしれません。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
ただし、嘘をつくときは十分注意してくださいね。[r]
論理的に破綻したCOをすると偽占い師だとバレてしまいますから。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
き、気を付けるのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
最後の「狂人」は、人狼に味方する村人です。[r]
特殊な能力はありませんが、人狼と同様に占い師COをすることができます。[p]

注意点としては、人狼と狂人はお互いに誰が人狼なのか、狂人なのかを知ることはできません。[p]

[m_changeCharacterFrameName name="ずんだもん" face="呆れ" side="left"]
もしかして、占い師COした狂人が人狼に●を出しちゃうこととか、人狼が狂人を襲撃しちゃうこともありえるのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
はい。ですので誰が味方かはよく見極めるようにしましょうね。[p]

; 役職説明画像を消す
[freeimage layer="1" time="200" wait="true"]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
さて、これで人狼ゲームそのものの説明はおしまいです。[r]
ここからは実際にゲームを進めながら、「ボイボ人狼」の説明をしますね。[p]

[eval exp="f.tutorialList.instruction = true"]

; 右側のキャラ退場、枠リセット
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[return]


*skipInstruction

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
了解です！それでは、ずんだもんちゃんの幸運を祈ります。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
…また会える時を楽しみにしていますね。[p]

[iscript]
  f.tutorialList = {};
[endscript]

[free_filter name="mochiko"]
[return]




*COPhase

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
昼の一番最初はCOフェイズです。[r]
占い師、人狼、狂人は、ここで占い師COをすることができます。[p]

逆にCOフェイズ以外でCOすることはできないのでご注意ください。[p]

占い師COと同時に、占い結果のCOも行います。[r]
占い師は昨夜の占い結果をCOするだけですが、人狼や狂人の場合は、このタイミングで偽の占い結果を決めていただきます。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
ちなみにプレイヤーであるあなたは、誰よりも早くCOするか、他の参加者の様子を見てからCOするかを選ぶことができますよ。[p]

なお、今日ではなく明日以降に占い師COすることもできます。[r]
その際は、COした日までの占い結果をすべてCOしていただきます。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
さあ、どうしますか？[p]

[eval exp="f.tutorialList.COPhase = true"]

; 右側のキャラ退場、枠リセット
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[return]


*discussionPhase
[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
議論フェイズでは生存者同士で議論を行います。[r]
誰が人狼として怪しいのかを全員で話し合うのです。[p]

議論に使えるアクションは「疑う」と「信じる」の2つです。[r]
人狼と疑わしい人には「疑う」を、仲間だと思う人には「信じる」を実行しましょう。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
左上に表示されるアクションボタンを押すと、実行するアクションと相手を選ぶことができますよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える" side="left"]
疑ったり信じたりすると、どうなるのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
ずんだもんちゃんは、仲間だと思っている人に「信じてる」と言われたらどう感じますか？[p]

[m_changeCharacterFrameName name="ずんだもん" face="大喜び" side="left"]
嬉しいのだ！その人のことをもっと信じたくなるのだ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
仲間だと信頼している人に「疑っている」と言われたら？[p]

[m_changeCharacterFrameName name="ずんだもん" face="悲しみ" side="left"]
勘違いだから、僕は味方だって信じてほしいって思うのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
敵だと思っている人に「信じてる」と言われたら？[p]

[m_changeCharacterFrameName name="ずんだもん" face="呆れ" side="left"]
うーん…もしかして僕のことを騙そうとしてるのかもって思っちゃうのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="怒り"]
敵だと思っている人に「疑っている」と言われたら？[p]

[m_changeCharacterFrameName name="ずんだもん" face="ドヤ顔" side="left"]
どうも思わないのだ。そんな人と無理に仲良くなる必要はないのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
つまりそういうことです。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
のだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
アクションを受けると、相手にそんな印象を抱くようになるのです。[r]
ゲーム的に言えば、信頼度が上がったり下がったりするわけですね。[p]

アクションを受けたときの反応、つまりリアクションをよく観察すると、相手からの現在の信頼度が高いか低いか分かるかもしれません。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
そして、アクションは周りの人にも少し影響を与えます。[r]
自分と同じ意見の人は仲間だと思いますし、[r]
自分と異なる意見の人は怪しく思うようになります。[p]

あなたは他の人よりも優先してアクションを実行できます。[r]
あなたが実行しないときは、他の人がアクションを実行します。[p]

[m_changeCharacterFrameName name="ずんだもん" face="自惚れ" side="left"]
それじゃあ、いっぱいアクションしてやるのだ！[r]
僕の言うことは絶対なのだ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
ですが、気をつけてくださいね。時間は有限です。[r]
あまりにも一人で喋りすぎると、反感を買ってしまうかも。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
全員合わせてラウンド数ぶんのアクションをすると、投票フェイズに移ります。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
なら、僕はどうすればいいのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
ずんだもんちゃんは人狼なので、追放されないように立ち回ることが大事です。[r]
まずは自分を信じてくれる味方を増やしてみるのはどうでしょうか？[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
が、がんばるのだ…！[p]

[eval exp="f.tutorialList.discussionPhase = true"]

; 右側のキャラ退場、枠リセット
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[return]


*votePhase

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
さあ、いよいよ投票フェイズです。[p]

ここまでのCO状況や議論の流れをよく考えて、投票したい人を選んでください。[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える" side="left"]
僕が村人陣営だったら人狼っぽい人に投票するのだ。[r]
けど、その人狼は僕なのだ…。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
誰に投票すればいいのか悩むのだ…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
人狼陣営の場合、人狼が生き残るのに不都合な人を追放したいです。[r]
占い師COしている人とか、人狼のことを怪しんでいる人とか。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="苦笑"]
でも、そういう人は他の村人陣営から信頼されていたりします。[r]
投票でも信頼度は上下するので、投票で怪しまれると翌日以降に不利になるかも。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
ちなみに最多得票者が二人以上いた場合、再投票になります。[r]
追放できるのは一日につき一人までですので。[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える" side="left"]
もしずっと再投票になったらどうなるのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
投票は最大でも4回までです。[r]
4回目でも追放する人が決まらなければ引き分けでゲーム終了です。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
では、運命の投票に移りましょう！[p]

[eval exp="f.tutorialList.votePhase = true"]

; 右側のキャラ退場、枠リセット
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[return]


*firstDayNightPhase

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
おめでとうございます！[r]
一日目の追放は免れましたね。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
ド、ドキドキしたのだ…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
でも、休んでいる暇はないですよ。[r]
夜こそ人狼が真の本性を表す時間です！[p]

誰か一人を選んで襲撃してしまいましょう！[p]

[m_changeCharacterFrameName name="ずんだもん" face="悲しみ" side="left"]
どうしても襲わなきゃダメなのだ…？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
ダメです。ずんだもんちゃんは今、血に飢えた恐ろしい人狼…という設定なんですから！[p]

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
うぅ…！[r]
ここまで来たら、とことんやってやるのだー！[p]

[eval exp="f.tutorialList.firstDayNightPhase = true"]

; 右側のキャラ退場、枠リセット
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[free_filter name="mochiko"]
[return]


*secondDayDayPhase

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
これで残り人数は三人。[r]
今日を乗り切れば人狼陣営の勝利です。[p]
[eval exp="f.tutorialList.secondDayDayPhase = true"]

[jump target="endInstruction" cond="f.tutorialList.statusButton"]
最後に、ステータス画面の説明をしますね。[r]
右上の「ステータス」ボタンを押してください。[p]

[jump target="endInstruction" cond="f.tutorialList.statusButton"]
[eval exp="f.tutorialList.thankStatusButton = true"]
右上の「ステータス」ボタンを押してください。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
右上の「ステータス」ボタンを押してください。[p]

[jump target="endInstruction" cond="f.tutorialList.statusButton"]
「ステータス」を押してください。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
「ステータス」を押してくださいってば。[p]

[jump target="endInstruction" cond="f.tutorialList.statusButton"]
「ステータス」を押してくださいよー。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="苦笑"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
「ステータス」を押していただけませんか？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
ほら、画面の右上ですよ。[r]
「ステータス」と書いてあるボタンを押してください。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
あの…早く…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="驚き泣き"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
早く「ステータス」ボタンを押してくださいっ！[p]

[jump target="endInstruction" cond="f.tutorialList.statusButton"]
私、このチュートリアルが終わらないと帰れないんですよぉ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="悲しみ"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
あなたも早くゲームの続きがしたいでしょう？[r]
そんなに意地を張らないでいいじゃないですか。[p]

[jump target="endInstruction" cond="f.tutorialList.statusButton"]
お願いです、私を助けると思って！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
右上の「ステータス」ボタンを押してください。[p]

[jump target="endInstruction" cond="f.tutorialList.statusButton"]
右上の「ステータス」ボタンを押してください。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="げっそり"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
右上の…「ステータス」ボタンを…。[p]

[jump target="endInstruction" cond="f.tutorialList.statusButton"]
あの…こんなに頼んでもダメですか…？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="驚き泣き"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
はっ…！[r]
まさかあなた、私の反応を見て楽しんでます？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="怒り"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
あーっ！[r]
その顔、絶対そうです！間違いないです！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
次はなんて言うんだろうって思ってるんでしょう？[r]
そのくらい私にはお見通しですよ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
全く、困った人ですね。[r]
私がこんなにお願いしてるのに…。[p]

[jump target="endInstruction" cond="f.tutorialList.statusButton"]
今更無駄でしょうけど、もう一度だけ言います。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
右上の「ステータス」ボタンを押してください。[p]

[jump target="endInstruction" cond="f.tutorialList.statusButton"]
…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
はいはい、分かりました。[r]
そっちがその気なら、私にも考えがあります。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
[jump target="endInstruction" cond="f.tutorialList.statusButton"]
強制的にステータス画面に飛ばしちゃいますからね！[r]
えいっ！[p]

[eval exp="f.tutorialList.forceStatusButton = true"]

; ステータス画面に飛ばす
[sleepgame storage="statusJinro.ks" target="*statusJinroMain" next="false"]

[jump target="endInstruction"]

*returnFromEndInstruction

[return]




*statusButton

; ステータス画面では、HTMLがfreeレイヤーに描画されており、それがメッセージレイヤーよりも前面に出ているためメッセージ送りができない状態になっている。
; freeレイヤーのz-indexを下げることで、HTML描画中でもメッセージを表示できるようにする。
[iscript]
  $(".layer.layer_free").css("z-index", 99);
[endscript]

[m_changeCharacterFrameName name="？？？" characterId="mochiko"]

[if exp="f.tutorialList.forceStatusButton"]
  [m_changeCharacterFrameName name="？？？" characterId="mochiko" face="ドヤ顔"]
  ふふふ、どうですか？[r]
  ここでは私に逆らうことなんてできないんですよーだ！[p]

[elsif exp="f.tutorialList.thankStatusButton"]
  [m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
  円滑なゲーム進行にご協力いただき、ありがとうございます！[p]

[endif]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
ここはステータス画面です。[r]
現在の状況や、過去の行動履歴を確認することができます。[p]

; TODO 矢印とかでボタンを指し示したい

「住人一覧」では誰が生存中か、追放や襲撃によって脱落済みかや、役職CO状況を確認できます。[r]
また、プレイヤー自身の役職も確認できますよ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
「投票履歴」では、ある日の投票フェーズで誰が誰に投票したかを確認できます。[r]
再投票が行われた日の履歴は上から下への順番で並んでいます。[p]

「占い履歴」では、どの占い師に、何日目に、何と占われたかを確認できます。[p]

これらの情報を活用して、人狼ゲームを有利に進めましょう！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
もとの画面に戻るには、「もどる」ボタンを押してくださいね。[p]

; freeレイヤーのz-indexを正しい値に戻す。ボタン操作も可能になる。
[iscript]
  $(".layer.layer_free").css("z-index", 9999999);
[endscript]

[eval exp="f.tutorialList.statusButton = true"]

; 右側のキャラ退場、枠リセット
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[return]





*endInstruction

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
さあ、これでインストラクションは終わりです。[r]
あとは自分を信じて、最後まで頑張ってくださいね！[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
ありがとうなのだ！[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
…あの、もう一度質問なのだ。[r]
お姉さんは一体誰なのだ？[p]

お姉さんの声、聞き覚えがあるはずなのに…全然思い出せないのだ。[p]

[m_changeCharacterFrameName name="？？？" face="苦笑" characterId="mochiko"]
…ここでは私はインストラクターのお姉さんです。[r]
それ以上でもそれ以下でもありません。[p]

[m_changeCharacterFrameName name="？？？" face="笑顔" characterId="mochiko"]
心配いりません。いつかまた、きっと会えますよ。[r]
でも、今はまだ、おあずけです。[p]

[m_changeCharacterFrameName name="？？？" face="通常" characterId="mochiko"]
そのときはきっと、ずんだもんちゃんも私を知っているはず。[r]
…ここではないどこかで、また会いましょう。[p]

; 右側のキャラ退場。退場を待つ
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId" wait="true"]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
ま、待つのだっ！[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
…行っちゃったのだ。[r]
本当に、誰だったのだ…？[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
でも、とにかく今は目の前のゲームに集中するのだ。[r]
このまま濡れ衣なんて嫌なのだ！[p]

[eval exp="f.tutorialList.endInstruction = true"]

; 枠リセット
[m_changeFrameWithId]
#

; secondDayDayPhase内のタグに戻り、secondDayDayPhaseの元々の呼び出し元にreturnする
[jump target="*returnFromEndInstruction"]

[return]


*secondInstruction

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
…ってこの状況、前にもあった気がするのだ。[r]
もし僕の記憶が正しければこのあと…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
お困りの方がいればどこにでも駆けつけます！[r]
インストラクターのお姉さん、颯爽登場です！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
あ、あれ、おかしいなぁ…？[r]
あんまり驚いてくれませんね…。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
前にも同じような状況があったのだ。[r]
夢かもしれないけど、確かに見覚えがあるのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
ふぅん、なるほど…。[r]
それじゃあ人狼ゲームとボイボ人狼の説明も要らないですか？[p]

[iscript]
  // チュートリアルリストのフラグ立て
  f.tutorialList.secondInstruction = true;

  // ボタン生成（2回目以降用）
  f.buttonObjects = [];
  f.buttonObjects.push(new Button(
    'continueInstruction',
    '説明して',
    'center',
    CLASS_GLINK_DEFAULT
  ));
  f.buttonObjects.push(new Button(
    'skipSecondInstruction',
    'スキップして',
    'center',
    CLASS_GLINK_DEFAULT,
    CLASS_GLINK_SELECTED
  ));
[endscript]
[call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]
[jump target="&f.selectedButtonId"]
[s]

*skipSecondInstruction

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
了解しました。[r]
でも、せっかくなのでヒントを差し上げます。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
この状況に見覚えがあると言っていましたよね。[r]
であれば、他にも以前と同じことがあるかもしれません。[p]

例えば、ずんだもんちゃんの味方の人が誰なのか、とか。[p]

その人に信頼してもらえるように、積極的に行動してみてはいかがでしょうか。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
あなたが諦めない限り、未来はきっと変えられます。[r]
だって未来は、未だ来てないから「未来」なんですから。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
お姉さん、ありがとうなのだ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
ふふっ。ではまたいつか。[r]
今度は別の形で会えるといいですね。[p]

; 右側のキャラ退場。退場を待つ
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId" wait="true"]

[m_changeCharacterFrameName name="ずんだもん" face="大喜び" side="left"]
…よし、今度こそ僕の無実を証明してやるのだ！[p]

; 枠リセット
[m_changeFrameWithId]
#

[iscript]
  f.tutorialList = {};
[endscript]

[free_filter name="mochiko"]
[return]
