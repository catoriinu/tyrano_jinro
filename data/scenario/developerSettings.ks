[cm  ]
[clearfix]
[bg storage="black.png" time="300"]

[ptext layer="1" x="410" y="28" text="開発者用設定画面" color="white" edge="0x00FF00" size="60"]
[ptext layer="1" x="165" y="153" text="独裁者モード" color="white" size="36"]
[ptext layer="1" x="149" y="253" text="役職シャッフル" color="white" size="36"]
[ptext layer="1" x="55" y="353" text="議論フェイズのラウンド数" color="white" size="36"]
[ptext layer="1" x="153" y="453" text="NPCの思考方針" color="white" size="36"]
[layopt layer="1" visible="true"]

[eval exp="tf.defaultMaxDoActionCount = MAX_DO_ACTION_COUNT"]

*displayButtons
[eval exp="console.log(sf.j_development)"]

; 独裁者モード
[eval exp="tf.dictatorMode_true = sf.j_development.dictatorMode ? 'red' : 'blue'"]
[glink color="&tf.dictatorMode_true" size="30" x="610" width="80" y="150" text="ON" target="*displayButtons" exp="sf.j_development.dictatorMode = true"]
[eval exp="tf.dictatorMode_false = !sf.j_development.dictatorMode ? 'red' : 'blue'"]
[glink color="&tf.dictatorMode_false" size="30" x="995" width="80" y="150" text="OFF" target="*displayButtons" exp="sf.j_development.dictatorMode = false"]

; 役職シャッフル
[eval exp="tf.doShuffle_true = sf.j_development.doShuffle ? 'red' : 'blue'"]
[glink color="&tf.doShuffle_true" size="30" x="610" width="80" y="250" text="する" target="*displayButtons" exp="sf.j_development.doShuffle = true"]
[eval exp="tf.doShuffle_false = !sf.j_development.doShuffle ? 'red' : 'blue'"]
[glink color="&tf.doShuffle_false" size="30" x="995" width="80" y="250" text="固定" target="*displayButtons" exp="sf.j_development.doShuffle = false"]

; 議論フェイズのラウンド数
[eval exp="tf.maxDoActionCount_0 = (sf.j_development.maxDoActionCount == 0) ? 'red' : 'blue'"]
[glink color="&tf.maxDoActionCount_0" size="30" x="540" width="30" y="350" text="0" target="*displayButtons" exp="sf.j_development.maxDoActionCount = 0"]
[eval exp="tf.maxDoActionCount_default = (sf.j_development.maxDoActionCount == MAX_DO_ACTION_COUNT) ? 'red' : 'blue'"]
[glink color="&tf.maxDoActionCount_default" size="30" x="735" width="30" y="350" text="&tf.defaultMaxDoActionCount" target="*displayButtons" exp="sf.j_development.maxDoActionCount = MAX_DO_ACTION_COUNT"]
[eval exp="tf.maxDoActionCount_5 = (sf.j_development.maxDoActionCount == 5) ? 'red' : 'blue'"]
[glink color="&tf.maxDoActionCount_5" size="30" x="925" width="30" y="350" text="5" target="*displayButtons" exp="sf.j_development.maxDoActionCount = 5"]
[eval exp="tf.maxDoActionCount_10 = (sf.j_development.maxDoActionCount == 10) ? 'red' : 'blue'"]
[glink color="&tf.maxDoActionCount_10" size="30" x="1115" width="30" y="350" text="10" target="*displayButtons" exp="sf.j_development.maxDoActionCount = 10"]

; NPCの思考方針
[eval exp="tf.thinking_logical = (sf.j_development.thinking == 'logical') ? 'red' : 'blue'"]
[glink color="&tf.thinking_logical" size="30" x="540" width="100" y="450" text="論理的" target="*displayButtons" exp="sf.j_development.thinking = 'logical'"]
[eval exp="tf.thinking_default = (sf.j_development.thinking == 'default') ? 'red' : 'blue'"]
[glink color="&tf.thinking_default" size="30" x="783" width="120" y="450" text="性格準拠" target="*displayButtons" exp="sf.j_development.thinking = 'default'"]
[eval exp="tf.thinking_emotional = (sf.j_development.thinking == 'emotional') ? 'red' : 'blue'"]
[glink color="&tf.thinking_emotional" size="30" x="1045" width="100" y="450" text="感情的" target="*displayButtons" exp="sf.j_development.thinking = 'emotional'"]

; タイトルに戻る
[glink  color="black" size="30" x="480" width="210" y="550" text="タイトルに戻る" target="*return"]
[s]


*return
[eval exp="tf = {}"]

; メッセージ削除してタイトルに戻る
[freeimage layer="1" ]
[jump storage="title.ks"]
