; 人狼ゲームのメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]


[bg storage="black.png" time="300"]

;メニューボタンの表示
[showmenubutton]

;メッセージウィンドウの設定
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true]

;文字が表示される領域を調整
[position layer=message0 page=fore margint="45" marginl="50" marginr="70" marginb="60"]


;メッセージウィンドウの表示
[layopt layer=message0 visible=true]

;キャラクターの名前が表示される文字領域
[ptext name="chara_name_area" layer="message0" color="white" size=28 bold=true x=180 y=510]

;上記で定義した領域がキャラクターの名前表示であることを宣言（これがないと#の部分でエラーになります）
[chara_config ptext="chara_name_area"]

;このゲームで登場するキャラクターを宣言
;キャラクターの表情登録


; ゲーム準備js読み込み
[loadjs storage="plugin/jinro/macro/prepareGame.js"]

#
人狼ゲームの幕開けです……！[p]

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
  [m_announcedFortuneTellingResult characterId="&f.playerCharacterId" result="&tf.todayResultObject.result"]

  ; 占いカットイン解放
  [freeimage layer="1" time=400 wait="false"]

[endif]

; 初日夜のNPCの行動。占い師のみ行動する。
[iscript]
  ; 夜時間開始時の生存者である、かつプレイヤー以外のキャラクターオブジェクトから、真占い師のID配列を抽出する。
  tf.fortuneTellerNpcCharacterIds = getValuesFromObjectArray(
    getHaveTheRoleObjects(
      getCharacterObjectsFromCharacterIds(
        getSurvivorObjects(f.characterObjectsHistory[f.day]),
        [f.playerCharacterId],
        false
      ),
      [ROLE_ID_FORTUNE_TELLER]
    ),
    'characterId'
  );
[endscript]

; ID配列なので、includesでチェックしていく。仮に候補者が複数人いても対応可能。
[if exp="tf.fortuneTellerNpcCharacterIds.includes(CHARACTER_ID_HIYORI)"]
  [j_fortuneTelling fortuneTellerId="hiyori"]
[endif]

[if exp="tf.fortuneTellerNpcCharacterIds.includes(CHARACTER_ID_FUTABA)"]
  [j_fortuneTelling fortuneTellerId="futaba"]
[endif]

[if exp="tf.fortuneTellerNpcCharacterIds.includes(CHARACTER_ID_MIKI)"]
  [j_fortuneTelling fortuneTellerId="miki"]
[endif]

[if exp="tf.fortuneTellerNpcCharacterIds.includes(CHARACTER_ID_DUMMY)"]
  [j_fortuneTelling fortuneTellerId="dummy"]
[endif]


*startDaytime
#
[eval exp="timePasses()"]
[bg storage="room.jpg" time="500"]
[m_timePasses isDaytime="&f.isDaytime"]

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

    ; 最新の占い結果を元にCO文を表示する
    [j_COfortuneTellingResultLastNight fortuneTellerId="&f.playerCharacterId"][p]

    ; 占いカットイン解放
    [freeimage layer="1" time=400 wait="false"]

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

    [jump target="*COEnd"]
  [endif]

  ; COなし
  *noCO

  [if exp="f.notExistCOCandidateNPC"]
    ; COフェイズ終了(NPCにCO候補者がいないため、これ以上COする者はいないとする)
    [jump target="*discussionPhase"]
  [else]
    ; COフェイズ継続(まだNPCにCO候補者がいるので、NPCのCOを確認する)
    [jump target="*COEnd"]
  [endif]

[endif]

*COEnd


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
  [image layer="1" x="1280" y="80" visible="true" storage="01_sad.png" name="01"]
  [anim name="01" left=850 time=350]

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
#
～議論フェイズは未作成～[p]


*votePhase
#
～投票フェイズ～[p]

; 投票フェイズ
; TODO NPCも投票する（ようにするには、ヘイトを実装してからでないと厳しいか） 

# &f.speaker['アイ']
テスト用に私に投票権が一任されてるよ。[r]
さて、誰に投票しようか？[p]

[iscript]
  ; 生存者である、かつプレイヤー以外のキャラクターオブジェクトを選択肢候補変数に格納する。
  tf.candidateObjects = getCharacterObjectsFromCharacterIds(
    getSurvivorObjects(f.characterObjects),
    [f.playerCharacterId],
    false
  );

  ; TODO ……のが正しいが、テスト用に生存者全員を投票対象にしておく。
  tf.candidateObjects = getSurvivorObjects(f.characterObjects);
[endscript]

; 選択肢ボタン表示と入力受付
[call storage="./fortuneTellingForPC.ks" target="*glinkFromCandidateObjects"]

; キャラ画像解放
[freeimage layer="1" time=400 wait="false"]

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
[bg storage="black.png" time="300"]
[m_timePasses isDaytime="&f.isDaytime"]


; 夜時間開始時に、夜時間中に生存しているかを参照するためのcharacterObjectを複製する。占い、噛みなどの記録は本物のf.characterObjectsに更新していく。
[eval exp="f.characterObjectsHistory[f.day] = clone(f.characterObjects)"]


; プレイヤーの行動（夜時間オブジェクトを参照）
[if exp="f.characterObjectsHistory[f.day][f.playerCharacterId].isAlive"]

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
    [freeimage layer="1" time=400 wait="false"]

  [endif]

  ; 人狼の場合のみ
  [if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_WEREWOLF"]

    [if exp="f.isBiteEnd != true"]

      [if exp="f.playerCharacterId == CHARACTER_ID_AI"]
        # &f.speaker['アイ']
        それじゃあ、今日の犠牲者を決めようか。[r]
        今日、私に噛まれるのは……[p]
      [endif]

      [iscript]
        ; 夜時間開始時の生存者である、かつ人狼以外のキャラクターオブジェクトを選択肢候補変数に格納する。
        tf.candidateObjects = getIsWerewolvesObjects(
          getSurvivorObjects(f.characterObjectsHistory[f.day]),
          false
        );
      [endscript]

      ; 選択肢ボタン表示と入力受付
      [call storage="./fortuneTellingForPC.ks" target="*glinkFromCandidateObjects"]

      ; 噛み実行
      [j_biting biterId="&f.playerCharacterId" characterId="&tf.targetCharacterId"]

      ; 噛み実行済みフラグを立てる
      [eval exp="f.isBiteEnd = true"]
    [endif]
  [endif]

[endif]


#
NPCが行動しています……[p]

;NPCの占い師フェイズ（真、騙り共通）
[iscript]
  ; 夜開始時点の生存者である、かつプレイヤー以外のキャラクターオブジェクトから、占い師のID配列を抽出する。
  ; 真占い師も騙り占い師もここで処理する。j_fortuneTellingマクロ内で真か騙りかで処理を分けているため問題ない。
  tf.fortuneTellerNpcCharacterIds = getValuesFromObjectArray(
    getHaveTheRoleObjects(
      getCharacterObjectsFromCharacterIds(
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

; ID配列なので、includesでチェックしていく。仮に候補者が複数人いても対応可能。
[if exp="tf.fortuneTellerNpcCharacterIds.includes(CHARACTER_ID_HIYORI)"]
  [j_fortuneTelling fortuneTellerId="hiyori"]
[endif]

[if exp="tf.fortuneTellerNpcCharacterIds.includes(CHARACTER_ID_FUTABA)"]
  [j_fortuneTelling fortuneTellerId="futaba"]
[endif]

[if exp="tf.fortuneTellerNpcCharacterIds.includes(CHARACTER_ID_MIKI)"]
  [j_fortuneTelling fortuneTellerId="miki"]
[endif]

[if exp="tf.fortuneTellerNpcCharacterIds.includes(CHARACTER_ID_DUMMY)"]
  [j_fortuneTelling fortuneTellerId="dummy"]
[endif]


; 噛み未実行なら（＝PCが人狼ではないなら）
[if exp="!f.isBiteEnd"]

  ;NPCの人狼フェイズ
  [iscript]
    ; 夜開始時点の生存者である、かつプレイヤー以外のキャラクターオブジェクトから、人狼のID配列を抽出する。
    tf.werewolfNpcCharacterIds = getValuesFromObjectArray(
      getHaveTheRoleObjects(
        getCharacterObjectsFromCharacterIds(
          getSurvivorObjects(f.characterObjectsHistory[f.day]),
          [f.playerCharacterId],
          false
        ),
        [ROLE_ID_WEREWOLF]
      ),
      'characterId'
    );
  [endscript]

  ; ID配列なので、includesでチェックしていく。仮に候補者が複数人いても対応可能。
  ; TODO 生存中のNPCに人狼が2人以上いた場合に、その人数分襲撃してしまう。1人だけ襲撃するように修正したい。（設定で襲撃人数を保持）
  [if exp="tf.werewolfNpcCharacterIds.includes(CHARACTER_ID_HIYORI)"]
    [j_biting biterId="&f.characterObjects.hiyori.characterId"]
  [endif]

  [if exp="tf.werewolfNpcCharacterIds.includes(CHARACTER_ID_FUTABA)"]
    [j_biting biterId="&f.characterObjects.futaba.characterId"]
  [endif]

  [if exp="tf.werewolfNpcCharacterIds.includes(CHARACTER_ID_MIKI)"]
    [j_biting biterId="&f.characterObjects.miki.characterId"]
  [endif]

  [if exp="tf.werewolfNpcCharacterIds.includes(CHARACTER_ID_DUMMY)"]
    [j_biting biterId="&f.characterObjects.dummy.characterId"]
  [endif]

[endif]


; 勝敗判定
[j_judgeWinnerCampAndJump storage="playJinro.ks" target="*gameOver"]


[bg storage="room.jpg" time="100"]

[jump target="*startDaytime"]


*gameOver

#
ゲームが終了しました。[p]

[if exp="tf.winnerCamp == 'villagers'"]

  #
  村人の勝利！[p]

[elsif exp="tf.winnerCamp == 'werewolves'"]

  #
  人狼の勝利！[p]

[endif]

おわり。
[j_saveJson]
[s]
