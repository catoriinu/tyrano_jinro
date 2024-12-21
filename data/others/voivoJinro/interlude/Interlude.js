/**
 * 幕間オブジェクト
 * @param {String} storage 
 * @param {String} target 
 * @param {Boolean} needPlay
 */
function Interlude(storage, target, needPlay = true) {
  this.storage = storage;
  this.target = target;
  this.needPlay = needPlay;
}