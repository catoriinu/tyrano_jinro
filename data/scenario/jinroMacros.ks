;人狼用マクロ
;first.ksでサブルーチンとして読み込んでおくこと


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






; テスト用カットイン表示マクロ
[macro name="j_cutin1"]

    ;[image layer="1" x="0" y="150" width="1280" height="200" time="700" wait="false" storage="cutin.gif" name="cutin"]
    ; ボイスとのスロットの競合を避けるためにbuf="2"を指定
    [playse storage="se/shakiin1.ogg" volume="35" buf="2"]
    ;[image layer="1" x="-1000" y="160" height="180" visible="true" reflect="true" storage="00_angry_eye.png" name="00"]
    ;[anim name="00" left=100 time=700]
    ;[wait time=700]
    [fadeoutse time="1800" buf="2"]

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
        CLASS_GLINK_DEFAULT,
        '',
        'se/button34.ogg',
        'se/button13.ogg',
      ));
    }

    // 役職COしない
    f.buttonObjects.push(new Button(
      'cancel',
      '役職COしない',
      'center',
      CLASS_GLINK_DEFAULT,
      CLASS_GLINK_SELECTED,
      'se/button34.ogg',
      'se/button15.ogg',
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
      CLASS_GLINK_DEFAULT,
      '',
      'se/button34.ogg',
      'se/button13.ogg',
    ));

    f.buttonObjects.push(new Button(
      'noCO',
      '何もしない',
      'center',
      CLASS_GLINK_DEFAULT,
      CLASS_GLINK_SELECTED,
      '',
      'se/button34.ogg',
      'se/button15.ogg',
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

      let additionalClassName = '';
      let clickse = 'se/button13.ogg';
      if (f.actionButtonList[aId].id === f.selectedActionId) {
        // 選択中のアクションIDのボタンは選択中の色に変える
        additionalClassName = CLASS_GLINK_SELECTED;

        // 対象をとらないアクション（現時点では「発言しない」のみ）はキャンセル用SEに変える
        //（対象をとるアクションは、キャラ選択時にキャンセル用SEを鳴らせばいいので）
        if (f.selectedActionId === ACTION_CANCEL) {
          clickse = 'se/button15.ogg';
        }
      }

      // ボタンオブジェクトをf.buttonObjectsに格納する
      f.buttonObjects.push(new Button(
        f.actionButtonList[aId].id,
        f.actionButtonList[aId].text,
        'left',
        CLASS_GLINK_DEFAULT,
        additionalClassName,
        'se/button34.ogg',
        clickse
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
      let clickse = 'se/button13.ogg';
      if (cId === f.originalSelectedCharacterId && 'actionId' in f.pcActionObject && f.selectedActionId === f.pcActionObject.actionId) {
        // 選択中のキャラクターIDかつ選択中のアクションである（つまり、実行予定だったアクションと同じ）ボタンは
        // 選択中の色&キャンセル用SEに変える
        additionalClassName = CLASS_GLINK_SELECTED;
        clickse = 'se/button15.ogg';
      }

      // ボタンオブジェクトをf.buttonObjectsに格納する
      f.buttonObjects.push(new Button(
        cId,
        f.characterObjects[cId].name,
        mp.side,
        CLASS_GLINK_DEFAULT,
        additionalClassName,
        'se/button34.ogg',
        clickse
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

    // アクション実行履歴オブジェクトに、空配列をpushする。[j_doActionImpl]内で、この配列にアクションオブジェクトを保存する
    const timeStr = getTimeStr();
    f.doActionHistory[f.day][timeStr].push([]);

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
      // MEMO 自身の論理力次第とする。例：0.8なら、同陣営割合が20%以上なら論理的な判断みたいな
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


; 投票結果画面用のキャラクター画像表示オブジェクトを設定する
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
        '投票→' + f.characterObjects[f.voteResultObjects[i].targetId].name
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


; キャラクター紹介画面用のキャラクター画像表示オブジェクトを設定する
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



; ステータス画面用のキャラクター画像表示オブジェクトを設定する
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
  詳細はステータス画面を確認してください。[r]
  クリックすると次に進みます。[p]

  ; キャラクター画像を表示していたレイヤーを解放するのは呼び元に任せる
[endmacro]


; 勝敗結果画面用のキャラクター画像表示オブジェクトを設定する
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
    [playse storage="se/megaten.ogg" buf="2" loop="false" volume="35" sprite_time="50-20000"]
  [elsif exp="isResultPlayersWin(mp.winnerFaction, f.characterObjects[f.playerCharacterId].role.faction)"]
    ; 勝利
    [playse storage="se/kirakira4.ogg" buf="2" loop="false" volume="35" sprite_time="50-20000"]
  [else]
    ; 敗北
    [playse storage="se/chiin1.ogg" buf="2" loop="false" volume="35" sprite_time="50-20000"]
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
    console.debug('表示');
    console.debug(mp);
  [endscript]

  [if exp="!f.displaingButton.action && mp.action"]
    [button graphic="button/button_action_normal.png" storage="action.ks" target="*start" x="23" y="17" width="100" height="100" fix="true" role="sleepgame" name="button-j-action" enterimg="button/button_action_hover.png" enterse="se/button34.ogg" clickse="se/button13.ogg"]
    [eval exp="f.displaingButton.action = mp.action"]
  [endif]

  [if exp="!f.displaingButton.menu && mp.menu"]
    ; 通常画面→メニュー画面に遷移する用。
    [button cond="mp.menu === 'normal'" graphic="button/button_menu_normal.png" storage="menuJinro.ks" target="*menuJinroMain" x="1200" y="17" width="70" height="100" fix="true" role="sleepgame" name="button-j-menu" enterimg="button/button_menu_hover.png" enterse="se/button34.ogg" clickse="se/button13.ogg"]
    [eval exp="f.displaingButton.menu = mp.menu"]
  [endif]

  [if exp="!f.displaingButton.backlog && mp.backlog"]
    [button graphic="button/button_backlog_normal.png" x="1118" y="17" width="70" height="100" fix="true" role="backlog" name="button-j-backlog" enterimg="button/button_backlog_hover.png" enterse="se/button34.ogg" clickse="se/button13.ogg"]
    [eval exp="f.displaingButton.backlog = mp.backlog"]
  [endif]


  ; status引数が渡されておりそれが表示中のボタンと異なる種類なら、この後ボタンを入れ替える前準備としてボタンとフラグを消去する
  [if exp="('status' in mp) && mp.status !== null && f.displaingButton.status !== null && f.displaingButton.status !== mp.status"]
    [clearfix name="button-j-status"]
    [eval exp="f.displaingButton.status = null"]
  [endif]

  [if exp="!f.displaingButton.status && mp.status"]
    ; 通常画面→ステータス画面への遷移
    [button cond="mp.status === 'normal'" graphic="button/button_status_normal.png" storage="statusJinro.ks" target="*statusJinroMain" x="1005" y="17" width="100" height="100" fix="true" role="sleepgame" name="button-j-status" enterimg="button/button_status_hover.png" enterse="se/button34.ogg" clickse="se/button13.ogg"]
    ; ステータス画面→元の画面へ戻る遷移
    [button cond="mp.status === 'nofix_click'" graphic="button/button_return_selected.png" storage="statusJinro.ks" target="*awake" x="1005" y="17" width="100" height="100" enterimg="button/button_return_hover.png" name="button-j-status" enterse="se/button34.ogg" clickse="se/button15.ogg"]

    [eval exp="f.displaingButton.status = mp.status"]
  [endif]


  [if exp="!f.displaingButton.pauseMenu && mp.pauseMenu"]
    [button graphic="button/button_menu_normal.png" storage="theater/pauseMenu.ks" target="*start" x="1200" y="17" width="70" height="100" fix="true" role="sleepgame" name="button-j-pause-menu" enterimg="button/button_menu_hover.png" enterse="se/button34.ogg" clickse="se/button13.ogg"]
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
    console.debug('消去');
    console.debug(mp);
  [endscript]

  [if exp="f.displaingButton.action && mp.action"]
    [clearfix name="button-j-action"]
    [eval exp="f.displaingButton.action = null"]
  [endif]

  [if exp="f.displaingButton.menu && mp.menu"]
    [clearfix name="button-j-menu"]
    [eval exp="f.displaingButton.menu = null"]
  [endif]

  [if exp="f.displaingButton.backlog && mp.backlog"]
    [clearfix name="button-j-backlog"]
    [eval exp="f.displaingButton.backlog = null"]
  [endif]

  [if exp="f.displaingButton.status && mp.status"]
    [clearfix name="button-j-status"]
    [eval exp="f.displaingButton.status = null"]
  [endif]

  [if exp="f.displaingButton.pauseMenu && mp.pauseMenu"]
    [clearfix name="button-j-pause-menu"]
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

  [playse storage="se/shock1.ogg" buf="2" loop="false" volume="35" sprite_time="50-20000"]
  [emb exp="f.day + '日目の朝を迎えました。'"][l][r]
  [if exp="typeof f.bitingObjectLastNight === 'undefined'"]
    [playse storage="se/shock1.ogg" buf="2" loop="false" volume="35" sprite_time="50-20000"]
    ; 昨夜の襲撃結果が取得できなかった（＝初日犠牲者のいない1日目昼）場合
    ; TODO 人狼の人数を可変で出力する
    ; FIXME 役職の内訳を表示してもいいかも。
    この中に人狼が1人潜んでいます…。
    [j_introductionCharacters]

  [elsif exp="f.bitingObjectLastNight.result"]
    [playse storage="se/shock1.ogg" buf="2" loop="false" volume="35" sprite_time="50-20000"]
    ; 昨夜の襲撃結果が襲撃成功の場合
    ; キャラを登場させ、メッセージ表示
    [m_changeCharacter characterId="&f.bitingObjectLastNight.targetId" eventFace="被襲撃"]
    [emb exp="f.characterObjects[f.bitingObjectLastNight.targetId].name + 'は無残な姿で発見されました…。'"][p]

    ; 噛まれたということは人狼ではないので、視点オブジェクトを更新する（TODO：人狼以外にも噛まれない役職が増えたら修正する）
    [eval exp="updateCommonPerspective(f.bitingObjectLastNight.targetId, [ROLE_ID_WEREWOLF])"]

    ; キャラを退場させる
    [m_exitCharacter characterId="&f.bitingObjectLastNight.targetId"]

  [else]
    ; 昨夜の襲撃結果が襲撃失敗の場合
    誰も襲われていない、平和な朝でした。[p]

  [endif]

  [playbgm storage="nc282335.ogg" loop="true" volume="10" restart="false"]
  [bg storage="living_day.jpg" time="1000" wait="true" effect="fadeInUp"]
[endmacro]


; 時間を昼から夜に進める
[macro name="j_turnIntoNight"]

  ; PCを退場させる
  [m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]

  ; 夜時間開始時用の初期化を行う
  [eval exp="nightInitialize()"]
  [bg storage="living_night_close.jpg" time="1000" wait="true" effect="fadeInUp"]

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
