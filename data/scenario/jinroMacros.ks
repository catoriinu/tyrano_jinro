;人狼用マクロ
;first.ksでサブルーチンとして読み込んでおくこと


; 参加者登録マクロ
; 登録をした後はすぐにj_prepareJinroGameを実行すること
; @param characterId キャラクターID。必須
; @param roleId 役職ID。指定しない場合、役職はランダムに決定される
; @param personalityName 性格名。指定しない場合、キャラクターのデフォルトの性格になる
; @param adjustParameters 性格調整用のパラメータオブジェクト。なければ無調整。
; @param isPlayer プレイヤーキャラクターかどうか。指定した時点で、他のキャラの登録は初期化される ※キーを指定した時点でtrue扱いになるので注意
[macro name="j_registerParticipant"]
; TODO: 後で消す
  [iscript]
    // 初回呼び出し、あるいはisPlayerを指定された場合、tmpParticipant配列を初期化
    if (!(('tmpParticipantObjectList' in tf) && Array.isArray(tf.tmpParticipantObjectList)) || ('isPlayer' in mp)) {
      tf.tmpParticipantObjectList = [];
    };

    const characterId = mp.characterId;
    const roleId = ('roleId' in mp) ? mp.roleId : null;
    const personalityName = ('personalityName' in mp) ? mp.personalityName : null;
    const adjustParameters = ('adjustParameters' in mp) ? mp.adjustParameters : {};
    tf.tmpParticipantObjectList.push(new Participant(characterId, roleId, personalityName, adjustParameters));
  [endscript]
[endmacro]


; 人狼ゲーム準備マクロ
; 事前に最低でも1人（プレイヤー）以上はj_registerParticipantで（または直接tf.tmpParticipantObjectListに）参加者を登録しておくこと
; TODO: 後で消す @param participantsNumber 参加者の総人数
; @param jinroGameData 利用する人狼ゲームデータ。指定しない場合、sf.jinroGameDataObjects[sf.currentJinroGameDataKey]を利用する
; @param preload 人狼ゲームで使用するファイルをpreloadするか。デフォルト=false(しない)
[macro name="j_prepareJinroGame"]
  [iscript]
    const jinroGameData = mp.jinroGameData || sf.jinroGameDataObjects[sf.currentJinroGameDataKey];

    // キャラクターオブジェクト生成と各種変数の初期化
    initializeCharacterObjectsForJinro(jinroGameData);
    initializeTyranoValiableForJinro();

    // 登録が済んだらティラノの一時変数は初期化しておく
    // TODO: 後で消す
    tf.tmpParticipantObjectList = [];

    // ボイスのプリロードが必要か判定しておく
    tf.needPreloadVoice = (('preload' in mp) && (mp.preload === 'true' || mp.preload === true));
  [endscript]

  ; 必要ならボイスをプリロードする
  [call storage="message/utility.ks" target="*preloadVoice" cond="tf.needPreloadVoice"]
[endmacro]


; キャラの名前を表示するマクロ
; このマクロでキャラの名前を表示させると、コンフィグのキャラ判別サポート設定を適用することができる
; @param targetId 表示するキャラのキャラクターID
; @param targetName 表示するキャラクター名そのもの
[macro name="j_callName"]

  [iscript]
    tf.color = f.color.character[mp.targetId];
    //tf.iconStorage = 'sdchara/' + mp.targetId + '_mini.png'
  [endscript]

  [mark color="&tf.color" size="&sf.config.mark_size" cond="sf.config.mark_size > 0"]
  [emb exp="mp.targetName"]
  [endmark cond="sf.config.mark_size > 0"]

  ;TODO 不具合が解消できるまでj_graphタグは使わない。
  ; mark,endmarkタグの前後で使うとそこで文字の表示が途切れる問題。元々のgraphタグでは発生しない。
  ;[j_graph storage="&tf.iconStorage" height="40" width="40" cond="sf.config.show_icon"]
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


; 勝利陣営がいるかを判定し、勝利陣営がいた場合、指定されたラベルにジャンプする（storage, targetともに必須）
; ex: [j_judgeWinnerFactionAndJump storage="playJinro.ks" target="*gameOver"]
[macro name="j_judgeWinnerFactionAndJump"]
  [iscript]
    f.winnerFaction = judgeWinnerFaction(f.characterObjects);
  [endscript]
  [jump * cond="f.winnerFaction != null"]
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
    [j_COFortuneTelling fortuneTellerId="&tf.COFortuneTellerId" day="&tf.CODay" noNeedNotice="true"]

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
[macro name="j_assignmentFakeRole"]
  [iscript]
    // 偽役職COしていない場合のみ実行 NOTE 撤回COさせたくなったらマクロの引数で強制できるようにする
    if (Object.keys(f.characterObjects[mp.characterId].fakeRole).length === 0) {
      f.characterObjects[mp.characterId].fakeRole = roleAssignment(mp.roleId);

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
      console.log(mp.fortuneTellerId + 'は、破綻した占い結果のCOをしてしまいました!');
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
; TODO j_COFortuneTellingUntilTheLastDayの中に移動させたい
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
    ; ボイスとのスロットの競合を避けるためにbuf="1"を指定
    [playse storage="shakiin1.ogg" volume="35" buf="1"]
    ;[image layer="1" x="-1000" y="160" height="180" visible="true" reflect="true" storage="00_angry_eye.png" name="00"]
    ;[anim name="00" left=100 time=700]
    ;[wait time=700]
    [fadeoutse time="1800"]

[endmacro]


; 占い師COすることができる役職・CO状態かを判定し、f.canCOFortuneTellerStatusに結果を入れる。内訳はコード内のコメント参照
; 定数の並び順が昇順ではないのは、「if文は肯定形にする」と「未COに+1したらCO済みとする」の2つを優先したため。
; @param characterId 判定対象のキャラクターID。必須。
[macro name="j_setCanCOFortuneTellerStatus"]
  [iscript]
    const characterObject = f.characterObjects[mp.characterId];

    ; 0: 占い師CO不可の役職、またはCO状態
    f.canCOFortuneTellerStatus = 0;
    if (characterObject.role.roleId == ROLE_ID_FORTUNE_TELLER) {
      if (characterObject.CORoleId == ROLE_ID_FORTUNE_TELLER) {
        ; 2: 真占い師であり、CO済み
        f.canCOFortuneTellerStatus = 2;

      } else {
        ; 1: 真占い師で、未CO
        f.canCOFortuneTellerStatus = 1;
      }

    } else if (characterObject.role.roleId == ROLE_ID_WEREWOLF || characterObject.role.roleId == ROLE_ID_MADMAN) {
      if (characterObject.CORoleId == ROLE_ID_FORTUNE_TELLER) {
        ; 4: 騙り占い師としてCO済み
        f.canCOFortuneTellerStatus = 4;

      } else if (characterObject.CORoleId == '') {
        ; 3: 騙り占い師としてCO可能な役職で、未CO
        f.canCOFortuneTellerStatus = 3;
      }
      ; 占い師以外の役職としてCO済みなら、占い師COは不可
    }
  [endscript]
[endmacro]


; 役職COするかを問うボタンオブジェクトを設定する（TODO:現状は占い師のみ考慮しているが、他の役職もここに追加する想定）
; @param characterId 判定対象のキャラクターID。必須。
[macro name="j_setCORoleToButtonObjects"]
  [iscript]
    const characterObject = f.characterObjects[f.playerCharacterId];
    f.buttonObjects = [];

    // 占い師、騙り占い師COする
    if (characterObject.role.allowCORoles.includes(ROLE_ID_FORTUNE_TELLER)) {
      let id = 'FortuneTellerCO';
      let text = '占い師COする';
      if (characterObject.role.roleId !== ROLE_ID_FORTUNE_TELLER) {
        id = 'fakeFortuneTellerCO';
        text = '騙り占い師COする';
      }
      f.buttonObjects.push(new Button(
        id,
        text,
        'center',
        CLASS_GLINK_DEFAULT
      ));
    }

    // 役職COしない
    f.buttonObjects.push(new Button(
      'cancel',
      '役職COしない',
      'center',
      CLASS_GLINK_DEFAULT,
      CLASS_GLINK_SELECTED
    ));
  [endscript]
[endmacro]


; 占い結果COするかを問うボタンオブジェクトを設定する
; @param characterId 判定対象のキャラクターID。必須。
[macro name="j_setFrotuneTellerResultCOToButtonObjects"]
  ; COするしないボタン表示
  [iscript]
    const roleId = f.characterObjects[f.playerCharacterId].role.roleId;
    f.buttonObjects = [];

    // 占い結果、騙り占い結果COする
    let id = 'FortuneTellerCO';
    let text = '占い結果COする';
    if (roleId !== ROLE_ID_FORTUNE_TELLER) {
      id = 'fakeFortuneTellerCO';
      text = '騙り占い結果COする';
    }
    f.buttonObjects.push(new Button(
      id,
      text,
      'center',
      CLASS_GLINK_DEFAULT
    ));

    f.buttonObjects.push(new Button(
      'noCO',
      '何もしない',
      'center',
      CLASS_GLINK_DEFAULT,
      CLASS_GLINK_SELECTED
    ));
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
      let additionalClassName = '';
      if (f.actionButtonList[aId].id === f.selectedActionId) {
        additionalClassName = CLASS_GLINK_SELECTED;
      }

      // ボタンオブジェクトをf.buttonObjectsに格納する
      f.buttonObjects.push(new Button(
        f.actionButtonList[aId].id,
        f.actionButtonList[aId].text,
        'left',
        CLASS_GLINK_DEFAULT,
        additionalClassName
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

      let additionalClassName = '';
      // 選択中のキャラクターIDかつ選択中のアクションである（つまり、実行予定だったアクションと同じ）ボタンは選択中の色に変える
      if (cId === f.originalSelectedCharacterId && 'actionId' in f.pcActionObject && f.selectedActionId === f.pcActionObject.actionId) {
        additionalClassName = CLASS_GLINK_SELECTED;
      }

      // ボタンオブジェクトをf.buttonObjectsに格納する
      f.buttonObjects.push(new Button(
        cId,
        f.characterObjects[cId].name,
        mp.side,
        CLASS_GLINK_DEFAULT,
        additionalClassName
      ));
    }
  [endscript]
[endmacro]


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
    console.log('actionId:' + actionId);

    // ここまでに決定した情報を、NPCのアクションオブジェクトに格納する
    f.npcActionObject = new Action(f.doActionCandidateId, actionId, targetCharacterId);
    f.npcActionObject.decision = decision;
  [endscript]

  *end_j_decideDoActionByNPC
[endmacro]


; アクション実行
; TODO サブルーチン化したい
[macro name="j_doAction"]
  [iscript]
    // 議論フェイズのアクションを誰が実行するかを判定し、実行するアクションオブジェクトをf.triggerActionObjectとf.actionObjectにcloneする
    // プレイヤーがアクションボタンでアクション指定済みならプレイヤー
    if (Object.keys(f.pcActionObject).length > 0) {
      f.actionObject = clone(f.pcActionObject);
      f.triggerActionObject = clone(f.pcActionObject);
    } else if (Object.keys(f.npcActionObject).length > 0) {
      // プレイヤーがアクション未指定で、NPCでアクション実行者がいればそのNPC
      f.actionObject = clone(f.npcActionObject);
      f.triggerActionObject = clone(f.npcActionObject);
    } else {
      // どちらでもなければ実行なし
      f.actionObject = {};
      f.triggerActionObject = {};
    }
  [endscript]
  [jump target="*end_doAction" cond="Object.keys(f.actionObject).length === 0"]

  [iscript]
    // アクション実行中フラグ
    f.isDoingAction = true;

    // アクションボタン用変数の初期化（PCからのボタン先行入力を受け付けられるように消す。セリフとリアクションにはマクロ変数をcloneしたオブジェクト渡すのでこのタイミングで消して問題ない）
    f.pcActionObject = {};
    f.npcActionObject = {};

    // アクション実行履歴オブジェクトに、トリガーアクションを0要素目とするアクションオブジェクト配列をpushする
    const timeStr = getTimeStr();
    f.doActionHistory[f.day][timeStr].push([f.triggerActionObject]);

    // トリガーアクションで1回のみ行う処理はここでやる
    // アクション実行者の主張力を下げて、同日中は再発言しにくくする
    f.characterObjects[f.actionObject.characterId].personality.assertiveness.current -= f.characterObjects[f.actionObject.characterId].personality.assertiveness.decrease;
    // アクション実行できなかったキャラのフラストレーションを溜める
    increaseFrustration(f.characterObjects, f.participantsIdList, f.actionCandidateObjects, f.actionObject.characterId);
  [endscript]

  ; アクション実行、カウンターアクションがある限り続けて実行
  *doActionImpl
    [j_doActionImpl]
  [jump target="*doActionImpl" cond="Object.keys(f.actionObject).length > 0"]

  ; アクション実行中フラグを折る
  [eval exp="f.isDoingAction = false"]

  *end_doAction
[endmacro]


; アクション実行と、次のカウンターアクションを決定する
; 事前にf.actionObjectにアクションオブジェクトを設定しておくこと
; [j_doAction]から呼び出すこと
[macro name="j_doActionImpl"]
  [iscript]
    // アクション実行者がプレイヤーの場合、ここで判断基準IDを入れる
    if (f.actionObject.characterId === f.playerCharacterId) {
      // TODO 信じる：表の視点で同陣営割合が50%以上なら論理的な判断　疑う：表の視点で同陣営割合が50%未満なら論理的な判断
      f.actionObject.decision = DECISION_LOGICAL; //DECISION_EMOTIONAL;
    }

    // 全員の信頼度増減
    updateReliabirityForAction(f.characterObjects, f.actionObject);

    // アクション実行履歴オブジェクトに、アクションオブジェクトを保存する
    const timeStr = getTimeStr();
    f.doActionHistory[f.day][timeStr].slice(-1)[0].push(f.actionObject);
 
    // 今回のトリガー起因のアクション実行履歴を取得する
    const triggerActionHistory = f.doActionHistory[f.day][timeStr].slice(-1)[0];

    // カウンターアクションを実行するか判定し、取得
    f.counterActionObject = getCounterAction(triggerActionHistory);
  [endscript]

  ; 実行するアクションのセリフ表示
  [m_doAction]

  [iscript]
    // MEMO プレイヤーが能動的にカウンターアクションを実行できるようにするなら、ここでボタン実行結果でf.counterActionObjectを上書きすべき

    // 続けてカウンターアクションを実行するならf.actionObjectに移し替える
    if (Object.keys(f.counterActionObject).length > 0) {
      f.actionObject = clone(f.counterActionObject);
    } else {
      f.actionObject = {};
    }
  [endscript]
[endmacro]


; 人狼メニュー画面に表示するための全占い師のCO状況テキストを生成する
; TODO 現在未使用
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
          // 「その日にCO済みなら」の判定が必要。履歴表示時にfalseなら表示しないようにしないと、夜の時点で開いたときに未COの履歴も表示されてしまう。
          // ただしプレイヤーの占い履歴は未COでも表示する（占い師CO自体をしていないなら表示しない TODO：役職未COと分かるようにすれば、表示してもいいかも）
          if (cId != f.playerCharacterId && !fortuneTellingHistory[day].isPublic) continue;
          
          let targetId = fortuneTellingHistory[day].targetId;
          let result = fortuneTellingHistory[day].result ? '●' : '○';
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
  [j_saveFixButton buf="openVote"]
  [j_clearFixButton]
  [layopt layer="message0" visible="false"]

  ; 投票結果を表示
  [j_setDchForOpenVote]
  [call storage="jinroSubroutines.ks" target="*displayCharactersHorizontally"]
  [p]
  ; 投票結果を表示していたレイヤーを解放
  [freeimage layer="1" time="400" wait="true"]

  ; 開票オブジェクトの処理。ステータス画面の投票履歴情報の制御用
  [iscript]
    if (f.day in f.openedVote) {
      // 2回目以降の開票なら、開票回数をインクリメント
      f.openedVote[f.day] += 1;
    } else {
      // その日の初回開票なら、開票日の値に1を入れる
      f.openedVote[f.day] = 1;
    }
  [endscript]

  ; ボタン復元とメッセージウィンドウを表示
  [j_loadFixButton buf="openVote"]
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
        getBgColorFromCharacterId(f.voteResultObjects[i].targetId),
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
  [j_saveFixButton buf="intro"]
  [j_clearFixButton]

  ; キャラクタ－画像を表示
  [j_setDchForintroductionCharacters]
  [call storage="jinroSubroutines.ks" target="*displayCharactersHorizontally"]
  [p]
  ; キャラクター画像を表示していたレイヤーを解放
  [freeimage layer="1" time="400" wait="true"]

  ; ボタン復元
  [j_loadFixButton buf="intro"]
[endmacro]


[macro name="j_setDchForintroductionCharacters"]
  [iscript]
    let tmpCharacterList = [];
    for (let i = 0; i < f.participantsIdList.length; i++) {
      let cId = f.participantsIdList[i];
      tmpCharacterList.push(new DisplayCharactersHorizontallySingle(
        cId,
        'normal.png',
        getBgColorFromCharacterId(cId),
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


[macro name="j_setDchForStatus"]
  [iscript]
    let tmpCharacterList = [];
    for (let i = 0; i < f.participantsIdList.length; i++) {
      let cId = f.participantsIdList[i];

      let bgColor = '';
      let fileName = '';

      if (mp.winnerFaction == null) {
        // 勝利陣営が未確定（ゲーム進行中）に開いた場合
        // TODO：夜の場合は夜時間開始時のオブジェクト（f.characterObjectsHistory[f.day]）のほうがいい？isAlive判定など。どちらの方が自然か検討する。
        bgColor = getBgColorFromCharacterId(cId, f.characterObjects[cId].isAlive);
        if (f.characterObjects[cId].isAlive) {
          fileName = f.statusFace[cId].alive;
        } else {
          fileName = f.statusFace[cId].lose;
        }
      } else {
        // 勝利陣営が確定済み（ゲーム終了後）に開いた場合
        bgColor = getBgColorFromCharacterId(cId, f.characterObjects[cId].isAlive);
        if (mp.winnerFaction == FACTION_DRAW_BY_REVOTE) {
          fileName = f.statusFace[cId].draw;
        } else if (f.characterObjects[cId].role.faction == mp.winnerFaction){
          fileName = f.statusFace[cId].win[mp.winnerFaction];
        } else {
          fileName = f.statusFace[cId].lose;
        }
      }

      tmpCharacterList.push(new DisplayCharactersHorizontallySingle(
        cId,
        fileName,
        bgColor,
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


; 勝敗結果画面を表示する
; 事前にf.winnerFactionに勝利陣営を格納しておくこと
[macro name="j_displayGameOverAndWinnerFaction"]

  [fadeoutbgm time="1000"]
  ; 全ボタンを消去
  [j_saveFixButton buf="gameover"]
  [j_clearFixButton]
  [m_displayGameOver][p]

  ; 勝利陣営を表示、プレイヤー視点での勝敗結果効果音を鳴らす
  [j_setDchForWinnerFactionCharacters winnerFaction="&f.winnerFaction"]
  [call storage="jinroSubroutines.ks" target="*displayCharactersHorizontally"]
  [j_playSePlayerResult winnerFaction="&f.winnerFaction"]
  [m_displayWinnerFaction winnerFaction="&f.winnerFaction"]

  ; ボタン復元
  [j_loadFixButton buf="gameover"]
  詳細はステータス画面を確認してください。[p]

  ; キャラクター画像を表示していたレイヤーを解放するのは呼び元に任せる
[endmacro]


; @param winnerFaction 勝利陣営。必須
[macro name="j_setDchForWinnerFactionCharacters"]
  [iscript]
    let tmpCharacterList = [];
    for (let i = 0; i < f.participantsIdList.length; i++) {
      let cId = f.participantsIdList[i];

      let fileName = '';
      if (mp.winnerFaction == FACTION_DRAW_BY_REVOTE) {
        fileName = f.statusFace[cId].draw;
      } else if (f.characterObjects[cId].role.faction == mp.winnerFaction){
        fileName = f.statusFace[cId].win[mp.winnerFaction];
      } else {
        // 敗北陣営のキャラクターは表示しない
        continue;
      }
      let bgColor = getBgColorFromCharacterId(cId);

      tmpCharacterList.push(new DisplayCharactersHorizontallySingle(
        cId,
        fileName,
        bgColor,
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
  [if exp="isResultDraw(mp.winnerFaction)"]
    ; 引き分け
    [playse storage="megaten.ogg" buf="1" loop="false" volume="35" sprite_time="50-20000"]
  [elsif exp="isResultPlayersWin(mp.winnerFaction, f.characterObjects[f.playerCharacterId].role.faction)"]
    ; 勝利
    [playse storage="kirakira4.ogg" buf="1" loop="false" volume="35" sprite_time="50-20000"]
  [else]
    ; 敗北
    [playse storage="chiin1.ogg" buf="1" loop="false" volume="35" sprite_time="50-20000"]
  [endif]
[endmacro]


; Fixレイヤーのボタンを表示する。表示中のボタンは指定されても再表示はしない。
; ボタンの消去は[j_clearFixButton]で行うこと。
; 以下のマクロ変数を全て省略すると、全てのボタンを表示する。
; @param action アクションボタンを表示する
; @param menu メニューボタンを表示する
; @param backlog バックログボタンを表示する
; @param status ステータスボタンを表示する
; @param pauseMenu ポーズメニューボタンを表示する（チャプター再生中用）
; ※引数に'ignore'を設定すると、引数を指定しなかった場合と同様にそのボタンには何もしない。'ignore'以外を渡すと通常のボタンを表示する
; ※以下は特殊なボタンを表示したい場合に設定する引数
; status="nofix": fix属性ではないかつrole="sleepgame"指定もしないステータスボタン
; status="nofix_click": fix属性ではないかつrole="sleepgame"指定もしないステータスボタンで、クリック済み画像を表示する
[macro name="j_displayFixButton"]

  [iscript]
    // 初回のみ、ボタンの表示ステータスを管理するオブジェクトを生成
    if (!('displaingButton' in f)) {
      f.displaingButton = {
        action: null,
        menu: null,
        backlog: null,
        status: null,
        pauseMenu: null,
      };
    };

    // TODO pauseMenuを追加すると多分未定義出る気がする。forで回すのはf.displaingButtonがいいかもしれない。
    for (let button in mp) {
      if (mp[button] === 'ignore') {
        // 'ignore'が渡されてきた場合、引数を指定しなかった場合と同様にそのボタンには何もしない
        mp[button] = null;
      } else if (mp[button] !== 'nofix' && mp[button] !== 'nofix_click') {
        // 'nofix','nofix_click'以外の値が渡されてきた場合、全て'normal'に変換する
        mp[button] = 'normal';
      }
    }

    // 一つも引数に指定されていないなら、全て表示する。一つでも指定されているなら引数通りとする。(基本的に人狼中を想定しているので、pauseMenuは判定・表示対象外)
    if (!(('action' in mp) || ('menu' in mp) || ('backlog' in mp) || ('status' in mp))) {
      mp.action = 'normal';
      mp.menu = 'normal';
      mp.backlog = 'normal';
      mp.status = 'normal';
    }
    console.log('表示');
    console.log(mp);
  [endscript]

  [if exp="!f.displaingButton.action && mp.action"]
    [button graphic="button/button_action_normal.png" storage="action.ks" target="*start" x="23" y="17" width="100" height="100" fix="true" role="sleepgame" name="button_j_fix,button_j_action" enterimg="button/button_action_hover.png"]
    [eval exp="f.displaingButton.action = mp.action"]
  [endif]

  [if exp="!f.displaingButton.menu && mp.menu"]
    ; 通常画面→メニュー画面に遷移する用。
    [button cond="mp.menu === 'normal'" graphic="button/button_menu_normal.png" storage="menuJinro.ks" target="*menuJinroMain" x="1200" y="17" width="70" height="100" fix="true" role="sleepgame" name="button_j_fix,button_j_menu" enterimg="button/button_menu_hover.png"]
    [eval exp="f.displaingButton.menu = mp.menu"]
  [endif]

  [if exp="!f.displaingButton.backlog && mp.backlog"]
    [button graphic="button/button_backlog_normal.png" x="1118" y="17" width="70" height="100" fix="true" role="backlog" name="button_j_fix,button_j_backlog" enterimg="button/button_backlog_hover.png"]
    [eval exp="f.displaingButton.backlog = mp.backlog"]
  [endif]


  ; status引数が渡されておりそれが表示中のボタンと異なる種類なら、この後ボタンを入れ替える前準備としてボタンとフラグを消去する
  [if exp="('status' in mp) && mp.status !== null && f.displaingButton.status !== null && f.displaingButton.status !== mp.status"]
    [clearfix name="button_j_status"]
    [eval exp="f.displaingButton.status = null"]
  [endif]

  [if exp="!f.displaingButton.status && mp.status"]
    ; 通常画面→ステータス画面への遷移
    [button cond="mp.status === 'normal'" graphic="button/button_status_normal.png" storage="statusJinro.ks" target="*statusJinroMain" x="1005" y="17" width="100" height="100" fix="true" role="sleepgame" name="button_j_fix,button_j_status" enterimg="button/button_status_hover.png"]
    ; ステータス画面→元の画面へ戻る遷移
    [button cond="mp.status === 'nofix_click'" graphic="button/button_return_selected.png" storage="statusJinro.ks" target="*awake" x="1005" y="17" width="100" height="100" enterimg="button/button_return_hover.png"]

    [eval exp="f.displaingButton.status = mp.status"]
  [endif]


  [if exp="!f.displaingButton.pauseMenu && mp.pauseMenu"]
    [button graphic="button/button_menu_normal.png" storage="theater/pauseMenu.ks" target="*start" x="1200" y="17" width="70" height="100" fix="true" role="sleepgame" name="button_j_fix,button_j_pauseMenu" enterimg="button/button_menu_hover.png"]
    [eval exp="f.displaingButton.pauseMenu = mp.pauseMenu"]
  [endif]
[endmacro]


; Fixレイヤーのボタンを消去する。消去中のボタンは指定されても再消去はしない。
; ボタンの表示は[j_displayFixButton]で行うこと。
; 以下のマクロ変数を全て省略すると、全てのボタンを消去する。
; @param action アクションボタンを消去する（※"false"を渡すとtrue判定になるので注意）
; @param menu メニューボタンを消去する（※"false"を渡すとtrue判定になるので注意）
; @param backlog バックログボタンを消去する（※"false"を渡すとtrue判定になるので注意）
; @param status ステータスボタンを消去する（※"false"を渡すとtrue判定になるので注意）
; @param pauseMenu ポーズメニューボタンを消去する（チャプター再生中用）（※"false"を渡すとtrue判定になるので注意）
[macro name="j_clearFixButton"]
  [iscript]
    // [j_displayFixButton]は実行済みでf.displaingButtonは存在している前提とする。
    // 一つもマクロ変数に指定されていないなら、全て消去する。一つでも指定されているならマクロ変数通りとする。
    if (!(('action' in mp) || ('menu' in mp) || ('backlog' in mp) || ('status' in mp) || ('pauseMenu' in mp))) {
      mp.action = true;
      mp.menu = true;
      mp.backlog = true;
      mp.status = true;
      mp.pauseMenu = true;
    }
    console.log('消去');
    console.log(mp);
  [endscript]

  [if exp="f.displaingButton.action && mp.action"]
    [clearfix name="button_j_action"]
    [eval exp="f.displaingButton.action = null"]
  [endif]

  [if exp="f.displaingButton.menu && mp.menu"]
    [clearfix name="button_j_menu"]
    [eval exp="f.displaingButton.menu = null"]
  [endif]

  [if exp="f.displaingButton.backlog && mp.backlog"]
    [clearfix name="button_j_backlog"]
    [eval exp="f.displaingButton.backlog = null"]
  [endif]

  [if exp="f.displaingButton.status && mp.status"]
    [clearfix name="button_j_status"]
    [eval exp="f.displaingButton.status = null"]
  [endif]

  [if exp="f.displaingButton.pauseMenu && mp.pauseMenu"]
    [clearfix name="button_j_pauseMenu"]
    [eval exp="f.displaingButton.pauseMenu = null"]
  [endif]
[endmacro]


; 現在のFixレイヤーのボタンの表示ステータスを保存しておくマクロ
; [j_displayFixButton]は実行済みでf.displaingButtonは存在している前提とする。
; @param buf 必須。保存バッファ。任意のキー名を指定すること。保存済みのキー名と重複した場合は上書きする
[macro name="j_saveFixButton"]
  [iscript]
    // 初回のみ、ボタンの表示ステータスを保存するオブジェクトを生成
    if (!('saveButton' in f)) {
      f.saveButton = {};
    };
    f.saveButton[mp.buf] = clone(f.displaingButton);
  [endscript]
[endmacro]


; 保存済みのFixレイヤーのボタンの表示ステータスを読み込み、復元するマクロ
; [j_saveFixButton]は実行済みでf.saveButtonは存在している前提とする。
; @param buf 必須。保存バッファ。任意のキー名を指定すること。保存済みのキー名から復元する。キーが存在しない場合はエラー（未考慮）
[macro name="j_loadFixButton"]
  [iscript]
    tf.tmpDisplayButton = {};
    tf.tmpClearButton = {};
    const loadButton = f.saveButton[mp.buf];

    for (let button of Object.keys(loadButton)) {
      let buttonStatus = loadButton[button];

      if (buttonStatus === null) {
        // 保存時の状態がnullなら、表示するかは無視し、消去は実行する
        tf.tmpDisplayButton[button] = 'ignore';
        tf.tmpClearButton[button] = 'true';
      } else {
        // 保存時の状況が表示中なら、当時の表示状態に復元し、消去は無視する
        tf.tmpDisplayButton[button] = buttonStatus;
        tf.tmpClearButton[button] = 'ignore';
      }
    }
  [endscript]
  [j_clearFixButton action="&tf.tmpClearButton.action" menu="&tf.tmpClearButton.menu" backlog="&tf.tmpClearButton.backlog" status="&tf.tmpClearButton.status" pauseMenu="&tf.tmpClearButton.pauseMenu"]
  [j_displayFixButton action="&tf.tmpDisplayButton.action" menu="&tf.tmpDisplayButton.menu" backlog="&tf.tmpDisplayButton.backlog" status="&tf.tmpDisplayButton.status" pauseMenu="&tf.tmpDisplayButton.pauseMenu"]
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

  [playse storage="shock1.ogg" buf="1" loop="false" volume="35" sprite_time="50-20000"]
  [emb exp="f.day + '日目の朝を迎えました。'"][l][r]
  [if exp="typeof f.bitingObjectLastNight === 'undefined'"]
    [playse storage="shock1.ogg" buf="1" loop="false" volume="35" sprite_time="50-20000"]
    ; 昨夜の襲撃結果が取得できなかった（＝初日犠牲者のいない1日目昼）場合
    ; TODO 人狼の人数を可変で出力する
    ; FIXME 役職の内訳を表示してもいいかも。
    この中に人狼が1人潜んでいます……。
    [j_introductionCharacters]

  [elsif exp="f.bitingObjectLastNight.result"]
    [playse storage="shock1.ogg" buf="1" loop="false" volume="35" sprite_time="50-20000"]
    ; 昨夜の襲撃結果が襲撃成功の場合
    ; キャラを登場させ、メッセージ表示
    ; TODO face="敗北"が登録必須なのを汎用的にしたい
    [m_changeCharacter characterId="&f.bitingObjectLastNight.targetId" face="敗北"]
    [emb exp="f.characterObjects[f.bitingObjectLastNight.targetId].name + 'は無残な姿で発見されました……。'"][p]

    ; 噛まれたということは人狼ではないので、視点オブジェクトを更新する（TODO：人狼以外にも噛まれない役職が増えたら修正する）
    [eval exp="updateCommonPerspective(f.bitingObjectLastNight.targetId, [ROLE_ID_WEREWOLF])"]

    ; キャラを退場させる
    [m_exitCharacter characterId="&f.bitingObjectLastNight.targetId"]

  [else]
    ; 昨夜の襲撃結果が襲撃失敗の場合
    誰も襲われていない、平和な朝でした。[p]

  [endif]

  [playbgm storage="nc282335.ogg" loop="true" volume="11" restart="false"]
  [bg storage="living_day_nc238325.jpg" time="1000" wait="true" effect="fadeInUp"]
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



; @param buf 必須。保存バッファ。任意のキー名を指定すること。
; @param bool noOverwrite trueの場合、bufが保存済みのキー名と重複した場合に上書きしない。デフォルトはfalse
[macro name="j_backupJinroObjects"]
  [iscript]
    // 初回のみ、バックアップ用オブジェクトを生成
    if (!('backupJinroObjects' in f)) {
      f.backupJinroObjects = {};
    };

    const noOverwrite = ('noOverwrite' in mp) ? mp.noOverwrite : false;
    // 「上書き防止フラグが立っているかつそのbufが保存済みの場合」以外はバックアップする
    if (!(noOverwrite && (mp.buf in f.backupJinroObjects))) {
      f.backupJinroObjects[mp.buf] = {
        characterObjects: clone(f.characterObjects),
        commonPerspective: clone(f.commonPerspective)
      };
    }
  [endscript]
[endmacro]

; @param buf 必須。保存バッファ。任意のキー名を指定すること。保存済みのキー名から復元する。キーが存在しない場合はエラー（未考慮）
[macro name="j_restoreJinroObjects"]
  [iscript]
    f.characterObjects = clone(f.backupJinroObjects[mp.buf].characterObjects);
    f.commonPerspective = clone(f.backupJinroObjects[mp.buf].commonPerspective);
  [endscript]
[endmacro]

; @param buf 必須。保存バッファ。任意のキー名を指定すること。
[macro name="j_initializeBackupJinroObjects"]
  [iscript]
    f.backupJinroObjects = {};
  [endscript]
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
