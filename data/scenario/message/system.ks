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
  夜が明けた…。[r]
  この中に人狼が潜んでいる…。[p]
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
*fakeFortuneTelledDayMsg
  [emb exp="f.fakeFortuneTelledDayMsg"]の占い先は…
[return]

; シーン：ゲームの勝敗判定結果を表示するシステムメッセージ
*displayWinnerFaction_villagers
  村人陣営の勝利！[p]
[return]

*displayWinnerFaction_werewolves
  人狼陣営の勝利！[p]
[return]

*displayWinnerFaction_drawByRevote
  引き分けです。[p]
[return]
