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
- ver.0.8.0(20230528)
  - ステータス画面実装。
  - バックログボタンを常時表示するように。
  - メニューボタンをステータス画面でのみ表示するように。
  - 占いCOメッセージ表示中にステータス画面を開くと、COしたことにならなくなるバグを修正。
  - プレイヤーが退場済みでも議論フェーズにアクションボタンが表示されているバグを修正。
- ver.0.7.2(20230501)
  - 「タイトルに戻る」後に再度プレイすると、メニューボタン等がクリックできなくなる問題を修正。
  - ティラノスクリプトのデフォルトのバックログ機能を、プレイヤーに使われる前提で修正。
    - ステータス画面内に、バックログ画面を表示するためのボタンを実装（ゲーム中にマウスのホイールを上に回すことでも表示可能）。
    - バックログに記録不要なメッセージは記録しないように。
    - 投票結果をバックログに記録するように。
    - メッセージ内でキャラ名を呼称するたびにログが切れて次の行に移っていた問題を修正。
    - バックログ保存行数をデフォルトの50から200に（修正した`data/system/Config.tjs`はgit push対象外）。
    - タイトル画面でバックログをリセットするように。
- ver.0.7.1(20230422)
  - 開発者用設定画面作成（独裁者モード、役職シャッフル、ラウンド設定、NPCの思考方針）
  - 現在の変数をファイル出力する機能を追加。
  - 資料置き場（docsディレクトリ）を作成。
  - 不要なボタンを削除。
  - 2日目以降のCO確率の調整。
  - BGM,SEの演出強化。
  - ステータス画面で現在のCO状況を表示できるように（アクションオブジェクトに適応）
- ver.0.7(20230326)
  - ティラノスクリプトのバージョンをv521fに。
  - ボイス実装。
  - 議論フェーズでNPCがアクション対象を選択する際、同陣営割合が同値なら仲間度で決めるように修正。
  - 表示キャラオブジェクトで、登場中のキャラクターの表示状態を管理するように修正。
  - 昼開始時や夜開始時に必要な処理や演出をまとめてマクロ化。
    - 初日にキャラ紹介画面を表示するように。
      - 横並びでキャラクター画像を表示するサブルーチンは、ステータス画面にも使える想定。
  - 視点整理（破綻）や情報公開などをするタイミングの変更。
    - 夜に占った場合の視点整理タイミングを、実際に占いCOしたタイミングに変更。
    - 騙り占いの結果は、夜ではなく昼に占いCOするタイミングで選択するよう変更。
    - 各キャラ視点で、昼の処刑対象者が人狼の最後の生存者だったのに夜時間を迎えた場合は破綻するように修正。
    - 昼時間開始の演出中に、昨夜の襲撃結果が判明し、視点整理するよう修正。
  - 以下のバグを修正。
    - PCの占い対象のキャラクターが翌朝最初に発言する場合、更に左へ移動してしまうことがあるバグ
    - PCが騙り占いで破綻すると例外エラーで止まるバグ
    - ボタン表示時にカーソルが初めからボタンの位置にあると、hoverイベントが発生しないのでクラス名を取得できないバグ
    - メッセージ表示よりも早く`[playse]`（ボイス）の再生が完了すると、`[p]`で止まらず次のセリフに進んでしまうバグ
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
- やることメモ
  - セリフパターン、演出強化系
  - 人狼ゲーム上の改善系
  - UI修正、改善系
  - バグ修正
  - ボイボ人狼用シナリオ、機能作成

★：次にやるタスク
☆：やらないとアプデできないタスク
◎：やらないとリリースできないタスク
○：できればやりたいタスク
△：リリース後でいいタスク

- [ ] COフェイズ
  - [ ] 【○】現在のCO状況によって、未CO者のCOしたい度を変動させる(j_decideCOCandidateId)
  - [ ] 【○】PCの騙り占い結果選択時、アクションボタンと同じように、第1階層はキャラクター、第2階層は騙り結果、という構成にしたい(fakeFortuneTellingForPC)
  - [ ] 【◎】PCの騙り占い結果選択時、「一つ前に戻る」ボタンを追加して入力を取り消せるようにする
  - [ ] 【△】CO時のセリフパターンの追加
    - [ ] 役職COと結果COで差分を付けられるようにする。（「自分が占い師だ」「昨日の占い結果は～」）
    - [ ] 役職COのとき、自分の前にCO済みの占い師がいる場合「自分こそが占い師だ」と主張することができるようにする
    - [ ] 結果COのとき、自分の前のCO結果によって反応を変えられるようにする（同じ相手を占った、違う相手を占った）
- [ ] 占い師の行動
  - [ ] 【○】ランダムではなく、一定の基準で占い先（騙りなら結果も）を決められるようにする(considerFortuneTellingTarget)
  - [ ] 【△】もし占い候補がいなければ（全員占い済みなら）占わないことができるようにする(determineFortuneTellingTargetId)
  - [x] 【◎】退場済みのキャラを占っていたとき用のセリフバリエーションを作る
- [ ] NPCの思考と行動の雛形制作  
  - [ ] 【○】自分や仲間が破綻する騙りCOはしない
  - [ ] 【○】自分や仲間が破綻する襲撃はしない
- [ ] 議論フェイズの制作  
  - [ ] アクションオブジェクトや定数をリファクタする
  - [x] 【◎】そのアクションが論理的な判断か感情的な判断かで、セリフを分ける
  - [x] 【◎】hate,love用のセリフを作る
  - [ ] 【◎】「聞き出す」アクションの作成
  - [ ] 【△】アクションボタンの横に実行予定のアクションを表示する。「発言しない」や「Xを疑う」とフキダシ表示するイメージ
- [ ] 投票フェイズの制作  
  - [ ] 【○】各役職ごとの投票ロジックを作成する(decideVote)
  - [ ] 【◎】キャラのセリフを表示、退場させる
  - [ ] 【◎】処刑後の反応セリフ作成、誰が言うかを決めるマクロを作成
- [ ] 【◎】開発者設定画面作成
  - [x] 論理力(0/デフォ/1)
    - [ ] 最終的には、性格オブジェクトを入れ分けたい
- [ ] 【◎】ステータス画面作成
  - [ ] 【○】ステータス画面のキャラクターフキダシに、テーマカラーをグラデーションする
  - [ ] 【○】ステータス画面の投票履歴で被投票数を表示したり、最多得票者がわかるようにする（★をつけるか背景色を変えるか）
  - [ ] 【△】キャラクターBoxを順に表示しているが、最後まで生成しきってから揃って表示できるようにする
  - [ ] 【△】一括表示すると重くなるなら、投票履歴や占い履歴はボタンを押してから読み込むようにする
  - [ ] 【△】夜時間に表示するときは夜用のオブジェクトの方がよいか検討する
- [x] 【◎】メニュー画面作成
  - セーブ・ロードは人狼プラグインの動作保証外とする
  - [ ] ボイボ人狼正式版ではボタン表示させない
- [ ] 【◎】ゲーム終了時の役職紹介画面作成
  - displayCharactersHorizontallyサブルーチンを利用したい。というよりステータス画面と同じような方式にしたい
- [ ] 【◎】ボイボ人狼正式版用タイトル画面作成
- [ ] 【◎】処刑時、襲撃時の演出作成
- [x] 【★】表情差分作る、差分表示しわける  
- [x] 【★】特にプレイヤーの立ち絵について、次の発言時にはnormalに戻す
- [ ] 【○】キャラクターの性格を作る
- [ ] 【○】システムメッセージにもボイスを入れる
- [ ] 【○】キャラ名の呼称テキストに、キャラのイメージカラーの下線を入れる
  - キャラ名の判別のため。このまま何も対策をしないと、No.7と春歌ナナを実装したときに判別がつかなくなる
- [ ] 【◎】BGM、演出を入れる
- [ ] 【◎】バックログ画面の作成
  - [ ] 【◎】バックログ画面に表示すべき(でない)メッセージを精査する
  - [x] 【◎】バックログボタンの表示位置、またはショートカットキーを検討する
  - [ ] 【○】公式テンプレートからの脱却
- [ ] 【○】投票画面の表示を初見でもわかりやすくする（→名前が投票先であること、背景色、★の意味）
- [ ] 【◎】ボイスのプリロードはゲーム起動時に行う（方がいいか含め検討する）→起動時ではなく開始時のままでいい。preload済みならロード時間かからないので繰り返しプレイには影響ない。
  - [ ] 【○】NOW LOADING画面を作る
- [ ] バグ修正
  - [ ] 【○】アクションの第二階層ボタンにマウスをホバーさせるたびに、ボタンが増殖することがある（シナリオを進めずにアクションボタンを繰り返し押すとなる？）
    - ボタン生成時のループ処理で、カウンターが勢い余ることがあるらしい。無限ループしないように`tf.cnt >= (tf.buttonCount - 1)`には修正したが根本原因の修正は未着手
      - おそらく、「ボタン表示時にカーソルが初めからボタンの位置にあると、hoverイベントが発生しないのでクラス名を取得できない」バグが第一階層のボタンで起きていたのではないか？そうなら上記のバグと同時に解消したと思われる。TODOはしばらく残しておく。
  - [ ] アクションの第二階層を開いたとき、黒いglinkボタンが表示されることがある（エラー文失念）
    - ひとつ上と同件？→これは今でもたまーに起きる
  - [ ] COフェーズ中にメニュー画面やステータス画面を開いて戻ると、同じキャラが再度COする
    - 少し試したが再現性なし？↓の修正をしたことで解消された？
  - [x] 占いCO時のメッセージが終わり切る前にステータスボタン（だけに限らない？）を押下すると、CORoleIdが格納されない（＝ステータス画面に占い師として表示されない）
    - メッセージ表示中に別画面に遷移すると処理が中断される系の問題は、メッセージ表示する前に内部処理を全て終わらせておけば解決しそう。全体的に大改修が必要だが……
      - 真の原因は「ステータス画面を開いたことでloadが入り、一時変数tfが初期化されたことで、後続処理でCORoleIdを格納するためのルートに入る判定に使うtf.canCOFortuneTellerStatusも初期化されてしまったため」だった。
        - tf.canCOFortuneTellerStatusをゲーム変数に置換を行い、メッセージ表示する前に内部処理をなるべく全て終わらせるように修正して解消を確認
  - [ ] mac版で.ogg,.m4aの音声が一部聞こえなくなる
  - [x] 【★】プレイヤーが退場済みでも、アクションボタンが表示されっぱなし。議論フェーズに押すとアクションできてしまう。
  - [ ] 稀に変数格納が間に合わずundefinedと表示される（ティラノの仕様？）
    - 議論フェーズの発言候補者選択時、getCharacterIdByReliability()で発生するundefinedは実装バグだった。しばらくテストして再発しなければ解消とする。
  - [ ] 投票先選択ボタンが表示されているときにステータス画面の投票履歴を見ると、NPCの次の投票先が見ることができてしまう（1日目限定）
  - [x] 追放決定時のセリフ時にステータス画面を開くとまだ「n日目追放」が表示されておらず、その次の「xが処刑されました」表示時にステータス画面を開くと「null日目襲撃」と表示される。
    - これもセリフ表示後にtfを利用して追放結果を格納しており、ステータス画面を開いたときにtfが削除されてしまったため。tfは使って良いこととし、処理順を入れ替えて対応。
- [ ] 【◎】ゲームシナリオ作る
- [ ] 【◎】遊びの部分を作る
  - [x] ステージ選択
  - [ ] 会話劇
  - [ ] アチーブメント
- [ ] 【○】カスタムプレイ画面作る
- [ ] 【○】コンフィグ画面作成（音量調整など）
- [ ] 【△】霊能者の実装（できれば）  
- [ ] 【△】狩人の実装（できれば）  
- [ ] NPCの思考の強化学習（マジで言ってんの？）  
- [ ] ファイル構成の再検討  
  - [ ] マクロ.ksに記載するのはどうしてもティラノで書かないといけない内容だけにし、ロジックは可能な限りjs内に移植する
- [ ] docsやコメントの補完  
- [ ] リファクタリング  
  - [ ] 【◎】メソッド、マクロ、サブルーチン、クラスを適切なファイルに移動する
  - [ ] 【△】iscript内のコメントを//にする
- [ ] アクションオブジェクトに関して
  - [x] 【○】メッセージの選択に使っている変数が、アクション実行時はtf.selectedCharacterId、占い時はf.actionObject.targetIdとちぐはぐなので統一したい(scenario/message配下)
  - [ ] 占い師のCO済み判定に使っているフラグisPublic（doneCOをアクションオブジェクト内に格納し名称変更）を、全てのアクションのオブジェクトに適用していく（公開情報ならtrueを入れるなど。議論履歴の表示可否判定にも使えるかもしれない）
  - [x] ヒストリーを残しておいたほうがよい？
- [ ] エラー調査用の実装
  - [ ] エラー発生時に全変数をファイル出力したい（ティラノ内にcatchしてる箇所がないか探す）
- [ ] 人狼プラグインからボイボ人狼依存のコードをなくす（サンプルになるコードが残るのは許容）

and more....
  

# 製作者
香取犬  
Twitter：[@catoriinu8190](https://twitter.com/catoriinu8190)  
ブログ：[ハイグレ郵便局 香取犬支店](http://highglepostoffice.blog.fc2.com/)  
ニコニコ動画：[香取犬](https://www.nicovideo.jp/user/128529457)  
  

# special thanks
[https://github.com/ShikemokuMK/tyranoscript](https://github.com/ShikemokuMK/tyranoscript)  
[https://webkatu.com/201407132011-clone-function-to-deepcopy-object/](https://webkatu.com/201407132011-clone-function-to-deepcopy-object/)  
[https://ameblo.jp/personwritep/entry-12495099049.html](https://ameblo.jp/personwritep/entry-12495099049.html)
