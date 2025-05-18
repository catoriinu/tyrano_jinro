/**
 * Versionクラス
 * @param {number} major メジャーバージョン番号
 * @param {number} minor マイナーバージョン番号
 * @param {number} patch パッチバージョン番号
 * @param {boolean} isDebugMode デバッグモードかどうか
 */
class Version {
    constructor(major, minor, patch, isDebugMode) {
        this.major = major;
        this.minor = minor;
        this.patch = patch;
        this.isDebugMode = isDebugMode;
    }

    /**
     * バージョン情報を表す文字列を返却する
     * @param {string} prefixParam バージョン情報のプレフィックス。デフォルトは'ver.'
     * @param {string} suffixParam バージョン情報のサフィックス。デフォルトは''
     * @returns {string} バージョン情報を表す文字列
     */
    getVersionText(prefixParam = 'ver.', suffixParam = '') {
        let suffix = suffixParam;
        // デバッグモードのときは、バージョン情報にデバッグモードであることを示す文字列を付加する
        if (this.isDebugMode) {
            suffix = `(debug)${suffix}`;
        }
        return `${prefixParam}${this.major}.${this.minor}.${this.patch}${suffix}`;
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
 * ゲーム本体のバージョン情報を指定し、Versionインスタンスとして返却する。
 * シナリオ変数内にバージョン情報がある場合、現在のバージョンがそれより新しい場合は更新し、同じ以下の場合はインスタンスを生成するのみとする。
 * 
 * @param {number} major メジャーバージョン番号
 * @param {number} minor マイナーバージョン番号
 * @param {number} patch パッチバージョン番号
 * @param {boolean} isDebugMode デバッグモードかどうか。デフォルトはfalse
 * @param {boolean} forceUpdate 強制的にバージョン情報を更新するかどうか。デフォルトはfalse
 * @returns {Version} Versionインスタンス
 */
function buildSfVersion(major, minor, patch, isDebugMode, forceUpdate = false) {
    const currentVersion = new Version(major, minor, patch, isDebugMode);

    if (!('version' in TYRANO.kag.variable.sf) || forceUpdate) {
        return currentVersion;
    } else {
        const major = TYRANO.kag.variable.sf.version.major;
        const minor = TYRANO.kag.variable.sf.version.minor;
        const patch = TYRANO.kag.variable.sf.version.patch;
        const lastVersion = new Version(major, minor, patch, isDebugMode);
        if (currentVersion.isNewerThan(lastVersion)) {
            // MEMO: lastVersionより新しかった場合、sfを最新版用にコンバートする必要があるかを判定、更新するようにする
            return currentVersion;
        } else {
            return lastVersion;
        }
    }
}