(function(global) {
  /**
   * personalityBase.js と個別性格で確立した jinroPersonalities 名前空間から window へ再エクスポートする。
   * 新しい性格を追加した場合は、ここにも公開対象を追加すること。
   */
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};

  namespace.attachGlobals = function() {
    const exports = {
      Personality: namespace.Personality,
      Personality_tester: namespace.tester,
      Personality_zundamon: namespace.zundamon,
      Personality_metan: namespace.metan,
      Personality_tsumugi: namespace.tsumugi,
      Personality_hau: namespace.hau,
      Personality_ritsu: namespace.ritsu
    };

    Object.keys(exports).forEach(function(key) {
      if (!exports[key]) {
        console.warn('[jinroPersonalities] ' + key + ' is not defined before index load.');
        return;
      }
      global[key] = exports[key];
    });
  };

  namespace.attachGlobals();
})(typeof window !== "undefined" ? window : this);
