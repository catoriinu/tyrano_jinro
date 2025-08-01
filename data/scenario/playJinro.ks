; 人狼ゲームのメインシナリオファイル
; 必ず[j_prepareJinroGame]を実行してから呼び出すこと

*start

[cm  ]
[clearfix]
[start_keyconfig]

[bg storage="living_night_close.jpg" time="500"]
[fadeoutse time="500" buf="1"]
[fadeoutse time="500" buf="2"]
[fadeoutbgm time="500"]

;このゲームで登場するキャラクターを宣言、表情登録
[call storage="./chara/common.ks" target="*registerCharactersFromParticipantsIdList"]

; ステータス、バックログ、メニューボタン表示
[j_displayFixButton status="true" backlog="true" menu="true"]

[playse storage="se/wadaiko_dodon.ogg" buf="2" loop="false" volume="60" sprite_time="50-20000"]
[m_changeFrameWithId]
#
人狼ゲームの幕開けです…！[p]

[w_noticeStartingSituation]

[clearstack]
*day0_nightPhase

; 夜時間開始時に、夜時間中に参照するためのcharacterObjectを複製する。占い、噛みなどの記録は本物のf.characterObjectsに更新していく。
; 初回はオブジェクト型に初期化する
[eval exp="f.characterObjectsHistory = {}"]
[eval exp="f.characterObjectsHistory[f.day] = clone(f.characterObjects)"]

; プレイヤーの役職確認セリフ出力
[m_noticeRole characterId="&f.playerCharacterId" roleId="&f.characterObjects[f.playerCharacterId].role.roleId"]

; 【チャプター再生】
[t_playChapter target="startInstruction"]

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
[playbgm storage="nc282335.ogg" loop="true" volume="10" restart="false"]

; 【チャプター再生】
[t_playChapter target="secondDayDayPhase"]

[m_changeFrameWithId]
#
～COフェイズ～[p]
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

; NPCにCO候補者がいるフラグを初期化する
[eval exp="f.notExistCOCandidateNPC = false"]

; 【チャプター再生】
[t_playChapter target="COPhase"]

*COPhasePlayer
; PC（占い師、人狼、狂人）による占いCOフェイズ
[call storage="./jinroSubroutines.ks" target="*COPhasePlayer"]
; 右側のキャラを退場させる（PCのCO先のキャラが残っているため。退場させないと、CO先のキャラが喋るまでそのままになってしまう）
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]

; COフェイズ終了判定
; f.notExistCOCandidateNPCがtrueなら、COフェイズ終了(NPCにCO候補者がいないため、これ以上COする者はいないとする)
; falseなら、COフェイズ継続(まだNPCにCO候補者がいるので、NPCのCOを確認する)
[jump target="*discussionPhase" cond="f.notExistCOCandidateNPC"]

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
  …沈黙が流れた。これ以上、COしたい者はいないようだ。[p]

  [j_setIsNeedToAskPCWantToCO]
  ; COフェイズ終了(PCはCO確認する必要がない状態のため、これ以上COする者はいないとする)
  [jump target="*discussionPhase" cond="!tf.isNeedToAskPCWantToCO"]
  ; COフェイズ継続(NPCにCO者がいないことを受けて、PCのCOを確認する)
  [jump target="*COPhasePlayer"]

[else]
  ; CO候補者がいるなら、そのキャラクターの行動を開始する
  [eval exp="f.notExistCOCandidateNPC = false"]

  [j_setCanCOFortuneTellerStatus characterId="&f.COCandidateId"]

  [if exp="f.canCOFortuneTellerStatus == 1"]
    ; 占い未COかつ、真占いCOをすると決めた場合
    ; 前日の分までの占い結果を、メッセージなしでCOしたことにする
    [j_COFortuneTellingUntilTheLastDay fortuneTellerId="&f.COCandidateId"]
    ; キャラクターオブジェクトにCOした役職IDを格納する
    [eval exp="f.characterObjects[f.COCandidateId].CORoleId = ROLE_ID_FORTUNE_TELLER"]

  [elsif exp="f.canCOFortuneTellerStatus == 3"]
    ; 占い騙りがまだで、今からCOする場合
    ; 騙り役職オブジェクトを取得し、騙り占いサブルーチンで昨夜までの分を占ってからCOする
    [j_assignmentFakeRole characterId="&f.COCandidateId" roleId="fortuneTeller"]
    [j_fakeFortuneTellingCOMultipleDays fortuneTellerId="&f.COCandidateId"]
    ; キャラクターオブジェクトにCOした役職IDを格納する
    [eval exp="f.characterObjects[f.COCandidateId].CORoleId = ROLE_ID_FORTUNE_TELLER"]

  [elsif exp="f.canCOFortuneTellerStatus == 4"]
    ; 騙り占いCO済みの場合
    ; 騙り占いサブルーチン実行。前日分のみ騙り占い結果を入れる
    [eval exp="tf.fakeFortuneTelledDay = f.day - 1"]
    [j_fakeFortuneTellingCOMultipleDays fortuneTellerId="&f.COCandidateId" fakeFortuneTelledDay="&tf.fakeFortuneTelledDay"]
  [endif]

  ; 指定した占い師のCOを実行する（メッセージは当日分のみ表示）
  [j_COFortuneTelling fortuneTellerId="&f.COCandidateId"]

  ; 初回CO時のみの処理
  ; TODO この処理、j_COFortuneTellingの前に持っていっても問題ないか？
  [if exp="f.canCOFortuneTellerStatus == 1 || f.canCOFortuneTellerStatus == 3"]

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

[m_resetDisplayCharacter]
[m_changeFrameWithId]
#
～議論フェイズ～[p]

; 【チャプター再生】
[t_playChapter target="discussionPhase"]

[eval exp="f.isDoingAction = false"]
; アクションボタン表示
[j_displayFixButton action="true" cond="f.characterObjects[f.playerCharacterId].isAlive"]

*startDiscussionLoop

; アクション実行上限回数以上の場合は議論フェイズを終了する
[jump target="*endDiscussionPhase" cond="f.doActionCount >= sf.j_development.maxDoActionCount"]
[eval exp="f.doActionCount++"]

; NPCのアクション実行者がいるか、いるならアクションとその対象を格納する
[j_decideDoActionByNPC]

*returnFromActionButton
; 現在のラウンド数と次のNPCのアクションを表示する
[m_displayRoundAndNextActionInDiscussionPhase]

; アクション実行（実行者がいなければ何もしない）
[j_doAction]

; 議論フェイズを繰り返す
[jump target="*startDiscussionLoop"]

*endDiscussionPhase
; アクションボタン非表示
[j_clearFixButton action="true"]


; 投票フェイズ
*votePhase
[clearstack]

[m_resetDisplayCharacter]
[m_changeFrameWithId]
#
～投票フェイズ～[p]

; 【チャプター再生】
[t_playChapter target="votePhase"]

; ここはバックログに記録しない。記録する必要がないシステムメッセージのため
[nolog]

[m_changeFrameWithId]
# 
[if exp="f.characterObjects[f.playerCharacterId].isAlive"]
  [m_changeCharacter characterId="&f.playerCharacterId" eventFace="投票" side="left"]
  投票するキャラクターを選択してください。
[else]
  あなたは退場済みなので投票できません。
  [if exp="sf.j_development.dictatorMode"]
    [r]
    が、独裁者モードなので投票できます。
  [endif]
[endif]

[if exp="sf.j_development.dictatorMode"]
  [r]
  独裁者モードのため、プレイヤーの投票先を追放します。
[endif]
[p]

; 再投票時はここに戻ってくる
*returnForRevote

; NOTE: デバッグモードのときのみ、ここでNPCの投票先を決める
; ここで決めると、プレイヤーの投票時にNPCの投票先が見えてしまうが、開発中は見えた方が再投票を起こしやすいのであえてそうしておく
[j_decideVote cond="sf.isDebugMode"]

; プレイヤーの投票をスキップする条件：プレイヤーが退場済み、かつ独裁者モードではない
[jump target="*skipPlayerVote" cond="!f.characterObjects[f.playerCharacterId].isAlive && !sf.j_development.dictatorMode"]

; プレイヤーの投票
; 生存者である、かつプレイヤー以外のキャラクターIDをボタンオブジェクトに格納する
; 開発者用設定：独裁者モードならプレイヤーも投票対象にできるようにする
[j_setCharacterToButtonObjects onlySurvivor="true" needPC="&sf.j_development.dictatorMode"]

; 選択肢ボタン表示と入力受付
[eval exp="tf.doSlideInCharacter = true"]
[call storage="./jinroSubroutines.ks" target="*glinkFromButtonObjects"]

; 右側のキャラを退場させる（PCの投票先のキャラが残っているため。退場させないと、処刑先のキャラが喋るまでそのままになってしまう）
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]

; ボタンで選択した投票先キャラクターIDを、プレイヤーの投票履歴に入れる
[iscript]
  f.characterObjects[f.playerCharacterId].voteHistory[f.day] = pushElement(f.characterObjects[f.playerCharacterId].voteHistory[f.day], f.selectedButtonId);
[endscript]

*skipPlayerVote
; ここまでログを記録しない
[endnolog]

; デバッグモードでないなら、ここでNPCの投票先を決める
[j_decideVote cond="!sf.isDebugMode"]

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
    [jump target="*returnForRevote"]
  [else]
    ; 再投票上限を越えた場合は引き分け処理
    投票で決着がつきませんでした。[p]
    [eval exp="f.winnerFaction = FACTION_DRAW_BY_REVOTE"]
    [jump target="*gameOver"]
  [endif]
[endif]

; 処刑セリフと処刑処理（TODO 今はこの順番だが、処刑ごとの演出がどうなるかによっては逆にしてもいい）
[j_execution characterId="&f.electedIdList[0]"]
[m_executed characterId="&f.electedIdList[0]"]

; 処刑メッセージ
[m_changeFrameWithId]
#
[emb exp="f.characterObjects[f.electedIdList[0]].name + 'は追放されました。'"][p]

; TODO: 処刑後の反応（誰が発言するかを決定するマクロ等が必要）

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

; 【チャプター再生】
[t_playChapter target="firstDayNightPhase"]

[m_changeFrameWithId]
#

; 村人、狂人
[if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_VILLAGER || f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_MADMAN"]
  夜に実行できる役職能力はありません。[p]
[endif]

; 占い師
[if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_FORTUNE_TELLER"]
  [m_changeCharacter characterId="&f.playerCharacterId" face="通常" side="left"]
  [m_askFortuneTellingTarget isFortuneTeller="true"]

  ; 占いカットイン発生
  [j_cutin1]

  ; 占い実行
  [call storage="./fortuneTellingForPC.ks" target="*fortuneTellingForPC"]

  ; 占い結果に合わせてセリフ出力
  [m_announcedFortuneTellingResult]
[endif]

; 人狼かつ今日の襲撃が未実行の場合（NPCが先に襲撃したケースを考慮して一応判定しているが、現状未実行はありえない）
[if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_WEREWOLF && f.isBiteEnd != true"]
  [m_chooseWhoToBite characterId="&f.playerCharacterId"]

  [iscript]
    // 夜時間開始時の生存者である、かつ人狼以外であるキャラクターID配列を選択肢候補変数に格納する。
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

  ; 襲撃実行
  [j_biting biterId="&f.playerCharacterId" characterId="&f.selectedButtonId"]
  [m_exitCharacter characterId="&f.selectedButtonId"]

  ; キャラ画像解放
  [freeimage layer="1" time="400" wait="false"]

  ; 襲撃実行済みフラグを立てる
  [eval exp="f.isBiteEnd = true"]
[endif]


*nightPhaseNPC

; 占い師（真のみ）の占い実行
[j_nightPhaseFortuneTellingForNPC]

; 襲撃未実行なら（＝PCが人狼ではないなら）襲撃実行
[if exp="!f.isBiteEnd"]
  [j_nightPhaseBitingForNPC]
  ; 襲撃されたキャラクターを退場させる（襲撃実行マクロ内でf.targetCharacterIdは格納済み）
  [m_exitCharacter characterId="&f.targetCharacterId"]
[endif]

; 勝敗判定
[j_judgeWinnerFactionAndJump storage="playJinro.ks" target="*gameOver"]

; 勝敗がつかなければ次の日に進む
[jump target="*startDaytime"]


*gameOver
[fadeoutbgm time="1000"]
[j_displayGameOverAndWinnerFaction]

[iscript]
  incrementPlayHistoryCount(f.characterObjects[f.playerCharacterId], f.winnerFaction);
  outputLog();
[endscript]

; 【チャプター再生】
[call storage="theater/episodeSubroutines.ks" target="*checkOutroUnlockCondition"]
[t_playChapter target="outroChapter"]
[t_playChapter target="encourageRetry"]

; タイトル画面に戻る前に、キャラの退場、メッセージ枠の削除、ボタンの削除を行う
[j_clearFixButton]
[m_exitCharacter characterId="&f.displayedCharacter.left.characterId" time="1"]
[m_exitCharacter characterId="&f.displayedCharacter.right.characterId" time="1"]
[layopt layer="message0" visible="false"]
[eval exp="f.currentFrame = null"]

; タイトル画面に戻るときのみ、背景をタイトル画面のものに変えておく
[bg storage="voivojinrou_title_v4.png" time="1" wait="true"]
; 勝利陣営キャラクターのレイヤーを消去する。wait=trueにして人狼ゲーム終了時に責任を持って消しておくこと。wait=falseだと遷移後の画面でfreeimageが発動して意図しない要素が消えてしまう
[freeimage layer="1" time="500" wait="true"]
[jump storage="title.ks"]
[s]
