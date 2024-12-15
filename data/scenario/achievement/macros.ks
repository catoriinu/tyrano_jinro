; TODO：「解決編を自動再生する」マクロに変えて、このファイルも削除する
; 達成したエピソードを画面上に表示する
[macro name="a_displayAchievedEpisodes"]

  ; 達成したエピソードがない場合、なにもせず終了する
  [jump target="*end_a_displayAchievedEpisodes" cond="f.achievedEpisodes.length < 1"]

  ; 表示開始前の準備
  [j_saveFixButton buf="achieved"]
  [j_clearFixButton]
  [layopt layer="message0" visible="false"]
  [eval exp="f.currentFrame = null"]
  [filter layer="0" blur="10"]
  [filter layer="base" blur="5"]

  [eval exp="tf.cnt = 0"]
  *loopstart
    ; 表示する
    [eval exp="f.displayEpisode = f.achievedEpisodes[tf.cnt]"]
    [call storage="achievement/achieveSituation.ks"]

    ; 達成したエピソードがまだある場合のみループ継続
    [eval exp="tf.cnt++"]
    [jump target="*loopstart" cond="tf.cnt < f.achievedEpisodes.length"]
    [jump target="*loopend"]
  *loopend

  ; 表示終了後の後片付け
  [free_filter layer="0"]
  [free_filter layer="base"]
  [layopt layer="message0" visible="true"]
  [j_loadFixButton buf="achieved"]

  *end_a_displayAchievedEpisodes
[endmacro]
