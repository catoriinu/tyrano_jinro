; 人狼ゲームのメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]


[bg storage="living_night_close_nc238328.jpg" time="300"]

;メッセージウィンドウの設定、文字が表示される領域を調整
[position layer="message0" left="53" top="484" width="1174" height="235" margint="65" marginl="75" marginr="80" marginb="65" opacity="210" page="fore"]

;メッセージウィンドウの表示
[layopt layer="message0" visible="true"]

;キャラクターの名前が表示される文字領域
[ptext name="chara_name_area" layer="message0" face="にくまるフォント" color="0x28332a" size=36 x=175 y=505]

;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
[chara_config ptext="chara_name_area"]
; pos_mode:キャラの初期位置はキャラ宣言時に全指定するのでfalse
[chara_config pos_mode="false" memory="true" time="200"]

;このゲームで登場する全キャラクターを宣言、表情登録
[call storage="./chara/common.ks" target="*registerAllCharacters"]

; ゲーム準備js読み込み
[loadjs storage="plugin/jinro/macro/prepareGame.js"]

; ステータス、メニューボタン表示
[j_displayFixButton status="true" menu="true"]

[m_changeFrameWithId]
#
人狼ゲームの幕開けです……！[p]

*day0_nightPhase
[clearstack]

; 夜時間開始時に、夜時間中に参照するためのcharacterObjectを複製する。占い、噛みなどの記録は本物のf.characterObjectsに更新していく。
; 初回はオブジェクト型に初期化する
[eval exp="f.characterObjectsHistory = {}"]
[eval exp="f.characterObjectsHistory[f.day] = clone(f.characterObjects)"]

; プレイヤーの役職確認セリフ出力
[m_noticeRole characterId="&f.playerCharacterId" roleId="&f.characterObjects[f.playerCharacterId].role.roleId"]

; 占い師なら初日占い実行
[if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_FORTUNE_TELLER"]

  ; 占いカットイン発生
  [j_cutin1]

  ; 占い実行
  [call storage="./fortuneTellingForPC.ks" target="*fortuneTellingForPC"]

  ; 占い結果に合わせてセリフ出力
  [m_announcedFortuneTellingResult]

  ; 占いカットイン解放
  ;[freeimage layer="1" time=400 wait="false"]

[endif]

; 初日夜のNPCの行動。占い師のみ行動する。
[j_nightPhaseFortuneTellingForNPC]

*startDaytime
[clearstack]
#
[eval exp="timePasses()"]
[bg storage="living_day_nc238325.jpg" time="500"]
[m_timePasses isDaytime="&f.isDaytime"]


[m_changeFrameWithId]
#
～COフェイズ～[p]
; [button name="action" fix="true" graphic="button/action_leave.png" enterimg="button/action_enter.png" x=50 y=220 storage="action.ks" target="*start" auto_next="false"]
; [button name="j_button" fix="true" hint="ほげ" x=300 y=220 storage="action.ks" target="*start" auto_next="false"]
; ミニストップ[p]

; 1) PCからCOがあるか確認する。
;    CO確認する必要なし                  →選択肢表示せず、2)へ
;    COする                             →CO実行。その後2)へ
;    COしない && 初回のため2)が未確認    →2)へ
;    COしない && 2)でCO候補者がいた      →2)へ
;    COしない && 2)でCO候補者がいなかった→COフェイズ終了
; 2) NPCにCO候補者がいるか確認する。
;    CO候補者がいた→CO実行（複数いた場合probabilityが最も高い1人のみCO実行）。その後CO候補者がいなくなるまで2)を繰り返す
;    CO候補者がいない && 1)でCO確認する必要なし→COフェイズ終了
;    CO候補者がいない && 1)でPCがCOしなかった  →1)へ

*COPhasePlayer

; PCがCOしたいかを確認する必要があるか。必要がなければジャンプ
[j_setIsNeedToAskPCWantToCO]
[jump target="*COPhaseNPC" cond="!tf.isNeedToAskPCWantToCO"]

  ; 占い師COすることができる役職・CO状態であれば。COできなければジャンプ
  [j_setCanCOFortuneTellerStatus characterId="&f.playerCharacterId"]
  [jump target="*noCO" cond="tf.canCOFortuneTellerStatus == 0"]

    [m_askFortuneTellerCO canCOFortuneTellerStatus="&tf.canCOFortuneTellerStatus"]

    ; メニューボタン非表示
    [j_clearFixButton menu="true"]

    ; COするしないボタン表示
    [iscript]
      f.buttonObjects = [];
      f.buttonObjects.push(new Button(
        'FortuneTellerCO',
        '占いCOする',
        'center',
        CLASS_GLINK_DEFAULT
      ));
      f.buttonObjects.push(new Button(
        'noCO',
        '何もしない',
        'center',
        CLASS_GLINK_DEFAULT
      ));
    [endscript]
    [call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

    ; メニューボタン再表示
    [j_displayFixButton menu="true"]

    ; 「何もしない」ならジャンプする
    [jump target="*noCO" cond="f.selectedButtonId == 'noCO'"]
    ; 「占いCOする」ならジャンプ……しなくてもすぐ下なので何もしない。COできる役職が増えたら増やす
    ; [jump target="*FortuneTellerCO" cond="f.selectedButtonId == 'FortuneTellerCO'"]
    *FortuneTellerCO

    [if exp="tf.canCOFortuneTellerStatus == 1"]
      ; 占い未COかつ、真占いCOをすると決めた場合
      ; 前日の分までの占い結果を、メッセージなしでCOしたことにする
      [j_COFortuneTellingUntilTheLastDay fortuneTellerId="&f.playerCharacterId"]

    [elsif exp="tf.canCOFortuneTellerStatus == 3"]
      ; 占い未COかつ、占い騙りをすると決めた場合
      ; 騙り役職オブジェクトを取得する
      [j_assignmentFakeRole characterId="&f.characterObjects[f.playerCharacterId].characterId" roleId="fortuneTeller"]
      ; 騙り占いサブルーチン実行。初日から騙り占い結果を入れていく(f.fakeFortuneTelledDayはデフォルトのままでよい)
      [call storage="./fortuneTellingForPC.ks" target="*fakeFortuneTellingCOMultipleDaysForPC"]

    [elsif exp="tf.canCOFortuneTellerStatus == 4"]
      ; 騙り占いCO済みの場合
      ; 騙り占いサブルーチン実行。前日分のみ騙り占い結果を入れる
      [eval exp="f.fakeFortuneTelledDay = f.day - 1"]
      [call storage="./fortuneTellingForPC.ks" target="*fakeFortuneTellingCOMultipleDaysForPC"]
    [endif]

    ; 占いカットイン発生
    [j_cutin1]

    ; 指定した占い師のCOを実行する（メッセージは当日分のみ表示）
    [j_COFortuneTelling fortuneTellerId="&f.playerCharacterId"]

    ; 初回CO時のみの処理
    [if exp="tf.canCOFortuneTellerStatus == 1 || tf.canCOFortuneTellerStatus == 3"]
      ; キャラクターオブジェクトにCOした役職IDを格納する
      [eval exp="f.characterObjects[f.playerCharacterId].CORoleId = ROLE_ID_FORTUNE_TELLER"]

      ; 共通および各キャラの視点オブジェクトを更新する
      [j_cloneRolePerspectiveForCO characterId="&f.characterObjects[f.playerCharacterId].characterId" CORoleId="fortuneTeller"]
      [eval exp="tf.tmpZeroRoleIds = [ROLE_ID_VILLAGER]"]
      [j_updateCommonPerspective characterId="&f.characterObjects[f.playerCharacterId].characterId" zeroRoleIds="&tf.tmpZeroRoleIds"]
    [endif]
    [jump target="*COPhaseNPC"]

  ; COなし
  *noCO

  ; f.notExistCOCandidateNPCがtrueなら、COフェイズ終了(NPCにCO候補者がいないため、これ以上COする者はいないとする)
  [jump target="*discussionPhase" cond="f.notExistCOCandidateNPC"]
  ; f.notExistCOCandidateNPCがfalseなら、COフェイズ継続(まだNPCにCO候補者がいるので、NPCのCOを確認する)

*COPhaseNPC
; NPC（占い師、人狼、狂人）による占いCOフェイズ

; 初回だけ取得する
; NOTE:f.surviveNpcCharacterIdsはCO結果を受けてのパラメータ変動時などに使う想定でいるが、なるべくcharacterObjectsだけで運用できるよう心がけていく。
; f.surviveNpcCharacterIdsは議論フェイズにも使える。というか、ただ判定に使うだけなので、j_decideCOCandidateIdの中で判定するだけにしておいた方がよさそう。
; どうせ「パラメータ変動時」と言っても、変動させるのはcharacterObjectsの方なので。
[if exp="!f.gottenSurviveNpcCharacterIds"]
  [iscript]
    ; 生存者である、かつプレイヤー以外のキャラクターID配列を抽出する。
    f.surviveNpcCharacterIds = getValuesFromObjectArray(
      getCharacterObjectsFromCharacterIds(
        getSurvivorObjects(f.characterObjects),
        [f.playerCharacterId],
        false
      ),
      'characterId'
    );
  [endscript]
  [eval exp="f.gottenSurviveNpcCharacterIds = true"]
[endif]

; CO候補者を決定し、f.COCandidateIdに格納する
[j_decideCOCandidateId characterIds="&f.surviveNpcCharacterIds"]

; f.COCandidateIdが空（＝CO候補者がいない）なら、
[if exp="f.COCandidateId == ''"]
  ; NPCのCO候補者がいないフラグをtrueにする
  [eval exp="f.notExistCOCandidateNPC = true"]
  [m_changeFrameWithId]
  #
  ……沈黙が流れた。これ以上、COしたい者はいないようだ。[p]

  [j_setIsNeedToAskPCWantToCO]
  [if exp="!tf.isNeedToAskPCWantToCO"]
    ; COフェイズ終了(PCはco確認する必要がない状態のため、これ以上COする者はいないとする)
    [jump target="*discussionPhase"]
  [else]
    ; COフェイズ継続(NPCにCO者がいないことを受けて、PCのCOを確認する)
    [jump target="*COPhasePlayer"]
  [endif]

[else]
  ; CO候補者がいるなら、そのキャラクターの行動を開始する
  [eval exp="f.notExistCOCandidateNPC = false"]

  [j_setCanCOFortuneTellerStatus characterId="&f.COCandidateId"]

  [if exp="tf.canCOFortuneTellerStatus == 1"]
    ; 占い未COかつ、真占いCOをすると決めた場合
    ; 前日の分までの占い結果を、メッセージなしでCOしたことにする
    [j_COFortuneTellingUntilTheLastDay fortuneTellerId="&f.COCandidateId"]

  [elsif exp="tf.canCOFortuneTellerStatus == 3"]
    ; 占い騙りがまだで、今からCOする場合
    ; 騙り役職オブジェクトを取得し、騙り占いサブルーチンで昨夜までの分を占ってからCOする
    [j_assignmentFakeRole characterId="&f.COCandidateId" roleId="fortuneTeller"]
    [j_fakeFortuneTellingCOMultipleDays fortuneTellerId="&f.COCandidateId"]

  [elsif exp="tf.canCOFortuneTellerStatus == 4"]
    ; 騙り占いCO済みの場合
    ; 騙り占いサブルーチン実行。前日分のみ騙り占い結果を入れる
    [eval exp="tf.fakeFortuneTelledDay = f.day - 1"]
    [j_fakeFortuneTellingCOMultipleDays fortuneTellerId="&f.COCandidateId" fakeFortuneTelledDay="&tf.fakeFortuneTelledDay"]
  [endif]

  ; 占いカットイン発生
  [j_cutin1]

  ; 指定した占い師のCOを実行する（メッセージは当日分のみ表示）
  [j_COFortuneTelling fortuneTellerId="&f.COCandidateId"]

  ; 初回CO時のみの処理
  [if exp="tf.canCOFortuneTellerStatus == 1 || tf.canCOFortuneTellerStatus == 3"]
    ; キャラクターオブジェクトにCOした役職IDを格納する
    [eval exp="f.characterObjects[f.COCandidateId].CORoleId = ROLE_ID_FORTUNE_TELLER"]

    ; 共通および各キャラの視点オブジェクトを更新する
    [j_cloneRolePerspectiveForCO characterId="&f.COCandidateId" CORoleId="fortuneTeller"]
    [eval exp="tf.tmpZeroRoleIds = [ROLE_ID_VILLAGER]"]
    [j_updateCommonPerspective characterId="&f.COCandidateId" zeroRoleIds="&tf.tmpZeroRoleIds"]
  [endif]
; TODO 占い結果を聞いて、各キャラのrolePerspectiveで真偽をつける

; NPCのCOが終了したら、他のNPCのCOを確認しに戻る
; ※NPCのCOが1人終わるごとにPCにCO有無を確認しに戻るのはPCの操作が面倒になるはず。
; CO順を理解できるAIが実装できるようになるまでは、NPCのCOはまとめて行ってしまうようにする。
; もし毎回PCにCO有無を確認しに戻るようにしたい場合は、[jump target="*COPhasePlayer"]にする。
  [jump target="*COPhaseNPC"]
[endif]


*discussionPhase
[clearstack]

; アクションボタン表示
[j_displayFixButton action="true"]

[m_changeFrameWithId]
#
～議論フェイズ～[p]
*startDiscussionLoop

; アクション実行上限回数以上の場合は議論フェイズを終了する
[jump target="*votePhase" cond="f.doActionCount >= MAX_DO_ACTION_COUNT"]
[eval exp="f.doActionCount++"]

[m_changeFrameWithId]
#
; TODO 画面上のどこかに常に、あるいはメニュー画面内に表示しておけるとベスト
～ラウンド[emb exp="f.doActionCount"]/[emb exp="MAX_DO_ACTION_COUNT"]～[r]
; NPCのアクション実行者がいるか、いるならアクションとその対象を格納する
[j_decideDoActionByNPC]
[if exp="f.doActionCandidateId != ''"]
～[emb exp="f.characterObjects[f.doActionCandidateId].name"]が話そうとしています～[p]
[else]
～誰も話そうとしていないようです～[p]
[endif]

; アクション実行
[j_setDoActionObject]
[if exp="Object.keys(f.doActionObject).length > 0"]
  [j_doAction actionObject="&f.doActionObject"]
[endif]

; 議論フェイズを繰り返す
[jump target="*startDiscussionLoop"]

*votePhase
[clearstack]

; アクションボタン非表示
[j_clearFixButton action="true"]

[m_changeFrameWithId]
#
～投票フェイズ～[p]

; 投票フェイズ
; TODO:前日の投票フェーズや、同日の再投票時に入ってしまった不要な変数を初期化する（多分ありそう）

; NPCの投票先を決める
[j_decideVote]

[if exp="!f.characterObjects[f.playerCharacterId].isAlive"]
  プレイヤーが死亡済みなので投票できません。[r]
  [jump target="*skipPlayerVote" cond="!f.developmentMode"]
  が、開発用モードなので投票できます。[p]
[endif]

; プレイヤーの投票先を決める
[m_changeFrameWithId]
# 
投票するキャラクターを選択してください。
[if exp="f.developmentMode"]
[r]
開発モードのため、プレイヤーの投票先を処刑します。
[endif]
[p]

; 生存者である、かつプレイヤー以外のキャラクターIDをボタンオブジェクトに格納する。
; [j_setCharacterToButtonObjects onlySurvivor="true"]
; TODO ……のが正しいが、テスト用に生存者全員を投票対象にしておく。
[j_setCharacterToButtonObjects onlySurvivor="true" needPC="true"]

; メニューボタン非表示
[j_clearFixButton menu="true"]

; 選択肢ボタン表示と入力受付
[eval exp="tf.doSlideInCharacter = true"]
[call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

; キャラ画像解放
[freeimage layer="1" time="400" wait="false"]

; ボタンで選択した投票先キャラクターIDを、プレイヤーの投票履歴に入れる
[iscript]
  f.characterObjects[f.playerCharacterId].voteHistory[f.day] = pushElement(f.characterObjects[f.playerCharacterId].voteHistory[f.day], f.selectedButtonId);
[endscript]

*skipPlayerVote

; 票を集計する
[j_countVote]

; 票を公開する
[j_openVote]

[if exp="!f.developmentMode"]
  [if exp="!f.doExecute"]
    [eval exp="f.revoteCount += 1"]
    ; 再投票上限回数未満であれば再投票する
    [if exp="f.revoteCount < MAX_REVOTE_COUNT"]
      再投票です。[r]
      あと[emb exp="MAX_REVOTE_COUNT - f.revoteCount"]回で決着しない場合は引き分けです。[p]
      [jump target="*votePhase"]
    [else]
      ; 再投票上限を越えた場合は引き分け処理
      投票で決着がつきませんでした。[p]
      [eval exp="tf.winnerCamp = CAMP_DRAW_BY_REVOTE"]
      [jump target="*gameOver"]
    [endif]
  [endif]
[endif]

; 処刑セリフと処刑処理（TODO 今はこの順番だが、処刑ごとの演出がどうなるかによっては逆にしてもいい）
[m_executed characterId="&f.electedIdList[0]"]
[j_execution characterId="&f.electedIdList[0]"]

; 処刑後の反応（TODO 誰が発言するかを決定するマクロ等が必要）
[if exp="f.characterObjects.ai.isAlive"]
  [m_afterExecution characterId="ai"]
[elsif exp="f.characterObjects.hiyori.isAlive"]
  [m_afterExecution characterId="hiyori"]
[endif]


; 勝敗判定
[j_judgeWinnerCampAndJump storage="playJinro.ks" target="*gameOver"]


; 夜時間開始
*nightPhase
[clearstack]

[eval exp="timePasses()"]
[bg storage="living_night_close_nc238328.jpg" time="300"]
[m_timePasses isDaytime="&f.isDaytime"]


; 夜時間開始時に、夜時間中に生存しているかを参照するためのcharacterObjectを複製する。占い、噛みなどの記録は本物のf.characterObjectsに更新していく。
[eval exp="f.characterObjectsHistory[f.day] = clone(f.characterObjects)"]


; プレイヤーの行動（夜時間オブジェクトを参照）
; MEMO: *nightPhaseNPCまでの区間を[if]で囲っていると、「人狼で、初日占いCOしており、直前で騙り占いをしている」場合に「人狼の場合のみ」ルートを通らなくなった。おそらく[if]の使いすぎによるスタック溢れでおかしくなった感じ。
; ここを[jump]に変えたら解決した。今後ももし起きたら、[if]を[jump]に置換可能か検討すること
; なお、この問題は[clearstack]では解決しなかったが、おまじないとして各フェイズの最初に追加しておく。
[jump target="*nightPhaseNPC" cond="!f.characterObjectsHistory[f.day][f.playerCharacterId].isAlive"]

[m_changeFrameWithId]
#
プレイヤーの行動です。[p]

; 村人
[if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_VILLAGER"]
  村人なので行動できません。[p]
[endif]

; 真占い師であれば
[j_setCanCOFortuneTellerStatus characterId="&f.playerCharacterId"]
[if exp="tf.canCOFortuneTellerStatus == 1 || tf.canCOFortuneTellerStatus == 2"]

  [m_askFortuneTellingTarget isFortuneTeller="true"]

  ; 占いカットイン発生
  [j_cutin1]

  ; 占い実行
  [call storage="./fortuneTellingForPC.ks" target="*fortuneTellingForPC"]

  ; 占い結果に合わせてセリフ出力
  [m_announcedFortuneTellingResult]

[endif]

; 人狼の場合のみ
[if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_WEREWOLF"]

  [if exp="f.isBiteEnd != true"]

    ; メニューボタン非表示
    [j_clearFixButton menu="true"]

    [m_chooseWhoToBite characterId="&f.playerCharacterId"]

    [iscript]
      ; 夜時間開始時の生存者である、かつ人狼以外であるキャラクターID配列を選択肢候補変数に格納する。
      tf.candidateCharacterIds = getValuesFromObjectArray(
        getIsWerewolvesObjects(
          getSurvivorObjects(f.characterObjectsHistory[f.day]),
          false
        ),
        'characterId'
      );
    [endscript]

    ; 選択肢ボタン表示と入力受付
    [j_setCharacterToButtonObjects characterIds="&tf.candidateCharacterIds"]
    [eval exp="tf.doSlideInCharacter = true"]
    [call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

    ; メニューボタン再表示
    [j_displayFixButton menu="true"]

    ; 噛み実行
    [j_biting biterId="&f.playerCharacterId" characterId="&f.selectedButtonId"]
    [m_exitCharacter characterId="&f.selectedButtonId"]

    ; キャラ画像解放
    [freeimage layer="1" time="400" wait="false"]

    ; 噛み実行済みフラグを立てる
    [eval exp="f.isBiteEnd = true"]
  [endif]
[endif]

*nightPhaseNPC
[m_changeFrameWithId]
#
NPCが行動しています……[p]

; 占い師（真のみ）の占い実行
[j_nightPhaseFortuneTellingForNPC]

; 噛み未実行なら（＝PCが人狼ではないなら）噛み実行
[if exp="!f.isBiteEnd"]
  [j_nightPhaseBitingForNPC]
  ; 噛まれたキャラクターを退場させる（噛み実行マクロ内でf.targetCharacterIdは格納済み）
  ; MEMO「右側に表示中のキャラが再度発言する際、enterCharacter()で更に左へ移動するケースがある」バグの原因だったとおもわれる。
  ; NPCが襲撃するタイミングでは、PCの占い対象キャラが表示されている場合がある。
  ; そこでNPCが襲撃実行し、「噛まれたキャラクターの」退場処理を行うと、PCの占い対象キャラが表示されたまま、f.rightSideCharacterId=undefinedに初期化されてしまう
  ; そこで翌朝最初に表示中の「PCの占い対象キャラが」発言すると、おかしなenterをしてしまう。
  ; →exitCharagter()内で「現在登場していないなら初期化しないで終了」するようにした。
  ; TODO f.displayPositionオブジェクトを作り、キャラクターの表示状態を一元管理したい。
  [m_exitCharacter characterId="&f.targetCharacterId"]
[endif]

; 勝敗判定
[j_judgeWinnerCampAndJump storage="playJinro.ks" target="*gameOver"]

[bg storage="living_day_nc238325.jpg" time="100"]
[jump target="*startDaytime"]


*gameOver
[m_displayGameOverAndWinnerCamp winnerCamp="&tf.winnerCamp"]

[m_changeFrameWithId]
#
おわり。[p]

[j_displayRoles]
;タイトルに戻ります。[p]
; [j_saveJson]

; TODO タイトル画面または戻る前に、キャラの退場、メッセージ枠の削除、ボタンの削除など必要。
;[jump storage="title.ks"]
[s]
