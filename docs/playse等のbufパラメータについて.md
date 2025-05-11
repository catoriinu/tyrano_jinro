# 要旨
『ボイボ人狼』においてSEは以下の通りに分類して、該当するbufを設定する。  
`[playse]`のbufパラメータは必ず設定すること。未指定（デフォルト0）は管理しにくいので不可とする。

| buf | 種別 | 説明
| - | ---- | ---- |
|  0  | ボタンSE | `[button][glink]`の`clickse`,`enterse`パラメータで鳴らす効果音。またはそれに類するタイミングで`[playse]`で鳴らす効果音。
|  1  | ボイス   | キャラクターのボイスを鳴らすための`[playse]`
|  2  | その他SE | 上記以外の効果音を鳴らすための`[playse]`

# 説明
`[button][glink]`の`clickse`, `enterse`, `leavese`パラメータで設定したSEは、必ずbuf="0"で鳴らされる。  
鳴らすbufを変更することは（ティラノ側を直接修正するなり、タグを上書きするなりしない限り）できない。  
すなわち上記を前提に、他のSEをどう鳴らしたいかを決めていく必要がある。  
  
『ボイボ人狼』で鳴らすSEは「ボタンSE」「ボイス」「その他SE」に分類できる。またそれぞれで音量設定できるようにしたい。  
よって「ボイス」をbuf="1"に、「その他SE」をbuf="2"に振り分けた。  
（1と2はどちらでもいい。単に「ボイス」をbuf="1"に設定した後に、「ボタンSE」と「その他SE」を分けることにしたので「その他SE」がbuf="2"になったという経緯）  
  
# bufパラメータが存在するタグ一覧

## SE系
```
[playse]
[stopse]
[fadeinse]
[fadeoutse]
[seopt]
[changevol]
[pausese]
[resumese]
```

## BGM系
```
[playbgm]
[bgmopt]
[changevol]
[pausebgm]
[resumebgm]
```
※BGMは、現時点では複数同時に鳴らす想定はないのでbuf="0"しか使わない。  

## ボイス系
```
[voconfig]
```
※『ボイボ人狼』では`[voconfig]`関連の機能は使わない。  
人狼ゲーム中は誰が次に喋るかが不定なので使えない。  
エピソード中は使おうと思えば使えるが、ファイルのリネームの手間がかかるので使わない。  
（VOICEVOXからファイルを出力する際には全キャラまとめて連番で出力するので）

# 参考資料
[タグリファレンス(V6)](https://tyrano.jp/tag/)  
https://github.com/ShikemokuMK/tyranoscript/blob/master/tyrano/plugins/kag/kag.tag_audio.js

