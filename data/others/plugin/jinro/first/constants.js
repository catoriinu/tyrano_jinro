// 定数定義

// キャラクターID
const CHARACTER_ID_AI     = 'ai'; // アイ
const CHARACTER_ID_HIYORI = 'hiyori'; // ヒヨリ
const CHARACTER_ID_FUTABA = 'futaba'; // フタバ
const CHARACTER_ID_MIKI   = 'miki'; // ミキ
const CHARACTER_ID_YU     = 'yu'; // ユウ
const CHARACTER_ID_DUMMY  = 'dummy'; // ダミー
const CHARACTER_ID_ZUNDAMON = 'zundamon'; // ずんだもん
const CHARACTER_ID_METAN    = 'metan'; // 四国めたん
const CHARACTER_ID_TSUMUGI  = 'tsumugi'; // 春日部つむぎ
const CHARACTER_ID_HAU      = 'hau'; // 雨晴はう
const CHARACTER_ID_RITSU    = 'ritsu'; // 波音リツ

// 役職ID
const ROLE_ID_VILLAGER       = 'villager'; // 村人
const ROLE_ID_WEREWOLF       = 'werewolf'; // 人狼
const ROLE_ID_FORTUNE_TELLER = 'fortuneTeller'; // 占い師
const ROLE_ID_MADMAN         = 'madman'; // 狂人
const ROLE_ID_PHYCHIC        = 'psychic'; // 霊能力者
const ROLE_ID_HUNTER         = 'hunter'; // 狩人
const ROLE_ID_FOX            = 'fox'; // 妖狐

// 役職IDと役職名の対応オブジェクト
const ROLE_ID_TO_NAME = {
    [ROLE_ID_VILLAGER]: '村人',
    [ROLE_ID_WEREWOLF]: '人狼',
    [ROLE_ID_FORTUNE_TELLER]: '占い師',
    [ROLE_ID_MADMAN]: '狂人',
    [ROLE_ID_PHYCHIC]: '霊能力者',
    [ROLE_ID_HUNTER]: '狩人',
    [ROLE_ID_FOX]: '妖狐',
}

// 陣営
const CAMP_VILLAGERS  = 'villagers'; // 村人陣営
const CAMP_WEREWOLVES = 'werewolves'; // 人狼陣営
const CAMP_DRAW_BY_REVOTE = 'drawByRevote'; // 再投票による引き分け

// 役職IDと役職陣営の対応オブジェクト
// TODO:全体的にCAMP→FACTIONに置換する
// TODO:role.campもこの定数を利用して入れるようにしたい
const ROLE_ID_TO_FACTION = {
    [ROLE_ID_VILLAGER]: CAMP_VILLAGERS,
    [ROLE_ID_WEREWOLF]: CAMP_WEREWOLVES,
    [ROLE_ID_FORTUNE_TELLER]: CAMP_VILLAGERS,
    [ROLE_ID_MADMAN]: CAMP_WEREWOLVES,
    [ROLE_ID_PHYCHIC]: CAMP_VILLAGERS,
    [ROLE_ID_HUNTER]: CAMP_VILLAGERS,
    [ROLE_ID_FOX]: 'TODO',
}

// アクション実行上限回数
const MAX_DO_ACTION_COUNT = 3;

// 死因
const DEATH_BY_EXECUTION = 'execution'; // 処刑。投票による吊り・追放
const DEATH_BY_ATTACK    = 'attack'; // 襲撃。人狼による噛み。

// 再投票上限回数（これが初回を含めた最大投票回数となる）
const MAX_REVOTE_COUNT = 4;

// 信頼度を更新する理由
// TODO アクションIDと理由を紐づける別のオブジェクトがほしい。こっちの中身は受動態にしたい
const REASON_WAS_VOTED = 'wasVoted'; // 相手に投票されたとき
const REASON_WAS_SUSPECTED = 'suspect'; // 相手に「疑う」されたとき
const REASON_WAS_TRUSTED = 'trust'; // 相手に「信じる」されたとき
const REASON_WAS_ASKED = 'ask'; // 相手に「聞き出す」されたとき
const REASON_TEST = 'test' // テスト用
// 計算方法（信頼度更新用）
const ARITHMETIC_ADDITION = 'addition'; // 現在の値に加算する（減算したい場合は負の値を足す）
const ARITHMETIC_MULTIPLICATION = 'multiplication'; // 現在の値に乗算する（除算したい場合は1未満の値を掛ける）

// 感情
const FEELING_HATE = 'hate';
const FEELING_NORMAL = 'normal';
const FEELING_LOVE = 'love';

// アクション名
const ACTION_SUSPECT = 'suspect'; // 疑う（アクションボタン）
const ACTION_TRUST = 'trust'; // 信じる（アクションボタン）
const ACTION_ASK = 'ask'; // 聞き出す（アクションボタン　未使用）
const ACTION_FORTUNE_TELLING = 'fortuneTelling'; // 占う（未使用）
const ACTION_VOTE = 'vote'; // 投票（未使用）


// 設定値
// ボタン配置範囲
const BUTTON_RANGE_Y_UPPER = -30 // 上限
const BUTTON_RANGE_Y_LOWER = 505 // 下限
const BUTTON_MARGIN_HEIGHT = 30 // ボタンの上下の余白
