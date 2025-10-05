/**
 * @classdec Personality definition for tester (default personality).
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};

  namespace.tester = function() {
    return new namespace.Personality(
      'テスト用の性格',
      0.7,
      1,
      {
        action: {}
      },
      1,
      {
        action: {},
        actor: {}
      },
      {
        original: 1,
        current: 1,
        decrease: 0.3
      },
      1.7,
      {
        [ROLE_ID_FORTUNE_TELLER]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.95
        },
        [ROLE_ID_WEREWOLF]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.4
        },
        [ROLE_ID_MADMAN]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.8
        }
      },
      {
        hate: 0.3,
        love: 0.7
      }
    );
  };
})(typeof window !== "undefined" ? window : this);
