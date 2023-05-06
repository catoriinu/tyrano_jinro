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

[playse storage="dodon.ogg" loop="false" volume="50" sprite_time="50-20000"]
[m_changeFrameWithId]
#
人狼ゲームの幕開けです……！[p]

; TODO あとで消す。playselistプラグインのテスト用
;[add_playselist storage="megaten.ogg" loop="false" volume="40" sprite_time="" interval="450"]
;[add_playselist storage="kirakira4.ogg" loop="false" volume="40" sprite_time=""]
;[playselist]
;[p]

[clearstack]
*day0_nightPhase

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

; 昼時間開始
*startDaytime
[j_turnIntoDaytime]
[clearstack]
[playbgm storage="nc282335.ogg" loop="true" volume="13" restart="false"]

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
[jump target="*votePhase" cond="f.doActionCount >= sf.j_development.maxDoActionCount"]
[eval exp="f.doActionCount++"]

[m_changeFrameWithId]
#
; TODO 画面上のどこかに常に、あるいはメニュー画面内に表示しておけるとベスト
～ラウンド[emb exp="f.doActionCount"]/[emb exp="sf.j_development.maxDoActionCount"]～[r]
; NPCのアクション実行者がいるか、いるならアクションとその対象を格納する
[j_decideDoActionByNPC]

; ここはバックログに記録しない。プレイヤーがアクション実行すると、実際にはアクションしなかったことになる可能性があるため
[nolog]

  [if exp="f.doActionCandidateId != ''"]
  ～[emb exp="f.characterObjects[f.npcActionObject.characterId].name"]が話そうとしています
    ; 開発者用設定：独裁者モードなら、アクション実行者のアクション内容をメッセージに表示する
    [if exp="sf.j_development.dictatorMode"]
      [iscript]
        tf.tmpDoActionMessage = ((f.npcActionObject.actionId == ACTION_TRUST) ? '信じる' : (f.npcActionObject.actionId == ACTION_SUSPECT) ? '疑う' : '？');
      [endscript]
      （[emb exp="f.characterObjects[f.npcActionObject.targetId].name"]に[emb exp="tf.tmpDoActionMessage"]）
    [endif]
  [else]
  ～誰も話そうとしていないようです
  [endif]
  ～[p]

; ここまでログを記録しない
[endnolog]

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
; NPCの投票先を決める
[j_decideVote]

; ここはバックログに記録しない。記録する必要がないシステムメッセージのため
[nolog]

[if exp="!f.characterObjects[f.playerCharacterId].isAlive"]
  プレイヤーが退場済みなので投票できません。[l][r]
  [jump target="*skipPlayerVote" cond="!sf.j_development.dictatorMode"]
  が、独裁者モードなので投票できます。[p]
[endif]

; プレイヤーの投票先を決める
[m_changeFrameWithId]
# 
投票するキャラクターを選択してください。
[eval exp="tf.needPC = false"]

[if exp="sf.j_development.dictatorMode"]
  [r]
  独裁者モードのため、プレイヤーの投票先を追放します。
  [eval exp="tf.needPC = true"]
[endif]
[p]

; 生存者である、かつプレイヤー以外のキャラクターIDをボタンオブジェクトに格納する
; 開発者用設定：独裁者モードならプレイヤーも投票対象にできるようにする
[j_setCharacterToButtonObjects onlySurvivor="true" needPC="&tf.needPC"]

; メニューボタン非表示
[j_clearFixButton menu="true"]

; 選択肢ボタン表示と入力受付
[eval exp="tf.doSlideInCharacter = true"]
[call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

; NPCを退場させる（PCの投票先、または（PCが投票していない場合）直前に発言したキャラが残っているため。退場させないと、処刑先のキャラが喋るまでそのままになってしまう）
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]

; ボタンで選択した投票先キャラクターIDを、プレイヤーの投票履歴に入れる
[iscript]
  f.characterObjects[f.playerCharacterId].voteHistory[f.day] = pushElement(f.characterObjects[f.playerCharacterId].voteHistory[f.day], f.selectedButtonId);
[endscript]

*skipPlayerVote
; ここまでログを記録しない
[endnolog]

; 票を集計する
[j_countVote]

; 票を公開する
[j_openVote]

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
    [eval exp="tf.winnerFaction = FACTION_DRAW_BY_REVOTE"]
    [jump target="*gameOver"]
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
[j_judgeWinnerFactionAndJump storage="playJinro.ks" target="*gameOver"]


; 夜時間開始
*nightPhase
[j_turnIntoNight]
[clearstack]

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
  [m_exitCharacter characterId="&f.targetCharacterId"]
[endif]

; 勝敗判定
[j_judgeWinnerFactionAndJump storage="playJinro.ks" target="*gameOver"]

; 勝敗がつかなければ次の日に進む
[jump target="*startDaytime"]


*gameOver
[fadeoutbgm time="1000"]
[m_displayGameOverAndWinnerFaction winnerFaction="&tf.winnerFaction"]

[m_changeFrameWithId]
#
おわり。[p]

[j_displayRoles]
タイトルに戻ります。[p]

; タイトル画面に戻る前に、キャラの退場、メッセージ枠の削除、ボタンの削除を行う
[j_clearFixButton]
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
[layopt layer="message0" visible="false"]
[jump storage="title.ks"]
[s]
