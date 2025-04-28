/**
 * Versionクラス
 * @param {number} major メジャーバージョン番号
 * @param {number} minor マイナーバージョン番号
 * @param {number} patch パッチバージョン番号
 */
class Version {
    constructor(major, minor, patch) {
        this.major = major;
        this.minor = minor;
        this.patch = patch;
    }

    /**
     * バージョン情報を表す文字列を返却する
     * @param {string} prefix バージョン情報のプレフィックス。デフォルトは'ver.'
     * @returns {string} バージョン情報を表す文字列
     */
    getVersionText(prefix = 'ver.') {
        return `${prefix}${this.major}.${this.minor}.${this.patch}`;
    }

    /**
     * otherVersionより新しいかどうかを判定する
     * @param {Version} otherVersion 
     * @returns {boolean} otherVersionより新しいかどうか
     */
    isNewerThan(otherVersion) {
        if (this.major > otherVersion.major) return true;
        if (this.major < otherVersion.major) return false;
        if (this.minor > otherVersion.minor) return true;
        if (this.minor < otherVersion.minor) return false;
        return this.patch > otherVersion.patch;
    }
}

/**
 * ゲーム本体のバージョン情報を指定し、シナリオ変数にVersionインスタンスとして保存する。
 * シナリオ変数内にバージョン情報がある場合、現在のバージョンがそれより新しい場合は更新し、同じ以下の場合はインスタンスを生成するのみとする。
 * 
 * @param {number} major メジャーバージョン番号
 * @param {number} minor マイナーバージョン番号
 * @param {number} patch パッチバージョン番号
 * @param {boolean} forceUpdate 強制的にバージョン情報を更新するかどうか。デフォルトはfalse
 */
function buildSfVersion(major, minor, patch, forceUpdate = false) {
    const currentVersion = new Version(major, minor, patch);

    if (!('version' in TYRANO.kag.variable.sf) || forceUpdate) {
        TYRANO.kag.variable.sf.version = currentVersion;
    } else {
        const major = TYRANO.kag.variable.sf.version.major;
        const minor = TYRANO.kag.variable.sf.version.minor;
        const patch = TYRANO.kag.variable.sf.version.patch;
        const lastVersion = new Version(major, minor, patch);
        if (currentVersion.isNewerThan(lastVersion)) {
            // MEMO: lastVersionより新しかった場合、sfを最新版用にコンバートする必要があるかを判定、更新するようにする
            TYRANO.kag.variable.sf.version = currentVersion;
        } else {
            TYRANO.kag.variable.sf.version = lastVersion;
        }
    }
}