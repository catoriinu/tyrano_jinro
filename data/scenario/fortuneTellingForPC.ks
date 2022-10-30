; PCの占いサブルーチン
*fortuneTellingForPC

  ; 占い候補のキャラオブジェクト配列を取得
  [eval exp="tf.candidateObjects = f.characterObjects[f.playerCharacterId].role.getCandidateObjects(f.playerCharacterId)"]

  ; 占い候補からボタンを生成。ボタン入力を受け付ける
  [call target="*glinkFromCandidateObjects"]

  ; 占い実行。占い結果をtf.todayResultObjectに格納する
  [j_fortuneTelling fortuneTellerId="&f.playerCharacterId" characterId="&tf.targetCharacterId"]

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
  [m_displayFakeFortuneTellingTarget]

  ; 騙り結果入力を受け付ける
  [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (0 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
  [glink color="black" size="28" x="360" width="500" y="&tf.y" text="●（人狼だった）とCOする" target="*doFakeFortuneTelling" exp="tf.declarationResult = true"]
  [eval exp="tf.y = (BUTTON_RANGE_Y_LOWER * (1 + 1)) / (2 + 1) + BUTTON_RANGE_Y_UPPER"]
  [glink color="white" size="28" x="360" width="500" y="&tf.y" text="○（人狼ではなかった）とCOする" target="*doFakeFortuneTelling" exp="tf.declarationResult = false"]
  [s]

  ; 騙り占い実行。占い結果をtf.todayResultObjectに格納する
  *doFakeFortuneTelling
  [j_fortuneTelling fortuneTellerId="&f.playerCharacterId" day="&tf.fortuneTelledDay" characterId="&tf.targetCharacterId" result="&tf.declarationResult"]
  [m_displayFakeFortuneTellingResult result="&tf.declarationResult"]

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
  [eval exp="tf.glink_name = 'glink_center,charahover,' + 'chara_' + tf.candidateObjects[tf.cnt].characterId"]
  [glink color="blue" size="28" width="300" y="&tf.y" name="&tf.glink_name" text="&f.speaker[tf.candidateObjects[tf.cnt].name]" target="&tf.glink_target"]
  
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
  ; ボタンにカーソルが乗ったときにキャラ画像をスライドイン、離れたときに画面外へ移動。
  $(".charahover").hover(
    function(e) {
      ; ホバーしたボタンのclass属性の中から、ボタン生成時に付与しておいたcharacterId部分を抽出する
      const classList = $(this).attr("class").split(" ");
      const enterCharacterId = classList.find(className => className.match(/^chara_(.*)$/)).match(/^chara_(.*)$/)[1];
      
      ; 表示中のキャラを画面外に出してから、ホバーされたキャラを登場させる
      changeCharacter(enterCharacterId, 'normal', f.defaultPosition[enterCharacterId].side);
      
      ; glinkのenterse属性だと細かい設定ができないため独自に設定（特にbufがデフォルトだと他で鳴っている効果音を打ち消してしまう）
      TYRANO.kag.ftag.startTag("playse",{storage:"botan_b34.ogg",volume:60,buf:1});
    },
    function(e) {
      if (typeof f.rightSideCharacterId != 'undefined') {
        exitCharacter(
          f.rightSideCharacterId,
          f.defaultPosition[f.rightSideCharacterId].side,
          f.defaultPosition[f.rightSideCharacterId].left
        );
      }

    }
  );
[endscript]
[s]

; 押下されたキャラクターのcharacterIdをtf.targetCharacterIdに格納する
; TODO キャラを増やすたびにラベルを増やさないで済むように修正したい
; TODO tf.targetCharacterId = enterCharacterIdするだけで済みそう。そうしたらtf.glink_targetの定義も不要になりそう。後で直す。
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

*target_zundamon
  [eval exp="tf.targetCharacterId = CHARACTER_ID_ZUNDAMON"]
  [jump target="*glinkFromCandidateObjects_end"]

*target_metan
  [eval exp="tf.targetCharacterId = CHARACTER_ID_METAN"]
  [jump target="*glinkFromCandidateObjects_end"]

*target_tsumugi
  [eval exp="tf.targetCharacterId = CHARACTER_ID_TSUMUGI"]
  [jump target="*glinkFromCandidateObjects_end"]

*target_hau
  [eval exp="tf.targetCharacterId = CHARACTER_ID_HAU"]
  [jump target="*glinkFromCandidateObjects_end"]

*target_ritsu
  [eval exp="tf.targetCharacterId = CHARACTER_ID_RITSU"]
  [jump target="*glinkFromCandidateObjects_end"]

*glinkFromCandidateObjects_end
; 選択した（＝最後のボタンホバー時に表示していた）キャラクターを退場させる
; TODO TypeError: Cannot read property 'side' of undefinedになる。rightSideCharacterIdがnullと思われる。
; ボタン押下直後にhoverが外れたときのルートに入り、exitCharacter()済みになっているのかも。だとするとなぜ退場していないのかが気になるが……。
; [m_exitCharacter characterId="tf.targetCharacterId"]

[return]


; 未使用サブルーチン
; 全キャラ分の占い結果CO文章を表示するサブルーチン
; サブルーチンの引数として、以下の変数を格納しておくこと。
; tf.fortuneTellingHistoryObject = COする占い師の占い履歴オブジェクト
; tf.fortuneTellerId = COする占い師のcharacterId
; 関連マクロ：[j_fortuneTellingHistoryObjectThatDay]、[j_COfortuneTellingResultLastNight]
; TODO とりあえずここのファイルに置いておくが、全キャラの占いCOに使えるのでUtil的なファイルのほうが良いと思う。
*COfortuneTellingResult
  COfortuneTellingResultサブルーチンは削除済（念のためしばらく置いておく）[p]
[return]


; PC用の騙り占いCOマクロ
; 初日から、指定された日付の前日の夜までを占ったことにできる。
*fakeFortuneTellingCOMultipleDaysForPC

  ; 騙り占いを行う最新の日の日付（＝前日）を入れる。（NOTE:もし指定できた方がよければ引数用変数を追加する）
  [eval exp="tf.lastDay = f.day - 1"]
  [eval exp="tf.fortuneTelledDay = 0"]
  [eval exp="tf.fortuneTelledDayMsg = '初日の夜'"]
  *fakeFortuneTellingCOMultipleDays_loopstart
    
    [m_fortuneTelledDayMsg]
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
