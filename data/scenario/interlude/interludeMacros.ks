; @param string target
[macro name="i_playInterlude"]
  [iscript]
    // 幕間リストの中に指定のキーが存在し、かつその幕間オブジェクトのneedPlayフラグが立っている場合に、幕間を再生する
    tf.targetInterlude = (mp.target in f.interludeList) ? f.interludeList[mp.target] : null;
    tf.needPlay = (tf.targetInterlude !== null && tf.targetInterlude.needPlay);

    // 対象の幕間オブジェクトの再生フラグを折る
    if (tf.needPlay) {
      f.interludeList[mp.target].needPlay = false;
    }
  [endscript]
  [call storage="&tf.targetInterlude.storage" target="&tf.targetInterlude.target" cond="tf.needPlay"]
[endmacro]