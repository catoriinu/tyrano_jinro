# 性格 (Personality)

NPCの振る舞いの個性を定義するデータクラス。
行動選択・信頼度の伝播・発言頻度・CO ふるまい・感情閾値など、jinroプラグインの**思考モデル三層（視点／信頼度／性格）**のうち「性格」層を担います。

実装ファイル：data/others/plugin/jinro/first/personalities.js

対象バージョン：人狼プラグイン v0.14.0 時点

目的：キャラごとの“らしさ”を、**論理（視点重視度）× 感情（信頼度の動き）× ふるまい（発言・CO・しきい値）**で表現・調整する

## TL;DR（最重要ポイント）

- 論理力 … 仲間度の計算やターゲット選択で視点をどれだけ優先するかを決める主因子。
- 影響力／抵抗力 … 信頼度の他者への与えやすさと自分の動きにくさを倍率で制御。
- 主張力 … その日しゃべりやすいか（抽選で選ばれやすいか）と、喋るほど下がるスタミナ。
- フラストレーション限界値 … アクション横取りが続くと「喋りすぎ」カウンターが出る閾値。
- 役職ごとの CO 確率 … 真／偽それぞれがどの役職として CO しやすいかの考え方。
- 感情の境界値 … 信頼度がどこから love／どこまでが hateかの個性。反応/伝播に効く。

## データ構造（API リファレンス）

```
/**
 * @classdec 性格情報を格納するクラス
 * @param {String} name 日本語名
 * @param {Number} logical 論理力（0〜1）
 * @param {Number} influenceMultiplier 影響力（倍率。基準1）
 * @param {Object} adjustmentInfluenceMultiplier 影響力の行為別調整
 * @param {Number} registanceMultiplier 抵抗力（倍率。基準1）
 * @param {Object} adjustmentRegistanceMultiplier 抵抗力の行為/実行者別調整
 * @param {Object} assertiveness 主張力（original/current/decrease）
 * @param {Number} limitFrustration フラストレーション限界値
 * @param {Object} roleCOProbability 役職ごとのCO確率
 * @param {Object} feelingBorder 感情の境界値（hate/love）
 */
function Personality(
  name,
  logical,
  influenceMultiplier,
  adjustmentInfluenceMultiplier,
  registanceMultiplier,
  adjustmentRegistanceMultiplier,
  assertiveness,
  limitFrustration,
  roleCOProbability,
  feelingBorder
) { ... }
```

## 各プロパティの意味と仕様

### 1) `name` : `String`
- 性格の表示・デバッグ用の日本語名。

### 2) `logical` : `Number (0〜1)`
- **視点（論理）と信頼度（感情）の混合比**を決める主要パラメータ。
- 高いほど論理派（確定情報に敏感）、低いほど感情派（love/hateの揺れが強く効く）。

### 3) `influenceMultiplier` : `Number (基準1)`
- そのキャラが周囲の**信頼度に与える影響の大きさ**（攻撃力イメージ）。
- 倍率が高いと行動が他者に強く響く。

#### 3-1) `adjustmentInfluenceMultiplier` : `Object`
- **行為別の影響力補正**。
- 例：`{ action: { suspect: 1.2 } }` → 疑う行為のみ影響が20%増加。

### 4) `registanceMultiplier` : `Number (基準1)`
- そのキャラ自身の**信頼度がどれだけ動きにくいか**（守備力イメージ）。
- 増減量は「計算値 ÷ registanceMultiplier」で処理される。

#### 4-1) `adjustmentRegistanceMultiplier` : `Object`
- **行為別／実行者別の抵抗力補正**。
- 例：`{ action: { trust: 0.5 } }` → 「信じる」に弱く、信頼度が2倍動く。

### 5) `assertiveness` : `Object`
- **主張力（スタミナ）**を表すオブジェクト。
- 発言抽選の際に [0, current] の範囲で乱数を取り、最も大きい値を出したキャラが発言する。
```
  {
    original: Number, // 毎日リセット後の基準値
    current: Number,  // 当日中に減っていく可変値
    decrease: Number  // 発言一回ごとに減る量
  }
```

### 6) `limitFrustration` : `Number`
- フラストレーションの限界値。
- 発言抽選で外れた際に不満が溜まり、閾値を超えると「喋りすぎ」リアクションが発動する。

### 7) `roleCOProbability` : `Object`
- 役職ごとにどの役職としてCOするかの確率を定義。
- 「真占はほぼ占CO」「狂人は高確率で占騙り」といった性格差を再現可能。
```
{
  [ROLE_ID_FORTUNE_TELLER]: { [ROLE_ID_FORTUNE_TELLER]: 0.95 },
  [ROLE_ID_WEREWOLF]:       { [ROLE_ID_FORTUNE_TELLER]: 0.4 },
  [ROLE_ID_MADMAN]:         { [ROLE_ID_FORTUNE_TELLER]: 0.8 }
}
```

### 8) feelingBorder : Object
- love／hate 状態の閾値。
```
{
  hate: 0.3, // これ未満で hate
  love: 0.7  // これ超過で love
}
```