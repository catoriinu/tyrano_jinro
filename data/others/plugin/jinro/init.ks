[iscript]
  // jinroプラグイン用の変数をシナリオ変数に格納する
  sf.jinro = {};
  sf.jinro.version = {
    major: 0,
    minor: 14,
    patch: 0,
  };
  // TODO: リリース時にはfalseにすること！
  sf.jinro.isDebugMode = true;
[endscript]


;人狼プラグインのfirstディレクトリ以下を読み込む
[loadjs storage="plugin/jinro/first/constants.js"]
[loadjs storage="plugin/jinro/first/utils.js"]
[loadjs storage="plugin/jinro/first/roles.js"]
[loadjs storage="plugin/jinro/first/characters.js"]
[loadjs storage="plugin/jinro/first/personalities.js"]
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
