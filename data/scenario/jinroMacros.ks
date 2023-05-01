;人狼用マクロ
;first.ksでサブルーチンとして読み込んでおくこと


; 処刑マクロ
[macro name="j_execution"]
  [iscript]
    // 引数のキャラクターIDを対象者とする処刑のアクションオブジェクトを生成
    let actionObject = new Action(
      '',
      ACTION_EXECUTE,
      mp.characterId
    );

    // 死亡判定を行う
    tf.actionObject = causeDeathToCharacter(actionObject);
    // MEMO:ここでは視点オブジェクトの更新は行わない。処刑後もゲームが継続することが確定したとき＝夜時間開始時用の初期化処理の中で行う。
  [endscript]

  [if exp="tf.actionObject.result"]
    ; 処刑メッセージ
    [m_changeFrameWithId]
    #
    [emb exp="f.characterObjects[tf.actionObject.targetId].name + 'は追放されました。'"][p]
  [endif]
  ; 処刑履歴オブジェクトにその日の処刑結果を保存する
  [eval exp="f.executionHistory[f.day] = tf.actionObject"]
[endmacro]


; 勝利陣営がいるかを判定し、勝利陣営がいた場合、指定されたラベルにジャンプする（storage, targetともに必須）
; ex: [j_judgeWinnerFactionAndJump storage="playJinro.ks" target="*gameOver"]
[macro name="j_judgeWinnerFactionAndJump"]
  [m_changeFrameWithId]
  #
  勝敗判定中……[p]
  [iscript]
    tf.winnerFaction = judgeWinnerFaction(f.characterObjects);
  [endscript]

  [if exp="tf.winnerFaction != null"]
    [jump *]
  [endif]
[endmacro]


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
        todayResult.action.targetId,
        getRoleIdsForOrganizePerspective(todayResult.action.result)
      );
    }

    // メッセージ出力用に占いのアクションオブジェクトを格納
    f.actionObject = todayResult.action;

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
  [j_COFortuneTelling fortuneTellerId="&tf.fortuneTellerId" day="&tf.fakeFortuneTelledDay" noNeedMessage="true"]

  ; 次の日の騙り占いを行う
  [eval exp="tf.fakeFortuneTelledDay++"]
  [jump target="*fakeFortuneTellingCOMultipleDays_loopstart"]

  *fakeFortuneTellingCOMultipleDays_loopend
[endmacro]


; 夜時間のNPCの占い師（真、騙り共通）の占い実行をまとめて行うマクロ
; @param needFakeFortuneTelling 騙り占い師の占いも実行するか。指定しない場合実行しない。（昼のCOフェイズ時に騙り占いするようにしている場合、実行してはいけない）
[macro name="j_nightPhaseFortuneTellingForNPC"]
  [iscript]
    // マクロ変数をboolean型に変換する。文字列の'true'かboolean型のtrueをtrue扱いとする
    let needFakeFortuneTelling = ('needFakeFortuneTelling' in mp && (mp.needFakeFortuneTelling === 'true' || mp.needFakeFortuneTelling === true)) ? true : false;

    ; 夜開始時点の生存者である、かつプレイヤー以外のキャラクターオブジェクトから、占い師のID配列を抽出する。
    ; 真占い師も騙り占い師もここで処理できる。j_fortuneTellingマクロ内で真か騙りかで処理を分けているため問題ない。
    ; 初日夜も同様の処理で良い（初日夜にはまだ騙り占い師はいないため、必然的に真しか取得しない）
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
    [j_COFortuneTelling fortuneTellerId="&tf.COFortuneTellerId" day="&tf.CODay" noNeedMessage="true"]

    ; 次の日の分をCOする
    [eval exp="tf.CODay++"]
    [jump target="*j_COFortuneTellingUntilTheLastDay_loopstart"]
  *j_COFortuneTellingUntilTheLastDay_loopend

[endmacro]


; 噛みマクロ
; @param biterId 噛み実行者のID。必須。ただし、猫又（噛んだ人狼が無残する）のように、誰が噛んだかを管理する必要が出るまではメッセージ表示用にしか利用しない。
; @param characterId 噛み対象のID。入っているなら、実行者はプレイヤーである。入っていないなら実行者はNPCのため、メソッド内部で対象を決める。
[macro name="j_biting"]
  [iscript]
    let actionObject = {};
    ; ターゲットが決まっている（＝実行者がプレイヤー）なら
    if (mp.characterId) {
      actionObject = f.characterObjects[f.playerCharacterId].role.biting(mp.biterId, mp.characterId);
    ; ターゲットが決まっていない（＝実行者がNPC）なら
    } else {
      actionObject = f.characterObjects[mp.biterId].role.biting(mp.biterId);
    }
    ; 噛まれたキャラクターの退場用にティラノの変数に入れておく
    f.targetCharacterId = actionObject.targetId;
  [endscript]
[endmacro]


; 夜時間のNPCの人狼の噛み実行を行うマクロ（襲撃人数は1人）
; PCによる噛み実行と被らないようにするのは、呼び元で行うこと
[macro name="j_nightPhaseBitingForNPC"]
  [iscript]
    ; 夜開始時点の生存者である、かつプレイヤー以外のキャラクターオブジェクトから、人狼のID配列を抽出する。
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


; 偽役職オブジェクトを取得するマクロ（人外による役職COを想定。なお、ギドラや撤回COは想定していない）
; @param characterId COするキャラクターのキャラクターID
; @param roleId COする役職の役職ID
[macro name=j_assignmentFakeRole]
  [iscript]
    f.characterObjects[mp.characterId].fakeRole = roleAssignment(mp.roleId);

    ; 今までの表の視点を破棄。現在の共通視点から新しく騙り役職についた状態での表の視点を上書きする。
    ; ちなみに、fakeRole.rolePerspectiveは利用しないので空オブジェクトのままとなるので注意。
    ; TODO ここで破綻することもありうる。対策を。
    f.characterObjects[mp.characterId].perspective = organizePerspective (
      f.commonPerspective,
      mp.characterId,
      f.uniqueRoleIdList.filter(rId => (rId != mp.roleId))
    );
  [endscript]
[endmacro]


; ※未使用マクロ
; 夜の占い用マクロ
[macro name=j_execFortuneTellingInNight]
  [iscript]
    ; 生存者を走査し、占い師COをしているキャラクターIDを抽出する（騙りも含む）
    for (let i = 0; i < f.participantsIdList.length; i++) {
      console.log(f.participantsIdList[i]);

      if (f.characterObjects[f.participantsIdList[i]].isAlive) {
        ; 真占い師なら
        if (f.characterObjects[f.participantsIdList[i]].role.roleId == ROLE_ID_FORTUNE_TELLER) {
          if (f.characterObjects[f.participantsIdList[i]].isPlayer){
            ; それがPCのアイなら
            if (f.participantsIdList[i] == CHARACTER_ID_AI) {
              TYRANO.kag.ftag.startTag("call",{storage: "./fortuneTellingForPC.ks", target:"*StartFortuneTelling_ai"});
            } else {
              alert('アイ以外のPCの占いサブルーチンは未作成。');
            }
          } else {
            ; NPCなら
          }

        ; 占い騙りなら
        } else if (f.characterObjects[f.participantsIdList[i]].fakeRole.roleId == ROLE_ID_FORTUNE_TELLER) {
          if (f.characterObjects[f.participantsIdList[i]].isPlayer){
            ; それがPCのアイなら
            if (f.participantsIdList[i] == CHARACTER_ID_AI) {
              TYRANO.kag.ftag.startTag("call",{storage: "./fortuneTellingForPC.ks", target:"*StartFakeFortuneTelling_ai"});
            } else {
              alert('アイ以外のPCの占いサブルーチンは未作成。');
            }
          } else {
            ; NPCなら
          }
        }
      }
    }
  [endscript]
[endmacro]


; ※未使用マクロ
; 引数で指定した役職を持つ（持たない）キャラクターオブジェクトを、tf.haveTheRoleObjectsに格納する
; @param characterId COするキャラクターのキャラクターID
; @param roleId COする役職の役職ID
; @param characterId COするキャラクターのキャラクターID
; @param roleId COする役職の役職ID
; @param characterId COするキャラクターのキャラクターID
; @param roleId COする役職の役職ID
[macro name=j_getHaveTheRoleObjects]
  [iscript]
    ; 型をstring→boolに変換する
    const boolSearchFlg = (mp.searchFlg == 'true') ? true : false;
    const boolCheckRole = (mp.checkRole == 'true') ? true : false;
    const boolCheckFakeRole = (mp.checkFakeRole == 'true') ? true : false;

    tf.haveTheRoleObjects = getHaveTheRoleObjects(f.characterObjects, [ROLE_ID_FORTUNE_TELLER], boolSearchFlg, boolCheckRole, boolCheckFakeRole);
  [endscript]
[endmacro]


; 指定したキャラクターの、指定した日の占い履歴アクションオブジェクトをもとに、COを実行する。
; 占い師、占い騙り両対応。
; @param fortuneTellerId 取得したい占い師（騙り占い）のキャラクターID。必須
; @param [day] 取得したい占い日。指定しない場合、その占い師の最新の履歴を取得する。引数の渡し方（型）は0でも"0"でも可。
; @param [noNeedMessage] 占いCOメッセージを表示しないか。trueなら表示しない（複数日分の占いCO時、前日以外の分は表示しないべき）
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
    // その占い履歴をCO済みにする
    tmpFortuneTellingHistory[day].doneCO = true;
    // 信頼度増減とメッセージ出力用にアクションオブジェクトを格納
    f.actionObject = tmpFortuneTellingHistory[day].action;
    // 占いCOによる信頼度増減を行う
    updateReliabirityForAction(f.characterObjects, f.actionObject);
  [endscript]

  ; メッセージ出力（mp.noNeedMessageがtrueなら表示しない）
  [m_COFortuneTelling cond="!(('noNeedMessage' in mp) && (mp.noNeedMessage === 'true' || mp.noNeedMessage === true))"]

  [iscript]
    // 真占い師でも騙り占い師でも、表の視点オブジェクトを更新する
    // ・CO済みということは対外的な真実であるから ・CO済みであれば占い師としての思考は表の視点を使うから
    try {
      f.characterObjects[mp.fortuneTellerId].perspective = organizePerspective(
        f.characterObjects[mp.fortuneTellerId].perspective,
        f.actionObject.targetId,
        getRoleIdsForOrganizePerspective(f.actionObject.result)
      );
    } catch (error) {
      console.log(mp.fortuneTellerId + 'は、破綻した占い結果のCOをしてしまいました!');
      // 破綻フラグを立てる
      TYRANO.kag.stat.f.characterObjects[mp.fortuneTellerId].isContradicted = true;
      // 視点オブジェクトが破綻してしまったので、共通視点オブジェクトを入れておく
      // role.rolePerspectiveは更新しない。本人の役職視点での破綻ではないため
      f.characterObjects[mp.fortuneTellerId].perspective = clone(f.commonPerspective);
      // 自分自身は嘘がつける役職（TODO:「嘘をつかない役職配列」をメソッドで取り出せるようにする）だったということで確定する。
      updateCommonPerspective(mp.fortuneTellerId, [ROLE_ID_VILLAGER, ROLE_ID_FORTUNE_TELLER]);
    }
  [endscript]

  ; 今日のCOが終わったキャラはisDoneTodaysCOをtrueにする
  [eval exp="f.characterObjects[mp.fortuneTellerId].isDoneTodaysCO = true"]

[endmacro]


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
      } else if (f.characterObjects[mp.characterIds[i]].role.allowCO) {
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
    if (f.characterObjects[f.playerCharacterId].isAlive && f.characterObjects[f.playerCharacterId].role.allowCO && !f.characterObjects[f.playerCharacterId].isDoneTodaysCO) {
      tf.isNeedToAskPCWantToCO = true;
    }
  [endscript]
[endmacro]


; 共通視点オブジェクトを更新する。
; 同時に、各キャラの視点オブジェクトも更新する
; TODO 更新した履歴はティラノ変数に残しておくこと。例えば後から占い師が確定したときに、追従して反映できるようにするため。
; @param characterId 0確定するキャラクターID。必須。
; @param zeroRoleIds 0確定する役職ID配列。必須。 
[macro name=j_updateCommonPerspective]
  [iscript]
    updateCommonPerspective(mp.characterId, mp.zeroRoleIds);
  [endscript]
[endmacro]


; 役職側の視点オブジェクトを表の視点オブジェクトにcloneする。
; 真役職CO時に利用。騙りCOには使わないこと。騙りCOの際は、j_assignmentFakeRoleマクロで表の視点を作成しているため。
; @param characterId COするキャラクターID。必須。
; @param CORoleId COする役職ID。roleに格納されていることが前提。必須。
[macro name=j_cloneRolePerspectiveForCO]
  [iscript]
    console.log('j_cloneRolePerspectiveForCO');
    if (f.characterObjects[mp.characterId].role.roleId == mp.CORoleId) {
      f.characterObjects[mp.characterId].perspective = clone(f.characterObjects[mp.characterId].role.rolePerspective);
    }
  [endscript]
[endmacro]


; テスト用カットイン表示マクロ
[macro name="j_cutin1"]

    ;[image layer="1" x="0" y="150" width="1280" height="200" time="700" wait="false" storage="cutin.gif" name="cutin"]
    [playse storage="シャキーン1.ogg" volume="40"]
    ;[image layer="1" x="-1000" y="160" height="180" visible="true" reflect="true" storage="00_angry_eye.png" name="00"]
    ;[anim name="00" left=100 time=700]
    ;[wait time=700]
    [fadeoutse time="1800"]

[endmacro]


; 占い師COすることができる役職・CO状態かを判定し、tf.canCOFortuneTellerStatusに結果を入れる。内訳はコード内のコメント参照
; 定数の並び順が昇順ではないのは、「if文は肯定形にする」と「未COに+1したらCO済みとする」の2つを優先したため。
; @param characterId 判定対象のキャラクターID。必須。
[macro name="j_setCanCOFortuneTellerStatus"]
  [iscript]

    ; 0: 占い師CO不可の役職、またはCO状態
    tf.canCOFortuneTellerStatus = 0;
    if (f.characterObjects[mp.characterId].role.roleId == ROLE_ID_FORTUNE_TELLER) {
      if (f.characterObjects[mp.characterId].CORoleId == ROLE_ID_FORTUNE_TELLER) {
        ; 2: 真占い師であり、CO済み
        tf.canCOFortuneTellerStatus = 2;

      } else {
        ; 1: 真占い師で、未CO
        tf.canCOFortuneTellerStatus = 1;
      }
      
    } else if (f.characterObjects[mp.characterId].role.roleId == ROLE_ID_WEREWOLF || f.characterObjects[mp.characterId].role.roleId == ROLE_ID_MADMAN) {
      if (f.characterObjects[mp.characterId].CORoleId == ROLE_ID_FORTUNE_TELLER) {
        ; 4: 騙り占い師としてCO済み
        tf.canCOFortuneTellerStatus = 4;

      } else if (f.characterObjects[mp.characterId].CORoleId == '') {
        ; 3: 騙り占い師としてCO可能な役職で、未CO
        tf.canCOFortuneTellerStatus = 3;
      }
      ; 占い師以外の役職としてCO済みなら、占い師COは不可
    }
  [endscript]
[endmacro]


; ボタンオブジェクトf.buttonObjectsに、アクションボタン用オブジェクトを詰める
; @param disableActionIdList f.actionButtonList定数に定義されている中で、ボタン表示したくないアクションIDのリスト
[macro name="j_setActionToButtonObjects"]
  [iscript]
    tf.disableActionIdList = Array.isArray(mp.disableActionIdList) ? mp.disableActionIdList : [];
    f.buttonObjects = [];

    for (let aId of Object.keys(f.actionButtonList)) {
      // ボタン表示したくないアクションIDはf.buttonObjectsに格納しない
      if (tf.disableActionIdList.includes(aId)) continue;

      // 選択中のアクションIDのボタンは選択中の色に変える
      const addClasses = [];
      if (f.actionButtonList[aId].id == f.selectedActionId) {
        addClasses.push(CLASS_GLINK_SELECTED);
      }
      // ボタンオブジェクトを、sideとaddClassesを指定するために再生成してf.buttonObjectsに格納する
      f.buttonObjects.push(new Button(
        f.actionButtonList[aId].id,
        f.actionButtonList[aId].text,
        'left',
        CLASS_GLINK_DEFAULT,
        addClasses
      ));
    }
  [endscript]
[endmacro]


; ボタンオブジェクトf.buttonObjectsに、キャラクターを詰める
; @param characterIds キャラクターID配列。省略した場合は全キャラクターが対象。
; @param needPC PCを含めるか。省略した場合含めない。※"false"を渡すとtrue判定になるので注意
; @param onlySurvivor 生存しているキャラのみか。省略した場合全員。（needsPC=trueでない限りPCは含めない）※"false"を渡すとtrue判定になるので注意
; @param side ボタンの表示位置 'left','right'のいずれか（省略した場合center）
[macro name="j_setCharacterToButtonObjects"]
  [iscript]
    // mp.characterIdsを省略した場合、全員分のキャラクターID配列
    mp.characterIds = ('characterIds' in mp) ? mp.characterIds : Object.keys(f.characterObjects);
    // mp.sideを省略した場合、'center'
    mp.side = ('side' in mp) ? mp.side : 'center';
    // ボタン格納用変数の初期化
    f.buttonObjects = [];
    for (let cId of Object.keys(f.characterObjects)) {
      // PCを含めない場合は、PCはスキップ
      if (!mp.needPC && f.characterObjects[cId].isPlayer) continue;
      // 生存しているキャラのみの場合は、死亡済みキャラはスキップ
      // MEMO 今のところ「死亡済みのキャラのみ返す」はできないので、必要になったら修正すること
      if (mp.onlySurvivor && !f.characterObjects[cId].isAlive) continue;
      // mp.characterIdsに含まれていないキャラはスキップ
      if (!mp.characterIds.includes(cId)) continue;

      // 選択中のキャラクターIDかつ選択中のアクションである（つまり、実行予定だったアクションと同じ）ボタンは選択中の色に変える
      const addClasses = [];
      if (cId == f.originalSelectedCharacterId) {
        if ('actionId' in f.pcActionObject && f.selectedActionId == f.pcActionObject.actionId) {
          addClasses.push(CLASS_GLINK_SELECTED);
        }
      }
      // ボタンオブジェクトを、sideとaddClassesを指定するために再生成してf.buttonObjectsに格納する
      f.buttonObjects.push(new Button(
        cId,
        f.characterObjects[cId].name,
        mp.side,
        CLASS_GLINK_DEFAULT,
        addClasses
      ));
    }
  [endscript]
[endmacro]


; 議論フェーズのアクションを誰が実行するかを判定し、実行するアクションオブジェクトをf.doActionObjectに入れる
[macro name="j_setDoActionObject"]
  [iscript]
    // PCがアクションボタンでアクション指定済みならPC
    if (Object.keys(f.pcActionObject).length > 0) {
      f.doActionObject = f.pcActionObject;
    } else if (Object.keys(f.npcActionObject).length > 0) {
      // PCがアクション未指定で、NPCでアクション実行者がいればそのNPC
      f.doActionObject = f.npcActionObject;
    } else {
      // どちらでもなければ実行なし
      f.doActionObject = {};
    }
  [endscript]
[endmacro]


; NPCの中からアクション実行候補者、実行するアクション、アクションの対象キャラクターを決定し、
; f.doActionCandidateIdとf.npcActionObjectに格納する。
[macro name="j_decideDoActionByNPC"]
  [iscript]
    // 変数の初期化
    f.npcActionObject = {};
    f.doActionCandidateId = '';
    let doActionCandidateIdArray = [];
    let maxProbability = 0;

    for (let cId of Object.keys(f.characterObjects)) {
      // プレイヤー、死亡済みのキャラクターは除外
      if (f.characterObjects[cId].isPlayer) continue;
      if (!f.characterObjects[cId].isAlive) continue;

      // 現在の主張力をもとに、アクション実行確率とアクション実行したいかを取得する
      console.log('キャラクター: ' + f.characterObjects[cId].name);
      const [probability, doesAction] = randomDecide(f.characterObjects[cId].personality.assertiveness.current);

      // アクション実行したくない判定なら除外
      if (!doesAction) continue;

      // アクション実行確率の値が現在保存中の最大の確率を超過していれば、キャラクターIDをアクション実行候補配列に格納する
      if (probability > maxProbability) {
        doActionCandidateIdArray = [cId];
        maxProbability = probability;
      } else if (probability == maxProbability) {
        // アクション実行確率の値が現在の比較用の値と同値なら、キャラクターIDを候補配列に追加する
        doActionCandidateIdArray.push(cId);
      }
    }
    console.log('doActionCandidateIdArray:');
    console.log(doActionCandidateIdArray);

    // アクション実行候補配列に候補が1人ならその対象を、複数ならランダムで、アクション実行候補者に決定する
    if (doActionCandidateIdArray.length == 1) {
      f.doActionCandidateId = doActionCandidateIdArray[0];
    } else if (doActionCandidateIdArray.length >= 2) {
      f.doActionCandidateId = getRandomElement(doActionCandidateIdArray);
    }
  [endscript]
  
  ; アクション実行候補者がいなければマクロ終了
  [jump target="*end_j_decideDoActionByNPC" cond="f.doActionCandidateId == ''"]

  ; 実行するアクションとその対象を決定する
  [iscript]
    // 論理的な判断をするか感情的な判断をするか、論理力をもとに決める
    // MEMO ここで仲間度を用いないのは、仲間度のみに限定すると中途半端な対象しか選択されないため。
    // 論理力の低いキャラでも論理的な判断（＝そのキャラ視点における人狼ゲーム的な正解）で発言するチャンスを設けることで、プレイヤーを悩ませられると思う。
    const [probability, isLogicalDecision] = randomDecide(f.characterObjects[f.doActionCandidateId].personality.logical);

    // 実行するアクションを決める
    // MEMO 選ばれるアクションは一旦ランダムとする。何らかの基準で比重を変えたい場合はここを修正する。
    const actionId = getRandomElement([ACTION_SUSPECT, ACTION_TRUST]);

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
    if (isLogicalDecision) {
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
    console.log('actionId:' + actionId);

    // ここまでに決定した情報を、NPCのアクションオブジェクトに格納する
    f.npcActionObject = new Action(f.doActionCandidateId, actionId, targetCharacterId);
  [endscript]

  *end_j_decideDoActionByNPC
[endmacro]


; 引数で受け取った、doActionObjectのアクションを実行する
; 事前に[j_setDoActionObject]の実行が必要
; @param actionObject アクションオブジェクト {characterId:アクション実行するキャラクターID, actionId:実行するアクションID, targetId:アクション対象のキャラクターID} 必須
[macro name="j_doAction"]
  ; アクションボタン用変数の初期化（PCからのボタン先行入力を受け付けられるように消す。セリフとリアクションにはマクロ変数を渡すのでこのタイミングで消して問題ない）
  [eval exp="f.doActionObject = {}"]
  [eval exp="f.pcActionObject = {}"]
  [eval exp="f.npcActionObject = {}"]

  ; セリフ表示
  [m_doAction characterId="&mp.actionObject.characterId" targetCharacterId="&mp.actionObject.targetId" actionId="&mp.actionObject.actionId"]

  [iscript]
    // 全員の信頼度増減
    updateReliabirityForAction(f.characterObjects, mp.actionObject);
    // アクション実行者の主張力を下げて、同日中は再発言しにくくする
    f.characterObjects[mp.actionObject.characterId].personality.assertiveness.current -= f.characterObjects[mp.actionObject.characterId].personality.assertiveness.decrease;

    // アクション実行履歴オブジェクトに、アクションオブジェクトを保存する
    let timeStr = getTimeStr();
    f.doActionHistory[f.day][timeStr].push(mp.actionObject);
  [endscript]

  ; リアクションのセリフ表示
  [m_doAction_reaction characterId="&mp.actionObject.targetId" actionId="&mp.actionObject.actionId"]
[endmacro]


; 人狼メニュー画面に表示するための全占い師のCO状況テキストを生成する
; TODO 作り直す
[macro name="j_getAllFortuneTellerCOText"]
  [iscript]
    tf.allFortuneTellerCOText = '';

    for (let cId of Object.keys(f.characterObjects)) {
      // 占い師CO済みのキャラクターか
      if (f.characterObjects[cId].CORoleId == ROLE_ID_FORTUNE_TELLER) {
        tf.allFortuneTellerCOText += f.characterObjects[cId].name + ' : ';

        // 真偽を確認し、占い履歴オブジェクトを取得する
        let fortuneTellingHistory = {}
        if (f.characterObjects[cId].role.roleId == ROLE_ID_FORTUNE_TELLER) {
          fortuneTellingHistory = f.characterObjects[cId].role.fortuneTellingHistory;
        } else {
          fortuneTellingHistory = f.characterObjects[cId].fakeRole.fortuneTellingHistory;
        }

        for (let day of Object.keys(fortuneTellingHistory)) {
          // 「その日にCO済みなら（doneCO）」の判定が必要。履歴表示時にfalseなら表示しないようにしないと、夜の時点で開いたときに未COの履歴も表示されてしまう。
          // ただしプレイヤーの占い履歴は未COでも表示する（占い師CO自体をしていないなら表示しない TODO：役職未COと分かるようにすれば、表示してもいいかも）
          if (cId != f.playerCharacterId && !fortuneTellingHistory[day].doneCO) continue;
          
          let targetId = fortuneTellingHistory[day].action.targetId;
          let result = fortuneTellingHistory[day].action.result ? '●' : '○';
          tf.allFortuneTellerCOText += f.characterObjects[targetId].name + result;
        }
        tf.allFortuneTellerCOText += '<br>';
      }
    }
  [endscript]
[endmacro]


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


; 各キャラの投票先を集計し、投票結果画面として出力する
[macro name="j_openVote"]
  ; 全ボタンとメッセージウィンドウを消去
  [j_clearFixButton]
  [layopt layer="message0" visible="false"]

  ; 投票結果を表示
  [j_setDchForOpenVote]
  [call storage="jinroSubroutines.ks" target="*displayCharactersHorizontally"]
  [p]
  ; 投票結果を表示していたレイヤーを解放
  [freeimage layer="1" time="400" wait="true"]

  ; ステータス、メニューボタン再表示とメッセージウィンドウを表示
  [j_displayFixButton status="true" menu="true"]
  [layopt layer="message0" visible="true"]
[endmacro]


[macro name="j_setDchForOpenVote"]
  ; バックログ用変数を初期化する
  [eval exp="tf.voteBacklog = ''"]

  [iscript]
    let tmpCharacterList = [];
    for (let i = 0; i < f.voteResultObjects.length; i++) {
      let cId = f.voteResultObjects[i].characterId;

      let votedCountText = (function(){
        if (cId in f.votedCountObject) {
          let electedMark = f.electedIdList.includes(cId) ? '★' : '';
          return electedMark + f.votedCountObject[cId] + '票';
        } else {
          return '0票';
        }
      })();

      tmpCharacterList.push(new DisplayCharactersHorizontallySingle(
        cId,
        'normal.png',
        f.voteResultObjects[i].targetId,
        votedCountText,
        '→' + f.characterObjects[f.voteResultObjects[i].targetId].name
      ))

      // 投票数の先頭が'★'ではない場合、' 'を追加する（行頭を揃えるため）
      if (votedCountText.charAt(0) != '★') { 
        votedCountText = '　' + votedCountText;
      }
      // 最後以外の要素の行末に、<br>を追加する（最後以外は改行するため）
      let br = (i == (f.voteResultObjects.length - 1)) ? '' : '<br>';
      // 必要な文字列を連結してバックログ用変数に格納する
      tf.voteBacklog += (votedCountText + ' ' + f.characterObjects[cId].name + '→' + f.characterObjects[f.voteResultObjects[i].targetId].name + br);
    }

    f.dch = new DisplayCharactersHorizontally(
      tmpCharacterList,
      20, // キャラクター画像の表示位置を中央より右へずらす。leftTextの文字を表示するスペースを作るため
      -100, // キャラクター画像の表示位置を中央より上へずらす。メニューボタンは非表示にしているので、干渉しない分上げておく
    );
  [endscript]

  ; バックログ用変数が初期状態でなければ、バックログに記録する
  ; [iscript]内の処理が始まるより前に、この[pushlog]が先読みされて実行されてしまうので、その時点ではログ出力しないように初期状態なら実行しないようにcond条件を設定している
  [pushlog text="&tf.voteBacklog" cond="tf.voteBacklog != ''"]
[endmacro]


; キャラクター紹介画面を出力する
[macro name="j_introductionCharacters"]
  ; 全ボタンを消去
  [j_clearFixButton]

  ; キャラクタ－画像を表示
  [j_setDchForintroductionCharacters]
  [call storage="jinroSubroutines.ks" target="*displayCharactersHorizontally"]
  [p]
  ; キャラクター画像を表示していたレイヤーを解放
  [freeimage layer="1" time="400" wait="true"]

  ; ステータス、メニューボタン再表示
  [j_displayFixButton status="true" menu="true"]
[endmacro]


[macro name="j_setDchForintroductionCharacters"]
  [iscript]
    let tmpCharacterList = [];
    for (let i = 0; i < f.participantsIdList.length; i++) {
      let cId = f.participantsIdList[i];
      tmpCharacterList.push(new DisplayCharactersHorizontallySingle(
        cId,
        'normal.png',
        cId,
        '',
        f.characterObjects[cId].name
      ))
    }

    f.dch = new DisplayCharactersHorizontally(
      tmpCharacterList,
      20, // キャラクター画像の表示位置を中央より右へずらす。leftTextの文字を表示するスペースを作るため
      -100, // キャラクター画像の表示位置を中央より上へずらす。メニューボタンは非表示にしているので、干渉しない分上げておく
    );
  [endscript]
[endmacro]


; ゲーム終了時のプレイヤーの勝敗結果（または引き分け）によって、再生する効果音を鳴らし分ける
; @param winnerFaction 勝利陣営。必須
[macro name="j_playSePlayerResult"]
  [if exp="mp.winnerFaction == FACTION_DRAW_BY_REVOTE"]
    ; 引き分け
    [playse storage="megaten.ogg" loop="false" volume="40" sprite_time="50-20000"]
  [elsif exp="f.characterObjects[f.playerCharacterId].role.faction == mp.winnerFaction"]
    ; 勝利
    [playse storage="kirakira4.ogg" loop="false" volume="40" sprite_time="50-20000"]
  [else]
    ; 敗北
    [playse storage="chiin1.ogg" loop="false" volume="40" sprite_time="50-20000"]
  [endif]
[endmacro]


[macro name="j_displayRoles"]
役職公開[r]
ずんだもん：[emb exp="f.characterObjects.zundamon.role.roleName"]、
四国めたん：[emb exp="f.characterObjects.metan.role.roleName"]、
春日部つむぎ：[emb exp="f.characterObjects.tsumugi.role.roleName"]、
雨晴はう：[emb exp="f.characterObjects.hau.role.roleName"]、
波音リツ：[emb exp="f.characterObjects.ritsu.role.roleName"][p]
[endmacro]


; Fixレイヤーのボタンを表示する。表示中のボタンは指定されても再表示はしない。
; ボタンの消去は[j_clearFixButton]で行うこと。
; 以下のマクロ変数を全て省略すると、全てのボタンを表示する。
; @param action アクションボタンを表示する（※"false"を渡すとtrue判定になるので注意）
; @param menu メニューボタンを表示する（※"false"を渡すとtrue判定になるので注意）
; @param status ステータスボタンを表示する（※"false"を渡すとtrue判定になるので注意）
[macro name="j_displayFixButton"]

  [iscript]
    // 初回のみ、ボタンの表示ステータスを管理するオブジェクトを生成
    if (!('displaingButton' in f)) {
      f.displaingButton = {
        action: false,
        menu: false,
        status: false
      };
    };
    // 一つもマクロ変数に指定されていないなら、全て表示する。一つでも指定されているならマクロ変数通りとする。
    if (!(('action' in mp) || ('menu' in mp) || ('status' in mp))) {
      mp.action = true;
      mp.menu = true;
      mp.status = true;
    }
    console.log('表示');
    console.log(mp);
  [endscript]

  [if exp="!f.displaingButton.action && mp.action"]
    [button graphic="button/button_action_normal.png" storage="action.ks" target="*start" x="23" y="23" width="114" height="103" fix="true" role="sleepgame" name="button_j_fix,button_j_action" enterimg="button/button_action_hover.png"]
    [eval exp="f.displaingButton.action = true"]
  [endif]

  [if exp="!f.displaingButton.menu && mp.menu"]
    [button graphic="button/button_menu_normal.png" storage="menuJinro.ks" target="*menuJinroMain" x="1005" y="23" width="114" height="103" fix="true" role="sleepgame" name="button_j_fix,button_j_menu" enterimg="button/button_menu_hover.png"]
    [eval exp="f.displaingButton.menu = true"]
  [endif]

  [if exp="!f.displaingButton.status && mp.status"]
    [button graphic="button/button_status_normal.png" storage="statusJinro.ks" target="*statusJinroMain" x="1143" y="23" width="114" height="103" fix="true" role="sleepgame" name="button_j_fix,button_j_status" enterimg="button/button_status_hover.png"]
    [eval exp="f.displaingButton.status = true"]
  [endif]
[endmacro]


; Fixレイヤーのボタンを消去する。消去中のボタンは指定されても再消去はしない。
; ボタンの表示は[j_displayFixButton]で行うこと。
; 以下のマクロ変数を全て省略すると、全てのボタンを消去する。
; @param action アクションボタンを消去する（※"false"を渡すとtrue判定になるので注意）
; @param menu メニューボタンを消去する（※"false"を渡すとtrue判定になるので注意）
; @param status ステータスボタンを消去する（※"false"を渡すとtrue判定になるので注意）
[macro name="j_clearFixButton"]
  [iscript]
    // [j_displayFixButton]は実行済みでf.displaingButtonは存在している前提とする。
    // 一つもマクロ変数に指定されていないなら、全て消去する。一つでも指定されているならマクロ変数通りとする。
    if (!(('action' in mp) || ('menu' in mp) || ('status' in mp))) {
      mp.action = true;
      mp.menu = true;
      mp.status = true;
    }
    console.log('消去');
    console.log(mp);
  [endscript]

  [if exp="f.displaingButton.action && mp.action"]
    [clearfix name="button_j_action"]
    [eval exp="f.displaingButton.action = false"]
  [endif]

  [if exp="f.displaingButton.menu && mp.menu"]
    [clearfix name="button_j_menu"]
    [eval exp="f.displaingButton.menu = false"]
  [endif]

  [if exp="f.displaingButton.status && mp.status"]
    [clearfix name="button_j_status"]
    [eval exp="f.displaingButton.status = false"]
  [endif]
[endmacro]


; 時間を夜から昼に進める
[macro name="j_turnIntoDaytime"]
  [fadeoutbgm time="200"]

  ; PC,NPCを退場させる
  [m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
  ; 夜に占った後だとNPCが画面に出ているので退場が必要
  [m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
  #
  [m_changeFrameWithId]

  ; 昨夜（時間を経過させる前なので厳密には同日）の襲撃アクションオブジェクトを取得する
  ; TODO 襲撃死と同時に別の死亡者が出る（例：呪殺）ようになった場合は修正する。配列で複数オブジェクトを取得することになるはず
  [eval exp="f.bitingObjectLastNight = f.bitingHistory[f.day]"]

  ; 昼時間開始時用の初期化を行う
  [eval exp="daytimeInitialize()"]

  [bg storage="black.png" time="1000" wait="true" effect="fadeInDown"]

  [playse storage="shock1.ogg" loop="false" volume="50" sprite_time="50-20000"]
  [emb exp="f.day + '日目の朝を迎えました。'"][l][r]
  [if exp="typeof f.bitingObjectLastNight === 'undefined'"]
    [playse storage="shock1.ogg" loop="false" volume="50" sprite_time="50-20000"]
    ; 昨夜の襲撃結果が取得できなかった（＝初日犠牲者のいない1日目昼）場合
    ; TODO 人狼の人数を可変で出力する
    ; FIXME 役職の内訳を表示してもいいかも。
    この中に人狼が1人潜んでいます……。
    [j_introductionCharacters]

  [elsif exp="f.bitingObjectLastNight.result"]
    [playse storage="shock1.ogg" loop="false" volume="40" sprite_time="50-20000"]
    ; 昨夜の襲撃結果が襲撃成功の場合
    ; キャラを登場させ、メッセージ表示
    [m_changeCharacter characterId="&f.bitingObjectLastNight.targetId" face="normal"]
    [emb exp="f.characterObjects[f.bitingObjectLastNight.targetId].name + 'は無残な姿で発見されました……。'"][p]

    ; 噛まれたということは人狼ではないので、視点オブジェクトを更新する（TODO：人狼以外にも噛まれない役職が増えたら修正する）
    [eval exp="updateCommonPerspective(f.bitingObjectLastNight.targetId, [ROLE_ID_WEREWOLF])"]

    ; キャラを退場させる
    [m_exitCharacter characterId="&f.bitingObjectLastNight.targetId"]

  [else]
    ; 昨夜の襲撃結果が襲撃失敗の場合
    誰も襲われていない、平和な朝でした。[p]

  [endif]

  [playbgm storage="nc282335.ogg" loop="true" volume="12" restart="false"]
  [bg storage="living_day_nc238325.jpg" time="1000" wait="true" effect="fadeInUp"]

  ; PCが生存していれば再度画面に登場させる
  [m_changeCharacter characterId="&f.playerCharacterId" face="normal" cond="f.characterObjects[f.playerCharacterId].isAlive"]

[endmacro]


; 時間を昼から夜に進める
[macro name="j_turnIntoNight"]

  ; PCを退場させる
  [m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]

  ; 夜時間開始時用の初期化を行う
  [eval exp="nightInitialize()"]
  [bg storage="living_night_close_nc238328.jpg" time="1000" wait="true" effect="fadeInUp"]

  恐ろしい夜がやってきました。[p]

[endmacro]



; jsonをローカルに保存する
; 参考　@link https://ameblo.jp/personwritep/entry-12495099049.html
[macro name="j_saveJson"]
  [iscript]
    ; cloneメソッドでコピーし、元の変数に影響ないようにする
    ; sf.system、tf.systemのオブジェクトは、人狼ゲーム側で入れたデータではないので除いておく
    ;（特にtf.systemにはバックログが入るのででかくなりそう）
    let tmp_sf = clone(sf);
    let tmp_tf = clone(tf);

    delete tmp_sf.system;
    delete tmp_tf.system;

    const all_variables = {
      'f':f,
      'sf':tmp_sf,
      'tf':tmp_tf
    };

    ; jsonファイル出力
    let write_json=JSON.stringify(all_variables);
    let blob=new Blob([write_json], {type: 'application/json'});
    let a=document.createElement("a");
    a.href=URL.createObjectURL(blob);
    document.body.appendChild(a); // Firefoxで必要
    let now = new Date().toLocaleString().replace(/\/|:|\s/g, '');
    a.download='jinro_all_variables_' + now + '.json';
    a.click();
    document.body.removeChild(a); // Firefoxで必要
    URL.revokeObjectURL(a.href);
  [endscript]
[endmacro]

[return]
