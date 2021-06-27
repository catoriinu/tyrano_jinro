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
; ex: [j_judgeWinnerCampAndJump storage="scene1.ks" target="*gameOver"]
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
  @jump *
[endif]
[endmacro]


; 占いマクロ
; @param fortuneTellerId 占い実行者のID。真占い師、占い騙りに関わらず、必須。
; @param characterId 占う対象のID。入っているなら、実行者はプレイヤーである。入っていないなら実行者はNPCのため、メソッド内部で対象を決める。
; @param result プレイヤーかつ騙りの占い師の場合のみ必要。宣言する占い結果をで渡す。※string型
; @param day 占った日付。当日であれば指定不要。
[macro name=j_fortuneTelling]
  [iscript]
    ; 型をstring→boolに変換する ※マクロにboolやnumを渡しても、stringに型変換されてしまうため、人狼プラグインのメソッドに渡す前に変換する。
    ; jsは空文字でないstringをtrueと評価するため、確実に'true'でないとtrueを入れないようにする。
    const boolResult = (mp.result == 'true') ? true : false;

    ; 占った日付を入れる。真占い師ならば当日の夜に占う（デフォルト）が、占い騙りのように前日の夜に占ったことを偽装する必要がある場合にmp.dayを渡す。
    const day = (typeof mp.day == 'undefined') ? f.day : parseInt(mp.day);

    let todayResult = {};
    ; ターゲットが決まっている（＝実行者がプレイヤー）なら
    if (mp.characterId) {
      if (f.characterObjects[f.playerCharacterId].fakeRole.roleId == ROLE_ID_FORTUNE_TELLER) {
        ; 占い騙りの場合
        todayResult = f.characterObjects[f.playerCharacterId].fakeRole.fortuneTelling(mp.fortuneTellerId, day, mp.characterId, boolResult);
      } else {
        ; 真占いの場合
        todayResult = f.characterObjects[f.playerCharacterId].role.fortuneTelling(mp.fortuneTellerId, day, mp.characterId);
      }
    ; ターゲットが決まっていない（＝実行者がNPC）なら
    } else {
      if (f.characterObjects[mp.fortuneTellerId].fakeRole.roleId == ROLE_ID_FORTUNE_TELLER) {
        ; 占い騙りの場合
        todayResult = f.characterObjects[mp.fortuneTellerId].fakeRole.fortuneTelling(mp.fortuneTellerId, day);
      } else {
        ; 真占いの場合
        todayResult = f.characterObjects[mp.fortuneTellerId].role.fortuneTelling(mp.fortuneTellerId, day);
      }
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
    
    ; 返り値用の一時変数に格納
    tf.todayResultObject = todayResult;

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
  ; マクロ変数に入れていると、マクロ内で呼んだマクロの終了時に消されてしまうため、一時変数に格納しておく
  [eval exp="tf.fortuneTellerId = mp.fortuneTellerId"]
  *fakeFortuneTellingCOMultipleDays_loopstart

    ; 占いマクロを、初日(day=0)から最新の日の日付までループ実行していく
    [j_fortuneTelling fortuneTellerId="&tf.fortuneTellerId" day="&tf.fortuneTelledDay"]

  [jump target="*fakeFortuneTellingCOMultipleDays_loopend" cond="tf.fortuneTelledDay == tf.lastDay"]
  [eval exp="tf.fortuneTelledDay++"]
  [jump target="*fakeFortuneTellingCOMultipleDays_loopstart"]

  *fakeFortuneTellingCOMultipleDays_loopend
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


; 指定したキャラクターの最新の占い履歴をもとに、占いCO文を出力する。
; 占い師、占い騙り両対応。
; @param fortuneTellerId 取得したい占い師（騙り占い）のキャラクターID。必須
[macro name=j_COfortuneTellingResultLastNight]

  ; COする占い師名も格納する
  ; 別マクロを呼び出す前に一時変数に格納すること！（理由は後述）
  [eval exp="tf.fortuneTellerId = mp.fortuneTellerId"]

  ; 占いカットイン発生
  [j_cutin1]

  [iscript]
    console.log('カットイン終了');
  [endscript]

  ; 指定した占い師の最新の占い履歴オブジェクトをtf.fortuneTellingHistoryObjectに格納する
  ; ※マクロ内で別マクロを呼び出すと、別マクロの終了時にmp変数が全て空にされてしまう。
  ; そのため、元マクロ側の引数を元マクロ内で引き続き使いたい場合は、一時変数などに格納しておかないといけない。
  [j_fortuneTellingHistoryObjectThatDay fortuneTellerId="&tf.fortuneTellerId"]

  ; 一時変数を元に、サブルーチン内でCO文を出力する
  [call storage="./fortuneTellingForPC.ks" target="*COfortuneTellingResult"]

[endmacro]


; CO候補となるキャラクターID配列からCO候補者を一人決定し、tf.COCandidateIdに格納する。
; @param characterIds CO候補となるキャラクターID配列（NPCかつ生存者を想定）。必須
[macro name=j_decideCOCandidateId]
  [iscript]
    ; TODO:直前（PC、NPCどちらも）のCOの内容によって、各キャラ内のCOしたい度が変動するようにする

    ; キャラクターID配列を回してCO意思があるかつisDoneTodaysCOがfalseであれば、isCOMyRoll()を噛ませる。
    let maxProbability = 0;
    let COCandidateIdArray = [];
    tf.COCandidateId = '';
    for (let i = 0; i < mp.characterIds.length; i++) {
      if (f.characterObjects[mp.characterIds[i]].role.willCO && !f.characterObjects[mp.characterIds[i]].isDoneTodaysCO) {
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
    ; 生存している && 現在CO意思があるか && 今日は未COか
    if (f.characterObjects[f.playerCharacterId].isAlive && f.characterObjects[f.playerCharacterId].role.willCO && !f.characterObjects[f.playerCharacterId].isDoneTodaysCO) {
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