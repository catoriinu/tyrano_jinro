/**
 * @classdec 性格情報を格納するクラス
 * @param {String} name 性格の日本語名
 * @param {Number} active 活発度
 * @param {Number} hungry 貪欲度
 * @param {Number} egoistic 保身度
 * @param {Number} logical 論理力
 * @param {Number} assertiveness 主張力
 * @param {Object} roleCOProbability 役職ごとのCO確率オブジェクト
 * @param {Object} impressiveActionList 信頼度に影響を与える行動リスト
 * @prop {String} name 性格の日本語名
 * @prop {Number} active 活発度
 * @prop {Number} hungry 貪欲度
 * @prop {Number} egoistic 保身度
 * @prop {Number} logical 論理力
 * @prop {Object} assertiveness 主張力
 * @prop {Object} roleCOProbability 役職ごとのCO確率オブジェクト
 * @prop {Object} impressiveReasonList 信頼度に影響を与える理由リスト
 */
function Personality(name, active, hungry, egoistic, logical, assertiveness, roleCOProbability, impressiveReasonList) {
  this.name = name;
  this.active = active;
  this.hungry = hungry;
  this.egoistic = egoistic;
  this.logical = logical;
  this.assertiveness = assertiveness;
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
    0, // logical 論理力(0～1)
    { // assertiveness 主張力（originalとcurrentは同値にすること）
      original: 1, // 元々の値（毎日currentをoriginalで初期化する）
      current: 1 // 現在の値（判定処理にはcurrentを用いる）
    },
    // COProbability {自身のRoleId : その役職としてCOする可能性}
    {
      [ROLE_ID_FORTUNE_TELLER]: {
        [ROLE_ID_FORTUNE_TELLER]: 1
      },
      [ROLE_ID_WEREWOLF]: {
        [ROLE_ID_FORTUNE_TELLER]: 1
      },
      [ROLE_ID_MADMAN]: {
        [ROLE_ID_FORTUNE_TELLER]: 1
      }
    },
    // impressiveReasonList {信頼度に影響を与える理由: {value: 値（絶対値とする）, arithmetic: 現在の信頼度とvalueとの計算方法}
    {
      [REASON_WAS_VOTED]: { // 相手に投票されたとき
        value: 0.1,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_SUSPECT]: { // 相手に疑われたとき
        value: 0.2,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_TRUST]: { // 相手に信じられたとき
        value: 0.2,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_ASK]: { // 相手に聞き出されたとき MEMO:試験用に信頼度を最大にできるようにする
        value: 1,
        arithmetic: ARITHMETIC_ADDITION
      },
      [REASON_TEST]: { // テスト
        value: 1,
        arithmetic: ARITHMETIC_MULTIPLICATION
      },
      // 以下のようなメソッドをここに格納できれば嬉しい
      // TODO:占われて○だったとき＝信頼度を少し上げる。ただし必ず敵陣営の場合は上げない
      // TODO:占われて●だったとき＝信頼度をガクッと下げる。ただし必ず味方陣営の場合は少ししか下げない
    },
  );
}
