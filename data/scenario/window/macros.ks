; 開始条件達成通知ウィンドウ表示用マクロ
[macro name="w_noticeStartingSituation"]
  [iscript]
    tf.noNeedNoticeStartingSituation = false;
    // 以下のいずれかに該当する場合は、開始条件達成通知ウィンドウを表示しない
    if (
      // f.displayEpisode（addChapterListサブルーチン内で設定）が設定されていない場合
      !f.displayEpisode ||
      // エピソード進捗ステータスが既に「3：解決編まで解放済み」の場合（同様の判定で、解決編も再生しない）
      getTheaterProgress(f.displayEpisode.pageId, f.displayEpisode.episodeId) === EPISODE_STATUS.OUTRO_UNLOCKED ||
      // インストラクションを行う場合は開始条件達成通知ウィンドウを表示したくないので、そのためのフラグが立っている場合
      tf.needAddInstruction
    ) {
      tf.noNeedNoticeStartingSituation = true;
    }
  [endscript]
  [jump target="*end_w_noticeStartingSituation" cond="tf.noNeedNoticeStartingSituation"]

  ; 表示開始前の準備
  [j_saveFixButton buf="window"]
  [j_clearFixButton]
  [layopt layer="message0" visible="false"]
  [eval exp="f.currentFrame = null"]
  [filter layer="0" blur="10"]
  [filter layer="base" blur="5"]

  ; 表示する
  [call storage="window/noticeStartingSituation.ks" target="*start"]

  ; 表示終了後の後片付け
  [free_filter layer="0"]
  [free_filter layer="base"]
  [layopt layer="message0" visible="true"]
  [j_loadFixButton buf="window"]

  *end_w_noticeStartingSituation
[endmacro]