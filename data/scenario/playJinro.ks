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

; アクション、ステータス、メニューボタン表示
; TODO 表示（＝プレイヤーに操作させてよい）タイミングは後々考える。それ以外は非表示にする。
[button graphic="button/button_action_normal.png" storage="action.ks" target="*start" x="33" y="25" width="114" height="103" fix="true" role="sleepgame" enterimg="button/button_action_hover.png" clickimg="button/button_action_click.png"]
[button graphic="button/button_menu_normal.png" x="1133" y="25" width="114" height="103" fix="true" role="menu" enterimg="button/button_menu_hover.png" clickimg="button/button_menu_click.png"]
[button graphic="button/button_status_normal.png" storage="menuJinro.ks" target="*menuJinroMain" x="985" y="25" width="114" height="103" fix="true" role="sleepgame" enterimg="button/button_status_hover.png" clickimg="button/button_status_click.png"]

[m_changeFrameWithId]
#
人狼ゲームの幕開けです……！[p]

*day0_nightPhase

; 夜時間開始時に、夜時間中に参照するためのcharacterObjectを複製する。占い、噛みなどの記録は本物のf.characterObjectsに更新していく。
; 初回はオブジェクト型に初期化する
[eval exp="f.characterObjectsHistory = {}"]
[eval exp="f.characterObjectsHistory[f.day] = clone(f.characterObjects)"]


; キャラの登場と退場のテスト
;[m_changeCharacter characterId="zundamon" face="normal"]
;[m_changeFrameWithId characterId="zundamon"]
;# ずんだもん
;めたんー[p]
;
;[m_changeCharacter characterId="metan" face="normal"]
;[m_changeFrameWithId characterId="metan"]
;# 四国めたん
;何よ？[p]
;
;[m_changeCharacter characterId="zundamon" face="normal"]
;[m_changeFrameWithId characterId="zundamon"]
;# ずんだもん
;つむぎー[p]
;
;[m_changeCharacter characterId="tsumugi" face="normal"]
;[m_changeFrameWithId characterId="tsumugi"]
;# 春日部つむぎ
;はーい[p]
;
;[m_changeCharacter characterId="zundamon" face="normal"]
;[m_changeFrameWithId characterId="zundamon"]
;# ずんだもん
;はうー、りつー、そしてつむぎ！[p]
;
;[m_changeCharacter characterId="hau" face="normal"]
;[m_changeFrameWithId characterId="hau"]
;# 雨晴はう
;ニンニクマシマシ！[p]
;
;[m_changeCharacter characterId="ritsu" face="normal"]
;[m_changeFrameWithId characterId="hau"]
;# 波音リツ
;大きなイチモツ！[p]
;
;[m_changeCharacter characterId="tsumugi" face="normal"]
;[m_changeFrameWithId characterId="tsumugi"]
;# 春日部つむぎ
;めがまわるー[p]

; プレイヤーの役職確認セリフ出力
[m_noticeRole characterId="&f.playerCharacterId" roleId="&f.characterObjects[f.playerCharacterId].role.roleId"]

; 占い師なら初日占い実行
[if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_FORTUNE_TELLER"]

  ; 占いカットイン発生
  [j_cutin1]

  ; 占い実行
  [call storage="./fortuneTellingForPC.ks" target="*fortuneTellingForPC"]

  ; 占い結果に合わせてセリフ出力
  [m_announcedFortuneTellingResult characterId="&f.playerCharacterId" result="&tf.todayResultObject.result"]

  ; 占いカットイン解放
  ;[freeimage layer="1" time=400 wait="false"]

[endif]

; 初日夜のNPCの行動。占い師のみ行動する。
[j_nightPhaseFortuneTellingForNPC]

*startDaytime
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

[j_setIsNeedToAskPCWantToCO]
[if exp="tf.isNeedToAskPCWantToCO"]

  ; 占い師COすることができる役職・CO状態であれば
  [j_setCanCOFortuneTellerStatus characterId="&f.playerCharacterId"]
  [if exp="tf.canCOFortuneTellerStatus > 0"]

    [m_askFortuneTellerCO canCOFortuneTellerStatus="&tf.canCOFortuneTellerStatus"]

    ; COするしないボタン表示
    [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (0 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
    [glink color="blue" storage="playJinro.ks" size="28" x="360" width="500" y="&tf.y" text="占いCOする" target="*FortuneTellerCO"]
    [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (1 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
    [glink color="blue" storage="playJinro.ks" size="28" x="360" width="500" y="&tf.y" text="何もしない" target="*noCO"]
    [s]

    *FortuneTellerCO

    ; 占い未COかつ、占い騙りをすると決めた場合、騙り役職オブジェクトを取得する
    [if exp="tf.canCOFortuneTellerStatus == 3"]
      [j_assignmentFakeRole characterId="&f.characterObjects[f.playerCharacterId].characterId" roleId="fortuneTeller"]
      ; 前日までの分、騙り占い実行
      [call storage="./fortuneTellingForPC.ks" target="*fakeFortuneTellingCOMultipleDaysForPC"]
    [endif]

    ; 占いカットイン発生
    [j_cutin1]

    ; 指定した占い師の最新の占い履歴オブジェクトをtf.fortuneTellingHistoryObjectに格納する
    [j_fortuneTellingHistoryObjectThatDay fortuneTellerId="&f.playerCharacterId"]
  
    ; ホバー時用の画像を画面外からスライドインさせる TODO ボタンごとにキャラに合わせた画像を表示する
    ;[image layer="1" x="1280" y="80" visible="true" storage="01_sad.png" name="01"]
    ;[anim name="01" left=850 time=350]

    [m_COFortuneTellingResult characterId="&f.playerCharacterId" result="&tf.fortuneTellingHistoryObject.result"]

    ; 占いカットイン解放
    ;[freeimage layer="1" time=400 wait="false"]

    [eval exp="f.characterObjects[f.playerCharacterId].isDoneTodaysCO = true"]

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
  [endif]

  ; COなし
  *noCO

  [if exp="f.notExistCOCandidateNPC"]
    ; COフェイズ終了(NPCにCO候補者がいないため、これ以上COする者はいないとする)
    [jump target="*discussionPhase"]
  [else]
    ; COフェイズ継続(まだNPCにCO候補者がいるので、NPCのCOを確認する)
    [jump target="*COPhaseNPC"]
  [endif]

[endif]


*COPhaseNPC
; NPC（占い師、人狼、狂人）による占いCOフェイズ

; 初回だけ取得する
; NOTE:f.surviveNpcCharacterIdsはCO結果を受けてのパラメータ変動時などに使う想定でいるが、なるべくcharacterObjectsだけで運用できるよう心がけていく。
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

; CO候補者を決定し、tf.COCandidateIdに格納する
[j_decideCOCandidateId characterIds=&f.surviveNpcCharacterIds]

; tf.COCandidateIdが空（＝CO候補者がいない）なら、
[if exp="tf.COCandidateId == ''"]
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

  ; 占い騙りがまだなら、騙り役職オブジェクトを取得し、昨夜までの分を占ってからCOする
  [j_setCanCOFortuneTellerStatus characterId="&tf.COCandidateId"]
  [if exp="tf.canCOFortuneTellerStatus == 3"]
    [j_assignmentFakeRole characterId="&tf.COCandidateId" roleId="fortuneTeller"]
    [j_fakeFortuneTellingCOMultipleDays fortuneTellerId="&tf.COCandidateId"]
  [endif]

  ; 占いカットイン発生
  [j_cutin1]

  ; 指定した占い師の最新の占い履歴オブジェクトをtf.fortuneTellingHistoryObjectに格納する
  [j_fortuneTellingHistoryObjectThatDay fortuneTellerId="&tf.COCandidateId"]
  
  ; ホバー時用の画像を画面外からスライドインさせる TODO ボタンごとにキャラに合わせた画像を表示する
  ;[image layer="1" x="1280" y="80" visible="true" storage="01_sad.png" name="01"]
  ;[anim name="01" left=850 time=350]

  [m_COFortuneTellingResult characterId="&tf.COCandidateId" result="&tf.fortuneTellingHistoryObject.result"]

  ; 占いカットイン解放
  [freeimage layer="1" time=400 wait="false"]

  ; TODO: どのように、前のCO内容を次のCOの確率に影響させるか？　今日のCO内容をどこかの配列に保存しておく必要がありそう？

  ; 今日のCOが終わったキャラはisDoneTodaysCOをtrueにする
  [eval exp="f.characterObjects[tf.COCandidateId].isDoneTodaysCO = true"]

  ; 初回CO時のみの処理
  [if exp="tf.canCOFortuneTellerStatus == 1 || tf.canCOFortuneTellerStatus == 3"]
    ; キャラクターオブジェクトにCOした役職IDを格納する
    [eval exp="f.characterObjects[tf.COCandidateId].CORoleId = ROLE_ID_FORTUNE_TELLER"]

    ; 共通および各キャラの視点オブジェクトを更新する
    [j_cloneRolePerspectiveForCO characterId="&tf.COCandidateId" CORoleId="fortuneTeller"]
    [eval exp="tf.tmpZeroRoleIds = [ROLE_ID_VILLAGER]"]
    [j_updateCommonPerspective characterId="&tf.COCandidateId" zeroRoleIds="&tf.tmpZeroRoleIds"]
  [endif]
; TODO 占い結果を聞いて、各キャラのrolePerspectiveで真偽をつける

; NPCのCOが終了したら、他のNPCのCOを確認しに戻る
; ※NPCのCOが1人終わるごとにPCにCO有無を確認しに戻るのはPCの操作が面倒になるはず。
; CO順を理解できるAIが実装できるようになるまでは、NPCのCOはまとめて行ってしまうようにする。
; もし毎回PCにCO有無を確認しに戻るようにしたい場合は、[jump target="*COPhasePlayer"]にする。
  [jump target="*COPhaseNPC"]
[endif]



*discussionPhase
[m_changeFrameWithId]
#
～議論フェイズは未作成～[p]

*votePhase
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
[if exp="f.developmentMode"]
開発モードのため、プレイヤーの投票先を処刑します。[r]
[endif]
投票するキャラクターを選択してください。[p]

[iscript]
  ; 生存者である、かつプレイヤー以外のキャラクターオブジェクトを選択肢候補変数に格納する。
  tf.candidateCharacterObjects = getCharacterObjectsFromCharacterIds(
    getSurvivorObjects(f.characterObjects),
    [f.playerCharacterId],
    false
  );

  ; TODO ……のが正しいが、テスト用に生存者全員を投票対象にしておく。
  tf.candidateCharacterObjects = getSurvivorObjects(f.characterObjects);
[endscript]

; 選択肢ボタン表示と入力受付
[call storage="./jinroSubroutines.ks" target="*glinkFromCandidateCharacterObjects"]

; キャラ画像解放
[freeimage layer="1" time=400 wait="false"]

; ボタンで選択した投票先キャラクターIDを、プレイヤーの投票履歴に入れる
[iscript]
  f.characterObjects[f.playerCharacterId].voteHistory[f.day] = pushElement(f.characterObjects[f.playerCharacterId].voteHistory[f.day], tf.targetCharacterId);
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
      あと[emb exp="MAX_REVOTE_COUNT-f.revoteCount"]回で決着しない場合は引き分けです。[p]
      [jump target="*votePhase"]
    [else]
      ; 再投票上限を越えた場合は引き分け処理
      投票で決着がつきませんでした。[p]
      [eval exp="tf.winnerCamp = CAMP_DRAW_BY_REVOTE"]
      [jump target="*gameOver"]
    [endif]
  [else]
    [eval exp="tf.targetCharacterId = f.electedIdList[0]"]
  [endif]
[endif]

; 処刑セリフと処刑処理（TODO 今はこの順番だが、処刑ごとの演出がどうなるかによっては逆にしてもいい）
[m_executed characterId="&tf.targetCharacterId"]
[j_execution characterId="&tf.targetCharacterId"]

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

[eval exp="timePasses()"]
[bg storage="living_night_close_nc238328.jpg" time="300"]
[m_timePasses isDaytime="&f.isDaytime"]


; 夜時間開始時に、夜時間中に生存しているかを参照するためのcharacterObjectを複製する。占い、噛みなどの記録は本物のf.characterObjectsに更新していく。
[eval exp="f.characterObjectsHistory[f.day] = clone(f.characterObjects)"]


; プレイヤーの行動（夜時間オブジェクトを参照）
[if exp="f.characterObjectsHistory[f.day][f.playerCharacterId].isAlive"]

[m_changeFrameWithId]
#
プレイヤーの行動です。[p]

  ; 村人
  [if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_VILLAGER"]
    村人なので行動できません。[p]
  [endif]

  ; 占い師、または騙り占い師CO済みであれば
  [j_setCanCOFortuneTellerStatus characterId="&f.playerCharacterId"]
  [if exp="tf.canCOFortuneTellerStatus == 1 || tf.canCOFortuneTellerStatus == 2 || tf.canCOFortuneTellerStatus == 4"]

    ; 騙り占い師の場合
    [if exp="tf.canCOFortuneTellerStatus == 4"]
      [m_askFortuneTellingTarget isFortuneTeller="false"]

      ; 占いカットイン発生
      [j_cutin1]

      ; 騙り占い実行
      [call storage="./fortuneTellingForPC.ks" target="*fakeFortuneTellingForPC"]

    [else]
      ; 真占い師の場合
      [m_askFortuneTellingTarget isFortuneTeller="true"]

      ; 占いカットイン発生
      [j_cutin1]

      ; 占い実行
      [call storage="./fortuneTellingForPC.ks" target="*fortuneTellingForPC"]

      ; 占い結果に合わせてセリフ出力
      [m_announcedFortuneTellingResult characterId="&f.playerCharacterId" result="&tf.todayResultObject.result"]

    [endif]

    ; 占いカットイン解放
    ;[freeimage layer="1" time=400 wait="false"]

  [endif]

  ; 人狼の場合のみ
  [if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_WEREWOLF"]

    [if exp="f.isBiteEnd != true"]

      [m_chooseWhoToBite characterId="&f.playerCharacterId"]

      [iscript]
        ; 夜時間開始時の生存者である、かつ人狼以外のキャラクターオブジェクトを選択肢候補変数に格納する。
        tf.candidateCharacterObjects = getIsWerewolvesObjects(
          getSurvivorObjects(f.characterObjectsHistory[f.day]),
          false
        );
      [endscript]

      ; 選択肢ボタン表示と入力受付
      [call storage="./jinroSubroutines.ks" target="*glinkFromCandidateCharacterObjects"]

      ; 噛み実行
      [j_biting biterId="&f.playerCharacterId" characterId="&tf.targetCharacterId"]
      [m_exitCharacter characterId="&tf.targetCharacterId"]

      ; キャラ画像解放
      [freeimage layer="1" time=400 wait="false"]

      ; 噛み実行済みフラグを立てる
      [eval exp="f.isBiteEnd = true"]
    [endif]
  [endif]

[endif]

[m_changeFrameWithId]
#
NPCが行動しています……[p]

; 占い師（真、騙り共通）の占い実行
[j_nightPhaseFortuneTellingForNPC]

; 噛み未実行なら（＝PCが人狼ではないなら）噛み実行
[if exp="!f.isBiteEnd"]
  [j_nightPhaseBitingForNPC]
  ; 噛まれたキャラクターを退場させる（噛み実行マクロ内でtf.targetCharacterIdは格納済み）
  [m_exitCharacter characterId="&tf.targetCharacterId"]
[endif]

; 勝敗判定
[j_judgeWinnerCampAndJump storage="playJinro.ks" target="*gameOver"]

[bg storage="living_day_nc238325.jpg" time="100"]
[jump target="*startDaytime"]


*gameOver
[m_displayGameOverAndWinnerCamp winnerCamp="&tf.winnerCamp"]

[m_changeFrameWithId]
#
おわり。[r]
;タイトルに戻ります。[p]
; [j_saveJson]

; TODO タイトル画面または戻る前に、キャラの退場、メッセージ枠の削除、ボタンの削除など必要。
;[jump storage="title.ks"]
[s]
