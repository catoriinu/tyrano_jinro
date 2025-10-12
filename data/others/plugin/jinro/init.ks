[iscript]
  // jinroプラグイン用の変数をシナリオ変数に格納する
  sf.jinro = {};
  sf.jinro.version = {
    major: 0,
    minor: 14,
    patch: 1,
  };
  // TODO: リリース時にはfalseにすること！
  sf.jinro.isDebugMode = true;
[endscript]


;人狼プラグインのfirstディレクトリ以下を読み込む
[loadjs storage="plugin/jinro/first/constants.js"]
[loadjs storage="plugin/jinro/first/utils.js"]

; 役職定義の読み込み
[loadjs storage="plugin/jinro/first/roles/roleBase.js"]
[loadjs storage="plugin/jinro/first/roles/villager.js"]
[loadjs storage="plugin/jinro/first/roles/fortuneTeller.js"]
[loadjs storage="plugin/jinro/first/roles/werewolf.js"]
[loadjs storage="plugin/jinro/first/roles/madman.js"]
; レジストリから役職を取得するユーティリティ（個別の役職定義はここまでに読み込んでおくこと）
[loadjs storage="plugin/jinro/first/roles/factory.js"]

; 性格定義の読み込み
[loadjs storage="plugin/jinro/first/personalities/personalityBase.js"] 
[loadjs storage="plugin/jinro/first/personalities/tester.js"]
[loadjs storage="plugin/jinro/first/personalities/zundamon.js"]
[loadjs storage="plugin/jinro/first/personalities/metan.js"]
[loadjs storage="plugin/jinro/first/personalities/tsumugi.js"]
[loadjs storage="plugin/jinro/first/personalities/hau.js"]
[loadjs storage="plugin/jinro/first/personalities/ritsu.js"]
; レジストリから性格を取得するユーティリティ（個別の性格定義はここまでに読み込んでおくこと）
[loadjs storage="plugin/jinro/first/personalities/factory.js"] 

[loadjs storage="plugin/jinro/first/characters.js"]
[loadjs storage="plugin/jinro/first/discussion.js"]
[loadjs storage="plugin/jinro/first/prepare.js"]
[loadjs storage="plugin/jinro/first/calcReliability.js"]
[loadjs storage="plugin/jinro/first/jinroGameData.js"]
; ゲーム内のマクロから呼び出す実体メソッドを実装したファイルも読み込む
[loadjs storage="plugin/jinro/macro/impl.js"]
[loadjs storage="plugin/jinro/macro/status.js"]
; 自作タグも読み込む が、現在未使用
[loadjs storage="plugin/jinro/tag/j_graph.js"]
[return ]
