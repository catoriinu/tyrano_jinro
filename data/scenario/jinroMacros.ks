;人狼用マクロ
;first.ksでサブルーチンとして読み込んでおくこと


; 処刑マクロ
[macro name=j_execution]
  [iscript]
    ; 引数のキャラクターIDを持つキャラクターオブジェクトを、ゲーム変数から取得する
    let tmpCharacterObject = {};
    tmpCharacterObject = f.characterObjects[mp.characterId];

    ; 死亡判定を行う（判定に成功したら、メソッドが死亡までやってくれる）
    if (causeDeathToCharacter(tmpCharacterObject, DEATH_BY_EXECUTION)) {
      alert(tmpCharacterObject.name + 'は処刑された。');
    }
  [endscript]
[endmacro]


; 未使用マクロ
; 襲撃マクロ
[macro name=j_attack]
; 引数テスト:[emb exp="mp.character_id"][p]
  [iscript]
    ; 引数のキャラクターIDを持つキャラクターオブジェクトを、ゲーム変数から取得する
    let tmpCharacterObject = {};
    tmpCharacterObject = f.characterObjects[mp.character_id];

    ; 死亡判定を行う（判定に成功したら、メソッドが死亡までやってくれる）
    if (causeDeathToCharacter(tmpCharacterObject, DEATH_BY_ATTACK)) {
      alert(tmpCharacterObject.name + 'は襲撃された。');
    }
  [endscript]
[endmacro]


; 勝利陣営がいるかを判定し、勝利陣営がいた場合、指定されたラベルにジャンプする（storage, targetともに必須）
; ex: [j_judgeWinnerCampAndJump storage="playJinro.ks" target="*gameOver"]
[macro name=j_judgeWinnerCampAndJump]
  #
  勝敗判定中……
  [iscript]
    tf.winnerCamp = judgeWinnerCamp(f.characterObjects);
    if (f.developmentMode) {
      alert('勝利陣営: ' + tf.winnerCamp);
    }
  [endscript]

  [if exp="tf.winnerCamp != null"]
    [jump *]
  [endif]
[endmacro]


; 占いマクロ
; @param fortuneTellerId 占い実行者のID。真占い師、占い騙りに関わらず、必須。
; @param day 占った日付。指定がない場合のデフォルトは当日。占い騙りのように前日の夜に占ったことを偽装する必要がある場合は指定すること。
; @param characterId 占う対象のID。入っているなら、実行者はプレイヤーである。入っていないなら実行者はNPCのため、メソッド内部で対象を決める。
; @param result プレイヤーかつ騙りの占い師の場合のみ必要。宣言する占い結果をbooleanまたはstringで渡す。
[macro name=j_fortuneTelling]
  [iscript]
    ; jsに渡す引数の準備。マクロへの指定がなければデフォルト値を入れる
    const day = (typeof mp.day == 'undefined') ? f.day : parseInt(mp.day);
    const targetCharacterId = (typeof mp.characterId == 'undefined') ? '' : mp.characterId;
    const declarationResult = (function(){
      if (typeof mp.result == 'string') {
        ; ※マクロの引数としてベタ書きでboolやnumを渡しても、stringに型変換されてしまうため、jinroプラグインに渡す前にstring→boolに変換する。
        ; jsは空文字でないstringをtrueと評価するため、確実に'true'でないとtrueを入れないようにする。
        return (mp.result === 'true') ? true : false;
      } else if (typeof mp.result == 'boolean') {
        ; boolean型ならそのまま格納する（マクロの引数に変数としてbooleanで渡して来た場合を考慮）
        return mp.result;
      } else {
        ; その他の型（未指定でundefined）ならnull
        return null;
      }
    })();

    let todayResult = {};
    ; 占い実行
    if (f.characterObjects[mp.fortuneTellerId].fakeRole.roleId == ROLE_ID_FORTUNE_TELLER) {
      ; 占い騙りの場合
      todayResult = f.characterObjects[mp.fortuneTellerId].fakeRole.fortuneTelling(mp.fortuneTellerId, day, targetCharacterId, declarationResult);
    } else {
      ; 真占いの場合
      todayResult = f.characterObjects[mp.fortuneTellerId].role.fortuneTelling(mp.fortuneTellerId, day, targetCharacterId);
    }

    ; 占い師の視点整理。
    ; 騙りの場合には、騙り役職の視点や、本人の役職視点の視点整理は行わない。（自分視点の真実ではないため）
    ; 表の視点を更新する理由は、・CO済みであれば表の視点を使うから　・未COでも思考に占い結果を反映させたいから（仮）
    ; →問題発生。
    ; TODO : 破綻の場合どうする？
    f.characterObjects[mp.fortuneTellerId].perspective = organizePerspective (f.characterObjects[mp.fortuneTellerId].perspective, todayResult.characterId, getRoleIdsForOrganizePerspective(todayResult.result));
    if (f.characterObjects[mp.fortuneTellerId].role.roleId == ROLE_ID_FORTUNE_TELLER) {
      f.characterObjects[mp.fortuneTellerId].role.rolePerspective = organizePerspective (f.characterObjects[mp.fortuneTellerId].role.rolePerspective, todayResult.characterId, getRoleIdsForOrganizePerspective(todayResult.result));
    }
    
    ; 一時変数に占い結果格納
    ; TODO:tf.todayResultObjectはtf.fortuneTellingHistoryObjectと役割がかぶっているのでどちらかに統一したい
    tf.todayResultObject = todayResult;

    ; 全占い結果履歴オブジェクトに占い結果格納
    if (typeof f.allFortuneTellingHistoryObject[mp.fortuneTellerId] !== 'object') {
      ; 初期化直後は空のオブジェクトを作成
      f.allFortuneTellingHistoryObject[mp.fortuneTellerId] = {};
    }
    f.allFortuneTellingHistoryObject[mp.fortuneTellerId][day] = todayResult;

    if (f.developmentMode) {
      let resultMassage = todayResult.result ? '人　狼' : '村　人';
      alert(f.characterObjects[mp.fortuneTellerId].name + 'は'
      + f.characterObjects[todayResult.characterId].name + 'を占いました。\n結果　【' + resultMassage + '】');
    }
  [endscript]
[endmacro]


; NPC用騙り占いCOマクロ
; 初日から、指定された日付の前日の夜までを占ったことにできる。
; @param fortuneTellerId 占い実行者のID。真占い師、占い騙りに関わらず、必須。
; @param day 占った日付。当日であれば指定不要。
[macro name=j_fakeFortuneTellingCOMultipleDays]

  ; 騙り占いを行う最新の日の日付を入れる。未指定（デフォルト）なら前日の夜までにする。
  [iscript]
    tf.lastDay = (typeof mp.day == 'undefined') ? f.day - 1 : parseInt(mp.day);
    console.log('tf.lastDay = ' + tf.lastDay);
  [endscript]

  [eval exp="tf.fortuneTelledDay = 0"]
  ; ※マクロ内で別マクロを呼び出すと、別マクロの終了時にmp変数が全て空にされてしまう。
  ; そのため、元マクロ側の引数を元マクロ内で引き続き使いたい場合は、一時変数などに格納しておかないといけない。
  [eval exp="tf.fortuneTellerId = mp.fortuneTellerId"]
  *fakeFortuneTellingCOMultipleDays_loopstart

    ; 占いマクロを、初日(day=0)から最新の日の日付までループ実行していく
    [j_fortuneTelling fortuneTellerId="&tf.fortuneTellerId" day="&tf.fortuneTelledDay"]

  [jump target="*fakeFortuneTellingCOMultipleDays_loopend" cond="tf.fortuneTelledDay == tf.lastDay"]
  [eval exp="tf.fortuneTelledDay++"]
  [jump target="*fakeFortuneTellingCOMultipleDays_loopstart"]

  *fakeFortuneTellingCOMultipleDays_loopend
[endmacro]


; 夜時間のNPCの占い師（真、騙り共通）の占い実行をまとめて行うマクロ
[macro name="j_nightPhaseFortuneTellingForNPC"]
  [iscript]
    ; 夜開始時点の生存者である、かつプレイヤー以外のキャラクターオブジェクトから、占い師のID配列を抽出する。
    ; 真占い師も騙り占い師もここで処理する。j_fortuneTellingマクロ内で真か騙りかで処理を分けているため問題ない。
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
        true
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
[macro name=j_biting]
  [iscript]
    let todayResult = {};
    ; ターゲットが決まっている（＝実行者がプレイヤー）なら
    if (mp.characterId) {
      todayResult = f.characterObjects[f.playerCharacterId].role.biting(mp.biterId, mp.characterId);
    ; ターゲットが決まっていない（＝実行者がNPC）なら
    } else {
      todayResult = f.characterObjects[mp.biterId].role.biting(mp.biterId);
    }

    let resultMassage = todayResult.result ? f.characterObjects[todayResult.characterId].name + 'は無残な姿で発見された。' : '平和な朝を迎えた。';
    alert(resultMassage);
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
      TYRANO_VAR_F.uniqueRoleIdList.filter(rId => (rId != mp.roleId))
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


; 指定したキャラクターの占い履歴から、指定した日の履歴オブジェクトをtf.fortuneTellingHistoryObjectに格納する
; 占い師、占い騙り両対応。
; @param fortuneTellerId 取得したい占い師（騙り占い）のキャラクターID。必須
; @param [day] 取得したい占い日。指定しない場合、その占い師の最新の履歴を取得する。引数の渡し方（型）は0でも"0"でも可。
[macro name=j_fortuneTellingHistoryObjectThatDay]
  [iscript]
    ; 占い履歴を変数に格納する
    ; なぜか、if文の中でconstで宣言するとif文の外で未定義になったため、事前に宣言しておく。
    let tmpFortuneTellingHistory = {}
    if (f.characterObjects[mp.fortuneTellerId].role.roleId == ROLE_ID_FORTUNE_TELLER) {
      tmpFortuneTellingHistory = f.characterObjects[mp.fortuneTellerId].role.fortuneTellingHistory;
    } else if (f.characterObjects[mp.fortuneTellerId].fakeRole.roleId == ROLE_ID_FORTUNE_TELLER) {
      tmpFortuneTellingHistory = f.characterObjects[mp.fortuneTellerId].fakeRole.fortuneTellingHistory;
    }

    ; 取得する日を決定する。引数があればその日の、なければ最新の日の履歴を取得する。
    const day = mp.day ? mp.day : Object.keys(tmpFortuneTellingHistory).length - 1;
    tf.fortuneTellingHistoryObject = tmpFortuneTellingHistory[day];
  [endscript]
[endmacro]


; ※未使用メソッド
; 指定したキャラクターの最新の占い履歴をもとに、占いCO文を出力する。
; 占い師、占い騙り両対応。
; @param fortuneTellerId 取得したい占い師（騙り占い）のキャラクターID。必須
[macro name=j_COfortuneTellingResultLastNight]
  j_COfortuneTellingResultLastNightマクロは削除済（念のためしばらく置いておく）[p]
[endmacro]


; CO候補となるキャラクターID配列からCO候補者を一人決定し、tf.COCandidateIdに格納する。
; @param characterIds CO候補となるキャラクターID配列（NPCかつ生存者を想定）。必須
[macro name=j_decideCOCandidateId]
  [iscript]
    ; TODO:直前（PC、NPCどちらも）のCOの内容によって、各キャラ内のCOしたい度が変動するようにする

    ; キャラクターID配列を回してCOできる役職かつisDoneTodaysCOがfalseであれば、isCOMyRoll()を噛ませる。
    let maxProbability = 0;
    let COCandidateIdArray = [];
    tf.COCandidateId = '';
    for (let i = 0; i < mp.characterIds.length; i++) {
      if (f.characterObjects[mp.characterIds[i]].role.allowCO && !f.characterObjects[mp.characterIds[i]].isDoneTodaysCO) {
        console.log('キャラクターID: ' + mp.characterIds[i]);
        let [probability, isCO] = isCOMyRoll(mp.characterIds[i]);
        ; COしたい、かつCO確率が現在保存中の最大の確率以上であれば、キャラクターIDをCO候補配列に格納する
        if (isCO && probability >= maxProbability) {
          COCandidateIdArray.push(mp.characterIds[i]);
          maxProbability = probability;
        }
      }
    }
    ; CO候補配列に候補が1人ならその対象を、複数ならランダムで、COするキャラクターIDに決定する。0人の場合は空文字を返す。
    if (COCandidateIdArray.length == 1) {
      tf.COCandidateId = COCandidateIdArray[0];
    } else if (COCandidateIdArray.length >= 2) {
      tf.COCandidateId = getRandomElement(COCandidateIdArray);
    }
    
    if (f.developmentMode) {
      alert('CO判定結果 キャラクターID:' + tf.COCandidateId + ' maxProbability:' + maxProbability);
    }
    
  [endscript]
[endmacro]


; PCがCOしたいかを確認する必要があるかを判定し、tf.isNeedToAskPCWantToCOに結果を入れる
[macro name=j_setIsNeedToAskPCWantToCO]
  [iscript]
    tf.isNeedToAskPCWantToCO = false;
    ; 以下の条件を満たした場合、PCがCOしたいかを確認する必要があると判定する
    ; 生存している && COできる役職か && 今日は未COか
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
    console.log('j_updateCommonPerspective');
    ; 共通視点オブジェクトを更新する
    ; TODO こっちも破綻用のcatchや事前0確定チェックが必要かも
    console.log('【共通視点】');
    f.commonPerspective = organizePerspective (f.commonPerspective, mp.characterId, mp.zeroRoleIds);

    ; 各キャラの視点オブジェクトも更新する
    for (let cId of Object.keys(f.characterObjects)) {
      console.log('【' + cId + 'の視点】');
      console.log(f.characterObjects[cId].perspective);
      f.characterObjects[cId].perspective = organizePerspective (f.characterObjects[cId].perspective, mp.characterId, mp.zeroRoleIds);
      f.characterObjects[cId].role.rolePerspective = organizePerspective (f.characterObjects[cId].role.rolePerspective, mp.characterId, mp.zeroRoleIds);
      ; TODO ここで破綻することもある。破綻用のcatchを行うこと。
    }
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
      f.characterObjects[mp.characterId].perspective = clone (f.characterObjects[mp.characterId].role.rolePerspective);
    }
  [endscript]
[endmacro]


; テスト用カットイン表示マクロ
[macro name=j_cutin1]

    [image layer="1" x="0" y="150" width="1280" height="200" time="700" wait="false" storage="cutin.gif" name="cutin"]
    [playse  storage="speedy.ogg" volume=60]
    [image layer="1" x="-1000" y="160" height="180" visible="true" reflect="true" storage="00_angry_eye.png" name="00"]
    [anim name="00" left=100 time=700]
    [wait time=700]
    [fadeoutse time="1800"]

[endmacro]


; 占い師COすることができる役職・CO状態かを判定し、tf.canCOFortuneTellerStatusに結果を入れる。内訳はコード内のコメント参照
; 定数の並び順が昇順ではないのは、「if文は肯定形にする」と「未COに+1したらCO済みとする」の2つを優先したため。
; @param characterId 判定対象のキャラクターID。必須。
[macro name=j_setCanCOFortuneTellerStatus]
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


; 人狼メニュー画面に表示するための全占い師のCO状況テキストを生成する
[macro name=j_getAllFortuneTellerCOText]
  ; TODO:これを表示したあと、2日目にプレイヤーが占う時にバグる。
  ; getCharacterObjectsFromCharacterIds()で、for (let k of Object.keys(characterObjects)) {の際にUncaught TypeError: Cannot convert undefined or null to object
  ; おそらくcharacterObjectsがnullになっている。人狼メニュー画面から戻った時にcharacterObjectsが初期化されるor読み込めない状態になっている？
  [iscript]
    tf.allFortuneTellerCOText = '';
    for (let cId of Object.keys(f.allFortuneTellingHistoryObject)) {
      ; そのcIdが占い師CO済みなら表示する TODO:現在はテスト用に無効化
      if (f.characterObjects[cId].CORoleId == ROLE_ID_FORTUNE_TELLER) {}
      if (true) {
        tf.allFortuneTellerCOText += cId + ' : ';
        for (let day of Object.keys(f.allFortuneTellingHistoryObject[cId])) {
          ; TODO:「その日にCO済みなら（doneCO）」の判定が必要。履歴表示時にfalseなら表示しないようにしないと、未COの履歴も表示されてしまう。
          ; 「ただしプレイヤーの占い履歴は未COでも表示する」があるとよさそう。
          let tmpResult = f.allFortuneTellingHistoryObject[cId][day].result ? '●' : '○';
          tf.allFortuneTellerCOText += f.allFortuneTellingHistoryObject[cId][day].characterId + tmpResult;
        }
        tf.allFortuneTellerCOText += '<br>';
      }
    }
  [endscript]
[endmacro]


; jsonをローカルに保存する
; 参考　@link https://ameblo.jp/personwritep/entry-12495099049.html
[macro name=j_saveJson]
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
    a.download='all_variables.json';
    a.click();
    document.body.removeChild(a); // Firefoxで必要
    URL.revokeObjectURL(a.href);
  [endscript]
[endmacro]

[return]
