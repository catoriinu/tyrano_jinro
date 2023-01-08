; シーン：占いCOをするか否かを判断する直前のシステムメッセージ
*askFortuneTellerCO_1
  占い師COをしますか？[p]
[return]

*askFortuneTellerCO_2
  占い結果COをしますか？[p]
[return]

*askFortuneTellerCO_3
  騙り占い師COをしますか？[r]
  （前日夜までの占い結果の偽装も行います）[p]
[return]

*askFortuneTellerCO_4
  騙り占い結果COをしますか？[r]
  （前日夜の占い結果の偽装を行います）[p]
[return]


; シーン：時間が経過したときのシステムメッセージ
*timePasses_true
  夜が明けた……。[r]
  この中に人狼が潜んでいる……。[p]
[return]

*timePasses_false
  恐ろしい夜がやってきた。[p]
[return]


; シーン：占い先を決めることを促すシステムメッセージ
*askFortuneTellingTarget_true
  今夜の占い先を選択してください。[p]
[return]

*askFortuneTellingTarget_false
  今夜の占い結果の偽装をしてください。[p]
[return]


; シーン：騙り占いCO時、過去の占い履歴を決めていく際の日付を表示するシステムメッセージ
*fortuneTelledDayMsg
  [emb exp="tf.fortuneTelledDayMsg"]の占い先は……
[return]


; シーン：偽の占い対象を入力した後、それを表示しつつそのCO結果を決めることを促すシステムメッセージ
*displayFakeFortuneTellingTarget
  [emb exp="f.characterObjects[f.targetCharacterId].name"]を……
[return]


; シーン：入力した偽の占いCO結果を表示するシステムメッセージ
*displayFakeFortuneTellingResult_true
  人狼だったと言うことにした。[p]
[return]

*displayFakeFortuneTellingResult_false
  人狼ではなかったと言うことにした。[p]
[return]


; シーン：ゲームの勝敗判定結果を表示するシステムメッセージ
*displayGameOverAndWinnerCamp_villagers
  ゲームが終了しました。[p]
  村人の勝利！[p]
[return]

*displayGameOverAndWinnerCamp_werewolves
  ゲームが終了しました。[p]
  人狼の勝利！[p]
[return]

*displayGameOverAndWinnerCamp_drawByRevote
  ゲームが終了しました。[p]
  引き分けです。[p]
[return]
