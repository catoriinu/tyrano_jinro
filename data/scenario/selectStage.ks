[cm  ]
[clearfix]
[bg storage="blue.png" time=300]

[ptext layer="1" x="400" y="100" text="ROLE_SELECT" color="white" edge="0xFF0000" size="60" time="100"]
[layopt layer="1" visible="true"]

[glink  color="black" size="28" x="300" width="500" y="200" text="占い師" target="*test" exp="tf.pcRoleId = ROLE_ID_FORTUNE_TELLER"]
[glink  color="black" size="28" x="300" width="500" y="300" text="人狼" target="*test" exp="tf.pcRoleId = ROLE_ID_WEREWOLF"]
[glink  color="black" size="28" x="300" width="500" y="400" text="狂人" target="*test" exp="tf.pcRoleId = ROLE_ID_MADMAN"]
[glink  color="black" size="28" x="300" width="500" y="500" text="村人" target="*test" exp="tf.pcRoleId = ROLE_ID_VILLAGER"]
[s]


*test

[iscript]
  ; 村の参加キャラクターを決める（要素0番目がPCキャラとなる）
  ; TODO このメソッドは脱却して、画面の入力や選択したステージによって決められるようにしたい
  f.participantsIdList = getParticipantsIdList();

  ; 村の全役職を決める
  ; TODO 今は完全に動作確認用。改めてロジックを考えること。
  ; TODO このメソッドは脱却して、画面の入力や選択したステージによって決められるようにしたい
  let tmpRoleIdList = getVillagersRoleIdList();
  
  ; 0番目がボタンで選択したPCの役職、それ以降がNPCの役職になるようにする。
  tmpRoleIdList.splice(tmpRoleIdList.indexOf(tf.pcRoleId), 1);
  f.VillagersRoleIdList = [tf.pcRoleId].concat(tmpRoleIdList);
[endscript]

; メッセージ削除してゲーム開始
[freeimage layer="1" ]
[jump storage="playJinro.ks"]
