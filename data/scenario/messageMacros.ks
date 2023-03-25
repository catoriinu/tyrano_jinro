; ./message/{characterId}.ksサブルーチンを呼び出すマクロ集。
; 発言者のキャラクターIDを引数にとり、./message/{characterId}.ksのサブルーチンラベルを呼び出して適切なセリフを出力する。

; messageマクロ・サブルーチン作成方針：
; ・マクロは呼び出されるシーンごとの入口として作成し、キャラクターごとにサブルーチンファイルを、パターンごとにサブルーチンラベルを呼び分ける。
; ・サブルーチンファイルはキャラクター1人ごとに1ファイルを作成し、サブルーチンラベルを呼び出されたときに適切なセリフを出力する役割に徹する。
; ・サブルーチンラベル内で変数を利用することでラベル数を削減できる場合は、マクロの引数を増やすよりも優先する。
; ・可能な限りサブルーチンラベル内では分岐は行わないが、シチュエーションごとにセリフ差分が必要な場合は許可する。

; メモ
; #（ptextタグの省略記法）で、キャラ名の後ろに:で続けてface要素（表情名）を指定可能。ここに書くなら全員表情差分名を共通にしておく必要がある。

; シーン：初日、役職を告知されたときの反応
; @param characterId 発言者のキャラクターID。必須
; @param roleId 発言者の役職ID。必須
; @param face 発言者の表情。（TODO）
[macro name="m_noticeRole"]
  [m_changeFrameWithId characterId="&mp.characterId"]
  [m_changeCharacter characterId="&mp.characterId" face="normal"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*noticeRole_' + mp.roleId"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：真占い師で、占い実行結果を知ったときの反応
; 事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
[macro name="m_announcedFortuneTellingResult"]
  [m_changeFrameWithId characterId="&f.actionObject.characterId"]
  [m_changeCharacter characterId="&f.actionObject.characterId" face="normal"]
  # &f.speaker[f.characterObjects[f.actionObject.characterId].name]
  [eval exp="tf.messageStorage = './message/' + f.actionObject.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*announcedFortuneTellingResult_' + f.actionObject.result"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：占いCOをするかを問うシステムメッセージ
; @param canCOFortuneTellerStatus 占い師COすることができる役職・CO状態かの定数。必須。関連マクロ：[j_setCanCOFortuneTellerStatus]
[macro name="m_askFortuneTellerCO"]
  [m_changeFrameWithId]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*askFortuneTellerCO_' + mp.canCOFortuneTellerStatus"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：前日の占い結果をCOするときのセリフ
; 事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
[macro name="m_COFortuneTelling"]
  [m_changeFrameWithId characterId="&f.actionObject.characterId"]
  [m_changeCharacter characterId="&f.actionObject.characterId" face="normal"]
  # &f.speaker[f.characterObjects[f.actionObject.characterId].name]
  [eval exp="tf.messageStorage = './message/' + f.actionObject.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*COFortuneTelling_' + f.actionObject.result"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：アクション実行時のセリフ
; @param characterId 発言者のキャラクターID。必須
; @param face 発言者の表情。（TODO）
; @param targetCharacterId アクション対象のキャラクターID。必須
; @param actionId 実行するアクションID。必須。
[macro name="m_doAction"]
  [m_changeFrameWithId characterId="&mp.characterId"]
  [m_changeCharacter characterId="&mp.characterId" face="normal"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.selectedCharacterId = mp.targetCharacterId"]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*doAction_' + mp.actionId"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：アクション実行対象になった時のセリフ
; @param characterId 発言者（＝アクション実行対象）のキャラクターID。必須
; @param face 発言者の表情。（TODO）
; @param targetCharacterId 返答相手（＝元々のアクション実行者）のキャラクターID。（TODO）
; @param actionId 実行されたアクションID。必須。
[macro name="m_doAction_reaction"]
  ; TODO love:信頼度がとても高いとき hate:信頼度がとても低いとき newtral:それ以外 の三段階のリアクションができると嬉しい
  ;　(「とても」としているのは、よほど極端な状況でない限り、人狼で露骨な反応はしないはずのため。ただ、顔に出やすい性格のキャラは条件をゆるくすると面白いかも）
  ; （上記の判定を信頼度でやるべきか、仲間度でやるべきかは要考慮）
  [m_changeFrameWithId characterId="&mp.characterId"]
  [m_changeCharacter characterId="&mp.characterId" face="normal"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  ; [eval exp="tf.targetCharacterId = mp.targetCharacterId"]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*doAction_reaction_' + mp.actionId"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：人狼で、誰を噛むか選ぶときのセリフ
; @param characterId 発言者のキャラクターID。必須
; @param face 発言者の表情。（TODO）
[macro name="m_chooseWhoToBite"]
  [m_changeFrameWithId characterId="&mp.characterId"]
  [m_changeCharacter characterId="&mp.characterId" face="normal"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*chooseWhoToBite'"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：投票により処刑対象に決まったときの反応
; @param characterId 発言者のキャラクターID。必須
; @param face 発言者の表情。（TODO）
[macro name="m_executed"]
  [m_changeFrameWithId characterId="&mp.characterId"]
  [m_changeCharacter characterId="&mp.characterId" face="normal"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*executed'"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
  [m_exitCharacter characterId="&mp.characterId"]
[endmacro]


; シーン：処刑後の反応
; @param characterId 発言者のキャラクターID。必須
; @param face 発言者の表情。（TODO）
[macro name="m_afterExecution"]
  [m_changeFrameWithId characterId="&mp.characterId"]
  [m_changeCharacter characterId="&mp.characterId" face="normal"]
  # &f.speaker[f.characterObjects[mp.characterId].name]
  [eval exp="tf.messageStorage = './message/' + mp.characterId + '.ks'"]
  [eval exp="tf.messageTarget = '*afterExecution'"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：時間が経過したときのシステムメッセージ
; TODO 現状、呼び元がない。j_turnIntoDaytime、j_turnIntoNightから呼ぶようにするかもしれないので残しておく。
; @param isDaytime （true:昼/false:夜）になったか。必須。関連メソッド：timePasses()
[macro name="m_timePasses"]
  [m_changeFrameWithId]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*timePasses_' + mp.isDaytime"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：占い先を決めることを促すシステムメッセージ
; @param isFortuneTeller 真占い師(true)か、騙り占い師か(false)。必須。関連マクロ：[j_setCanCOFortuneTellerStatus]を元に呼び元でbooleanに変換しておくこと。
[macro name="m_askFortuneTellingTarget"]
  [m_changeFrameWithId]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*askFortuneTellingTarget_' + mp.isFortuneTeller"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：騙り占いCO時、過去の占い履歴を決めていく際の日付を表示するシステムメッセージ
[macro name="m_fakeFortuneTelledDayMsg"]
  [m_changeFrameWithId]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*fakeFortuneTelledDayMsg'"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：偽の占い対象を入力した後、それを表示しつつそのCO結果を決めることを促すシステムメッセージ
[macro name="m_displayFakeFortuneTellingTarget"]
  [m_changeFrameWithId]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*displayFakeFortuneTellingTarget'"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：入力した偽の占いCO結果を表示するシステムメッセージ
; @param result 偽の占い結果（true:●/false:○）。必須
[macro name="m_displayFakeFortuneTellingResult"]
  [m_changeFrameWithId]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*displayFakeFortuneTellingResult_' + mp.result"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：ゲームの勝敗判定結果を表示するシステムメッセージ
; @param winnerCamp 勝利陣営。必須
[macro name="m_displayGameOverAndWinnerCamp"]
  [m_changeFrameWithId]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*displayGameOverAndWinnerCamp_' + mp.winnerCamp"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; ～ここから個人用設定あり～

; メッセージフレームを、発言者の位置に合わせて切り替える
; 現在のフレームと同じフレームに変える場合は何もしない
; TODO 高頻度で切り替え時にチラつくのをなんとかしたい
; @param characterId 発言者のキャラクターID。ない場合、発言者枠なしのメッセージフレームに変える。
[macro name="m_changeFrameWithId"]
  [if exp="!('characterId' in mp)"]
    [position layer="message0" frame="message_window_none.png" cond="f.currentFrame != 'none'"]
    [eval exp="f.currentFrame = 'none'"]
  [elsif exp="f.displayedCharacter.left.isDisplay && mp.characterId == f.displayedCharacter.left.characterId"]
    [position layer="message0" frame="message_window_left.png" cond="f.currentFrame != 'left'"]
    [eval exp="f.currentFrame = 'left'"]
  [else]
    [position layer="message0" frame="message_window_right.png" cond="f.currentFrame != 'right'"]
    [eval exp="f.currentFrame = 'right'"]
  [endif]
[endmacro]


; 登場しているキャラクターを交代する。既に登場しているキャラクターの場合は表情のみ変える。
; キャラの表示位置は、PC：画面左側、NPC：画面右側とする。同じ側には一人しか出ない（ので、例えばNPC1が右側にいるときNPC2が喋る場合、NPC1が退場してからNPC2が登場する）
; すでにそのキャラがchara_newで登録,およびその表情がchara_faceで登録済みである前提とする。
; @param characterId 登場させたいキャラのキャラクターID。必須。
; @param face 登場させたいキャラのface。基本的に必須。
[macro name="m_changeCharacter"]

  ; マクロの引数を一時変数に保持しておく。別マクロを呼ぶ際にmpが上書きされ、戻ってきたときに参照できなくなるため
  [eval exp="tf.cc = clone(mp)"]
  ; そのキャラがデフォルトで登場する位置を格納する（exitCharacterマクロでtf.side変数を上書きするため、tc.cc配下に保持しておく）
  [eval exp="tf.cc.side = f.defaultPosition[tf.cc.characterId].side"] 

  ; その位置に既に登場しているキャラがいる場合
  [if exp="f.displayedCharacter[tf.cc.side].isDisplay"]

    ; それが登場させたいキャラ自身の場合
    [if exp="f.displayedCharacter[tf.cc.side].characterId == tf.cc.characterId"]

      ; 表情の指定があり、かつ今の表情と違う場合、表情を変える
      [if exp="'face' in tf.cc && f.displayedCharacter[tf.cc.side].face != tf.cc.face"]
        [chara_mod name="&tf.cc.characterId" face="&tf.cc.face" time="500" wait="false"]
        ; 表示キャラオブジェクトを更新する
        [eval exp="f.displayedCharacter[tf.cc.side].face = tf.cc.face"]
      [endif]

    [else]

      ; 今登場している別のキャラを退場させてから、そのキャラを登場させる
      [m_exitCharacter characterId="&f.displayedCharacter[tf.cc.side].characterId"]
      [m_enterCharacter characterId="&tf.cc.characterId" face="&tf.cc.face" side="&tf.cc.side"]
    [endif]

  [else]

    ; 登場しているキャラがいないなら、そのキャラを登場させる
    [m_enterCharacter characterId="&tf.cc.characterId" face="&tf.cc.face" side="&tf.cc.side"]

  [endif]
[endmacro]


; 登場マクロ
; 現在は登場していないキャラを登場させる
; @param characterId 登場させたいキャラのキャラクターID。必須。
; @param face 登場させたいキャラのface。必須。
; @param side そのキャラがデフォルトで登場する位置。必須。
[macro name="m_enterCharacter"]

  [eval exp="console.log('★enter ' + mp.characterId)"]

  ; 表情を変える
  ; MEMO 「そのキャラの今の表情」を取得可能であれば、「今の表情と違う場合のみ」にしたい。が、HTML要素内に表情の情報がimgのパスくらいしかなかったので無理そう。
  [chara_mod name="&mp.characterId" face="&mp.face" time="1" wait="false"]

  ; sideに合わせて、キャラクター画像を移動させるべき量を格納する
  [eval exp="tf.moveLeft = '-=1000'" cond="mp.side == 'right'"]
  [eval exp="tf.moveLeft = '+=1000'" cond="mp.side == 'left'"]

  ; sideがrightなら画面右から右側に、leftなら画面左から左側にスライドインしてくる
  [chara_move name="&mp.characterId" time="600" anim="true" left="&tf.moveLeft" wait="false" effect="easeOutExpo"]

  ; 表示キャラオブジェクトを更新する
  [eval exp="f.displayedCharacter[mp.side] = new DisplayedCharacterSingle(true, mp.characterId, mp.face)"]

[endmacro]


; 退場マクロ
; 現在登場しているキャラを退場させる
; TODO 襲撃死時とPCの処刑時の呼び出しで、フェードアウトしない。NPCの処刑時はする。ここというより、呼び出し元の処理順が問題かも。
; @param characterId 退場させたいキャラのキャラクターID。必須。
[macro name="m_exitCharacter"]

  ; そのキャラがどちらのサイドに表示されているかを取得する
  [iscript]
    tf.side = (function(){
      if (f.displayedCharacter.right.isDisplay && f.displayedCharacter.right.characterId == mp.characterId) return 'right';
      if (f.displayedCharacter.left.isDisplay  && f.displayedCharacter.left.characterId  == mp.characterId) return 'left';
      return null;
    })();
  [endscript]
  ; 現在そのキャラが表示されていないなら、何もせず終了
  [jump target="*end_m_exitCharacter" cond="tf.side === null"]

  [eval exp="console.log('★exit ' + mp.characterId)"]

  ; そのキャラをデフォルトの位置に移動させる
  [chara_move name="&mp.characterId" time="600" left="&f.defaultPosition[mp.characterId].left" wait="false"]

  ; 表示キャラオブジェクトを更新する
  [eval exp="f.displayedCharacter[tf.side] = new DisplayedCharacterSingle()"]

  *end_m_exitCharacter
[endmacro]
