/**
 * @classdec 性格情報を格納するクラス
 * @param {String} name 性格の日本語名
 * @param {Number} logical 論理力
 * @param {*} influenceMultiplier 
 * @param {*} adjustmentInfluenceMultiplier 
 * @param {*} registanceMultiplier 
 * @param {*} adjustmentRegistanceMultiplier 
 * @param {Number} assertiveness 主張力
 * @param {Object} roleCOProbability 役職ごとのCO確率オブジェクト
 * @param {Object} feelingBorder 感情の境界値オブジェクト
 */
function Personality(
  name,
  logical,
  influenceMultiplier,
  adjustmentInfluenceMultiplier,
  registanceMultiplier,
  adjustmentRegistanceMultiplier,
  assertiveness, roleCOProbability,
  feelingBorder
) {
  this.name = name;
  this.influenceMultiplier = influenceMultiplier;
  this.adjustmentInfluenceMultiplier = adjustmentInfluenceMultiplier;
  this.registanceMultiplier = registanceMultiplier;
  this.adjustmentRegistanceMultiplier = adjustmentRegistanceMultiplier;
  this.logical = logical;
  this.assertiveness = assertiveness;
  this.roleCOProbability = roleCOProbability;
  this.feelingBorder = feelingBorder;
}


/**
 * @classdec テスト用の性格クラス
 */
function Personality_tester() {
  return new Personality (
    'テスト用の性格', // name
    0.7, // logical 論理力(0～1)
    1,
    {
      action: {}
    },
    1,
    {
      action: {},
      actor: {}
    },
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
    1,
    {
      action: {}
    },
    1,
    {
      action: {},
      actor: {}
    },
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
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.2,
      love: 0.8
    }
  );
}


/**
 * @classdec ずんだもんの性格クラス
 * 基本的にはPC自身なので論理力は高めで、影響力は少し強め。その他は標準のままとする
 */
function Personality_zundamon() {
  return new Personality (
    'ずんだもん', // name
    0.8, // logical 論理力(0～1)
    1.2,
    {
      action: {}
    },
    1,
    {
      action: {},
      actor: {}
    },
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
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.3,
      love: 0.7
    }
  );
}


/**
 * @classdec ずんだもん（強化）の性格クラス
 * 通常のずんだもんよりも影響力、抵抗力がとても高い
 */
function Personality_zundamon_enhanced() {
  return new Personality (
    'ずんだもん（強化）', // name
    0.8, // logical 論理力(0～1)
    1.5,
    {
      action: {}
    },
    1.2,
    {
      action: {},
      actor: {}
    },
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
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.3,
      love: 0.7
    }
  );
}


/**
 * @classdec 四国めたんの性格クラス
 * 論理力強め。ただし信じられるとすぐに味方だと思ってしまうチョロイン。役職CO率は正統派。
 */
function Personality_metan() {
  return new Personality (
    '四国めたん', // name
    0.8, // logical 論理力(0～1)
    1,
    {
      action: {}
    },
    0.95,
    {
      action: {
        [ACTION_TRUST]: 0.6
      },
      actor: {}
    },
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
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.3,
      love: 0.65
    }
  );
}


/**
 * @classdec 春日部つむぎの性格クラス
 * ギャルなので主張力と影響力が強い。反面、論理力と抵抗力は低め。役職CO率は中途半端。
 */
function Personality_tsumugi() {
  return new Personality (
    '春日部つむぎ', // name
    0.4, // logical 論理力(0～1)
    1.1,
    {
      action: {}
    },
    0.9,
    {
      action: {},
      actor: {}
    },
    { // assertiveness 主張力（originalとcurrentは同値にすること）
      original: 1.1,  // 元々の値（毎日currentをoriginalで初期化する）
      current: 1.1,   // 現在の値（判定処理にはcurrentを用いる）
      decrease: 0.25 // 減少値（発言一回ごとに減少値分currentを減らす）
    },
    // COProbability {自身のRoleId : その役職としてCOする可能性}
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
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.3,
      love: 0.7
    }
  );
}


/**
 * @classdec 雨晴はうの性格クラス
 * 論理寄り。主張力は低め。役職COについて、人外の場合は潜伏しがち。占いと疑うへの抵抗力が低い。
 */
function Personality_hau() {
  return new Personality (
    '雨晴はう', // name
    0.7, // logical 論理力(0～1)
    1,
    {
      action: {}
    },
    1,
    {
      action: {
        [ACTION_FORTUNE_TELLING]: 0.8,
        [ACTION_SUSPECT]: 0.8,
      },
      actor: {}
    },
    { // assertiveness 主張力（originalとcurrentは同値にすること）
      original: 0.9,  // 元々の値（毎日currentをoriginalで初期化する）
      current: 0.9,   // 現在の値（判定処理にはcurrentを用いる）
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
        [ROLE_ID_FORTUNE_TELLER]: 0.1
      }
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.2,
      love: 0.7
    }
  );
}


/**
 * @classdec 波音リツの性格クラス
 * 頑固で、議論の影響を与えにくく受けにくい。疑うの影響力だけ高い。役持ちの場合COしがち。HATEになりやすくLOVEになりにくい
 */
function Personality_ritsu() {
  return new Personality (
    '波音リツ', // name
    0.6, // logical 論理力(0～1)
    1,
    {
      action: {
        [ACTION_SUSPECT]: 1.2
      }
    },
    1.2,
    {
      action: {},
      actor: {}
    },
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
        [ROLE_ID_FORTUNE_TELLER]: 0.9
      }
    },
    { // feelingBorder {hate:仲間度がこれ未満ならhate状態, love:仲間度がこれ超過ならlove状態}
      hate: 0.35,
      love: 0.75
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
