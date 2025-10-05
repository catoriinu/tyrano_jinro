/**
 * @classdec Personality definition for 四国めたん.
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};

  namespace.metan = function() {
    return new namespace.Personality(
      '四国めたん',
      0.8,
      1,
      {
        action: {}
      },
      0.95,
      {
        action: {
          [ACTION_TRUST]: 0.5
        },
        actor: {}
      },
      {
        original: 1,
        current: 1,
        decrease: 0.25
      },
      1.8,
      {
        [ROLE_ID_FORTUNE_TELLER]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.95
        },
        [ROLE_ID_WEREWOLF]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.2
        },
        [ROLE_ID_MADMAN]: {
          [ROLE_ID_FORTUNE_TELLER]: 0.8
        }
      },
      {
        hate: 0.3,
        love: 0.65
      }
    );
  };
})(typeof window !== "undefined" ? window : this);
