; -------------------------
; ゲーム準備系マクロ
; -------------------------

; @param jinroGameData 人狼ゲームデータ。未指定なら sf.jinroGameDataObjects[sf.currentJinroGameDataKey] を使用
[macro name="j_prepareJinroGame"]
  [iscript]
    console.debug('[j_prepareJinroGame] start');

    let jinroGameData = null;
    if (typeof mp.jinroGameData !== 'undefined' && mp.jinroGameData !== null) {
      jinroGameData = mp.jinroGameData;
    } else if (
      sf.jinroGameDataObjects &&
      typeof sf.currentJinroGameDataKey !== 'undefined' &&
      sf.currentJinroGameDataKey !== null &&
      sf.jinroGameDataObjects[sf.currentJinroGameDataKey]
    ) {
      jinroGameData = sf.jinroGameDataObjects[sf.currentJinroGameDataKey];
    }

    if (!jinroGameData) {
      throw new Error('[j_prepareJinroGame] 人狼ゲームデータが取得できませんでした。');
    }

    initializeCharacterObjectsForJinro(jinroGameData);
    initializeTyranoValiableForJinro();
    console.debug('[j_prepareJinroGame] complete');
  [endscript]
[endmacro]


; -------------------------
; アクション系マクロ
; -------------------------

; 占いマクロ
; @param fortuneTellerId 占い実行者のID。真占い師、占い騙りに関わらず、必須。
; @param day 占った日付。指定がない場合のデフォルトは当日。占い騙りのように前日の夜に占ったことを偽装する必要がある場合は指定すること。
; @param characterId 占う対象のID。入っているなら、実行者はプレイヤーである。入っていないなら実行者はNPCのため、メソッド内部で対象を決める。
; @param result プレイヤーかつ騙りの占い師の場合のみ必要。宣言する占い結果をbooleanまたはstringで渡す。
[macro name="j_fortuneTelling"]
  [iscript]
    // jsに渡す引数の準備。マクロへの指定がなければデフォルト値を入れる
    const day = (typeof mp.day == 'undefined') ? f.day : parseInt(mp.day);
    const targetCharacterId = (typeof mp.characterId == 'undefined') ? '' : mp.characterId;
    const declarationResult = (function(){
      if (typeof mp.result == 'string') {
        // ※マクロの引数としてベタ書きでboolやnumを渡しても、stringに型変換されてしまうため、jinroプラグインに渡す前にstring→boolに変換する。
        // jsは空文字でないstringをtrueと評価するため、確実に'true'でないとtrueを入れないようにする。
        return (mp.result === 'true') ? true : false;
      } else if (typeof mp.result == 'boolean') {
        // boolean型ならそのまま格納する（マクロの引数に変数としてbooleanで渡して来た場合を考慮）
        return mp.result;
      } else {
        // その他の型（未指定でundefined）ならnull
        return null;
      }
    })();

    let todayResult = {};
    // 占い実行
    if (f.characterObjects[mp.fortuneTellerId].fakeRole.roleId == ROLE_ID_FORTUNE_TELLER) {
      // 占い騙りの場合
      todayResult = f.characterObjects[mp.fortuneTellerId].fakeRole.fortuneTelling(mp.fortuneTellerId, day, targetCharacterId, declarationResult);
    } else {
      // 真占いの場合
      todayResult = f.characterObjects[mp.fortuneTellerId].role.fortuneTelling(mp.fortuneTellerId, day, targetCharacterId);
    }

    // 占い師の視点整理
    // 真占い師の場合のみ、占い師視点（＝本人の思考に使う視点）の視点整理を行う。
    // 騙りの場合には視点整理は行わない。（騙りの占い結果は自分視点の真実ではないため、視点整理が必要ないため）
    if (f.characterObjects[mp.fortuneTellerId].role.roleId == ROLE_ID_FORTUNE_TELLER) {
      f.characterObjects[mp.fortuneTellerId].role.rolePerspective = organizePerspective(
        f.characterObjects[mp.fortuneTellerId].role.rolePerspective,
        todayResult.targetId,
        getRoleIdsForOrganizePerspective(todayResult.result)
      );
    }

    // メッセージ出力用に占いのアクションオブジェクトを格納
    f.actionObject = todayResult;

    // 全占い結果履歴オブジェクトに占い結果格納
    // TODO メニュー画面用。メニュー画面を後回しにしているうちは一旦コメントアウト
    /*
    if (typeof f.allFortuneTellingHistoryObject[mp.fortuneTellerId] !== 'object') {
      ; 初期化直後は空のオブジェクトを作成
      f.allFortuneTellingHistoryObject[mp.fortuneTellerId] = {};
    }
    f.allFortuneTellingHistoryObject[mp.fortuneTellerId][day] = todayResult;
    */
  [endscript]
[endmacro]



; -------------------------
; 役職CO系マクロ
; -------------------------

; CO候補となるキャラクターID配列からCO候補者を一人決定し、f.COCandidateIdに格納する。
; @param characterIds CO候補となるキャラクターID配列（NPCかつ生存者を想定）。必須
[macro name="j_decideCOCandidateId"]
  [iscript]
    // TODO:直前（PC、NPCどちらも）のCOの内容によって、各キャラ内のCOしたい度が変動するようにする
    // TODO:現状、占い師の役職COと占い結果COしか考慮していない。他の役職を追加するときには要修正

    let maxProbability = 0;
    let COCandidateIdArray = [];
    f.COCandidateId = '';
    for (let i = 0; i < mp.characterIds.length; i++) {

      // 今日、CO済みのキャラは対象外
      if (f.characterObjects[mp.characterIds[i]].isDoneTodaysCO) continue;

      let probability = 0;
      let isCO = false;
      if (f.characterObjects[mp.characterIds[i]].CORoleId != '') {
        // 既に役職CO済みの場合、必ず結果COしたいとする
        [probability, isCO] = [1, true]
      } else if (f.characterObjects[mp.characterIds[i]].role.allowCORoles.length >= 1) {
        // 役職COできる役職で未COの場合、そのキャラの性格からCO確率を取得する
        [probability, isCO] = isCOMyRoll(mp.characterIds[i]);
      }

      // COしたい、かつCO確率が現在保存中の最大の確率以上であれば、キャラクターIDをCO候補配列に格納する
      if (isCO && probability >= maxProbability) {
        COCandidateIdArray.push(mp.characterIds[i]);
        maxProbability = probability;
      }
    }

    // CO候補配列に候補が1人ならその対象を、複数ならランダムで、COするキャラクターIDに決定する。0人の場合は空文字を格納する。
    if (COCandidateIdArray.length == 1) {
      f.COCandidateId = COCandidateIdArray[0];
    } else if (COCandidateIdArray.length >= 2) {
      f.COCandidateId = getRandomElement(COCandidateIdArray);
    }
  [endscript]
[endmacro]


; PCがCOしたいかを確認する必要があるかを判定し、tf.isNeedToAskPCWantToCOに結果を入れる
[macro name="j_setIsNeedToAskPCWantToCO"]
  [iscript]
    tf.isNeedToAskPCWantToCO = false;
    // 以下の条件を満たした場合、PCがCOしたいかを確認する必要があると判定する
    // 生存している && COできる役職か && 今日は未COか
    if (f.characterObjects[f.playerCharacterId].isAlive
      && f.characterObjects[f.playerCharacterId].role.allowCORoles.length >= 1
      && !f.characterObjects[f.playerCharacterId].isDoneTodaysCO
    ) {
      tf.isNeedToAskPCWantToCO = true;
    }
  [endscript]
[endmacro]


; 偽役職オブジェクトを取得するマクロ（人外による役職COを想定。なお、ギドラや撤回COは想定していない）
; @param characterId COするキャラクターのキャラクターID
; @param roleId COする役職の役職ID
[macro name="j_assignmentFakeRole"]
  [iscript]
    // 偽役職COしていない場合のみ実行 NOTE 撤回COさせたくなったらマクロの引数で強制できるようにする
    if (Object.keys(f.characterObjects[mp.characterId].fakeRole).length === 0) {
      f.characterObjects[mp.characterId].fakeRole = getRole(mp.roleId);

      // 今までの表の視点を破棄。現在の共通視点から新しく騙り役職についた状態での表の視点を上書きする。
      // ちなみに、fakeRole.rolePerspectiveは利用しないので空オブジェクトのままとなるので注意。
      // TODO ここで破綻することもありうる。対策を。
      f.characterObjects[mp.characterId].perspective = organizePerspective (
        f.commonPerspective,
        mp.characterId,
        f.uniqueRoleIdList.filter(rId => (rId != mp.roleId))
      );
    }
  [endscript]
[endmacro]


; 共通視点オブジェクトを更新する。
; 同時に、各キャラの視点オブジェクトも更新する
; TODO 更新した履歴はティラノ変数に残しておくこと。例えば後から占い師が確定したときに、追従して反映できるようにするため。
; @param characterId 0確定するキャラクターID。必須。
; @param zeroRoleIds 0確定する役職ID配列。必須。
[macro name="j_updateCommonPerspective"]
  [iscript]
    updateCommonPerspective(mp.characterId, mp.zeroRoleIds);
  [endscript]
[endmacro]


; 役職側の視点オブジェクトを表の視点オブジェクトにcloneする。
; 真役職CO時に利用。騙りCOには使わないこと。騙りCOの際は、j_assignmentFakeRoleマクロで表の視点を作成しているため。
; TODO j_COFortuneTellingUntilTheLastDayの中に移動させたい
; @param characterId COするキャラクターID。必須。
; @param CORoleId COする役職ID。roleに格納されていることが前提。必須。
[macro name="j_cloneRolePerspectiveForCO"]
  [iscript]
    if (f.characterObjects[mp.characterId].role.roleId == mp.CORoleId) {
      f.characterObjects[mp.characterId].perspective = clone(f.characterObjects[mp.characterId].role.rolePerspective);
    }
  [endscript]
[endmacro]


; 指定したキャラクターの、指定した日の占い履歴アクションオブジェクトをもとに、COを実行する。
; 占い師、占い騙り両対応。
; @param fortuneTellerId 取得したい占い師（騙り占い）のキャラクターID。必須
; @param [day] 取得したい占い日。指定しない場合、その占い師の最新の履歴を取得する。引数の渡し方（型）は0でも"0"でも可。
; @param [noNeedNotice] 占いCO演出（カットインやメッセージ）を表示しないか。trueなら表示しない（複数日分の占いCO時、前日以外の分は表示しないべき）
[macro name="j_COFortuneTelling"]

  [iscript]
    // if文の中でconstで宣言するとif文の外で未定義になるので、事前に宣言しておく。
    let tmpFortuneTellingHistory = {}
    if (f.characterObjects[mp.fortuneTellerId].role.roleId == ROLE_ID_FORTUNE_TELLER) {
      tmpFortuneTellingHistory = f.characterObjects[mp.fortuneTellerId].role.fortuneTellingHistory;
    } else if (f.characterObjects[mp.fortuneTellerId].fakeRole.roleId == ROLE_ID_FORTUNE_TELLER) {
      tmpFortuneTellingHistory = f.characterObjects[mp.fortuneTellerId].fakeRole.fortuneTellingHistory;
    }

    // 取得する日を決定する。引数があればその日の、なければ最新の日の履歴を取得する。
    const day = ('day' in mp) ? parseInt(mp.day) : Object.keys(tmpFortuneTellingHistory).length - 1;
    // その占い履歴を公開（CO済み）に更新する
    tmpFortuneTellingHistory[day].isPublic = true;
    // 信頼度増減とメッセージ出力用にアクションオブジェクトを格納
    f.actionObject = tmpFortuneTellingHistory[day];
    // 占いCOによる信頼度増減を行う
    updateReliabirityForAction(f.characterObjects, f.actionObject);

    // 真占い師でも騙り占い師でも、表の視点オブジェクトを更新する
    // ・CO済みということは対外的な真実であるから ・CO済みであれば占い師としての思考は表の視点を使うから
    try {
      f.characterObjects[mp.fortuneTellerId].perspective = organizePerspective(
        f.characterObjects[mp.fortuneTellerId].perspective,
        f.actionObject.targetId,
        getRoleIdsForOrganizePerspective(f.actionObject.result)
      );
    } catch (error) {
      console.debug(mp.fortuneTellerId + 'は、破綻した占い結果のCOをしてしまいました!');
      // 破綻フラグを立てる
      TYRANO.kag.stat.f.characterObjects[mp.fortuneTellerId].isContradicted = true;
      // 視点オブジェクトが破綻してしまったので、共通視点オブジェクトを入れておく
      // role.rolePerspectiveは更新しない。本人の役職視点での破綻ではないため
      f.characterObjects[mp.fortuneTellerId].perspective = clone(f.commonPerspective);
      // 自分自身は嘘がつける役職（TODO:「嘘をつかない役職配列」をメソッドで取り出せるようにする）だったということで確定する。
      updateCommonPerspective(mp.fortuneTellerId, [ROLE_ID_VILLAGER, ROLE_ID_FORTUNE_TELLER]);
    }

    // 今日のCOが終わったキャラはisDoneTodaysCOをtrueにする
    f.characterObjects[mp.fortuneTellerId].isDoneTodaysCO = true;
  [endscript]

  ; 占い演出、メッセージ出力（mp.noNeedNoticeがtrueなら表示しない）
  [if exp="!(('noNeedNotice' in mp) && (mp.noNeedNotice === 'true' || mp.noNeedNotice === true))"]
    [j_cutin1]
    [m_COFortuneTelling]
  [endif]
[endmacro]


; NPC用騙り占いCOマクロ
; 指定された日から、前日の夜までを占ったことにできる。
; @param fortuneTellerId 占い実行者のID。真占い師、占い騙りに関わらず、必須。
; @param fakeFortuneTelledDay 騙り占いを実行する開始日。
; 指定された日がなければ初日から。（＝2日目以降の騙り占い師CO用）
; 指定された日が前日の夜ならその1回分のみ。（＝騙り占いCO済み時の、騙り占い結果CO用）
; MEMO NPCが2日目以降に騙り占い師COするケースは、現状動作確認していない
[macro name="j_fakeFortuneTellingCOMultipleDays"]

  ; 騙り占いを行う最新の日の日付（＝前日）を入れる。
  [eval exp="tf.lastDay = f.day - 1"]
  ; マクロの引数に開始日が指定されていればそれを、されていなければ0（=初日）を入れる
  [eval exp="tf.fakeFortuneTelledDay = ('fakeFortuneTelledDay' in mp) ? mp.fakeFortuneTelledDay : 0"]

  ; ※マクロ内で別マクロを呼び出すと、別マクロの終了時にmp変数が全て空にされてしまう。
  ; そのため、元マクロ側の引数を元マクロ内で引き続き使いたい場合は、一時変数などに格納しておかないといけない。
  [eval exp="tf.fortuneTellerId = mp.fortuneTellerId"]
  *fakeFortuneTellingCOMultipleDays_loopstart

    ; 占いマクロを、初日(day=0)から最新の日の日付までループ実行していく
    [j_fortuneTelling fortuneTellerId="&tf.fortuneTellerId" day="&tf.fakeFortuneTelledDay"]

  ; 前日まで占い終わったらループ終了
  [jump target="*fakeFortuneTellingCOMultipleDays_loopend" cond="tf.fakeFortuneTelledDay >= tf.lastDay"]

  ; メッセージを表示しないでCOしたことにする（メッセージ表示が必要な、前日の分のCOは呼び元側で行う）
  [j_COFortuneTelling fortuneTellerId="&tf.fortuneTellerId" day="&tf.fakeFortuneTelledDay" noNeedNotice="true"]

  ; 次の日の騙り占いを行う
  [eval exp="tf.fakeFortuneTelledDay++"]
  [jump target="*fakeFortuneTellingCOMultipleDays_loopstart"]

  *fakeFortuneTellingCOMultipleDays_loopend
[endmacro]


; 初日から前日までの占い結果を、メッセージは表示せずにCOしたことにするマクロ
;（真占い師用（騙り占い師は騙り占いマクロ内でCOしたことにしているため不要）。PC、NPC兼用）
; 2日目以降に初めて占いCOした場合に、前日までのCO処理を補完するために利用。
; @param fortuneTellerId 占い実行者のID。必須。
[macro name="j_COFortuneTellingUntilTheLastDay"]

  ; 前日（ループ終了条件用）
  [eval exp="tf.lastDay = f.day - 1"]
  ; 初日（ループ開始条件用）
  [eval exp="tf.CODay = 0"]
  ; マクロ内でマクロを呼ぶので、一時変数に退避させる
  [eval exp="tf.COFortuneTellerId = mp.fortuneTellerId"]

  *j_COFortuneTellingUntilTheLastDay_loopstart

    ; 前日までCOしたらループ終了（当日のCOは呼び元でメッセージを表示して行う）
    ; ※前日が初日の場合は即終了でよい
    [jump target="*j_COFortuneTellingUntilTheLastDay_loopend" cond="tf.CODay >= tf.lastDay"]

    ; メッセージなしでCOしたことにする
    [j_COFortuneTelling fortuneTellerId="&tf.COFortuneTellerId" day="&tf.CODay" noNeedNotice="true"]

    ; 次の日の分をCOする
    [eval exp="tf.CODay++"]
    [jump target="*j_COFortuneTellingUntilTheLastDay_loopstart"]
  *j_COFortuneTellingUntilTheLastDay_loopend

[endmacro]



; -------------------------
; 議論・アクション系マクロ
; -------------------------

; NPCの中からアクション実行候補者、実行するアクション、アクションの対象キャラクターを決定し、
; f.doActionCandidateIdとf.npcActionObjectに格納する。
; また、アクション実行しようとした候補者をf.actionCandidateObjects配列に格納する（フラストレーション増加用）
[macro name="j_decideDoActionByNPC"]
  [iscript]
    // 変数の初期化
    f.npcActionObject = {};
    // アクション実行候補者を取得
    f.actionCandidateObjects = getActionCandidateCharacter();
  [endscript]
  ; アクション実行候補者がいなければマクロ終了
  [jump target="*end_j_decideDoActionByNPC" cond="f.actionCandidateObjects.length === 0"]

  ; 実行するアクションとその対象を決定する
  [iscript]
    f.doActionCandidateId = f.actionCandidateObjects[0].characterId;

    // 論理的な判断をするか感情的な判断をするか、論理力をもとに決める
    // MEMO ここで仲間度を用いないのは、仲間度のみに限定すると中途半端な対象しか選択されないため。
    // 論理力の低いキャラでも論理的な判断（＝そのキャラ視点における人狼ゲーム的な正解）で発言するチャンスを設けることで、プレイヤーを悩ませられると思う。
    const [probability, isLogicalDecision] = randomDecide(f.characterObjects[f.doActionCandidateId].personality.logical);
    const decision = isLogicalDecision ? DECISION_LOGICAL : DECISION_EMOTIONAL;

    // 実行するアクションを決める
    // TODO 選ばれるアクションは一旦ランダムとする。何らかの基準で比重を変えたい場合はここを修正する。
    // MEMO ここはアクションを増やすときには絶対に仕組みごと作り直すこと
    const timeStr = getTimeStr();
    const thisTimeActionHistory = f.doActionHistory[f.day][timeStr];
    let actionId = "";
    if (!Array.isArray(f.doActionHistory[f.day][timeStr]) || f.doActionHistory[f.day][timeStr].length === 0) {
      // まだその日のアクションがない場合は、疑うか信じるかをランダムで決める
      actionId = getRandomElement([ACTION_SUSPECT, ACTION_TRUST]);

    } else {
      // その日のアクションの中から、自分の直前のアクションを取得する
      const latestAction = getLatestAction(f.doActionCandidateId, thisTimeActionHistory, [ACTION_SUSPECT, ACTION_TRUST]);
      console.debug("★★latestAction");
      console.debug(latestAction);
      if (latestAction === null) {
        // まだアクションしていなかった場合は、疑うか信じるかをランダムで決める
        actionId = getRandomElement([ACTION_SUSPECT, ACTION_TRUST]);
      } else {
        // すでにアクションしていた場合は、自分の直前のアクションとは違うアクションを取る
        const latestActionId = latestAction.actionId;
        actionId = (latestActionId === ACTION_SUSPECT) ? ACTION_TRUST : ACTION_SUSPECT;
      }
    }


    // アクションの対象を決める
    // TODO アクションID定数の中にmax,minを持っていた方が、アクションを増やしやすいかも
    let needsMax = true;
    if (actionId == ACTION_SUSPECT) {
      needsMax = false;
    } else if (actionId == ACTION_TRUST) {
      needsMax = true;
    } else {
      alert('未定義のactionIdです');
    }

    // 同陣営判定の対象となる役職は、CO中の役職（COがなければ村人）とする
    const roleId = (f.characterObjects[f.doActionCandidateId].CORoleId == '') ? ROLE_ID_VILLAGER : f.characterObjects[f.doActionCandidateId].CORoleId;

    let targetCharacterId = '';
    if (decision == DECISION_LOGICAL) {
      // 論理的な判断

      // 同陣営判定の対象となる役職は、CO中の役職（COがなければ村人）とする
      const roleId = (f.characterObjects[f.doActionCandidateId].CORoleId == '') ? ROLE_ID_VILLAGER : f.characterObjects[f.doActionCandidateId].CORoleId;
      // perspectiveをもとに同陣営割合を出して対象を決める（役職騙り中の人狼や狂人は騙り役職としての視点オブジェクトで判定する。発言は嘘をつくため）
      targetCharacterId = getCharacterIdBySameFactionPerspective(
        f.characterObjects[f.doActionCandidateId],
        f.characterObjects[f.doActionCandidateId].perspective,
        roleId,
        needsMax
      );
    } else {
      // 感情的な判断
      // 信頼度をもとに対象を決める
      targetCharacterId = getCharacterIdByReliability(f.characterObjects[f.doActionCandidateId], needsMax);
    }
    console.debug('actionId:' + actionId);

    // ここまでに決定した情報を、NPCのアクションオブジェクトに格納する
    f.npcActionObject = new Action(f.doActionCandidateId, actionId, targetCharacterId);
    f.npcActionObject.decision = decision;
  [endscript]

  *end_j_decideDoActionByNPC
[endmacro]


; -------------------------
; 投票・追放系マクロ
; -------------------------

; 投票先を決める
; ※プレイヤーの投票先は決めない
[macro name="j_decideVote"]
  [iscript]
    decideVote(f.characterObjects, f.day);
  [endscript]
[endmacro]


; 各キャラの投票先を集計し、その日の処刑先を決める
; ※プレイヤーの投票先も集計対象
[macro name="j_countVote"]
  [iscript]
    countVote(f.characterObjects, f.day);
  [endscript]
  ; 開発者用設定：独裁者モードならPCの選択したキャラを処刑する
  [if exp="sf.j_development.dictatorMode"]
    [eval exp="f.electedIdList = [f.selectedButtonId]"]
    [eval exp="f.doExecute = true"]
  [endif]
[endmacro]


; 処刑マクロ
[macro name="j_execution"]
  [iscript]
    // 引数のキャラクターIDを対象者とする処刑のアクションオブジェクトを生成
    let actionObject = new Action(
      '',
      ACTION_EXECUTE,
      mp.characterId
    );

    // メソッド内で死亡判定を行う
    tf.actionObject = causeDeathToCharacter(actionObject);
    // MEMO:ここでは視点オブジェクトの更新は行わない。処刑後もゲームが継続することが確定したとき＝夜時間開始時用の初期化処理の中で行う。
    // 処刑履歴オブジェクトにその日の処刑結果を保存する
    f.executionHistory[f.day] = clone(tf.actionObject);
  [endscript]
[endmacro]



; -------------------------
; 夜時間系マクロ
; -------------------------

; 夜時間のNPCの占い師（真、騙り共通）の占い実行をまとめて行うマクロ
; @param needFakeFortuneTelling 騙り占い師の占いも実行するか。指定しない場合実行しない。（昼のCOフェイズ時に騙り占いするようにしている場合、実行してはいけない）
[macro name="j_nightPhaseFortuneTellingForNPC"]
  [iscript]
    // マクロ変数をboolean型に変換する。文字列の'true'かboolean型のtrueをtrue扱いとする
    let needFakeFortuneTelling = ('needFakeFortuneTelling' in mp && (mp.needFakeFortuneTelling === 'true' || mp.needFakeFortuneTelling === true)) ? true : false;

    // 夜開始時点の生存者である、かつプレイヤー以外のキャラクターオブジェクトから、占い師のID配列を抽出する。
    // 真占い師も騙り占い師もここで処理できる。j_fortuneTellingマクロ内で真か騙りかで処理を分けているため問題ない。
    // 初日夜も同様の処理で良い（初日夜にはまだ騙り占い師はいないため、必然的に真しか取得しない）
    tf.fortuneTellerNpcCharacterIds = getValuesFromObjectArray (
      getHaveTheRoleObjects (
        getCharacterObjectsFromCharacterIds (
          getSurvivorObjects(f.characterObjectsHistory[f.day]),
          [f.playerCharacterId],
          false
        ),
        [ROLE_ID_FORTUNE_TELLER],
        true,
        true,
        needFakeFortuneTelling // falseなら真占い師のみ取得する。trueなら騙り占い師も取得する。
      ),
      'characterId'
    );
  [endscript]

  [eval exp="tf.idsLength = tf.fortuneTellerNpcCharacterIds.length"]
  ; 行動する占い師がいない場合は、ループに入らず終了する（占いマクロへの引数がとれずエラーになる）
  [jump target="*j_nightPhaseFortuneTellingForNPC_loopend" cond="tf.idsLength == 0"]

  [eval exp="tf.cnt = 0"]
  *j_nightPhaseFortuneTellingForNPC_loopstart

    [j_fortuneTelling fortuneTellerId="&tf.fortuneTellerNpcCharacterIds[tf.cnt]"]

    [jump target="*j_nightPhaseFortuneTellingForNPC_loopend" cond="tf.cnt == (tf.idsLength - 1)"]
    [eval exp="tf.cnt++"]
    [jump target="*j_nightPhaseFortuneTellingForNPC_loopstart"]
  *j_nightPhaseFortuneTellingForNPC_loopend

[endmacro]


; 噛みマクロ
; @param biterId 噛み実行者のID。必須。ただし、猫又（噛んだ人狼が無残する）のように、誰が噛んだかを管理する必要が出るまではメッセージ表示用にしか利用しない。
; @param characterId 噛み対象のID。入っているなら、実行者はプレイヤーである。入っていないなら実行者はNPCのため、メソッド内部で対象を決める。
[macro name="j_biting"]
  [iscript]
    let actionObject = {};
    // ターゲットが決まっている（＝実行者がプレイヤー）なら
    if (mp.characterId) {
      actionObject = f.characterObjects[f.playerCharacterId].role.biting(mp.biterId, mp.characterId);
    // ターゲットが決まっていない（＝実行者がNPC）なら
    } else {
      actionObject = f.characterObjects[mp.biterId].role.biting(mp.biterId);
    }
    // 噛まれたキャラクターの退場用にティラノの変数に入れておく
    f.targetCharacterId = actionObject.targetId;
  [endscript]
[endmacro]


; 夜時間のNPCの人狼の噛み実行を行うマクロ（襲撃人数は1人）
; PCによる噛み実行と被らないようにするのは、呼び元で行うこと
[macro name="j_nightPhaseBitingForNPC"]
  [iscript]
    // 夜開始時点の生存者である、かつプレイヤー以外のキャラクターオブジェクトから、人狼のID配列を抽出する。
    tf.werewolfNpcCharacterIds = getValuesFromObjectArray (
      getHaveTheRoleObjects (
        getCharacterObjectsFromCharacterIds (
          getSurvivorObjects (f.characterObjectsHistory[f.day]),
          [f.playerCharacterId],
          false
        ),
        [ROLE_ID_WEREWOLF]
      ),
      'characterId'
    );
  [endscript]

  ; TODO 生存中のNPCに人狼が2人以上いた場合に、誰が（誰の思考で）襲撃するようにするかの判定と処理を実装する。
  ; 今は人狼1人想定なので、0要素目を確定で渡す
  [j_biting biterId="&tf.werewolfNpcCharacterIds[0]"]
[endmacro]



; -------------------------
; 判定系マクロ
; -------------------------

; 勝利陣営がいるかを判定し、勝利陣営がいた場合、指定されたラベルにジャンプする（storage, targetともに必須）
; ex: [j_judgeWinnerFactionAndJump storage="playJinro.ks" target="*gameOver"]
[macro name="j_judgeWinnerFactionAndJump"]
  [iscript]
    f.winnerFaction = judgeWinnerFaction(f.characterObjects);
  [endscript]
  [jump * cond="f.winnerFaction != null"]
[endmacro]


; 占い師COすることができる役職・CO状態かを判定し、f.canCOFortuneTellerStatusに結果を入れる。内訳はコード内のコメント参照
; 定数の並び順が昇順ではないのは、「if文は肯定形にする」と「未COに+1したらCO済みとする」の2つを優先したため。
; @param characterId 判定対象のキャラクターID。必須。
[macro name="j_setCanCOFortuneTellerStatus"]
  [iscript]
    const characterObject = f.characterObjects[mp.characterId];

    // 0: 占い師CO不可の役職、またはCO状態
    f.canCOFortuneTellerStatus = 0;
    if (characterObject.role.roleId == ROLE_ID_FORTUNE_TELLER) {
      if (characterObject.CORoleId == ROLE_ID_FORTUNE_TELLER) {
        // 2: 真占い師であり、CO済み
        f.canCOFortuneTellerStatus = 2;

      } else {
        // 1: 真占い師で、未CO
        f.canCOFortuneTellerStatus = 1;
      }

    } else if (characterObject.role.roleId == ROLE_ID_WEREWOLF || characterObject.role.roleId == ROLE_ID_MADMAN) {
      if (characterObject.CORoleId == ROLE_ID_FORTUNE_TELLER) {
        // 4: 騙り占い師としてCO済み
        f.canCOFortuneTellerStatus = 4;

      } else if (characterObject.CORoleId == '') {
        // 3: 騙り占い師としてCO可能な役職で、未CO
        f.canCOFortuneTellerStatus = 3;
      }
      // 占い師以外の役職としてCO済みなら、占い師COは不可
    }
  [endscript]
[endmacro]


[return]
