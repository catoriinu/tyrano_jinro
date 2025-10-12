/**
 * @classdesc Personality definition for 雨晴はう.
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};
  const Personality = namespace.Personality;

  class HauPersonality extends Personality {
    constructor() {
      super(
        '雨晴はう',
        0.7,
        1,
        {
          action: {}
        },
        0.9,
        {
          action: {
            [ACTION_FORTUNE_TELLING]: 0.6,
            [ACTION_SUSPECT]: 0.8
          },
          actor: {}
        },
        {
          original: 0.9,
          current: 0.9,
          decrease: 0.25
        },
        1.8,
        {
          [ROLE_ID_FORTUNE_TELLER]: {
            [ROLE_ID_FORTUNE_TELLER]: 0.95
          },
          [ROLE_ID_WEREWOLF]: {
            [ROLE_ID_FORTUNE_TELLER]: 0.05
          },
          [ROLE_ID_MADMAN]: {
            [ROLE_ID_FORTUNE_TELLER]: 0.1
          }
        },
        {
          hate: 0.2,
          love: 0.7
        }
      );
    }
  }

  namespace.registerPersonality('hau', HauPersonality);
})(typeof window !== 'undefined' ? window : this);
