; PCの占いサブルーチン
*fortuneTellingForPC

; 占い候補のキャラオブジェクト配列を取得
[eval exp="tf.candidateObjects = f.characterObjects[f.playerCharacterId].role.getCandidateObjects(f.playerCharacterId)"]

; 占い候補からボタンを生成。ボタン入力を受け付ける
[call target="*glinkFromCandidateObjects"]

; 占い実行。占い結果をtf.todayResultObjectに格納する
[j_fortuneTelling fortuneTellerId=&f.playerCharacterId characterId=&tf.targetCharacterId]

[return]


; PCの騙り占いサブルーチン
; 夜時間には直接呼び出してよい。
; 昼時間に騙り占い師COするために呼び出すときは、*fakeFortuneTellingCOMultipleDaysForPCから呼び出すこと
; （上記サブルーチン内で、tf.fortuneTelledDayの格納を行っておく必要がある）
*fakeFortuneTellingForPC

; 夜時間の呼び出しであれば、占い指定日に当日を格納する
[if exp="!f.isDaytime"]
  [eval exp="tf.fortuneTelledDay = f.day"]
[endif]

; 騙り占い候補のキャラオブジェクト配列を取得。指定された日の夜時間開始時の生存者を参照する。
[eval exp="tf.candidateObjects = f.characterObjects[f.playerCharacterId].fakeRole.getCandidateObjects(f.playerCharacterId, tf.fortuneTelledDay)"]

; 騙り占い候補からボタンを生成。ボタン入力を受け付ける
[call target="*glinkFromCandidateObjects"]

; 騙り占い先のキャラクター名をメッセージに表示する
#
[emb exp="f.characterObjects[tf.targetCharacterId].name"]を……

; 騙り結果入力を受け付ける
[eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (0 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
[glink  color="black" size="28"  x="360"  width="500"  y="&tf.y"  text="●（人狼だった）とCOする"  target="*fakeResultBlack"  ]
[eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (1 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
[glink  color="white" size="28"  x="360"  width="500"  y="&tf.y"  text="○（人狼ではなかった）とCOする"  target="*fakeResultWhite"  ]
[s]

; 騙り占い実行。占い結果をtf.todayResultObjectに格納する
*fakeResultBlack
  [j_fortuneTelling fortuneTellerId="&f.playerCharacterId" characterId="&tf.targetCharacterId" result="true" day="&tf.fortuneTelledDay"]
  人狼だったと言うことにした。[p]
  @jump target="*fakeFortuneTellingForPC_end"

*fakeResultWhite
  [j_fortuneTelling fortuneTellerId="&f.playerCharacterId" characterId="&tf.targetCharacterId" result="false" day="&tf.fortuneTelledDay"]
  人狼ではなかったと言うことにした。[p]
  @jump target="*fakeFortuneTellingForPC_end"

*fakeFortuneTellingForPC_end

[return]


; tf.candidateObjectsに入っているキャラクター名をボタン化し、押したcharacterIdをtf.targetCharacterIdに格納するサブルーチン
*glinkFromCandidateObjects

; 選択肢ボタン表示ループ
[eval exp="tf.buttonCount = tf.candidateObjects.length"]
[eval exp="tf.cnt = 0"]
*loopstart
  ; y座標計算。範囲を(ボタン数+1)等分し、上限点と下限点を除く点に順番に配置することで、常に間隔が均等になる。式 = (範囲下限 * (tf.cnt + 1)) / (tf.buttonCount + 1) + (範囲上限)
  [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (tf.cnt + 1)) / (tf.buttonCount + 1) + BUTTON_RANGE_Y_UPPER"]
  ; ボタン押下時のターゲット文字列は、事前に変数化して渡すこと。
  ; ※target内では変数は使えない。また、targetを固定にしてexpで押下したボタンを判定しようとすると、expは押下時に評価されるためcntと併用すると最後の要素番目しか取れないのでNG。
  [eval exp="tf.glink_target = '*target_' + tf.candidateObjects[tf.cnt].characterId"]
  [glink  color="blue" size="28" width="300" y="&tf.y" name="glink_center,charahover" text="&f.speaker[tf.candidateObjects[tf.cnt].name]" target="&tf.glink_target" ]
  
  ; ホバー時用の画像を画面外に準備しておく TODO ボタンごとにキャラに合わせた画像を表示する
  [image layer="1" x="1280" y="80" visible="true" storage="01_sad.png" name="01"]
  
  [iscript]
    ; ボタンの横軸を画面の中央に調整（ループ外で一括でやるとボタンが動く瞬間が見えてしまうため、ループ内で動かす）
    $(".glink_center").css("left","50%");
    $(".glink_center").css("transform","translateX(-50%)");
  [endscript]

  [jump target="*loopend" cond="tf.cnt == (tf.buttonCount - 1)"]
  [eval exp="tf.cnt++"]
  [jump target="*loopstart"]
*loopend

[iscript]
  ; ボタンにカーソルが乗ったときにキャラ画像をスライドイン、離れたときに画面外へ移動。TODO ボタンごとにキャラに合わせた画像を表示する
  $(".charahover").hover(
    function(e) {
      console.log('enter');
      TYRANO.kag.ftag.startTag("stopanim",{name:"01"});
      TYRANO.kag.ftag.startTag("anim",{name:"01",left:850,time:350});
      ; glinkのenterse属性だと細かい設定ができないため独自に設定（特にbufがデフォルトだと他で鳴っている効果音を打ち消してしまう）
      TYRANO.kag.ftag.startTag("playse",{storage:"botan_b34.ogg",volume:60,buf:1});
    },
    function(e) {
      console.log('leave');
      TYRANO.kag.ftag.startTag("stopanim",{name:"01"});
      TYRANO.kag.ftag.startTag("anim",{name:"01",left:1280,time:0});
    }
  );
[endscript]
[s]

; 押下されたキャラクターのcharacterIdをtf.targetCharacterIdに格納する
*target_ai
  [eval exp="tf.targetCharacterId = CHARACTER_ID_AI"]
  [jump target="*glinkFromCandidateObjects_end"]

*target_hiyori
  [eval exp="tf.targetCharacterId = CHARACTER_ID_HIYORI"]
  [jump target="*glinkFromCandidateObjects_end"]

*target_futaba
  [eval exp="tf.targetCharacterId = CHARACTER_ID_FUTABA"]
  [jump target="*glinkFromCandidateObjects_end"]

*target_miki
  [eval exp="tf.targetCharacterId = CHARACTER_ID_MIKI"]
  [jump target="*glinkFromCandidateObjects_end"]

*target_dummy
  [eval exp="tf.targetCharacterId = CHARACTER_ID_DUMMY"]
  [jump target="*glinkFromCandidateObjects_end"]

*glinkFromCandidateObjects_end

[return]


; 全キャラ分の占い結果CO文章を表示するサブルーチン
; サブルーチンの引数として、以下の変数を格納しておくこと。
; tf.fortuneTellingHistoryObject = COする占い師の占い履歴オブジェクト
; tf.fortuneTellerId = COする占い師のcharacterId
; 関連マクロ：[j_fortuneTellingHistoryObjectThatDay]、[j_COfortuneTellingResultLastNight]
; TODO とりあえずここのファイルに置いておくが、全キャラの占いCOに使えるのでUtil的なファイルのほうが良いと思う。
*COfortuneTellingResult

; ホバー時用の画像を画面外からスライドインさせる TODO ボタンごとにキャラに合わせた画像を表示する
[image layer="1" x="1280" y="80" visible="true" storage="01_sad.png" name="01"]
[anim name="01" left=850 time=350]

; アイ
[if exp="tf.fortuneTellerId == CHARACTER_ID_AI"]

  [if exp="tf.fortuneTellingHistoryObject.result"]
    [eval exp="tf.fortuneTellingResultMessage = '人狼だった……。'"]
  [else]
    [eval exp="tf.fortuneTellingResultMessage = '人狼じゃなかった。'"]
  [endif]

  # &f.speaker['アイ']
  昨夜は[emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]を占ったよ。[r]
  結果は[emb exp="tf.fortuneTellingResultMessage"]

; ヒヨリ
[elsif exp="tf.fortuneTellerId == CHARACTER_ID_HIYORI"]

  [if exp="tf.fortuneTellingHistoryObject.result"]
    [eval exp="tf.fortuneTellingResultMessage = 'じ、人狼だったんです……！'"]
  [else]
    [eval exp="tf.fortuneTellingResultMessage = '人狼ではなかったです。'"]
  [endif]

  # &f.speaker['ヒヨリ']
  わたし、[emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]さんを占いました。[r]
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]さんは、[emb exp="tf.fortuneTellingResultMessage"]

; フタバ
[elsif exp="tf.fortuneTellerId == CHARACTER_ID_FUTABA"]

  [if exp="tf.fortuneTellingHistoryObject.result"]
    [eval exp="tf.fortuneTellingResultMessage = '●（クロ）だよ！へへ、覚悟しなよ！'"]
  [else]
    [eval exp="tf.fortuneTellingResultMessage = '○（シロ）だったよ。'"]
  [endif]

  # &f.speaker['フタバ']
  占いCO！[r]
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]は[emb exp="tf.fortuneTellingResultMessage"]

; ミキ
[elsif exp="tf.fortuneTellerId == CHARACTER_ID_MIKI"]

  [if exp="tf.fortuneTellingHistoryObject.result"]
    [eval exp="tf.fortuneTellingResultMessage = '人狼だったわ！　早く吊るのよ！'"]
  [else]
    [eval exp="tf.fortuneTellingResultMessage = '人狼じゃなかったわ。'"]
  [endif]
  # &f.speaker['ミキ']
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]は[emb exp="tf.fortuneTellingResultMessage"]

; ダミー
[elsif exp="tf.fortuneTellerId == CHARACTER_ID_DUMMY"]

  [if exp="tf.fortuneTellingHistoryObject.result"]
    [eval exp="tf.fortuneTellingResultMessage = '人狼やでー！'"]
  [else]
    [eval exp="tf.fortuneTellingResultMessage = '人狼やあらへんかったわ。'"]
  [endif]

  # &f.speaker['ダミー']
  [emb exp="f.characterObjects[tf.fortuneTellingHistoryObject.characterId].name"]は[emb exp="tf.fortuneTellingResultMessage"]

[else]
  ちゃんと格納できてないのでは？[p]
[endif]

[return]


; PC用の騙り占いCOマクロ
; 初日から、指定された日付の前日の夜までを占ったことにできる。
*fakeFortuneTellingCOMultipleDaysForPC

  ; 騙り占いを行う最新の日の日付（＝前日）を入れる。（NOTE:もし指定できた方がよければ引数用変数を追加する）
  [eval exp="tf.lastDay = f.day - 1"]
  [eval exp="tf.fortuneTelledDay = 0"]
  [eval exp="tf.fortuneTelledDayMsg = '初日の夜'"]
  *fakeFortuneTellingCOMultipleDays_loopstart
    
    #
    [emb exp="tf.fortuneTelledDayMsg"]の占い先は……
    ; PCの騙り占いサブルーチンを、初日(day=0)から最新の日の日付までループ実行していく
    [call storage="./fortuneTellingForPC.ks" target="*fakeFortuneTellingForPC"]

  [jump target="*fakeFortuneTellingCOMultipleDays_loopend" cond="tf.fortuneTelledDay == tf.lastDay"]
  [eval exp="tf.fortuneTelledDay++"]
  ; 次の日用の表示メッセージ作成。昨夜の場合だけ、（昨夜）を追加してあげる。
  [eval exp="tf.fortuneTelledDayMsg = (tf.fortuneTelledDay + 1) + '日目の夜'"]
  [eval exp="tf.fortuneTelledDayMsg = tf.fortuneTelledDayMsg + '（昨夜）'" cond="tf.fortuneTelledDay == tf.lastDay"]
  [jump target="*fakeFortuneTellingCOMultipleDays_loopstart"]

  *fakeFortuneTellingCOMultipleDays_loopend

[return]
