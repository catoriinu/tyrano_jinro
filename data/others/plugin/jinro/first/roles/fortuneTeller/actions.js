(function(global) {
  const namespace = global.jinroRoles = global.jinroRoles || {};

  function assignFortuneTellerActions(roleObject) {
    /**
     * 占い実行メソッド
     * @param {String} fortuneTellerId 占い師のキャラクターID（真偽併用）
     * @param {Number} day 占い実行日（過去の日付で占ったことにしたいときに指定）
     * @param {String} targetCharacterId 占い対象のキャラクターID
     * @param {Object} result PCの騙り占い師による結果騙り入力(t:●/f:○) デフォルト（PCの真占い師、またはNPCの場合）はnull
     * @returns {Object} 占いCOする結果オブジェクト{characterId, result(t:●/f:○)}
     */
    roleObject.fortuneTelling = function(fortuneTellerId, day = TYRANO.kag.stat.f.day, targetCharacterId = '', result = null) {
      // 占い先が未決定の場合、決める（NPC専用。プレイヤーなら占い先を先に決めているため）
      if (!targetCharacterId) {
        [targetCharacterId, result] = this.determineFortuneTellingTargetId(
          TYRANO.kag.stat.f.characterObjects[fortuneTellerId],
          day
        );
      }

      // 占い結果が未決定の場合、占い先のisWerewolvesプロパティを格納する（真占い師専用）
      if (typeof result != "boolean") {
        result = TYRANO.kag.stat.f.characterObjects[targetCharacterId].role.isWerewolves;
        // NOTE:真占い師かつターゲットが妖狐の場合、妖狐を呪殺する
      }

      console.debug(fortuneTellerId + ' fortuneTelled ' + targetCharacterId);
      console.debug('result : ' + result);

      // 指定された日（デフォルトは今日）の占い結果をアクションオブジェクトに保存＆返却する
      const todayResult = new Action(
        fortuneTellerId,
        ACTION_FORTUNE_TELLING,
        targetCharacterId,
        result,
        false
      );

      this.fortuneTellingHistory[day] = todayResult;

      return todayResult;
    };
  }

  namespace.assignFortuneTellerActions = assignFortuneTellerActions;
})(typeof window !== "undefined" ? window : this);