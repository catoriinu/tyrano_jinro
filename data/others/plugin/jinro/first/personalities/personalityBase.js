/**
 * @classdec Base class for personalities.
 * @param {String} name Name of the personality.
 * @param {Number} logical Logical parameter value.
 * @param {Number} influenceMultiplier Multiplier for influence.
 * @param {Object} adjustmentInfluenceMultiplier Adjustment map for influence multiplier.
 * @param {Number} registanceMultiplier Multiplier for resistance.
 * @param {Object} adjustmentRegistanceMultiplier Adjustment map for resistance multiplier.
 * @param {Number} assertiveness Assertiveness configuration {original,current,decrease}.
 * @param {Number} limitFrustration Frustration threshold.
 * @param {Object} roleCOProbability Probability map for role CO actions.
 * @param {Object} feelingBorder Emotion border definition.
 */
(function(global) {
  const namespace = global.jinroPersonalities = global.jinroPersonalities || {};

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
  ) {
    this.name = name;
    this.influenceMultiplier = influenceMultiplier;
    this.adjustmentInfluenceMultiplier = adjustmentInfluenceMultiplier;
    this.registanceMultiplier = registanceMultiplier;
    this.adjustmentRegistanceMultiplier = adjustmentRegistanceMultiplier;
    this.logical = logical;
    this.assertiveness = assertiveness;
    this.limitFrustration = limitFrustration;
    this.roleCOProbability = roleCOProbability;
    this.feelingBorder = feelingBorder;
  }

  namespace.Personality = Personality;
})(typeof window !== "undefined" ? window : this);
