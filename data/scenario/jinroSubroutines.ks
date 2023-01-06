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
