jinro プラグイン 取扱メモ（v0.14.0 時点）

▼概要
- data/others/plugin/jinro/ は、NPC が自律的に会話・行動する人狼戦を支えるコアプラグイン置き場です。
- data/scenario/first.ks で [plugin name="jinro"] を宣言すると init.ks が実行され、以下の JavaScript 群を [loadjs] します。
- TyranoScript 上の各種マクロ（data/scenario/jinroMacros.ks など）から本ディレクトリの関数を呼び出す構成になっています。

▼初期化フロー
1. init.ks で sf.jinro.version／sf.jinro.isDebugMode を初期化します。
2. 同ファイルの [loadjs] で first/ 配下のモジュールを読み込みます。roles は roleBase → 個別役職 → factory.js の順で依存しています。
3. 続いて macro/impl.js と macro/status.js を読み込み、シナリオマクロから利用する実装を公開します。
4. 最後に tag/j_graph.js を読み込みます（現在は未使用。復活させる場合は jQuery 前提です）。

▼ディレクトリ構成
jinro/
|- init.ks                        … プラグインの入口。読み込み順とデバッグ設定を管理。
|- jinro_readme.txt               … このファイル。
|- first/                         … 人狼ゲームのロジック本体。
|  |- constants.js                … 役職 ID、アクション種別、UI 用定数の定義。
|  |- utils.js                    … 日夜切替・履歴管理・信頼度計算のための共通関数群。
|  |- calcReliability.js          … 信頼度（0.0-1.0）更新ユーティリティ。
|  |- characters.js               … Character クラスとプレイ中状態の保持。
|  |- personalities.js            … NPC 性格 (Personality) の定義と生成ヘルパー。
|  |- discussion.js               … 昼時間の発言／CO／投票ロジック。randomDecide など確率判定を集約。
|  |- prepare.js                  … Participant 定義と初期化。initializeCharacterObjectsForJinro などを提供。
|  |- jinroGameData.js            … JinroGameData とシナリオ既定値 (getJinroGameDataForTheater)。
|  `- roles/                      … 役職ごとの AI 実装。
|     |- roleBase.js              … 共通ロジックとレジストリ定義。各役職はここを継承し registerRole で登録する。
|     |- villager.js              … 村人ロール定義。
|     |- werewolf.js              … 人狼の夜行動・襲撃ロジック。
|     |- madman.js                … 狂人ロール定義。
|     |- fortuneTeller.js         … 占い師ロール定義（占い実行・候補選定ロジックを内包）。
|     `- factory.js               … 登録済みロールからインスタンスを生成するユーティリティ（getRole）。
|- macro/                         … TyranoScript マクロから叩く JS 実装。
|  |- impl.js                     … m_changeCharacter/m_enterCharacter 等の表示制御と getLabelFor～ 系ユーティリティ。
|  `- status.js                   … 住民一覧や履歴パネルを生成する DOM 操作群。
|- tag/
|  `- j_graph.js                  … 独自タグ定義。現在はコメントアウトされており既定では未使用。
`- memo/
   `- playJinroFlow.drawio        … 実装時のフローチャートメモ。

▼シナリオ側との接続
- マクロ定義は data/scenario/jinroMacros.ks・statusJinro.ks・jinroSubroutines.ks にあり、[macro] 内から本プラグインの関数を呼び出します。
- キャラクター表示状態は f.displayedCharacter に保持し、macro/impl.js の関数が Tyrano の chara_* タグをラップします。
- ステータスパネルは macro/status.js が返す jQuery オブジェクトを statusJinro.ks で挿入しています。
- ゲームデータ初期化 (resetJinroGameDataObjectsToDefault) は first.ks から呼ばれるため、既定値を更新する際は jinroGameData.js を変更し、必要に応じて CHANGELOG.md を更新してください。

▼運用メモ
- モジュールを追加・分割した場合は init.ks の [loadjs] 順序を更新し、依存関係が崩れないようにしてください。
- sf.jinro.isDebugMode を false にするとデバッグログを抑制できます。リリースビルド前に確認してください。
- 各 JavaScript は 2 スペースインデント・末尾カンマなし・説明的な camelCase（calcReliability など）というプロジェクト規約を守ってください。
- macro/impl.js から Tyrano のタグを直接呼ぶとページ送りが発生するため、wait:"false" 付与や既存実装を参考にしてください。
- 性格や役職を増やす場合は personalities.js と roles/ 系ファイルを同時に更新し、discussion.js の行動選択テーブルにも反映する必要があります。
