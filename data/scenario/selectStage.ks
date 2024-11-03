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
; TODO: 後で消す
[j_registerParticipant characterId="&CHARACTER_ID_ZUNDAMON" roleId="&tf.pcRoleId" isplayer="true"]
[j_prepareJinroGame participantsNumber="5" preload="true"]

; メッセージ削除してゲーム開始
[freeimage layer="1" ]
[jump storage="playJinro.ks"]
