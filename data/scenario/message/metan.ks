; 四国めたんのmessageサブルーチン

; 呼び方サブルーチン
; 事前にtf.characterIdToCallにcharacterIdを入れてから、このサブルーチンを呼び出す
; このmessageサブルーチンのキャラクターが、tf.characterIdToCallのキャラクターを呼ぶ際の二人称をtf.calledCharacterNameに格納する
; キャラクターごとの差異をなくすため、自分自身のIDが渡された場合は一人称を入れる
*changeIdToCallName
  [iscript]
    tf.calledCharacterName = (function(characterId) {
      const calledCharacterNameObject = {
        [CHARACTER_ID_ZUNDAMON]: 'ずんだもん',
        [CHARACTER_ID_METAN]:    'わたくし',
        [CHARACTER_ID_TSUMUGI]:  'つむぎさん',
        [CHARACTER_ID_HAU]:      'はうさん',
        [CHARACTER_ID_RITSU]:    'リツさん',
      }
      return calledCharacterNameObject[characterId];
  }(tf.characterIdToCall));
  [endscript]
[return]

; COFortuneTelling_{result}
; シーン：前日の占い結果をCOするときのセリフ
; NOTE:事前にf.actionObjectに占いのアクションオブジェクトを格納しておくこと
; TODO：
; 役職COと結果COで差分を付けられるようにする。（「自分が占い師だ」「昨日の占い結果は～」）
; 役職COのとき、自分の前にCO済みの占い師がいる場合「自分こそが占い師だ」と主張することができるようにする
; 結果COのとき、自分の前のCO結果によって反応を変えられるようにする（同じ相手を占った、違う相手を占った）
*COFortuneTelling_true
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/metan/005_四国めたん（ノーマル）_聞きなさい。Xは人…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/metan/006_四国めたん（ノーマル）_聞きなさい。Xは人…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/metan/007_四国めたん（ノーマル）_聞きなさい。Xは人…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/metan/008_四国めたん（ノーマル）_聞きなさい。Xは人…(1).ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
[call target="changeIdToCallName"]

聞きなさい。[emb exp="tf.calledCharacterName"]は人狼だったわ！[r]
ふふっ、わたくしの魔眼に見抜けぬものはないわ。[p]
[stopse]
[return]

*COFortuneTelling_false
[if exp="f.actionObject.targetId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/metan/016_四国めたん（ノーマル）_聞きなさい。Xは人…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_METAN"]

[elsif exp="f.actionObject.targetId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/metan/017_四国めたん（ノーマル）_聞きなさい。Xは人…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_HAU"]
[playse storage="chara/metan/018_四国めたん（ノーマル）_聞きなさい。Xは人…(1).ogg" loop="false" sprite_time="50-20000"]
[elsif exp="f.actionObject.targetId == CHARACTER_ID_RITSU"]
[playse storage="chara/metan/019_四国めたん（ノーマル）_聞きなさい。Xは人…(1).ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = f.actionObject.targetId"]
[call target="changeIdToCallName"]

聞きなさい。[emb exp="tf.calledCharacterName"]は人狼ではなかったわ。[r]
信頼の証に、同盟を結ばせてもらえるかしら。[p]
[stopse]
[return]


; doAction_{actionId}
; NOTE：事前にtf.selectedCharacterIへの格納（PCならアクションボタンの実行、NPCならTODO）が必要。
; シーン：「疑う」アクション実行時
*doAction_suspect
[if exp="tf.selectedCharacterId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/metan/015_四国めたん（ノーマル）_X、そろそろ認めた….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_METAN"]

[elsif exp="tf.selectedCharacterId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/metan/016_四国めたん（ノーマル）_X、そろそろ認めた….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_HAU"]
[playse storage="chara/metan/017_四国めたん（ノーマル）_X、そろそろ認めた….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_RITSU"]
[playse storage="chara/metan/018_四国めたん（ノーマル）_X、そろそろ認めた….ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

[emb exp="tf.calledCharacterName"]、そろそろ認めたらどうかしら？[r]
自分が人狼だということを。[p]
[stopse]
[return]

; シーン：「信じる」アクション実行時
*doAction_trust
[if exp="tf.selectedCharacterId == CHARACTER_ID_ZUNDAMON"]
[playse storage="chara/metan/019_四国めたん（ノーマル）_X、わたくしと共に….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_METAN"]

[elsif exp="tf.selectedCharacterId == CHARACTER_ID_TSUMUGI"]
[playse storage="chara/metan/020_四国めたん（ノーマル）_X、わたくしと共に….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_HAU"]
[playse storage="chara/metan/021_四国めたん（ノーマル）_X、わたくしと共に….ogg" loop="false" sprite_time="50-20000"]
[elsif exp="tf.selectedCharacterId == CHARACTER_ID_RITSU"]
[playse storage="chara/metan/022_四国めたん（ノーマル）_X、わたくしと共に….ogg" loop="false" sprite_time="50-20000"]
[endif]

[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

[emb exp="tf.calledCharacterName"]、わたくしと共にこの苦難を乗り越えましょう。[p]
[stopse]
[return]

; シーン：「聞き出す」アクション実行時
*doAction_ask
[eval exp="tf.characterIdToCall = tf.selectedCharacterId"]
[call target="changeIdToCallName"]

状況が混沌としてきたわね……。[r]
[emb exp="tf.calledCharacterName"]の考えを聞かせてくれるかしら？[p]
[return]


; doAction_reaction_{actionId}
; シーン：「疑う」アクションの実行対象になった時
*doAction_reaction_suspect
[playse storage="chara/metan/024_四国めたん（ノーマル）_心外ね。あなたはも….ogg" loop="false" sprite_time="50-20000"]

心外ね。あなたはもう少し賢いと思っていたのだけど。[p]
[stopse]
[return]

; シーン：「信じる」アクションの実行対象になった時
*doAction_reaction_trust
[playse storage="chara/metan/025_四国めたん（ノーマル）_べ、別に嬉しくなん….ogg" loop="false" sprite_time="50-20000"]

べ、別に嬉しくなんてないわ……！[p]
[stopse]
[return]

; シーン：「聞き出す」アクションの実行対象になった時
*doAction_reaction_ask
  わたくしに聞かないでちょうだい！[p]
[return]


; executed
; シーン：投票により処刑対象に決まったときの反応
*executed
[playse storage="chara/metan/027_四国めたん（ノーマル）_これがわたくしの運….ogg" loop="false" sprite_time="50-20000"]

これがわたくしの運命なら、受け入れるしかないのでしょうね。[p]
[stopse]
[return]


; afterExecution
; シーン：処刑後の反応
; TODO：どのように呼び出すかから考えること
*afterExecution
  （未作成）[p]
[return]
