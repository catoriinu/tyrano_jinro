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
[macro name="m_noticeRole"]
  [iscript]
    // 発言者名を表示するためだけにアクションオブジェクトを作成する
    f.actionObject = new Action(mp.characterId);

    tf.side = 'left';
    tf.messageStorage = './message/' + mp.characterId + '.ks';
    tf.messageTarget = '*noticeRole_' + mp.roleId;
  [endscript]

  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：真占い師で、占い実行結果を知ったときの反応
; 事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
[macro name="m_announcedFortuneTellingResult"]
  [iscript]
    tf.side = 'left';
    tf.messageStorage = './message/' + f.actionObject.characterId + '.ks';
    tf.messageTarget = '*announcedFortuneTellingResult_' + f.actionObject.result;
  [endscript]
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
  [iscript]
    tf.targetLabel = getLabelForCOFortuneTelling(f.actionObject);
    console.log(tf.targetLabel);

    tf.side = 'left';
    tf.messageStorage = './message/' + f.actionObject.characterId + '.ks';
    tf.messageTarget = '*COFortuneTelling' + tf.targetLabel;
  [endscript]

  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：アクション実行時のセリフ
; 事前にf.actionObjectにアクションオブジェクトを格納しておくこと
[macro name="m_doAction"]
  [iscript]
    tf.targetLabel = getLabelForDoAction(f.actionObject);
    console.log(tf.targetLabel);

    tf.side = 'left';
    tf.messageStorage = './message/' + f.actionObject.characterId + '.ks';
    tf.messageTarget = '*doAction' + tf.targetLabel;
  [endscript]

  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：アクション実行対象になった時のセリフ
; 事前にf.actionObjectにアクションオブジェクトを格納しておくこと
[macro name="m_doAction_reaction"]
  [iscript]
    tf.targetLabel = getLabelForDoActionReaction(f.actionObject);
    console.log(tf.targetLabel);

    tf.side = 'right';
    tf.messageStorage = './message/' + f.actionObject.targetId + '.ks';
    tf.messageTarget = '*doAction_reaction' + tf.targetLabel;
  [endscript]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：人狼で、誰を噛むか選ぶときのセリフ
; @param characterId 発言者のキャラクターID。必須
[macro name="m_chooseWhoToBite"]
  [iscript]
    // 発言者名を表示するためだけにアクションオブジェクトを作成する
    f.actionObject = new Action(mp.characterId);

    tf.side = 'left';
    tf.messageStorage = './message/' + mp.characterId + '.ks';
    tf.messageTarget = '*chooseWhoToBite';
  [endscript]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：投票により処刑対象に決まったときの反応
; @param characterId 発言者のキャラクターID。必須
[macro name="m_executed"]
  [iscript]
    // 発言者名を表示するためだけにアクションオブジェクトを作成する
    f.actionObject = new Action(mp.characterId);

    tf.side = 'left';
    tf.messageStorage = './message/' + mp.characterId + '.ks';
    tf.messageTarget = '*executed';
  [endscript]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
  [m_exitCharacter characterId="&mp.characterId"]
[endmacro]


; シーン：処刑後の反応
; @param characterId 発言者のキャラクターID。必須
; @param face 発言者の表情。（TODO）
[macro name="m_afterExecution"]
  [m_changeCharacter characterId="&mp.characterId" face="normal"]
  [m_changeFrameWithId characterId="&mp.characterId"]
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


; シーン：ゲームの勝敗判定結果を表示するシステムメッセージ
[macro name="m_displayGameOver"]
  [m_changeFrameWithId]
  #
  ゲームが終了しました。
[endmacro]

; シーン：ゲームの勝敗判定結果を表示するシステムメッセージ
; @param winnerFaction 勝利陣営。必須
[macro name="m_displayWinnerFaction"]
  [m_changeFrameWithId]
  #
  [eval exp="tf.messageStorage = './message/system.ks'"]
  [eval exp="tf.messageTarget = '*displayWinnerFaction_' + mp.winnerFaction"]
  [call storage="&tf.messageStorage" target="&tf.messageTarget"]
[endmacro]


; シーン：現在のラウンド数と次のNPCのアクションを表示するシステムメッセージ
[macro name="m_displayRoundAndNextActionInDiscussionPhase"]

  [iscript]
    // アクション実行者を判定する
    tf.tmpDoActionObject = {};
    // PCがアクションボタンでアクション指定済みならPC
    if (Object.keys(f.pcActionObject).length > 0) {
      tf.tmpDoActionObject = f.pcActionObject;
    } else if (Object.keys(f.npcActionObject).length > 0) {
      // PCがアクション未指定で、NPCでアクション実行者がいればそのNPC
      tf.tmpDoActionObject = f.npcActionObject;
    }

    // アクション予告メッセージを作成する
    tf.tmpMsg = '～誰も話そうとしていないようです～';
    if (tf.tmpDoActionObject !== {}) {
      const actorName = f.characterObjects[tf.tmpDoActionObject.characterId].name;
      tf.tmpMsg = '～' + actorName + 'が話そうとしています';
      
      if (sf.j_development.dictatorMode) {
        // 開発者用設定：独裁者モードなら、アクション実行者のアクション内容をメッセージに表示する
        const actionName = ((tf.tmpDoActionObject.actionId == ACTION_TRUST) ? '信じる' : (tf.tmpDoActionObject.actionId == ACTION_SUSPECT) ? '疑う' : '？');
        const targetName = f.characterObjects[tf.tmpDoActionObject.targetId].name;
        tf.tmpMsg += '（' + targetName + 'に' + actionName + '）～';
      } else {
        tf.tmpMsg += '～';
      }
    }
  [endscript]

  ; アクション実行者がいるなら左に表示する。いないなら左のキャラクターを退場させる
  [m_changeCharacter characterId="&tf.tmpDoActionObject.characterId" face="normal" side="left" cond="Object.keys(tf.tmpDoActionObject).length >= 1"]
  [m_exitCharacter characterId="&f.displayedCharacter.left.characterId" cond="Object.keys(tf.tmpDoActionObject).length === 0"]
  ; 右のキャラクターは必ず退場させる
  [m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]

  [m_changeFrameWithId]
  #
  ; TODO 画面上のどこかに常に、あるいはメニュー画面内に表示しておけるとベスト
  ; メモ：プレイヤーがアクション選択→発言しないを繰り返すと複数回ラウンドが表示されるが、バックログには1回分しか残らない。次に進んだときに記録されるため？
  ～ラウンド[emb exp="f.doActionCount"]/[emb exp="sf.j_development.maxDoActionCount"]～[r]

  ; アクション予告メッセージはバックログに記録しない。プレイヤーがアクション実行すると、実際にはアクションしなかったことになる可能性があるため
  [nolog]
    [emb exp="tf.tmpMsg"][p]
  [endnolog]
[endmacro]


; ～ここから個人用設定あり～

; メッセージフレームを、発言者の位置に合わせて切り替える
; 現在のフレームと同じフレームに変える場合は何もしない
; NOTICE: [m_changeCharacter]と併用する場合、[m_changeCharacter]を先に実行してf.displayedCharacterを更新しておく必要がある
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
; 同じキャラは同時に二人は出ない（ので、例えばNPC1が右側にいるときNPC1が左側に登場する場合、右側からNPC1が退場してから左側からNPC1が登場する）
; すでにそのキャラがchara_newで登録,およびその表情がchara_faceで登録済みである前提とする。
; @param characterId 登場させたいキャラのキャラクターID。必須。
; @param face 登場させたいキャラのface。未指定の場合は表情は変えない。
; @param side 画面のどちら側に登場させるか。'left'で左側。それ以外または未指定の場合は右側。
[macro name="m_changeCharacter"]
  [iscript]
    // マクロの引数を一時変数に保持しておく。別マクロを呼ぶ際にmpが上書きされ、戻ってきたときに参照できなくなるため
    tf.cc = clone(mp)

    // exitCharacterマクロでtf.side変数を上書きしてしまうため、tc.cc配下に保持しておく
    tf.cc.counterSide = 'right';
    if (!(('side' in tf.cc) && tf.cc.side == 'left')) {
      tf.cc.side = 'right';
      tf.cc.counterSide = 'left';
    }
  [endscript]

  ; 自分自身がすでに登場済み、かつ逆側に登場させる場合、まず自分自身を退場させる
  [if exp="f.displayedCharacter[tf.cc.counterSide].characterId == tf.cc.characterId"]
    [m_exitCharacter characterId="&tf.cc.characterId"]
  [endif]

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

  ; sideに合わせて、キャラクター画像を移動させるべき量を格納する
  [eval exp="tf.moveLeft = '-=1000'" cond="mp.side == 'right'"]
  [eval exp="tf.moveLeft = '+=1000'" cond="mp.side == 'left'"]

  ; sideがleftの場合のみ、一度leftOnDefautLeftの位置に移動させる。デフォルトの待機位置がleftOnDefautRightなので。
  [chara_move name="&mp.characterId" time="1" left="&f.defaultPosition[mp.characterId].leftOnDefautLeft" wait="true" cond="mp.side == 'left'"]

  ; 表情を変える
  ; MEMO 「そのキャラの今の表情」を取得可能であれば、「今の表情と違う場合のみ」にしたい。が、HTML要素内に表情の情報がimgのパスくらいしかなかったので無理そう。
  [chara_mod name="&mp.characterId" face="&mp.face" time="1" wait="false"]

  ; 画面の内側向きになるように画像の向きを変える 
  [chara_mod name="&mp.characterId" reflect="false" time="1" wait="false" cond="mp.side == 'right'"]
  [chara_mod name="&mp.characterId" reflect="true" time="1" wait="false" cond="mp.side == 'left'"]

  ; sideがrightなら画面右から右側に、leftなら画面左から左側にスライドインしてくる
  [chara_move name="&mp.characterId" time="600" anim="true" left="&tf.moveLeft" wait="false" effect="easeOutExpo"]

  ; 表示キャラオブジェクトを更新する
  [eval exp="f.displayedCharacter[mp.side] = new DisplayedCharacterSingle(true, mp.characterId, mp.face)"]

[endmacro]


; 退場マクロ
; 現在登場しているキャラを退場させる
; @param characterId 退場させたいキャラのキャラクターID。必須。
; @param time 退場にかかる時間（[chara_move]のtime）。指定しなければデフォルト600ミリ秒
[macro name="m_exitCharacter"]
  [iscript]
    // timeのデフォルト値設定
    if (!('time' in mp)) {
      mp.time = 600;
    }

    // そのキャラがどちらのサイドに表示されているかを取得する
    tf.side = (function(){
      if (f.displayedCharacter.right.isDisplay && f.displayedCharacter.right.characterId == mp.characterId) return 'right';
      if (f.displayedCharacter.left.isDisplay  && f.displayedCharacter.left.characterId  == mp.characterId) return 'left';
      return null;
    })();
  [endscript]
  ; 現在そのキャラが表示されていないなら、何もせず終了
  [jump target="*end_m_exitCharacter" cond="tf.side === null"]

  [eval exp="console.log('★exit ' + mp.characterId)"]

  ; そのキャラをデフォルトの待機位置に移動させる
  [chara_move name="&mp.characterId" time="&mp.time" left="&f.defaultPosition[mp.characterId].leftOnDefautRight" wait="false"]

  ; 表示キャラオブジェクトを更新する
  [eval exp="f.displayedCharacter[tf.side] = new DisplayedCharacterSingle()"]

  *end_m_exitCharacter
[endmacro]


; キャラクター表示状態リセットマクロ
; 右のキャラクターを退場させ、（生きているなら）プレイヤーキャラクターをノーマルの表情で左に登場させる
; フェイズの転換時にリセットするために使う
[macro name="m_resetDisplayCharacter"]
  [m_exitCharacter characterId="&f.displayedCharacter.right.characterId"]
  [m_exitCharacter characterId="&f.displayedCharacter.left.characterId"]
  ;[m_changeCharacter characterId="&f.playerCharacterId" face="normal" side="left" cond="f.characterObjects[f.playerCharacterId].isAlive"]
  ;[m_exitCharacter characterId="&f.displayedCharacter.left.characterId" cond="!(f.characterObjects[f.playerCharacterId].isAlive)"]
[endmacro]


; 
; @param characterId 発言者のキャラクターID。指定しない場合はnameが必須になる。
; @param name 発言者のキャラクター名。characterIdが指定されている場合そちらが優先。
; @param face 発言者のface。指定がなければそのまま。
; @param side 発言者が登場する位置。'left'で左側。それ以外または未指定の場合は右側。
; NOTE 使いづらかったら変える。
[macro name="m_changeCharacterFrameName"]

  [iscript]
    // マクロの引数を一時変数に保持しておく。別マクロを呼ぶ際にmpが上書きされ、戻ってきたときに参照できなくなるため
    tf.ccfn = clone(mp);

    if (!('name' in tf.ccfn) && !('name' in tf.ccfn)) {
      alert('characterId, nameともに未指定です');
    }

    // マクロの引数にcharacterIdが未指定なら、nameをもとに取得してくる
    if (!('characterId' in tf.ccfn)) {
      tf.ccfn.characterId = getCharacterIdByName(tf.ccfn.name);
    }

    tf.ccfn.side = (('side' in tf.ccfn) && tf.ccfn.side == 'left') ? 'left' : 'right';

    // マクロの引数にnameが未指定なら、characterIdをもとに取得してくる
    if (!('name' in tf.ccfn)) {
      tf.ccfn.name = getNameByCharacterId(tf.ccfn.characterId);
    }
    // 発言者表示の#に、f.speaker（＝人狼ゲーム中の発言者名格納変数。独裁者モードの場合、発言者の役職を追加表示できる）を使えるかを判定する。
    if (('speaker' in f) && (tf.ccfn.name in f.speaker)) {
      // TODO 人狼ゲーム終了時やタイトル画面表示時などに初期化しておかないと、前の人狼ゲーム時の役職が表示されそう
      tf.ccfn.speaker = f.speaker[tf.ccfn.name];
    } else {
      // 使えない場合はnameをそのまま表示する
      tf.ccfn.speaker = tf.ccfn.name;
    }

  [endscript]

  ; マクロの引数にfaceが未指定なら、faceを渡さない=表情はそのままにする。
  [if exp="'face' in tf.ccfn"]
    [m_changeCharacter characterId="&tf.ccfn.characterId" side="&tf.ccfn.side" face="&tf.ccfn.face"]
  [else]
    [m_changeCharacter characterId="&tf.ccfn.characterId" side="&tf.ccfn.side"]
  [endif]
  [m_changeFrameWithId characterId="&tf.ccfn.characterId"]
  # &tf.ccfn.speaker

[endmacro]
