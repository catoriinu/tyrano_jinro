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
 * @param {Object} feelingBorder 感情の境界値オブジェクト
 */
function Personality(name, active, hungry, egoistic, logical, assertiveness, roleCOProbability, impressiveReasonList, feelingBorder) {
  this.name = name;
  this.active = active;
  this.hungry = hungry;
  this.egoistic = egoistic;
  this.logical = logical;
  this.assertiveness = assertiveness;
  this.roleCOProbability = roleCOProbability;
  this.impressiveReasonList = impressiveReasonList;
  this.feelingBorder = feelingBorder;
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
      original: 1,  // 元々の値（毎日currentをoriginalで初期化する）
      current: 1,   // 現在の値（判定処理にはcurrentを用いる）
      decrease: 0.2 // 減少値（発言一回ごとに減少値分currentを減らす）
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
      [ACTION_SUSPECT]: { // 疑う
        value: 0.2,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_TRUST]: { // 信じる
        value: 0.2,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_ASK]: { // 聞き出す MEMO:試験用に信頼度を最大にできるようにする
        value: 1,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_VOTE]: { // 投票
        value: 0.1,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_FORTUNE_TELLING]: { // 占う
        value: 0.3,
        arithmetic: ARITHMETIC_ADDITION
      },
      // 以下のようなメソッドをここに格納できれば嬉しい
      // TODO:占われて○だったとき＝信頼度を少し上げる。ただし必ず敵陣営の場合は上げない
      // TODO:占われて●だったとき＝信頼度をガクッと下げる。ただし必ず味方陣営の場合は少ししか下げない
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.2,
      love: 0.8
    }
  );
}


/**
 * @classdec テスト用の性格クラス
 */
function Doll() {
  return new Personality (
    'テスト用の性格', // name
    0.7, // active
    0.1, // hungry
    0.1, // egoistic
    0, // logical 論理力(0～1)
    { // assertiveness 主張力（originalとcurrentは同値にすること）
      original: 0,  // 元々の値（毎日currentをoriginalで初期化する）
      current: 0,   // 現在の値（判定処理にはcurrentを用いる）
      decrease: 0 // 減少値（発言一回ごとに減少値分currentを減らす）
    },
    // COProbability {自身のRoleId : その役職としてCOする可能性}
    {
      [ROLE_ID_FORTUNE_TELLER]: {
        [ROLE_ID_FORTUNE_TELLER]: 0
      },
      [ROLE_ID_WEREWOLF]: {
        [ROLE_ID_FORTUNE_TELLER]: 0
      },
      [ROLE_ID_MADMAN]: {
        [ROLE_ID_FORTUNE_TELLER]: 0
      }
    },
    // impressiveReasonList {信頼度に影響を与える理由: {value: 値（絶対値とする）, arithmetic: 現在の信頼度とvalueとの計算方法}
    {
      [ACTION_SUSPECT]: { // 疑う
        value: 0.2,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_TRUST]: { // 信じる
        value: 0.2,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_ASK]: { // 聞き出す MEMO:試験用に信頼度を最大にできるようにする
        value: 1,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_VOTE]: { // 投票
        value: 0.1,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_FORTUNE_TELLING]: { // 占う
        value: 0.3,
        arithmetic: ARITHMETIC_ADDITION
      },
      // 以下のようなメソッドをここに格納できれば嬉しい
      // TODO:占われて○だったとき＝信頼度を少し上げる。ただし必ず敵陣営の場合は上げない
      // TODO:占われて●だったとき＝信頼度をガクッと下げる。ただし必ず味方陣営の場合は少ししか下げない
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.2,
      love: 0.8
    }
  );
}
