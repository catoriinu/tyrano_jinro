/**
 * @classdec Personality definition for ずんだもん.
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};

  namespace.zundamon = function() {
    return new namespace.Personality(
      'ずんだもん',
      0.8,
      1.2,
      {
        action: {}
      },
      1.1,
      {
        action: {},
        actor: {}
      },
      {
        original: 1.2,
        current: 1.2,
        decrease: 0.2
      },
      2.1,
      {
        [ROLE_ID_FORTUNE_TELLER]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.95
        },
        [ROLE_ID_WEREWOLF]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.1
        },
        [ROLE_ID_MADMAN]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.9
        }
      },
      {
        hate: 0.2,
        love: 0.7
      }
    );
  };
})(typeof window !== "undefined" ? window : this);
