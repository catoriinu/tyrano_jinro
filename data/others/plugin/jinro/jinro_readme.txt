jinro
├─first // 最初にfirst.ksで必ず[loadjs]しておくファイル。loadjsの順番は以下 or 不問（この中では定義しかしないので）
│ ├─constants.js
│ ├─utils.js
│ ├─roles.js
│ └─charactors.js
│
├─macro
│ ├─constants.js
│ ├─utils.js
│ ├─role.js


─　│　┌　┐　┘　└　├　┬　┤　┴　┼


・メモ
macroのjsでは、main関数の中に処理を書いて、そのmain関数を呼び出す形で実行すること。
（複数回マクロを呼び出したとき、let, constの変数宣言が重複してエラーになるため。
　let, constはブロックスコープなので関数が終われば破棄されるため、関数内にしまっておけば再呼び出ししたときに定義済みになっていない）