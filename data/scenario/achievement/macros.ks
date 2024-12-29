; 開始条件達成通知ウィンドウ表示用マクロ
[macro name="w_noticeStartingSituation"]
  ; f.displayEpisode（addChapterListサブルーチン内で設定）が設定されていない場合、なにもせず終了する
  [jump target="*end_w_noticeStartingSituation" cond="!f.displayEpisode"]

  ; 表示開始前の準備
  [j_saveFixButton buf="achieved"]
  [j_clearFixButton]
  [layopt layer="message0" visible="false"]
  [eval exp="f.currentFrame = null"]
  [filter layer="0" blur="10"]
  [filter layer="base" blur="5"]

  ; 表示する TODO ファイル名変更
  [call storage="achievement/achieveSituation.ks" target="*start"]

  ; 表示終了後の後片付け
  [free_filter layer="0"]
  [free_filter layer="base"]
  [layopt layer="message0" visible="true"]
  [j_loadFixButton buf="achieved"]

  *end_w_noticeStartingSituation
[endmacro]