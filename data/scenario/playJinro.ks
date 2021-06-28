; 人狼ゲームのメインシナリオファイル

*start

[cm  ]
[clearfix]
[start_keyconfig]


[bg storage="black.png" time="300"]

;メニューボタンの表示
@showmenubutton

;メッセージウィンドウの設定
[position layer="message0" left=160 top=500 width=1000 height=200 page=fore visible=true]

;文字が表示される領域を調整
[position layer=message0 page=fore margint="45" marginl="50" marginr="70" marginb="60"]


;メッセージウィンドウの表示
@layopt layer=message0 visible=true

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
[d_noticeRole characterId="&f.playerCharacterId" roleId="&f.characterObjects[f.playerCharacterId].role.roleId"]

; 占い師なら初日占い実行
[if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_FORTUNE_TELLER"]

  ; 占いカットイン発生
  [j_cutin1]

  ; 占い実行
  [call storage="./fortuneTellingForPC.ks" target="*fortuneTellingForPC"]

  ; 占い結果に合わせてセリフ出力
  [d_announcedFortuneTellingResult characterId="&f.playerCharacterId" result="&tf.todayResultObject.result"]

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


#
夜が明けた……。[r]
この中に人狼が潜んでいる……。[p]

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

  ;プレイヤーが占い師、人狼、狂人なら、占い師COするか？（騙りの場合、ここで占い結果も偽装する）
  [if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_FORTUNE_TELLER"]

    [if exp="f.notExistCOCandidateNPC"]
      [if exp="f.playerCharacterId == CHARACTER_ID_AI"]
        # &f.speaker['アイ']
        （さて、今度こそCOしようか……？）[p]
      [endif]
    [else]
      [if exp="f.playerCharacterId == CHARACTER_ID_AI"]
        # &f.speaker['アイ']
        （夜の間に占った結果をCOしようか……？）[p]
      [endif]
    [endif]

    ; COするしないボタン表示
    [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (0 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
    [glink  color="blue"  storage="playJinro.ks"  size="28"  x="360"  width="500"  y="&tf.y"  text="占いCOする"  target="*FortuneTellerCO"  ]
    [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (1 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
    [glink  color="blue"  storage="playJinro.ks"  size="28"  x="360"  width="500"  y="&tf.y"  text="何もしない"  target="*noCO"  ]
    [s]

    *FortuneTellerCO

    [if exp="f.playerCharacterId == CHARACTER_ID_AI"]

      ; 最新の占い結果を元にCO文を表示する
      [j_COfortuneTellingResultLastNight fortuneTellerId="ai"][p]

    [endif]

    ; 占いカットイン解放
    [freeimage layer="1" time=400 wait="false"]

    [eval exp="f.characterObjects[f.playerCharacterId].isDoneTodaysCO = true"]
    ; COしたため共通および各キャラの視点オブジェクトを更新する TODO 初回だけで充分。2回目以降やっても問題はないが無駄処理になる
    [j_cloneRolePerspectiveForCO characterId="&f.characterObjects.ai.characterId" CORoleId="fortuneTeller"]
    [eval exp="tf.tmpZeroRoleIds = [ROLE_ID_VILLAGER]"]
    [j_updateCommonPerspective characterId="&f.characterObjects.ai.characterId" zeroRoleIds="&tf.tmpZeroRoleIds"]
    @jump target="*COEnd"

  [elsif exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_WEREWOLF"]

    [if exp="f.playerCharacterId == CHARACTER_ID_AI"]
    [endif]

  [elsif exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_MADMAN"]

    [if exp="f.playerCharacterId == CHARACTER_ID_AI"]
    [endif]

  [endif]
  ; 人狼、狂人の場合のみここに来る

  ; 占い騙りCOをまだしていない場合
  [if exp="f.characterObjects[f.playerCharacterId].fakeRole.roleId != ROLE_ID_FORTUNE_TELLER"]

    [if exp="f.notExistCOCandidateNPC"]
      [if exp="f.playerCharacterId == CHARACTER_ID_AI"]
        # &f.speaker['アイ']
        （さて、今度こそ占い師を騙ろうか？）[p]
      [endif]
    [else]
      [if exp="f.playerCharacterId == CHARACTER_ID_AI"]
        # &f.speaker['アイ']
        （これから占い師を騙ろうか？）[p]
      [endif]
    [endif]

    [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (0 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
    [glink  color="blue"  storage="playJinro.ks"  size="28"  x="360"  width="500"  y="&tf.y"  text="占いCOする"  target="*fakeFortuneTellerCO"  ]
    [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (1 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
    [glink  color="blue"  storage="playJinro.ks"  size="28"  x="360"  width="500"  y="&tf.y"  text="何もしない"  target="*noCO"  ]
    [s]

    *fakeFortuneTellerCO
    ; 未COかつ、占い騙りをすると決めた場合、騙り役職オブジェクトを取得する
    [j_assignmentFakeRole characterId="&f.characterObjects[f.playerCharacterId].characterId" roleId="fortuneTeller"]

    ; 前日までの分、騙り占い実行
    [call storage="./fortuneTellingForPC.ks" target="*fakeFortuneTellingCOMultipleDaysForPC"]

  [endif]

  ; TODO このままだと、既に騙り占いをCO済みの場合、必ず翌日以降の昼時間のCOフェイズの最初に、昨夜の占い偽装結果をCOしてしまう。
  ; 最終的にはそれを目指していたため問題ないのだが、他のパターンもちゃんと実装すること。
  [j_COfortuneTellingResultLastNight fortuneTellerId="ai"][p]
  
  ; 占いカットイン解放
  [freeimage layer="1" time=400 wait="false"]
  
  [eval exp="f.characterObjects[f.playerCharacterId].isDoneTodaysCO = true"]
  ; COしたため共通および各キャラの視点オブジェクトを更新する TODO 初回だけで充分。2回目以降やっても問題はないが無駄処理になる
  [eval exp="tf.tmpZeroRoleIds = [ROLE_ID_VILLAGER]"]
  [j_updateCommonPerspective characterId="&f.characterObjects.ai.characterId" zeroRoleIds="&tf.tmpZeroRoleIds"]
  @jump target="*COEnd"


  ; 汎用　COなし
  *noCO

  [if exp="f.notExistCOCandidateNPC"]
    ; COフェイズ終了(NPCにCO候補者がいないため、これ以上COする者はいないとする)

    [if exp="f.playerCharacterId == CHARACTER_ID_AI"]
      # &f.speaker['アイ']
      （いや、このまま議論に移ろう）[p]
    [endif]

    @jump target="*discussionPhase"

  [endif]
  ; COフェイズ継続(まだNPCにCO候補者がいるので、NPCのCOを確認する)

  [if exp="f.playerCharacterId == CHARACTER_ID_AI"]
    # &f.speaker['アイ']
    （いや、ここは様子見をしよう）[p]
  [endif]

  @jump target="*COEnd"
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
    @jump target="*discussionPhase"
  [else]
    ; COフェイズ継続(NPCにCO者がいないことを受けて、PCのCOを確認する)
    @jump target="*COPhasePlayer"
  [endif]

[elsif]
  [eval exp="f.notExistCOCandidateNPC = false"]
[endif]

; ヒヨリ
[if exp="tf.COCandidateId == CHARACTER_ID_HIYORI"]

  ;占い師
  [if exp="f.characterObjects.hiyori.role.roleId == ROLE_ID_FORTUNE_TELLER"]

    # &f.speaker['ヒヨリ']
    う、占いCOです！[r]
    [j_COfortuneTellingResultLastNight fortuneTellerId="hiyori"][p]

  ;人狼または狂人
  [elsif exp="f.characterObjects.hiyori.role.roleId == ROLE_ID_WEREWOLF || f.characterObjects.hiyori.role.roleId == ROLE_ID_MADMAN"]
    ; 占い騙りがまだなら、騙り役職を取得し、昨夜までの分を占ってからCOする
    [if exp="f.characterObjects.hiyori.fakeRole.roleId != ROLE_ID_FORTUNE_TELLER"]
      [j_assignmentFakeRole characterId="&f.characterObjects.hiyori.characterId" roleId='fortuneTeller']
      [j_fakeFortuneTellingCOMultipleDays fortuneTellerId="&f.characterObjects.hiyori.characterId"]
    [endif]

    # &f.speaker['ヒヨリ']
    う、占いCOです！[r]
    [j_COfortuneTellingResultLastNight fortuneTellerId="hiyori"][p]

  [endif]

; フタバ
[elsif exp="tf.COCandidateId == CHARACTER_ID_FUTABA"]

  ;占い師
  [if exp="f.characterObjects.futaba.role.roleId == ROLE_ID_FORTUNE_TELLER"]

    # &f.speaker['フタバ']
    [j_COfortuneTellingResultLastNight fortuneTellerId="futaba"][p]

  ;人狼または狂人
  [elsif exp="f.characterObjects.futaba.role.roleId == ROLE_ID_WEREWOLF || f.characterObjects.futaba.role.roleId == ROLE_ID_MADMAN"]
    ;占い騙りがまだなら、騙り役職を取得し、昨夜までの分を占ってからCOする
    [if exp="f.characterObjects.futaba.fakeRole.roleId != ROLE_ID_FORTUNE_TELLER"]
      [j_assignmentFakeRole characterId="&f.characterObjects.futaba.characterId" roleId='fortuneTeller']
      [j_fakeFortuneTellingCOMultipleDays fortuneTellerId="&f.characterObjects.futaba.characterId"]
    [endif]

    # &f.speaker['フタバ']
    [j_COfortuneTellingResultLastNight fortuneTellerId="futaba"][p]

  [endif]

; ミキ
[elsif exp="tf.COCandidateId == CHARACTER_ID_MIKI"]

  ;占い師
  [if exp="f.characterObjects.miki.role.roleId == ROLE_ID_FORTUNE_TELLER"]

    # &f.speaker['ミキ']
    私の占い結果を聞きなさい！[r]
    [j_COfortuneTellingResultLastNight fortuneTellerId="miki"][p]

  ;人狼または狂人
  [elsif exp="f.characterObjects.miki.role.roleId == ROLE_ID_WEREWOLF || f.characterObjects.miki.role.roleId == ROLE_ID_MADMAN"]
    ;占い騙りがまだなら、騙り役職を取得し、昨夜までの分を占ってからCOする
    [if exp="f.characterObjects.miki.fakeRole.roleId != ROLE_ID_FORTUNE_TELLER"]
      [j_assignmentFakeRole characterId="&f.characterObjects.miki.characterId" roleId='fortuneTeller']
      [j_fakeFortuneTellingCOMultipleDays fortuneTellerId="&f.characterObjects.miki.characterId"]
    [endif]

    # &f.speaker['ミキ']
    私の占い結果を聞きなさい！[r]
    [j_COfortuneTellingResultLastNight fortuneTellerId="miki"][p]

  [endif]

[elsif exp="tf.COCandidateId == CHARACTER_ID_DUMMY"]

  ;占い師
  [if exp="f.characterObjects.dummy.role.roleId == ROLE_ID_FORTUNE_TELLER"]

    # &f.speaker['ダミー']
    占いCOやで！[r]
    [j_COfortuneTellingResultLastNight fortuneTellerId="dummy"][p]

  ;人狼または狂人
  [elsif exp="f.characterObjects.dummy.role.roleId == ROLE_ID_WEREWOLF || f.characterObjects.dummy.role.roleId == ROLE_ID_MADMAN"]
    ; NOTE: 霊能など他の役職のCOを実装することになった際は、ここでCOする役職ごとに分岐するようにする

    ; 占い騙りがまだなら、騙り役職を取得し、昨夜までの分を占ってからCOする
    [if exp="f.characterObjects.dummy.fakeRole.roleId != ROLE_ID_FORTUNE_TELLER"]
      [j_assignmentFakeRole characterId="&f.characterObjects.dummy.characterId" roleId='fortuneTeller']
      [j_fakeFortuneTellingCOMultipleDays fortuneTellerId="&f.characterObjects.dummy.characterId"]
    [endif]

    # &f.speaker['ダミー']
    占いCOやで！[r]
    [j_COfortuneTellingResultLastNight fortuneTellerId="dummy"][p]

  [endif]

[endif]

; 占いカットイン解放
[freeimage layer="1" time=400 wait="false"]

; TODO: どのように、前のCO内容を次のCOの確率に影響させるか？　今日のCO内容をどこかの配列に保存しておく必要がありそう？

; 今日のCOが終わったキャラはisDoneTodaysCOをtrueにする
[eval exp="f.characterObjects[tf.COCandidateId].isDoneTodaysCO = true"]
; COしたため共通および各キャラの視点オブジェクトを更新する TODO 初回だけで充分。2回目以降やっても問題はないが無駄処理になる
; TODO:騙りCOの場合も無害ではあるが、やりたくないので避けるようにしたい
[j_cloneRolePerspectiveForCO characterId="&f.characterObjects[tf.COCandidateId].characterId" CORoleId="fortuneTeller"]
[eval exp="tf.tmpZeroRoleIds = [ROLE_ID_VILLAGER]"]
[j_updateCommonPerspective characterId="&f.characterObjects[tf.COCandidateId].characterId" zeroRoleIds="&tf.tmpZeroRoleIds"]
; TODO 占い結果を聞いて、各キャラのrolePerspectiveで真偽をつける

; NPCのCOが終了したら、他のNPCのCOを確認しに戻る
; ※NPCのCOが1人終わるごとにPCにCO有無を確認しに戻るのはPCの操作が面倒になるはず。
; CO順を理解できるAIが実装できるようになるまでは、NPCのCOはまとめて行ってしまうようにする。
; もし毎回PCにCO有無を確認しに戻るようにしたい場合は、@jump target="*COPhasePlayer"にする。
@jump target="*COPhaseNPC"



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
[d_executed characterId="&tf.targetCharacterId"]
[j_execution characterId="&tf.targetCharacterId"]

[if exp="f.characterObjects.ai.isAlive"]
  # &f.speaker['アイ']
  もし間違ってたら、ごめん……。[p]

[elsif exp="f.characterObjects.hiyori.isAlive"]
  # &f.speaker['ヒヨリ']
  もう嫌だよ……こんなのがまだ続くの……？[p]

[endif]


; 勝敗判定
[j_judgeWinnerCampAndJump storage="playJinro.ks" target="*gameOver"]


; 夜時間開始
*nightPhase

[bg storage="black.png" time="300"]
[eval exp="timePasses()"]

#
恐ろしい夜がやってきた。[p]

; 夜時間開始時に、夜時間中に生存しているかを参照するためのcharacterObjectを複製する。占い、噛みなどの記録は本物のf.characterObjectsに更新していく。
[eval exp="f.characterObjectsHistory[f.day] = clone(f.characterObjects)"]


; プレイヤーの行動（夜時間オブジェクトを参照）
[if exp="f.characterObjectsHistory[f.day][f.playerCharacterId].isAlive"]

プレイヤーの行動です。[p]

  ; 村人
  [if exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_VILLAGER"]

    村人なので行動できません。[p]

  ; 占い師
  [elsif exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_FORTUNE_TELLER"]

    [if exp="f.playerCharacterId == CHARACTER_ID_AI"]

      # &f.speaker['アイ']
      今夜は誰を占おうか？[p]

      ; 占いカットイン発生
      [j_cutin1]

      ; 占い実行
      [call storage="./fortuneTellingForPC.ks" target="*fortuneTellingForPC"]

      ; 占い結果に合わせてメッセージを表示
      [if exp="tf.todayResultObject.result"]
        # &f.speaker['アイ']
        ……[emb exp="f.characterObjects[tf.todayResultObject.characterId].name"]が人狼だったんだね……。[p]

      [else]
        # &f.speaker['アイ']
        [emb exp="f.characterObjects[tf.todayResultObject.characterId].name"]は人狼じゃないみたい。[p]
        
      [endif]

      ; 占いカットイン解放
      [freeimage layer="1" time=400 wait="false"]
    [endif]

  ; 人狼または狂人
  [elsif exp="f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_WEREWOLF || f.characterObjects[f.playerCharacterId].role.roleId == ROLE_ID_MADMAN"]

    ; 占い騙り中なら（夜時間に騙り始めることはできない）
    [if exp="f.characterObjects[f.playerCharacterId].fakeRole.roleId == ROLE_ID_FORTUNE_TELLER"]

      [if exp="f.playerCharacterId == CHARACTER_ID_AI"]
        # &f.speaker['アイ']
        今夜は、誰を占ったことにしようか？[p]
      [endif]

      ; 占いカットイン発生
      [j_cutin1]

      ; 騙り占い実行
      [call storage="./fortuneTellingForPC.ks" target="*fakeFortuneTellingForPC"]

      ; 占いカットイン解放
      [freeimage layer="1" time=400 wait="false"]

    [endif]

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

@jump target="*startDaytime"
;@jump storage="playJinro.ks"


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
