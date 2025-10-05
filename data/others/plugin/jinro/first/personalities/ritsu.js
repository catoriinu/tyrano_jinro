/**
 * @classdec Personality definition for 波音リツ.
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};

  namespace.ritsu = function() {
    return new namespace.Personality(
      '波音リツ',
      0.6,
      1,
      {
        action: {
          [ACTION_SUSPECT]: 1.2
        }
      },
      1.25,
      {
        action: {},
        actor: {}
      },
      {
        original: 1,
        current: 1,
        decrease: 0.25
      },
      1.7,
      {
        [ROLE_ID_FORTUNE_TELLER]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.95
        },
        [ROLE_ID_WEREWOLF]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.8
        },
        [ROLE_ID_MADMAN]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.9
        }
      },
      {
        hate: 0.35,
        love: 0.8
      }
    );
  };
})(typeof window !== "undefined" ? window : this);
