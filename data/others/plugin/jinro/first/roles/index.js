(function(global) {
  /**
   * 役職モジュール群を旧来通りのグローバル関数として公開する仲介レイヤー。
   * 役職ファクトリ（Villager 等）が new される呼び出し側を変更しなくても済むように、
   * roleBase.js と個別役職で確立した jinroRoles 名前空間から window へ再エクスポートする。
   * 新しい役職を追加した場合は、ここにも公開対象を追加すること。
   */
  const namespace = global.jinroRoles = global.jinroRoles || {};

  namespace.attachGlobals = function() {
    const exports = {
      Role: namespace.Role,
      Villager: namespace.Villager,
      FortuneTeller: namespace.FortuneTeller,
      Werewolf: namespace.Werewolf,
      Madman: namespace.Madman
    };

    Object.keys(exports).forEach(function(key) {
      if (!exports[key]) {
        console.warn('[jinroRoles] ' + key + ' is not defined before index load.');
        return;
      }
      global[key] = exports[key];
    });
  };

  namespace.attachGlobals();
})(typeof window !== "undefined" ? window : this);