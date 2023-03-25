# tyrano_jinro
『汝は人狼なりや？』をティラノスクリプト製のノベルゲームとして制作・プレイするためのプラグインやマクロ集、  
およびその実装例としてのサンプルゲームです。  
  
※まだ製作中なので利用はお控えください。  
完成の暁にはティラノスクリプト用プラグイン、マクロとして利用いただけるようにいたします。
  
# 動作確認バージョン
- Windows10
- ティラノスクリプト v521f(ver.0.7から)
- ティラノスタジオ v120(ver.0.4から)
  

# 更新履歴
- ver.0.6(20230212)
  - 投票結果画面をHTMLを利用した立ち絵で一覧表示できるように。
  - 投票結果や占いCO結果で信頼度を増減するように。
    - 内部的には、投票や占いもアクションオブジェクトに集約し、信頼度増減処理に渡すようにした。
  - アクション実行者の主張力を下げて、同日中は再発言しにくくなるように。
  - ボタンのテーマを統一し、選択中やその他の理由で色を変えられるように。
    - 内部的には、ボタンオブジェクトを作成してボタン表示するように処理を統一した。
  - ボタンを押されたくないタイミングでは消去するように。
- ver.0.5(20230116)
  - 投票フェイズで同票だった場合に再投票できるように。上限を越えたら引き分けにするように。
  - 議論フェイズ作成。
    - 議論によって信頼度が増減するように。
    - NPCが他キャラへの信頼度や同陣営可能性によって議論時のターゲットを選ぶように。
    - アクションボタン実装。
      - ロード後または`[awakegame]`を通るとゲーム変数`tyrano.plugin.kag.stat.f`が参照できなくなる仕様への対応のため、参照と書き込みは全て`TYRANO.kag.stat.f`を使うよう修正。
  - ボイボ人狼用glinkボタンのCSS作成。
    - ボタンオブジェクトおよびボタンオブジェクトからglinkを生成するサブルーチン作成。
    - 他のボタンも順次デフォルトのglinkから切り替えたい。
- ver.0.4(20221016)
  - サンプルゲームの方向性を決定。
    - キャラクター、メッセージマクロ、タイトル画面、フレームやボタン表示、フォント表示など実装（画像やフォントは非同梱）
  - キャラクターの入退場マクロを作成。
  - キャラクター選択ボタンへのマウスホバーでも入退場マクロを実行するようにした。
- ver.0.3(20220820)
  - 議論フェイズ用アクションボタンの仮実装。呼び出し箇所は未作成。
  - 視点の破綻後は、破綻したキャラの視点は共通視点オブジェクトで上書き、その他の視点は破綻したキャラを人狼陣営で更新するようにした。
    - プレイヤーの占い騙りによる破綻は未ブロック。扱いは同様でいいと思う。
  - 人狼メニュー画面を作成。占いCO結果を一覧表示できるように。
    - 人狼メニュー画面から戻ってからゲームを進行するとエラーになるバグあり。
    - 「ステータス画面」に改称予定。
  - 各キャラクターに信頼度オブジェクトを実装。
  - 投票ロジック実装。
- ver.0.2(20210704)
  - [messageマクロ](./data/scenario/messageMacros.ks)と[messageサブルーチン](data/scenario/message)にセリフやシステムメッセージを集約
  - [playJinro.ks](./data/scenario/playJinro.ks)（scene1.ksから名称変更）をリファクタリング。キャラクターIDに依存していた処理をほぼ脱却
  - PCの役職を選択できる画面を追加（将来のステージ選択機能の仮実装）
- ver.0.1(20210627)
  - ある程度動いたところで初版公開
  

# TODO
- [ ] COフェイズ
  - [ ] COフェイズ中の視点整理とNPCのCO意思の計算タイミングの再考（カットインのタイミングに被せられるか？）  
- [x] 破綻に関するタスク
  - [x] 襲撃による破綻について、破綻するタイミングを朝に襲撃されたキャラが判明した瞬間にしたい
    - [x] 襲撃結果の演出もついでに検討したい
  - [x] 騙り占いは2日目以降も、夜ではなくCOフェイズ内で決めるようにしたい。夜に騙り占い結果を決めた後、襲撃によって破綻するCOになってしまうことがあるため
  - [x] 騙り占いで、●を出したキャラが（処刑されてもゲームが終わらないことで）村確定する場合に、破綻扱いになっていないので修正する。
    - 処刑時or夜の初期化時に視点整理する
      - 夜の初期化時にした。処刑時にしなかったのは、処刑の後に勝敗判定を行うので、最後の人狼を処刑成功した場合でも先に破綻判定することになってしまうため。
    - 「占い師視点で残り狼数が1のとき、●を出したキャラが処刑されてもゲームが終わらない場合は（計算ロジックを通すまでもなく）破綻とする」
      - 念のため共通視点を除く全視点でチェックする。チェック内容は「各キャラ視点で、昼の処刑対象者が人狼の最後の生存者だったのに夜時間を迎えた場合は破綻」とした。
- [ ] NPCの思考と行動の雛形制作  
  - [ ] 自分や仲間が破綻する騙りCOはしない
  - [ ] 自分や仲間が破綻する襲撃はしない
- [ ] 議論フェイズの制作  
  - [ ] アクションオブジェクトや定数をリファクタする
  - [ ] そのアクションが論理的な判断か感情的な判断かで、セリフを分ける
  - [ ] hate,love用のセリフを作る
- [ ] 投票フェイズの制作  
  - [ ] キャラのセリフを表示、退場させる
- [ ] ステータス画面作成
- [ ] メニュー画面作成
- [ ] 処刑時、襲撃時の演出作成
- [ ] 表情差分作る、差分表示しわける  
- [ ] ボイスを入れる
- [ ] BGM、演出を入れる
- [ ] バグ修正
  - [x] PCが騙り占いで破綻すると例外エラーで止まる（修正可能）
    - 暫定対応は完了。（騙り）占いの破綻時に例外をcatchするようにした。また視点整理のタイミングを（騙り）占い時ではなく、占いCO時に修正した。
  - [x] 右側に表示中のキャラが再度発言する際、enterCharacter()で更に左へ移動するケースがある（時々起こるが再現性なし）
    - 暫定対応は完了。TODO f.displayPositionオブジェクトを作り、キャラクターの表示状態を一元管理したい。
      - f.displayedPositionオブジェクトで一元管理するように恒久対応完了。
  - [x] キャラクター選択ボタン押下時にundefinedになりその後しばらくして止まることがある（クリックしまくってると起きやすい？）
    - ボタン表示時にカーソルが初めからボタンの位置にあると、hoverイベントが発生しないのでクラス名を取得できないため（その後はめたんを選択したことになるみたい）
    - [「ボタン生成時にpreexpの式を評価する」](https://github.com/ShikemokuMK/tyranoscript/commit/82d7a51b1fbc7100e49834303bc438dc7f1a372c)の修正が入ったティラノスクリプトにアップデートすれば、[glinkFromButtonObjectsサブルーチン](./data/scenario/jinroSubroutines.ks)で生成するglinkボタンの判定にpreexpを使えるようになるはず。そもそもprefixがボタン押下時に評価されてたのがこう実装していた原因だったので。
      - ティラノスクリプトをv521fにアップデートし、preexpとexpを使うようにしたことで、バグの解消を確認。
  - [ ] アクションの第二階層ボタンにマウスをホバーさせるたびに、ボタンが増殖することがある（シナリオを進めずにアクションボタンを繰り返し押すとなる？）
    - ボタン生成時のループ処理で、カウンターが勢い余ることがあるらしい。無限ループしないように`tf.cnt >= (tf.buttonCount - 1)`には修正したが根本原因の修正は未着手
      - おそらく、「ボタン表示時にカーソルが初めからボタンの位置にあると、hoverイベントが発生しないのでクラス名を取得できない」バグが第一階層のボタンで起きていたのではないか？そうなら上記のバグと同時に解消したと思われる。TODOはしばらく残しておく。
  - [x] メッセージ表示よりも早くボイス（playse）の再生が完了すると、pタグで止まらず次のセリフに進んでしまう。
    - [impl.js](./data/others/plugin/jinro/macro/impl.js)でjs内でタグ実行をしているのが原因な気がする。もしそうならティラノタグを使うようポーティングが必要。
      - ポーティングした結果解決した。つまり原因も上記のとおりだった。ただし、jsから登場キャラ変更するケース（ボタンホバー時）のためにjsのメソッドも残した。
- [ ] ゲームシナリオ作る
- [ ] 遊びの部分を作る
  - [ ] ステージ選択
  - [ ] 会話劇
  - [ ] アチーブメント
- [ ] 霊能者の実装（できれば）  
- [ ] 狩人の実装（できれば）  
- [ ] NPCの思考の強化学習（マジで言ってんの？）  
- [ ] ファイル構成の再検討  
  - [ ] マクロ.ksに記載するのはどうしてもティラノで書かないといけない内容だけにし、ロジックは可能な限りjs内に移植する
- [ ] docsやコメントの補完  
- [ ] リファクタリング  
  - [ ] iscript内のコメントを//にする
- [ ] アクションオブジェクトに関して
  - [ ] ヒストリーを残しておいたほうがよい？
- [ ] エラー調査用の実装
  - [ ] エラー発生時に全変数をファイル出力したい（ティラノ内にcatchしてる箇所がないか探す）

and more....
  

# 製作者
香取犬  
Twitter：[@catoriinu8190](https://twitter.com/catoriinu8190)  
ブログ：[ハイグレ郵便局 香取犬支店](http://highglepostoffice.blog.fc2.com/)  
  

# special thanks
[https://github.com/ShikemokuMK/tyranoscript](https://github.com/ShikemokuMK/tyranoscript)  
[https://webkatu.com/201407132011-clone-function-to-deepcopy-object/](https://webkatu.com/201407132011-clone-function-to-deepcopy-object/)  
[https://ameblo.jp/personwritep/entry-12495099049.html](https://ameblo.jp/personwritep/entry-12495099049.html)
