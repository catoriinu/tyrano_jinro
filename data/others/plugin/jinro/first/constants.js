// 定数定義

// キャラクターID
const CHARACTER_ID_AI     = 'ai'; // アイ
const CHARACTER_ID_HIYORI = 'hiyori'; // ヒヨリ
const CHARACTER_ID_FUTABA = 'futaba'; // フタバ
const CHARACTER_ID_MIKI   = 'miki'; // ミキ
const CHARACTER_ID_YU     = 'yu'; // ユウ
const CHARACTER_ID_DUMMY  = 'dummy'; // ダミー
const CHARACTER_ID_ZUNDAMON = 'zundamon'; // ずんだもん
const CHARACTER_ID_METAN    = 'metan';    // 四国めたん
const CHARACTER_ID_TSUMUGI  = 'tsumugi';  // 春日部つむぎ
const CHARACTER_ID_HAU      = 'hau';      // 雨晴はう
const CHARACTER_ID_RITSU    = 'ritsu';    // 波音リツ
const CHARACTER_ID_TAKEHIRO = 'takehiro'; // 玄野武宏
const CHARACTER_ID_KOTARO   = 'kotaro';   // 白上虎太郎
const CHARACTER_ID_RYUSEI   = 'ryusei';   // 青山龍星
const CHARACTER_ID_HIMARI   = 'himari';   // 冥鳴ひまり
const CHARACTER_ID_SORA     = 'sora';     // 九州そら
const CHARACTER_ID_MESUO    = 'mesuo';    // 剣崎雌雄
const CHARACTER_ID_MOCHIKO  = 'mochiko';  // もち子さん
const CHARACTER_ID_MIKO     = 'miko';     // 櫻歌ミコ

// 登場する全てのキャラクターIDと名前、およびその基本的な序列
const PARTICIPANTS_LIST = [
  {characterId: CHARACTER_ID_ZUNDAMON, name: 'ずんだもん'},
  {characterId: CHARACTER_ID_METAN,    name: '四国めたん'},
  {characterId: CHARACTER_ID_TSUMUGI,  name: '春日部つむぎ'},
  {characterId: CHARACTER_ID_HAU,      name: '雨晴はう'},
  {characterId: CHARACTER_ID_RITSU,    name: '波音リツ'},
  {characterId: CHARACTER_ID_TAKEHIRO, name: '玄野武宏'},
  {characterId: CHARACTER_ID_KOTARO,   name: '白上虎太郎'},
  {characterId: CHARACTER_ID_RYUSEI,   name: '青山龍星'},
  {characterId: CHARACTER_ID_HIMARI,   name: '冥鳴ひまり'},
  {characterId: CHARACTER_ID_SORA,     name: '九州そら'},
  {characterId: CHARACTER_ID_MESUO,    name: '剣崎雌雄'},
  {characterId: CHARACTER_ID_MOCHIKO,  name: 'もち子さん'},
//  {characterId: CHARACTER_ID_MIKO,     name: '櫻歌ミコ'},
];

// 実装済みキャラクターの参加ステータス
const PARTICIPATE_AS_PC = 'pc';
const PARTICIPATE_AS_NPC = 'npc';
const NOT_PARTICIPATE = 'not';
// 初回起動時のみ、デフォルト設定値を入れる
if (!('participantStatus' in TYRANO.kag.variable.sf)) {
  TYRANO.kag.variable.sf.participantStatus = {
    [CHARACTER_ID_ZUNDAMON]: PARTICIPATE_AS_PC,
    [CHARACTER_ID_METAN]:    PARTICIPATE_AS_NPC,
    [CHARACTER_ID_TSUMUGI]:  PARTICIPATE_AS_NPC,
    [CHARACTER_ID_HAU]:      PARTICIPATE_AS_NPC,
    [CHARACTER_ID_RITSU]:    PARTICIPATE_AS_NPC,
    [CHARACTER_ID_TAKEHIRO]: NOT_PARTICIPATE,
    [CHARACTER_ID_KOTARO]:   NOT_PARTICIPATE,
    [CHARACTER_ID_RYUSEI]:   NOT_PARTICIPATE,
    [CHARACTER_ID_HIMARI]:   NOT_PARTICIPATE,
    [CHARACTER_ID_SORA]:     NOT_PARTICIPATE,
    [CHARACTER_ID_MESUO]:    NOT_PARTICIPATE,
    [CHARACTER_ID_MOCHIKO]:  NOT_PARTICIPATE,
  }
}

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
const FACTION_VILLAGERS  = 'villagers'; // 村人陣営
const FACTION_WEREWOLVES = 'werewolves'; // 人狼陣営
const FACTION_DRAW_BY_REVOTE = 'drawByRevote'; // 再投票による引き分け

// 役職IDと役職陣営の対応オブジェクト
const ROLE_ID_TO_FACTION = {
    [ROLE_ID_VILLAGER]: FACTION_VILLAGERS,
    [ROLE_ID_WEREWOLF]: FACTION_WEREWOLVES,
    [ROLE_ID_FORTUNE_TELLER]: FACTION_VILLAGERS,
    [ROLE_ID_MADMAN]: FACTION_WEREWOLVES,
    [ROLE_ID_PHYCHIC]: FACTION_VILLAGERS,
    [ROLE_ID_HUNTER]: FACTION_VILLAGERS,
    [ROLE_ID_FOX]: 'TODO',
}

// アクション実行上限回数
const MAX_DO_ACTION_COUNT = 3;

// 再投票上限回数（これが初回を含めた最大投票回数となる）
const MAX_REVOTE_COUNT = 4;

// 計算方法（信頼度更新用）
const ARITHMETIC_ADDITION = 'addition'; // 現在の値に加算する（減算したい場合は負の値を足す）
const ARITHMETIC_MULTIPLICATION = 'multiplication'; // 現在の値に乗算する（除算したい場合は1未満の値を掛ける）

// 感情
const FEELING_HATE = 'hate';
const FEELING_NEUTRAL = 'neutral';
const FEELING_LOVE = 'love';

// アクション名
const ACTION_SUSPECT = 'suspect'; // 疑う（アクションボタン）
const ACTION_TRUST = 'trust'; // 信じる（アクションボタン）
const ACTION_ASK = 'ask'; // 聞き出す（アクションボタン　未使用）
const ACTION_CANCEL = 'cancel'; // 発言しない（アクションボタン）
const ACTION_FORTUNE_TELLING = 'fortuneTelling'; // 占う
const ACTION_VOTE = 'vote'; // 投票
const ACTION_EXECUTE = 'execute'; // 処刑。投票による吊り・追放（死亡処理アクション）
const ACTION_BITE = 'bite'; // 襲撃。人狼による噛み（死亡処理アクション）

// 判断基準
const DECISION_LOGICAL = 'logical'; // 論理的な判断
const DECISION_EMOTIONAL = 'emotional'; // 感情的な判断

// CSSのclass要素名（glinkのnameやcolorに設定するなど）
const CLASS_GLINK_DEFAULT = 'btn_voivo'; // glinkのcolor用。ゲーム内で基本となるボタンのテーマ
const CLASS_GLINK_SELECTED = 'btn_voivo_selected'; // glinkのname用。現在選択されているボタン用のテーマ
const CLASS_GLINK_WHITE = 'btn_voivo_white'; // glinkのname用。白色のテーマ（未作成）
const CLASS_GLINK_BLACK = 'btn_voivo_black'; // glinkのname用。黒色のテーマ（未作成）

// 設定値
// ボタン配置範囲
const BUTTON_RANGE_Y_UPPER = -30 // 上限
const BUTTON_RANGE_Y_LOWER = 505 // 下限
const BUTTON_MARGIN_HEIGHT = 30 // ボタンの上下の余白

// 開発者用設定のシステム変数設定
// 初回起動時のみ、デフォルト設定値を入れる
function resetJDevelopmentSettingToDefault() {
  TYRANO.kag.variable.sf.j_development = {
    dictatorMode: false,
    doShuffle: true,
    maxDoActionCount: MAX_DO_ACTION_COUNT,
    thinking: 'default'
  }
}
if (!('j_development' in TYRANO.kag.variable.sf)) {
  resetJDevelopmentSettingToDefault();
}
