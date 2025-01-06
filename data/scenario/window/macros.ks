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
  [eval exp="f.currentFrame = null"]
  [w_openWindow hideMessage="true"]

  ; 表示する
  [call storage="window/noticeStartingSituation.ks" target="*start"]

  ; 表示終了後の後片付け
  [w_closeWindow]
  [j_loadFixButton buf="window"]

  *end_w_noticeStartingSituation
[endmacro]

; 【重要】ウィンドウ枠およびウィンドウ上に表示する要素は、layer="2"を指定すること

; ウィンドウ枠を表示する
; @param hideMessage true:メッセージ枠を隠す | false:メッセージ枠を隠さない（デフォルト）
; メモ：メッセージ枠が表示されているタイミングでウィンドウ表示したいなら隠す必要あり。メッセージ枠のレイヤーの方が上なので、ウィンドウの上に被ってしまうため。
; ウィンドウを表示するときには適切なタイミングで[trans layer="2"]すること
; 関連マクロ：[w_closeWindow]
[macro name="w_openWindow"]
  [iscript]
    f.needHideMessage = ('hideMessage' in mp) ? parseBool(mp.hideMessage) : false;
  [endscript]
  [layopt layer="message0" visible="false" cond="f.needHideMessage"]
  [filter layer="0" blur="10"]
  [filter layer="1" blur="10"]
  [filter layer="base" blur="5"]
  [image storage="theater/episodeWindow_rectangle.png" layer="2" page="back" name="windowElement" x="158.5" y="38"]
  [kanim name="windowElement" keyframe="open_episodeWindow" time="150" easing="ease-out"]
[endmacro]


; ウィンドウの表示領域の外側に、特定のターゲット（ウィンドウを閉じる目的を想定）に遷移するためのクリッカブル領域を生成する
; @param storage 遷移先のシナリオファイル。必須
; @param target 遷移先のターゲット。必須
; 関連マクロ：[w_openWindow]
[macro name="w_makeClickableAreaOuterWindow"]
  [clickable width="174" height="720" x="0" y="0" storage="&mp.storage" target="&mp.target"]
  [clickable width="174" height="720" x="1105" y="0" storage="&mp.storage" target="&mp.target"]
  [clickable width="1280" height="55" x="0" y="0" storage="&mp.storage" target="&mp.target"]
  [clickable width="1280" height="55" x="0" y="665" storage="&mp.storage" target="&mp.target"]
[endmacro]


; ウィンドウを閉じる
; @param showMessage true:メッセージ枠を表示する | false:メッセージ枠を表示しない
; 事前に[w_openWindow]を実行済みである前提。そのためメッセージ枠の表示要否のデフォルト挙動は、[w_openWindow]で隠したか否か次第とする
; 関連マクロ：[w_openWindow]
[macro name="w_closeWindow"]
  [iscript]
    f.needShowMessage = ('showMessage' in mp) ? parseBool(mp.showMessage) : f.needHideMessage;
  [endscript]
  [free_filter layer="0"]
  [free_filter layer="1"]
  [free_filter layer="base"]
  [freeimage layer="2" page="fore" time="130" wait="false"]
  [freeimage layer="2" page="back" time="130" wait="false"]
  [layopt layer="message0" visible="true" cond="f.needShowMessage"]
[endmacro]
