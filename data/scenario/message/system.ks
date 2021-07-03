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
