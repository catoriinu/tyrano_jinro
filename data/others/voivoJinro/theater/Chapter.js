/**
 * チャプターオブジェクト
 * [call]や[jump]で飛ぶための情報を格納する
 * @param {String} storage チャプターのシナリオが記載されたファイル名。scenarioフォルダからの相対パス
 * @param {String} target storageのファイル内で再生開始するラベル名
 * @param {Boolean} needPlay 再生するかどうかのフラグ
 */
function Chapter(storage, target = '', needPlay = true) {
  this.storage = storage;
  this.target = target;
  this.needPlay = needPlay;
}
