/**
 * @classdec 性格情報を格納するクラス
 * @param {String} name 性格の日本語名
 * @param {Number} active 活発度
 * @param {Number} hungry 貪欲度
 * @param {Number} egoistic 保身度
 * @param {Number} logical 論理力
 * @param {Object} roleCOProbability 役職ごとのCO確率オブジェクト
 * @param {Object} impressiveActionList 信頼度に影響を与える行動リスト
 * @prop {String} name 性格の日本語名
 * @prop {Number} active 活発度
 * @prop {Number} hungry 貪欲度
 * @prop {Number} egoistic 保身度
 * @param {Number} logical 論理力
 * @prop {Object} roleCOProbability 役職ごとのCO確率オブジェクト
 * @prop {Object} impressiveReasonList 信頼度に影響を与える理由リスト
 */
function Personality(name, active, hungry, egoistic, logical, roleCOProbability, impressiveReasonList) {
  this.name = name;
  this.active = active;
  this.hungry = hungry;
  this.egoistic = egoistic;
  this.logical = logical;
  this.roleCOProbability = roleCOProbability;
  this.impressiveReasonList = impressiveReasonList;
}


/**
 * @classdec テスト用の性格クラス
 */
function Tester() {
  return new Personality (
    'テスト用の性格', // name
    0.7, // active
    0.1, // hungry
    0.1, // egoistic
    0, // logical 論理力
    // COProbability {自身のRoleId : その役職としてCOする可能性}
    {
      [ROLE_ID_FORTUNE_TELLER]: {
        [ROLE_ID_FORTUNE_TELLER]: 100
      },
      [ROLE_ID_WEREWOLF]: {
        [ROLE_ID_FORTUNE_TELLER]: 100
      },
      [ROLE_ID_MADMAN]: {
        [ROLE_ID_FORTUNE_TELLER]: 100
      }
    },
    // impressiveReasonList {信頼度に影響を与える理由: {value: 値, arithmetic: 現在の信頼度とvalueとの計算方法}
    {
      [REASON_WAS_VOTED]: { // 相手に投票されたとき
        value: -0.1,
        arithmetic: ARITHMETIC_ADDITION
      },
      [REASON_TEST]: { // テスト
        value: 1,
        arithmetic: ARITHMETIC_MULTIPLICATION
      },
    },
  );
}
