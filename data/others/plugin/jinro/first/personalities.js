/**
 * @classdec 性格情報を格納するクラス
 * @param {String} name 性格の日本語名
 * @param {Number} active 活発度
 * @param {Number} hungry 貪欲度
 * @param {Number} egoistic 保身度
 * @param {Object} roleCOProbability 役職ごとのCO確率オブジェクト
 * @prop {String} name 性格の日本語名
 * @prop {Number} active 活発度
 * @prop {Number} hungry 貪欲度
 * @prop {Number} egoistic 保身度
 * @prop {Object} roleCOProbability 役職ごとのCO確率オブジェクト
 */
function Personality(name, active, hungry, egoistic, roleCOProbability) {
  this.name = name;
  this.active = active;
  this.hungry = hungry;
  this.egoistic = egoistic;
  this.roleCOProbability = roleCOProbability;
}


/**
 * @classdec テスト用の性格クラス
 */
function Tester() {
  return new Personality (
    'テスト用の性格', // name
    70, // active
    10, // hungry
    10, // egoistic
    {
      [ROLE_ID_FORTUNE_TELLER]: {
        [ROLE_ID_FORTUNE_TELLER]: 90
      },
      [ROLE_ID_WEREWOLF]: {
        [ROLE_ID_FORTUNE_TELLER]: 90
      },
      [ROLE_ID_MADMAN]: {
        [ROLE_ID_FORTUNE_TELLER]: 90
      }
    } // COProbability {自身のRoleId : その役職としてCOする可能性}
  );
}
