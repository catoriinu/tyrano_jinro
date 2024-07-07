/**
 * @classdec 性格情報を格納するクラス
 * @param {String} name 性格の日本語名
 * @param {Number} logical 論理力
 * @param {Number} assertiveness 主張力
 * @param {Object} roleCOProbability 役職ごとのCO確率オブジェクト
 * @param {Object} impressiveActionList 信頼度に影響を与える行動リスト
 * @param {Object} feelingBorder 感情の境界値オブジェクト
 */
function Personality(name, logical, assertiveness, roleCOProbability, impressiveReasonList, feelingBorder) {
  this.name = name;
  // 未使用なのでコメントアウト
  // this.active = active;
  // this.hungry = hungry;
  // this.egoistic = egoistic;
  this.logical = logical;
  this.assertiveness = assertiveness;
  this.roleCOProbability = roleCOProbability;
  this.impressiveReasonList = impressiveReasonList;
  this.feelingBorder = feelingBorder;
}


/**
 * @classdec テスト用の性格クラス
 */
function Personality_tester() {
  return new Personality (
    'テスト用の性格', // name
    0.7, // logical 論理力(0～1)
    { // assertiveness 主張力（originalとcurrentは同値にすること）
      original: 1,  // 元々の値（毎日currentをoriginalで初期化する）
      current: 1,   // 現在の値（判定処理にはcurrentを用いる）
      decrease: 0.3 // 減少値（発言一回ごとに減少値分currentを減らす）
    },
    // COProbability {自身のRoleId : その役職としてCOする可能性}
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
    // impressiveReasonList {信頼度に影響を与える理由: {value: 値（絶対値とする）, arithmetic: 現在の信頼度とvalueとの計算方法}
    {
      [ACTION_SUSPECT]: { // 疑う
        value: 0.3,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_TRUST]: { // 信じる
        value: 0.3,
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
        value: 0.4,
        arithmetic: ARITHMETIC_ADDITION
      },
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.3,
      love: 0.7
    }
  );
}


/**
 * @classdec テスト用の性格クラス
 */
function Doll() {
  return new Personality (
    'テスト用の性格', // name
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
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.2,
      love: 0.8
    }
  );
}


/**
 * @classdec ずんだもんの性格クラス
 * 基本的にはPC自身なので最強の論理力プレイヤーとしておく
 */
function Personality_tester() {
  return new Personality (
    'ずんだもん', // name
    0.9, // logical 論理力(0～1)
    { // assertiveness 主張力（originalとcurrentは同値にすること）
      original: 1,  // 元々の値（毎日currentをoriginalで初期化する）
      current: 1,   // 現在の値（判定処理にはcurrentを用いる）
      decrease: 0.1 // 減少値（発言一回ごとに減少値分currentを減らす）
    },
    // COProbability {自身のRoleId : その役職としてCOする可能性}
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
    // impressiveReasonList {信頼度に影響を与える理由: {value: 値（絶対値とする）, arithmetic: 現在の信頼度とvalueとの計算方法}
    {
      [ACTION_SUSPECT]: { // 疑う
        value: 0.5,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_TRUST]: { // 信じる
        value: 0.5,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_ASK]: { // 聞き出す MEMO:試験用に信頼度を最大にできるようにする
        value: 1,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_VOTE]: { // 投票
        value: 0.2,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_FORTUNE_TELLING]: { // 占う
        value: 0.4,
        arithmetic: ARITHMETIC_ADDITION
      },
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.3,
      love: 0.7
    }
  );
}


/**
 * @classdec 四国めたんの性格クラス
 * 論理力強めの正統派プレイヤー。ただし信じられるとすぐに味方だと思う。
 */
function Personality_metan() {
  return new Personality (
    '四国めたん', // name
    0.8, // logical 論理力(0～1)
    { // assertiveness 主張力（originalとcurrentは同値にすること）
      original: 1,  // 元々の値（毎日currentをoriginalで初期化する）
      current: 1,   // 現在の値（判定処理にはcurrentを用いる）
      decrease: 0.3 // 減少値（発言一回ごとに減少値分currentを減らす）
    },
    // COProbability {自身のRoleId : その役職としてCOする可能性}
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
    // impressiveReasonList {信頼度に影響を与える理由: {value: 値（絶対値とする）, arithmetic: 現在の信頼度とvalueとの計算方法}
    {
      [ACTION_SUSPECT]: { // 疑う
        value: 0.2,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_TRUST]: { // 信じる
        value: 0.5,
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
        value: 0.5,
        arithmetic: ARITHMETIC_ADDITION
      },
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.3,
      love: 0.65
    }
  );
}


/**
 * @classdec 春日部つむぎの性格クラス
 * 主張力が高い。論理力は低く、議論で心が動きやすい。
 */
function Personality_tsumugi() {
  return new Personality (
    '春日部つむぎ', // name
    0.4, // logical 論理力(0～1)
    { // assertiveness 主張力（originalとcurrentは同値にすること）
      original: 1,  // 元々の値（毎日currentをoriginalで初期化する）
      current: 1,   // 現在の値（判定処理にはcurrentを用いる）
      decrease: 0.2 // 減少値（発言一回ごとに減少値分currentを減らす）
    },
    // COProbability {自身のRoleId : その役職としてCOする可能性}
    {
      [ROLE_ID_FORTUNE_TELLER]: {
        [ROLE_ID_FORTUNE_TELLER]: 0.75
      },
      [ROLE_ID_WEREWOLF]: {
        [ROLE_ID_FORTUNE_TELLER]: 0.5
      },
      [ROLE_ID_MADMAN]: {
        [ROLE_ID_FORTUNE_TELLER]: 0.6
      }
    },
    // impressiveReasonList {信頼度に影響を与える理由: {value: 値（絶対値とする）, arithmetic: 現在の信頼度とvalueとの計算方法}
    {
      [ACTION_SUSPECT]: { // 疑う
        value: 0.4,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_TRUST]: { // 信じる
        value: 0.4,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_ASK]: { // 聞き出す MEMO:試験用に信頼度を最大にできるようにする
        value: 1,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_VOTE]: { // 投票
        value: 0.15,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_FORTUNE_TELLING]: { // 占う
        value: 0.5,
        arithmetic: ARITHMETIC_ADDITION
      },
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.3,
      love: 0.7
    }
  );
}


/**
 * @classdec 雨晴はうの性格クラス
 * 論理寄り。主張力が低めで、人外の場合は潜伏しがち。疑うによる影響が大きい。
 */
function Personality_hau() {
  return new Personality (
    '雨晴はう', // name
    0.75, // logical 論理力(0～1)
    { // assertiveness 主張力（originalとcurrentは同値にすること）
      original: 0.95,  // 元々の値（毎日currentをoriginalで初期化する）
      current: 0.95,   // 現在の値（判定処理にはcurrentを用いる）
      decrease: 0.3 // 減少値（発言一回ごとに減少値分currentを減らす）
    },
    // COProbability {自身のRoleId : その役職としてCOする可能性}
    {
      [ROLE_ID_FORTUNE_TELLER]: {
        [ROLE_ID_FORTUNE_TELLER]: 0.95
      },
      [ROLE_ID_WEREWOLF]: {
        [ROLE_ID_FORTUNE_TELLER]: 0.05
      },
      [ROLE_ID_MADMAN]: {
        [ROLE_ID_FORTUNE_TELLER]: 0.2
      }
    },
    // impressiveReasonList {信頼度に影響を与える理由: {value: 値（絶対値とする）, arithmetic: 現在の信頼度とvalueとの計算方法}
    {
      [ACTION_SUSPECT]: { // 疑う
        value: 0.5,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_TRUST]: { // 信じる
        value: 0.25,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_ASK]: { // 聞き出す MEMO:試験用に信頼度を最大にできるようにする
        value: 1,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_VOTE]: { // 投票
        value: 0.08,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_FORTUNE_TELLING]: { // 占う
        value: 0.3,
        arithmetic: ARITHMETIC_ADDITION
      },
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.2,
      love: 0.7
    }
  );
}


/**
 * @classdec 波音リツの性格クラス
 * 役持ちの場合COしがち。頑固で、議論の影響を与えにくく受けにくい。
 */
function Personality_ritsu() {
  return new Personality (
    '波音リツ', // name
    0.7, // logical 論理力(0～1)
    { // assertiveness 主張力（originalとcurrentは同値にすること）
      original: 1,  // 元々の値（毎日currentをoriginalで初期化する）
      current: 1,   // 現在の値（判定処理にはcurrentを用いる）
      decrease: 0.3 // 減少値（発言一回ごとに減少値分currentを減らす）
    },
    // COProbability {自身のRoleId : その役職としてCOする可能性}
    {
      [ROLE_ID_FORTUNE_TELLER]: {
        [ROLE_ID_FORTUNE_TELLER]: 0.95
      },
      [ROLE_ID_WEREWOLF]: {
        [ROLE_ID_FORTUNE_TELLER]: 0.8
      },
      [ROLE_ID_MADMAN]: {
        [ROLE_ID_FORTUNE_TELLER]: 0.95
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
        value: 0.05,
        arithmetic: ARITHMETIC_ADDITION
      },
      [ACTION_FORTUNE_TELLING]: { // 占う
        value: 0.2,
        arithmetic: ARITHMETIC_ADDITION
      },
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.3,
      love: 0.7
    }
  );
}


/**
 * 性格クラスを取得する。引数には、キャラクターIDまたは性格クラス名そのものを渡されることを想定。
 * @param {string} name 性格クラス名。その名前の性格クラスが定義されていればそれを、なければテスト用の性格クラスを返却する。
 * @returns {Personality} 性格クラス
 */
function getPersonality(name = 'tester') {
  // 名前被りを避けるために接頭辞を付ける
  const personalityFunctionName = 'Personality_' + name;
  if (typeof window[personalityFunctionName] === 'function') {
    return new window[personalityFunctionName]();
  }
  // 未定義ならテスト用の性格を返却する
  return new Personality_tester();
}
