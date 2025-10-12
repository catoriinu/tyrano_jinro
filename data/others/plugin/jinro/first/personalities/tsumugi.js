/**
 * @classdesc Personality definition for 春日部つむぎ.
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};
  const Personality = namespace.Personality;

  class TsumugiPersonality extends Personality {
    constructor() {
      super(
        '春日部つむぎ',
        0.4,
        1.1,
        {
          action: {}
        },
        0.8,
        {
          action: {},
          actor: {}
        },
        {
          original: 1.25,
          current: 1.25,
          decrease: 0.3
        },
        1.7,
        {
          [ROLE_ID_FORTUNE_TELLER]: {
            [ROLE_ID_FORTUNE_TELLER]: 0.8
          },
          [ROLE_ID_WEREWOLF]: {
            [ROLE_ID_FORTUNE_TELLER]: 0.5
          },
          [ROLE_ID_MADMAN]: {
            [ROLE_ID_FORTUNE_TELLER]: 0.6
          }
        },
        {
          hate: 0.3,
          love: 0.7
        }
      );
    }
  }

  namespace.registerPersonality('tsumugi', TsumugiPersonality);
})(typeof window !== 'undefined' ? window : this);
