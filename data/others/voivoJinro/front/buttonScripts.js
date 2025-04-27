function setButtonSe() {
  // ボタンにカーソルが乗ったときの処理
  $(".button-se-hover").hover(
    function(e) {
      console.log("button-se-hover clicked");
      // glinkのenterse属性だと細かい設定ができないため独自に設定（特にbufがデフォルトだと他で鳴っている効果音を打ち消してしまう）
      TYRANO.kag.ftag.startTag(
        "playse",
        {
          storage: "botan_b34.ogg",
          volume: 40,
          buf: 1
        }
      );
      console.log("button-se-hover end");
    },
    function(e) {
      // ボタンが離れても何もしない。第二引数を明記しておかないと、離れたときも乗ったときと同じ処理が発生する
    }
  );
/**
  $(".button-se-select").click(function(e) {
    console.log("button-se-select clicked");
    TYRANO.kag.ftag.startTag(
      "stopse",
      {
        buf: 1
      }
    );
    TYRANO.kag.ftag.startTag(
      "playse",
      {
        storage: "se/button13.ogg",
        volume: 40,
        buf: 1
      }
    );
    console.log("button-se-select clicked end");
  });

  $(".button-se-cancel").click(function(e) {
    TYRANO.kag.ftag.startTag(
      "playse",
      {
          storage: "se/button15.ogg",
          volume: 40,
          buf: 1
      }
    );
  });
*/
}