*startInstruction
[iscript]
  // もち子さんの立ち絵を追加で登録する
  tf.registerCharacterList = [CHARACTER_ID_MOCHIKO];
[endscript]
[call storage="./chara/common.ks" target="*addRegisterCharacters"]
; もち子さんにフィルターをかける
; MEMO: フィルターをかけた責任としてインストラクションが完了する箇所でfree_filterしておくこと。
; ただしプレイヤー途中でゲームを抜けてしまうことを防ぐことはできないので、次に立ち絵を読み込んだタイミングでもfree_filterしておくこと。
[filter name="mochiko" brightness="30"]

; 本当の初回起動時以外は2回目以降用のシナリオにジャンプさせる
[jump target="*secondInstruction" cond="!f.chapterList.flags.isFirstContact"]


[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="se/surprised.ogg" buf="0" volume="60"]
[playse storage="other/01_instruction/001.ogg" buf="1"]
…って、人狼って悪者なんじゃないのだ！？[r]
このままだと僕が犯人ってことにされるのだ！[p]

; もち子さんのセリフ。立ち絵はまだ出さない
[m_changeFrameWithId characterId="mochiko"]
# ？？？
[playse storage="other/01_instruction/002.ogg" buf="1"]
いいえ、それは違います。[r]
人狼ゲームで勝てばいいんですよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="other/01_instruction/003.ogg" buf="1"]
この声は！[p]

; ずんだもんのセリフ。もち子さん立ち絵だけ登場
[m_enterCharacter characterId="mochiko" face="通常"]
[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="other/01_instruction/004.ogg" buf="1"]
…どちら様なのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
[playse storage="other/01_instruction/005.ogg" buf="1"]
…私は…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/006.ogg" buf="1"]
私はインストラクターのお姉さんです。[r]
あなたに人狼ゲームのルールと、「ボイボ人狼」の遊び方を説明しにきました。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/007.ogg" buf="1"]
今回の村の内訳は「人狼1人、狂人1人、占い師1人、村人2人」です。[p]

[playse storage="other/01_instruction/008.ogg" buf="1"]
…と突然言われても、と思った方はこのまま説明をお聞きください。[r]
理解できた方は、人狼ゲームの説明はスキップしても大丈夫です。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
[playse storage="other/01_instruction/009.ogg" buf="1"]
ちなみにこの説明は何度でも見返せます。[r]
タイトル画面の「ヘルプ」から「インストラクションをリプレイ」を選べばOKです。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="se/hatena01-1.ogg" buf="0" volume="60"]
[playse storage="other/01_instruction/010.ogg" buf="1"]
お姉さんは誰に向かって喋ってるのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="苦笑"]
[playse storage="other/01_instruction/011.ogg" buf="1"]
まあまあ、気にしないでください。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[playse storage="other/01_instruction/012.ogg" buf="1"]
ということで、あなたに人狼ゲームのルール説明をしてもよろしいでしょうか？[p]

[stopse buf="1"]
[iscript]
  // ボタン生成（初回用）
  f.buttonObjects = [];
  f.buttonObjects.push(new Button(
    'continueInstruction',
    '全て説明して',
    'center',
    CLASS_GLINK_DEFAULT,
    '',
    'se/button34.ogg',
    'se/button13.ogg',
  ));
  f.buttonObjects.push(new Button(
    'skipInstruction',
    'ボイボ人狼の説明だけ',
    'center',
    CLASS_GLINK_DEFAULT,
    '',
    'se/button34.ogg',
    'se/button13.ogg',
  ));
[endscript]
[call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]
[jump target="&f.selectedButtonId"]
[s]

*continueInstruction
[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="se/kira1.ogg" buf="0" volume="50"]
[playse storage="other/01_instruction/017.ogg" buf="1"]
了解です！[r]
それではご説明いたしましょう！[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
[playse storage="other/01_instruction/018.ogg" buf="1"]
よろしくなのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/019.ogg" buf="1"]
こほん…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[playse storage="other/01_instruction/020.ogg" buf="1"]
「私たちの村に恐ろしい人狼が忍び込みました！[r]
人狼は村人と見分けが付きませんが、毎朝見つかる無惨な死体が、[r]
人狼が紛れ込んでいる証拠です。[p]

[playse storage="other/01_instruction/021.ogg" buf="1"]
村人たちは議論と投票を行い人狼を追放することにしました。[r]
彼らはこの村に平和を取り戻せるのか、それとも人狼の餌食と成り果ててしまうのか！」[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/022.ogg" buf="1"]
…という設定で、村人陣営と人狼陣営に分かれて戦う、[r]
会話型サバイバルゲーム、それが人狼ゲームなのです！[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える" side="left"]
[playse storage="other/01_instruction/023.ogg" buf="1"]
「設定」なんて言っちゃっていいのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[playse storage="other/01_instruction/024.ogg" buf="1"]
いいんです。[r]
あくまでこのゲームはそういう「設定」なんですよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="other/01_instruction/025.ogg" buf="1"]
わ、分かったのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/026.ogg" buf="1"]
さて、もう少し詳しいルール説明に移りますね。[p]

[playse storage="other/01_instruction/027.ogg" buf="1"]
人狼ゲームは、生存者が議論と投票をする「昼」と、[r]
役職の能力を使用する「夜」を繰り返して進みます。[p]

[playse storage="other/01_instruction/028.ogg" buf="1"]
村人陣営と人狼陣営、いずれかの勝利条件を満たしたらゲーム終了となります。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/029.ogg" buf="1"]
村人陣営の勝利条件は「2日目の投票までに人狼を追放すること」。[r]
それが達成されなかった場合は人狼陣営の勝利です。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
[playse storage="other/01_instruction/030.ogg" buf="1"]
僕は人狼って言われたのだ。[r]
人狼は、投票から2回逃げ延びられれば勝ちってことでいいのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/031.ogg" buf="1"]
はい、その通りです。[p]

; 役職説明画像を出す
[image storage="icon_instruction_v2.png" layer="1" visible="true" left="310" top="30" width="660" height="440" time="600" wait="false"]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
[playse storage="other/01_instruction/032.ogg" buf="1"]
次に、役職について説明します。[r]
参加者の5人にはそれぞれ、「村人」「占い師」「人狼」「狂人」のいずれかの役職が配役されています。[p]

[playse storage="other/01_instruction/033.ogg" buf="1"]
人狼と狂人は人狼陣営。村人と占い師は村人陣営です。[r]
あ、村人だけは2人いて、他は1人ずつですね。[p]

[playse storage="other/01_instruction/034.ogg" buf="1"]
「村人」は他の役職と違って何の能力も持ちません。[r]
だからこそよく観察して推理をし、誰が人狼かを突き止めなくてはなりません。[p]

[playse storage="other/01_instruction/035.ogg" buf="1"]
「占い師」は夜、生存者から1人を選び、その人が[ruby text="クロ"]●（人狼である）か[ruby text="シロ"]◯（人狼ではない）かを知ることができる能力を持っています。[p]

[playse storage="other/01_instruction/036.ogg" buf="1"]
昼には「自分は占い師だ」と宣言して占い結果を公開できます。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[playse storage="other/01_instruction/037.ogg" buf="1"]
なお、自分の役職を公開する、または役職の能力を実行した結果を公開することを「[ruby text="カミング"]C[ruby text="アウト"]O」と言います。[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="other/01_instruction/038.ogg" buf="1"]
そんな能力ズルいのだ！[r]
占い師に占われて人狼ってバレたらおしまいなのだ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
[playse storage="other/01_instruction/039.ogg" buf="1"]
ずんだもんちゃんの言う通りですね。[r]
だから人狼陣営には対抗手段があります。[p]

[playse storage="other/01_instruction/040.ogg" buf="1"]
「人狼」には、夜時間に生存者を1人襲撃する能力があります。[r]
襲撃された人はゲームから脱落します。[p]

[playse storage="other/01_instruction/041.ogg" buf="1"]
そして人狼も「自分は占い師だ」と宣言すること…つまり、占い師COをすることができます。[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える" side="left"]
[playse storage="other/01_instruction/042.ogg" buf="1"]
あれ？人狼も占いができるのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="苦笑"]
[playse storage="other/01_instruction/043.ogg" buf="1"]
いいえ、人狼は占いの能力は持っていません。[r]
ですから必然的に嘘の占い結果をCOすることになります。[p]

[playse storage="other/01_instruction/044.ogg" buf="1"]
上手く嘘をつけば、本物の占い師の方を偽者だとみんなに信じ込ませられるかもしれません。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/045.ogg" buf="1"]
ただし、嘘をつくときは十分注意してくださいね。[r]
論理的に破綻したCOをすると偽占い師だとバレてしまいますから。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="other/01_instruction/046.ogg" buf="1"]
き、気を付けるのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/047.ogg" buf="1"]
最後の「狂人」は、人狼に味方する村人です。[r]
人狼と同様に、占い師COをすることができます。[p]

[playse storage="other/01_instruction/048.ogg" buf="1"]
人狼陣営ですが人狼ではないので、占い結果は[ruby text="シロ"]◯となります。[r]
その立場を活用して、村を混乱に陥れるのが狂人の役目です。[p]

[playse storage="other/01_instruction/049.ogg" buf="1"]
注意点としては、人狼と狂人はお互いに、[r]
誰が人狼なのか、狂人なのかを知ることはできません。[p]

[m_changeCharacterFrameName name="ずんだもん" face="呆れ" side="left"]
[playse storage="other/01_instruction/050.ogg" buf="1"]
もしかして、占い師COした狂人が人狼に[ruby text="クロ"]●を出しちゃうこととか、[r]
人狼が狂人を襲撃しちゃうこともありえるのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/051.ogg" buf="1"]
はい。ですので誰が味方かはよく見極めるようにしましょうね。[p]

; 役職説明画像を消す
[freeimage layer="1" time="200" wait="true"]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/052.ogg" buf="1"]
さて、これで人狼ゲームそのものの説明はおしまいです。[r]
ここからは実際にゲームをしつつ「ボイボ人狼」の説明をしますね。[p]

; 右側のキャラ退場、枠リセット
[stopse buf="1"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]



*skipInstruction
[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="se/kira1.ogg" buf="0" volume="50"]
[playse storage="other/01_instruction/014.ogg" buf="1"]
了解です！[r]
それでは人狼ゲーム自体の説明はスキップさせていただきます。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/015.ogg" buf="1"]
ここからは実際にゲームをしつつ「ボイボ人狼」の説明をしますね。[p]

; 右側のキャラ退場、枠リセット
[stopse buf="1"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]



*COPhase
[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/054.ogg" buf="1"]
昼の一番最初はCOフェイズです。[r]
占い師、人狼、狂人は、ここで占い師COをすることができます。[p]

[playse storage="other/01_instruction/055.ogg" buf="1"]
占い師は昨夜の占い結果をCOするだけですが、人狼や狂人の場合は、[r]
このタイミングで偽の占い結果を決めていただきます。[p]

[playse storage="other/01_instruction/056.ogg" buf="1"]
プレイヤーであるあなたは、誰よりも早くCOするか、他の参加者の様子を見てからCOするかを選べますよ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
[playse storage="other/01_instruction/057.ogg" buf="1"]
なお、今日ではなく明日以降に占い師COすることもできます。[r]
その際は、COした日までの占い結果をすべてCOしていただきます。[p]

[playse storage="other/01_instruction/058.ogg" buf="1"]
注意点としては、COフェイズ以外でCOすることはできないので、[r]
タイミングを逃さないようにしましょう。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/059.ogg" buf="1"]
さあ、どうしますか？[p]

; 右側のキャラ退場、枠リセット
[stopse buf="1"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]



*discussionPhase
[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/061.ogg" buf="1"]
議論フェイズでは生存者同士で議論を行います。[r]
誰が人狼として怪しいのかを全員で話し合うのです。[p]

[playse storage="other/01_instruction/062.ogg" buf="1"]
議論に使えるアクションは2つ。敵だと思う人には「疑う」を、[r]
仲間だと思う人には「信じる」を実行しましょう。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[playse storage="other/01_instruction/063.ogg" buf="1"]
左上のアクションボタンを押すと、実行するアクションと相手を選ぶことができますよ。[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える" side="left"]
[playse storage="other/01_instruction/064.ogg" buf="1"]
疑ったり信じたりすると、どうなるのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/065.ogg" buf="1"]
ずんだもんちゃんは、仲間だと思っている人に「信じてる」と言われたらどう思いますか？[p]

[m_changeCharacterFrameName name="ずんだもん" face="大喜び" side="left"]
[playse storage="other/01_instruction/066.ogg" buf="1"]
嬉しいのだ！その人のことをもっと信じたくなるのだ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
[playse storage="other/01_instruction/067.ogg" buf="1"]
仲間だと信頼している人に「疑っている」と言われたら？[p]

[m_changeCharacterFrameName name="ずんだもん" face="悲しみ" side="left"]
[playse storage="other/01_instruction/068.ogg" buf="1"]
勘違いだから、僕は味方だって信じてほしいって思うのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
[playse storage="other/01_instruction/069.ogg" buf="1"]
敵だと思っている人に「信じてる」と言われたら？[p]

[m_changeCharacterFrameName name="ずんだもん" face="呆れ" side="left"]
[playse storage="other/01_instruction/070.ogg" buf="1"]
うーん…もしかして僕のことを騙そうとしてるのかもって思っちゃうのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="怒り"]
[playse storage="other/01_instruction/071.ogg" buf="1"]
敵だと思っている人に「疑っている」と言われたら？[p]

[m_changeCharacterFrameName name="ずんだもん" face="ドヤ顔" side="left"]
[playse storage="other/01_instruction/072.ogg" buf="1"]
どうも思わないのだ。そんな人と無理に仲良くなる必要はないのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/073.ogg" buf="1"]
つまりそういうことです。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="se/hatena01-1.ogg" buf="0" volume="60"]
[playse storage="other/01_instruction/074.ogg" buf="1"]
のだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/075.ogg" buf="1"]
アクションを受けると、相手にそういう感情を抱くようになります。[r]
ゲーム的に言えば、信頼度が増減するわけですね。[p]

[playse storage="other/01_instruction/076.ogg" buf="1"]
アクションを受けたときの反応をよく観察すると、[r]
相手からの今の信頼度が高いか低いか分かるかもしれません。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
[playse storage="other/01_instruction/077.ogg" buf="1"]
そして、アクションは周りの人にも影響します。自分と同意見の人には好印象を抱くし、異なる意見の人は怪しく見えます。[p]

[playse storage="other/01_instruction/078.ogg" buf="1"]
あなたは他の人よりも優先してアクションを実行できます。[r]
あなたが実行しないときは、他の人がアクションを実行します。[p]

[m_changeCharacterFrameName name="ずんだもん" face="自惚れ" side="left"]
[playse storage="other/01_instruction/079.ogg" buf="1"]
それじゃあ、いっぱいアクションしてやるのだ！[r]
僕の言うことは絶対なのだ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
[playse storage="other/01_instruction/080.ogg" buf="1"]
ですが、気をつけてくださいね。時間は有限です。[r]
あまりにも一人で喋りすぎると、反感を買ってしまうかも。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/081.ogg" buf="1"]
全員合わせてラウンド数ぶんのアクションをすると、投票フェイズに移ります。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
[playse storage="other/01_instruction/082.ogg" buf="1"]
なら、僕はどうすればいいのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/083.ogg" buf="1"]
人狼のずんだもんちゃんは、追放されないことが最重要です。[r]
まずは自分を信じてくれる味方を増やしてみてはどうでしょう？[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
[playse storage="other/01_instruction/084.ogg" buf="1"]
が、がんばるのだ…！[p]

; 右側のキャラ退場、枠リセット
[stopse buf="1"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]



*votePhase
[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/086.ogg" buf="1"]
さあ、いよいよ投票フェイズです。[p]

[playse storage="other/01_instruction/087.ogg" buf="1"]
ここまでのCO状況や議論の流れをよく考えて、追放したい人に投票してください。[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える" side="left"]
[playse storage="other/01_instruction/088.ogg" buf="1"]
僕が村人陣営だったら人狼っぽい人に投票するのだ。[r]
けど、その人狼は僕なのだ…。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="se/manuke4.ogg" buf="0" volume="60"]
[playse storage="other/01_instruction/089.ogg" buf="1"]
誰に投票すればいいのか悩むのだ…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/090.ogg" buf="1"]
人狼陣営の場合、人狼が生き残るのに不都合な人を追放したいです。[r]
占い師COしている人や、人狼のことを疑っている人など。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="苦笑"]
[playse storage="other/01_instruction/091.ogg" buf="1"]
ただ、そういう人は他の人から信頼されていることも。[r]
投票先の選択次第でも他の人からの信頼度が変化するので注意です。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/092.ogg" buf="1"]
1日につき、追放されるのは最多得票者になった1人だけです。[r]
2人以上が同票の場合は再投票になります。[p]

[m_changeCharacterFrameName name="ずんだもん" face="考える" side="left"]
[playse storage="other/01_instruction/093.ogg" buf="1"]
もしずっと再投票になったらどうなるのだ？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[playse storage="other/01_instruction/094.ogg" buf="1"]
投票は最大4回です。4回目でも最多得票者が1人に決まらなければ、[r]
引き分けでゲーム終了です。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
[playse storage="other/01_instruction/095.ogg" buf="1"]
それでは、運命の投票に移りましょう！[p]

; 右側のキャラ退場、枠リセット
[stopse buf="1"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]



*firstDayNightPhase
[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/096.ogg" buf="1"]
おめでとうございます！[r]
1日目の追放は免れましたね。[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="other/01_instruction/097.ogg" buf="1"]
ド、ドキドキしたのだ…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
[playse storage="other/01_instruction/098.ogg" buf="1"]
でも、休んでいる暇はないですよ。[r]
夜こそ人狼が本性を表す時間です！[p]

[playse storage="other/01_instruction/099.ogg" buf="1"]
人狼の役職能力で、誰か1人を選んで襲撃してしまいましょう！[p]

[m_changeCharacterFrameName name="ずんだもん" face="悲しみ" side="left"]
[playse storage="other/01_instruction/100.ogg" buf="1"]
どうしても襲わなきゃダメなのだ…？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[playse storage="other/01_instruction/101.ogg" buf="1"]
ダメです。ずんだもんちゃんは今、血に飢えた恐ろしい人狼…[r]
という「設定」なんですから！[p]

[m_changeCharacterFrameName name="ずんだもん" face="否定" side="left"]
[playse storage="other/01_instruction/102.ogg" buf="1"]
うぅ…！[r]
ここまで来たら、とことんやってやるのだー！[p]

; 右側のキャラ退場、枠リセット
[stopse buf="1"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[m_changeFrameWithId]
#

[free_filter name="mochiko"]

; 2日目昼用のチャプターを再生するためにここでtrueにする
[eval exp="f.chapterList.secondDayDayPhase.needPlay = true"]
[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]



*secondDayDayPhase
[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/104.ogg" buf="1"]
これで残り人数は3人。[r]
今日を乗り切れば人狼陣営の勝利です。[p]

; statusButtonチャプターを再生済みなら、ensInstructionに飛ばす
; これまでにステータス画面を開き済みなら再生済みになっているのでここですぐに飛ばされる
; まだステータス画面を開いていなかった場合は、画面から帰ってきたらすぐにendInstructionに飛ばす必要があるので、以降1行ごとにjumpを挟んでおく
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/105.ogg" buf="1"]
最後に、ステータス画面の説明をしますね。[r]
右上の「ステータス」ボタンを押してください。[p]

[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[eval exp="f.chapterList.flags.thankStatusButton = true"]
[playse storage="other/01_instruction/113.ogg" buf="1"]
右上の「ステータス」ボタンを押してください。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/114.ogg" buf="1"]
右上の「ステータス」ボタンを押してください。[p]

[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/115.ogg" buf="1"]
「ステータス」を押してください。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/116.ogg" buf="1"]
「ステータス」を押してくださいってば。[p]

[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/117.ogg" buf="1"]
「ステータス」を押してくださいよー。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="苦笑"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/118.ogg" buf="1"]
「ステータス」を押していただけませんか？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/119.ogg" buf="1"]
ほら、画面の右上ですよ。[r]
「ステータス」と書いてあるボタンを押してください。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="驚き泣き"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/120.ogg" buf="1"]
もう！早く「ステータス」ボタンを押してくださいっ！[p]

[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/121.ogg" buf="1"]
私、このインストラクションが終わらないと帰れないんですよ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="悲しみ"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/122.ogg" buf="1"]
あなたも早くゲームの続きがしたいでしょう？[r]
そんなに意地を張らないでいいじゃないですか。[p]

[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/123.ogg" buf="1"]
お願いです！私を助けると思って！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/124.ogg" buf="1"]
右上の「ステータス」ボタンを押してください。[p]

[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/125.ogg" buf="1"]
右上の「ステータス」ボタンを押してください。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="げっそり"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/126.ogg" buf="1"]
右上の…「ステータス」ボタンを…。[p]

[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/127.ogg" buf="1"]
あの…こんなに頼んでもダメですか…？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="驚き泣き"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/128.ogg" buf="1"]
はっ…！[r]
まさかあなた、私の反応を見て楽しんでます？[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="怒り"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/129.ogg" buf="1"]
あーっ！[r]
その顔、絶対そうです！間違いないです！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="説明"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/130.ogg" buf="1"]
次はなんて言うんだろうって思ってるんでしょう？[r]
そのくらい私にはお見通しですよ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/131.ogg" buf="1"]
全く、困った人ですね。[r]
私がこんなにお願いしてるのに…。[p]

[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/132.ogg" buf="1"]
今更無駄でしょうけど、もう一度だけ言います。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/133.ogg" buf="1"]
右上の「ステータス」ボタンを押してください。[p]

[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/134.ogg" buf="1"]
…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/135.ogg" buf="1"]
はいはい、分かりました。[r]
そっちがその気なら、私にも考えがあります。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="企む"]
[jump target="endInstruction" cond="f.chapterList.flags.playedStatusButton"]
[playse storage="other/01_instruction/136.ogg" buf="1"]
強制的にステータス画面に飛ばしちゃいますからね！[r]
えいっ！[p]

; 強制的にステータス画面に飛ばす
[eval exp="f.chapterList.flags.forceStatusButton = true"]
[sleepgame storage="statusJinro.ks" target="*statusJinroMain" next="false"]

[jump target="endInstruction"]
*returnFromEndInstruction

[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]



*statusButton
; 視聴済みフラグを立てる
[eval exp="f.chapterList.flags.playedStatusButton = true"]

; ステータス画面では、HTMLがfreeレイヤーに描画されており、それがメッセージレイヤーよりも前面に出ているためメッセージ送りができない状態になっている。
; freeレイヤーのz-indexを下げることで、HTML描画中でもメッセージを表示できるようにする。
[iscript]
  $(".layer.layer_free").css("z-index", 99);
[endscript]

; memo:インストラクションでのステータス画面表示中は、キャラの立ち絵を表示する必要はない。
; そもそも立ち絵よりもfreeレイヤーのほうが前面なので、立ち絵は表示されない。

[if exp="f.chapterList.flags.forceStatusButton"]
  [playse storage="other/01_instruction/137.ogg" buf="1"]
  ふっふっふ！どうですか？[r]
  ここでは私に逆らうことなんてできないんですよーだ！[p]

[elsif exp="f.chapterList.flags.thankStatusButton"]
  [playse storage="other/01_instruction/138.ogg" buf="1"]
  円滑なゲーム進行にご協力いただき、ありがとうございます！[p]

[endif]

[playse storage="other/01_instruction/106.ogg" buf="1"]
ここはステータス画面です。[r]
現在の状況や、過去の行動履歴を確認することができます。[p]

; TODO 矢印とかでボタンを指し示したい
[playse storage="other/01_instruction/107.ogg" buf="1"]
「住人一覧」では誰が生存中か脱落済みかや、役職のCO状況を確認できます。また、プレイヤーの役職は常時表示されます。[p]

[playse storage="other/01_instruction/108.ogg" buf="1"]
「投票履歴」では、その日に誰が誰に投票したかを確認できます。[r]
再投票があった日の履歴は上から下への順番で並んでいます。[p]

[playse storage="other/01_instruction/109.ogg" buf="1"]
「占い履歴」では、誰がどの占い師から、何日目に、[ruby text="シロ"]◯[ruby text="クロ"]●どちらと占われたかを確認できます。[p]

[playse storage="other/01_instruction/110.ogg" buf="1"]
これらの情報を活用して、人狼ゲームを有利に進めましょう！[p]

[playse storage="other/01_instruction/111.ogg" buf="1"]
元の画面に戻るには、「もどる」ボタンを押してくださいね。[p]

; freeレイヤーのz-indexを正しい値に戻す。ボタン操作も可能になる。
[iscript]
  $(".layer.layer_free").css("z-index", 9999999);
[endscript]

; 枠リセット
; キャラ退場はしない。そもそもキャラは表示されていないため。
[stopse buf="1"]
[m_changeFrameWithId]
#

[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]



; ※サブルーチンではないため、callではなくjumpで飛んでくること。
*endInstruction
[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/140.ogg" buf="1"]
さあ、これでインストラクションは終わりです。[r]
あとは自分を信じて、最後まで頑張ってくださいね！[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
[playse storage="other/01_instruction/141.ogg" buf="1"]
ありがとうなのだ！[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="se/hatena01-1.ogg" buf="0" volume="60"]
[playse storage="other/01_instruction/142.ogg" buf="1"]
…あの、もう一度質問なのだ。[r]
お姉さんは一体誰なのだ？[p]

[playse storage="other/01_instruction/143.ogg" buf="1"]
お姉さんの声、聞き覚えがあるはずなのに…全然思い出せないのだ。[p]

[m_changeCharacterFrameName name="？？？" face="苦笑" characterId="mochiko"]
[playse storage="other/01_instruction/144.ogg" buf="1"]
…ここでは私はインストラクターのお姉さんです。[r]
それ以上でもそれ以下でもありません。[p]

[m_changeCharacterFrameName name="？？？" face="笑顔" characterId="mochiko"]
[playse storage="other/01_instruction/145.ogg" buf="1"]
心配いりません。いつかまた、どこかで会えますよ。[r]
でも、今はまだ、おあずけです。[p]

[m_changeCharacterFrameName name="？？？" face="通常" characterId="mochiko"]
[playse storage="other/01_instruction/146.ogg" buf="1"]
そのときはきっと、ずんだもんちゃんも私を知っているはず。[r]
…ここではないどこかで、また会いましょう。[p]

; 右側のキャラ退場。退場を待つ
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId" wait="true"]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="other/01_instruction/147.ogg" buf="1"]
ま、待つのだっ！[p]

[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="other/01_instruction/148.ogg" buf="1"]
…行っちゃったのだ。[r]
本当に、誰だったのだ…？[p]

[m_changeCharacterFrameName name="ずんだもん" face="驚き" side="left"]
[playse storage="other/01_instruction/149.ogg" buf="1"]
でも、とにかく今は目の前のゲームに集中するのだ。[r]
このまま濡れ衣なんて嫌なのだ！[p]

; 枠リセット
[stopse buf="1"]
[m_changeFrameWithId]
#

; secondDayDayPhase内のタグに戻り、secondDayDayPhaseの元々の呼び出し元にreturnする。ゆえにこれはサブルーチンとして実装していない。
[jump target="*returnFromEndInstruction"]
[s]



*secondInstruction
[m_changeCharacterFrameName name="ずんだもん" face="困惑" side="left"]
[playse storage="other/01_instruction/165.ogg" buf="1"]
…ってこの状況、前にもあった気がするのだ。[r]
もし僕の記憶が正しければこのあと…。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/166.ogg" buf="1"]
お困りの方がいればどこにでも駆けつけます！[r]
インストラクターのお姉さん、颯爽登場です！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="se/manuke4.ogg" buf="0" volume="60"]
[playse storage="other/01_instruction/167.ogg" buf="1"]
あ、あれ、おかしいですね…？[r]
あんまり驚いてくれませんね…。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
[playse storage="other/01_instruction/168.ogg" buf="1"]
前にも同じような状況があったのだ。[r]
夢かもしれないけど、確かに見覚えがあるのだ。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/169.ogg" buf="1"]
ふぅん、なるほど…。[r]
それでは人狼ゲームと「ボイボ人狼」の説明も要らないですか？[p]

[stopse buf="1"]
[iscript]
  // ボタン生成（2回目以降用）
  f.buttonObjects = [];
  f.buttonObjects.push(new Button(
    'continueInstruction',
    '全て説明して',
    'center',
    CLASS_GLINK_DEFAULT,
    '',
    'se/button34.ogg',
    'se/button13.ogg',
  ));
  f.buttonObjects.push(new Button(
    'skipInstruction',
    'ボイボ人狼の説明だけ',
    'center',
    CLASS_GLINK_DEFAULT,
    '',
    'se/button34.ogg',
    'se/button13.ogg',
  ));
  f.buttonObjects.push(new Button(
    'skipSecondInstruction',
    '全てスキップして',
    'center',
    CLASS_GLINK_DEFAULT,
    CLASS_GLINK_SELECTED,
    'se/button34.ogg',
    'se/button15.ogg',
  ));
[endscript]
[call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]
[jump target="&f.selectedButtonId"]
[s]

*skipSecondInstruction

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/151.ogg" buf="1"]
了解しました。[r]
でも、せっかくなのでヒントを差し上げます。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="紹介"]
[playse storage="other/01_instruction/152.ogg" buf="1"]
この状況に見覚えがあると言っていましたよね。[r]
であれば、他にも以前と同じことがあるかもしれません。[p]

[playse storage="other/01_instruction/153.ogg" buf="1"]
例えば、ずんだもんちゃんの味方の人が誰なのか、とか。[p]

[playse storage="other/01_instruction/154.ogg" buf="1"]
その人に信頼してもらえるように、積極的に行動してみてはいかがでしょうか。[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="笑顔"]
[playse storage="other/01_instruction/155.ogg" buf="1"]
あなたが諦めない限り、未来はきっと変えられます。[r]
だって未来は、未だ来てないから「未来」なんですから。[p]

[m_changeCharacterFrameName name="ずんだもん" face="通常" side="left"]
[playse storage="other/01_instruction/156.ogg" buf="1"]
お姉さん、ありがとうなのだ！[p]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="通常"]
[playse storage="other/01_instruction/157.ogg" buf="1"]
ふふっ。ではまたいつか。[r]
今度は別の形で会えるといいですね。[p]

; 右側のキャラ退場。退場を待つ
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId" wait="true"]
[stopse buf="1"]

[m_changeCharacterFrameName name="ずんだもん" face="大喜び" side="left"]
[playse storage="other/01_instruction/158.ogg" buf="1"]
…よし、今度こそ僕の無実を証明してやるのだ！[p]

[stopse buf="1"]
; 枠リセット
[m_changeFrameWithId]
#

[free_filter name="mochiko"]

[iscript]
  // encourageRetryを除くインストラクションのチャプターの再生フラグを折る
  f.chapterList.COPhase.needPlay = false;
  f.chapterList.discussionPhase.needPlay = false;
  f.chapterList.votePhase.needPlay = false;
  f.chapterList.firstDayNightPhase.needPlay = false;
  f.chapterList.secondDayDayPhase.needPlay = false;
  f.chapterList.statusButton.needPlay = false;
[endscript]
[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget"]
[s]



*encourageRetry
; リトライを促す（つまりこの下でjumpで戻らない）条件
; 「誰がずんだもちを食べたのだ？」が「3:解決編まで解放済み」ではない（＝インストラクションで勝利していない）
[iscript]
  tf.needPlayEncourageRetry = (getTheaterProgress('p01', 'e01') !== EPISODE_STATUS.OUTRO_UNLOCKED);
  console.log('needEncourageRetry: ' + tf.needEncourageRetry);
[endscript]
[jump storage="&f.returnJumpStorage" target="&f.returnJumpTarget" cond="!tf.needPlayEncourageRetry"]

; 左側の立ち絵と、勝利陣営キャラクターのレイヤーを消去する
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId" time="1"]
[freeimage layer="1" time="500" wait="true"]

[if exp="f.winnerFaction === FACTION_VILLAGERS"]
  [m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
  [playse storage="other/01_instruction/160.ogg" buf="1"]
  そんな、負けてしまうなんて…。[p]

[elsif exp="f.winnerFaction === FACTION_DRAW_BY_REVOTE"]
  [m_changeCharacterFrameName name="？？？" characterId="mochiko" face="伏し目"]
  [playse storage="other/01_instruction/161.ogg" buf="1"]
  あらら、引き分けになっちゃいましたか…。[p]

[endif]

[m_changeCharacterFrameName name="？？？" characterId="mochiko" face="ドヤ顔"]
[playse storage="other/01_instruction/162.ogg" buf="1"]
…くよくよしてはいられません。[r]
こうなったら、勝てるまで何度でもリトライです！[p]

[playse storage="other/01_instruction/163.ogg" buf="1"]
ずんだもんちゃんの疑いを晴らすには、人狼ゲームに勝つしかありませんからね！[p]

; 後処理。キャラをゆっくり消すところが他との相違点
[j_clearFixButton]
[layopt layer="message0" visible="false"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId" wait="true"]
[stopse buf="1"]
[free_filter name="mochiko"]
[eval exp="f.currentFrame = null"]
[jump storage="title.ks"]
[s]
