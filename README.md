# tyrano_jinro
『汝は人狼なりや？』をティラノスクリプト製のノベルゲームとして制作・プレイするためのプラグインやマクロ集、  
およびその実装例としてのサンプルゲームです。  
  
※まだ製作中なので利用はお控えください。  
完成の暁にはティラノスクリプト用プラグイン、マクロとして利用いただけるようにいたします。
  
# 動作確認バージョン
- Windows10
- ティラノスクリプト v506e
- ティラノスタジオ v110c 
  

# 更新履歴
- ver.0.2(20210704)
  - [messageマクロ](./data/scenario/messageMacros.ks)と[messageサブルーチン](data/scenario/message)にセリフやシステムメッセージを集約
  - [playJinro.ks](./data/scenario/playJinro.ks)（scene1.ksから名称変更）をリファクタリング。キャラクターIDに依存していた処理をほぼ脱却
  - PCの役職を選択できる画面を追加（将来のステージ選択機能の仮実装）
- ver.0.1(20210627)
  - ある程度動いたところで初版公開
  

# TODO
- [x] messageマクロ・サブルーチンへセリフを集約  
- [x] COフェイズの処理をより簡潔に  
- [ ] COフェイズ中の視点整理とNPCのCO意思の計算タイミングの再考（カットインのタイミングに被せられるか？）  
- [ ] 視点の破綻後の扱いについて決める  
- [ ] NPCの思考と行動の雛形制作  
- [ ] 議論フェイズの制作  
- [ ] 投票フェイズの制作  
- [ ] 霊能者の実装（できれば）  
- [ ] 狩人の実装（できれば）  
- [ ] NPCの思考の強化学習（マジで言ってんの？）  
- [ ] ファイル構成の再検討  
- [ ] docsやコメントの補完  
- [ ] リファクタリング  
and more....
  

# 製作者
香取犬  
Twitter：[@catoriinu8190](https://twitter.com/catoriinu8190)  
ブログ：[ハイグレ郵便局 香取犬支店](http://highglepostoffice.blog.fc2.com/)  
  

# special thanks
[https://github.com/ShikemokuMK/tyranoscript](https://github.com/ShikemokuMK/tyranoscript)  
[https://webkatu.com/201407132011-clone-function-to-deepcopy-object/](https://webkatu.com/201407132011-clone-function-to-deepcopy-object/)  
[https://ameblo.jp/personwritep/entry-12495099049.html](https://ameblo.jp/personwritep/entry-12495099049.html)
