*preloadVoice
  ; 配列として初期化
  [eval exp="tf.preloadList = []"]

  ; 登場キャラクターのpreloadVoiceサブルーチンを呼び出していく
  [call storage="message/zundamon.ks" target="preloadVoice" cond="f.participantsIdList.includes(CHARACTER_ID_ZUNDAMON)"]
  [call storage="message/metan.ks" target="preloadVoice" cond="f.participantsIdList.includes(CHARACTER_ID_METAN)"]
  [call storage="message/tsumugi.ks" target="preloadVoice" cond="f.participantsIdList.includes(CHARACTER_ID_TSUMUGI)"]
  [call storage="message/hau.ks" target="preloadVoice" cond="f.participantsIdList.includes(CHARACTER_ID_HAU)"]
  [call storage="message/ritsu.ks" target="preloadVoice" cond="f.participantsIdList.includes(CHARACTER_ID_RITSU)"]

  ; まとめてプリロード実行
  [preload storage="&tf.preloadList" single_use="false" name="jinroVoice"]
  ; このままだと配列がでかすぎてパフォーマンスに影響があると嫌なので初期化しなおす
  [eval exp="tf.preloadList = []"]
[return]


; メッセージ準備サブルーチン
; キャラクター登場、表情差分、発言者名、登場する側、フレーム、相手キャラクターの呼び方を設定する
; 事前準備：
; f.actionObject = アクションオブジェクト。必須
; tf.reaction = リアクションの場合はtrueを指定する。通常の場合は未指定でよい
; tf.face = キャラクターの表情差分名。未指定の場合、normalになる
; tf.side = キャラクターをどちら側に登場させるか。'left'なら左側。未指定やそれ以外の場合は右側
*prepareMessage
  [iscript]
    // 表情差分名を設定
    tf.tmpFace = ('face' in tf && tf.face !== '') ? tf.face : 'normal';
    tf.face = '';

    // 自分のキャラクターID、対象キャラクターの呼び方を取得するための一時変数を設定
    if (!('reaction' in tf) || tf.reaction !== true) {
      tf.characterId = f.actionObject.characterId;
      tf.targetId = f.actionObject.targetId;
    } else {
      // リアクションをする時は、格納される変数を逆にする
      tf.characterId = f.actionObject.targetId;
      tf.targetId = f.actionObject.characterId;
    }
    tf.reaction = false;

    // 自分のmessageサブルーチンファイルを指定する
    tf.messageStorage = './message/' + tf.characterId + '.ks';

    // どちら側に登場させるかを設定
    tf.tmpSide = ('side' in tf && tf.side === 'left') ? tf.side : 'right';
    tf.side = 'right';
  [endscript]

  ; 呼び方をtf.targetNameに格納する
  [call storage="&tf.messageStorage" target="changeIdToCallName"]

  ; メッセージ処理開始
  [m_changeCharacter characterId="&tf.characterId" face="&tf.tmpFace" side="&tf.tmpSide"]
  [m_changeFrameWithId characterId="&tf.characterId"]
  # &f.speaker[f.characterObjects[tf.characterId].name]
[return]
