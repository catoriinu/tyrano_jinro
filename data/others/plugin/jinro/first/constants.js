// 定数定義

// ティラノ変数オブジェクト
const TYRANO_VAR_F  = tyrano.plugin.kag.stat.f; // ゲーム変数
const TYRANO_VAR_SF = tyrano.plugin.kag.variable.sf; // システム変数
const TYRANO_VAR_TF = tyrano.plugin.kag.variable.tf; // 一時変数

// キャラクターID
const CHARACTER_ID_AI     = 'ai'; // アイ
const CHARACTER_ID_HIYORI = 'hiyori'; // ヒヨリ
const CHARACTER_ID_FUTABA = 'futaba'; // フタバ
const CHARACTER_ID_MIKI   = 'miki'; // ミキ
const CHARACTER_ID_YU     = 'yu'; // ユウ
const CHARACTER_ID_DUMMY  = 'dummy'; // ダミー

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

// 死因
const DEATH_BY_EXECUTION = 'execution'; // 処刑。投票による吊り・追放
const DEATH_BY_ATTACK    = 'attack'; // 襲撃。人狼による噛み。


// 設定値
// ボタン配置範囲
const BUTTON_RANGE_Y_UPPER = -25 // 上限
const BUTTON_RANGE_Y_LOWER = 505 // 下限