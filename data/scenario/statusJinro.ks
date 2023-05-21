*statusJinroMain
[cm]
[clearfix]
;[bg storage="black.png" time="100" wait="true"]
; TODO:メッセージ枠、名前表示テキストを消去し、awakeするときには再表示する
;[html_show type="status"]

[html]
<div class="main">
    <div class="window">
        <div class="infomation">
            <input type="radio" name="display" id="participants" value="participants" checked /><label class="radioLabel" for="participants">住人一覧</label>
            <input type="radio" name="display" id="voteHistory" value="voteHistory" /><label class="radioLabel" for="voteHistory">投票履歴</label>
            <input type="radio" name="display" id="fortuneTellingHistory" value="fortuneTellingHistory" /><label class="radioLabel" for="fortuneTellingHistory">占い履歴</label>
            <!--<input type="radio" name="display" id="radioMedium" value="medium" /><label class="radioLabel" for="radioMedium">霊能履歴</label>-->
            <!--<input type="radio" name="display" id="radioKnight" value="knight" /><label class="radioLabel" for="radioKnight">護衛履歴</label>-->
        </div>

        <div class="survivor">
            <!--<input type="checkbox" id="survivor" /><label class="checkLabel" for="survivor">生存者のみ</label>-->
            <!-- 名前表示/詳細表示（CO役職、死因など表示→占い結果と同じ位置でいいのでは？）-->
        </div>

        <div class="counterForVoteHistory">
            <div class="counter">
                <button type="button" class="minusButton">-</button>
                <span class="value">1</span><span>日目</span>
                <button type="button" class="plusButton">+</button>
            </div>
        </div>
    </div>
    <div class="dchStatusContainer">
        <!-- ここはdisplayCharactersHorizontallyForStatusサブルーチン内で生成する
        <div class="dchStatusBox">
            <p class="dchStatusBoxVerticalText">キャラクター名</p>
            <img src="./data/fgimage/chara/キャラクター画像" />
            <div class="infoContainer">
                <div class="infoBox line1"></div>
                <div class="infoBox line2"></div>
            </div>
        </div>
        -->
    </div>
</div>
[endhtml]

[iscript]
    $(document).ready(function() {
        // ステータス画面の初期状態設定
        // 1行目のラジオボタンは「住人一覧」に設定され、2行目は「生存者のみ」チェックボックスを表示するので、それら以外の要素は非表示にする
        $(".counterForVoteHistory").hide();

        // ラジオボタンをクリックした時の処理
        $('input[type="radio"]').click(function() {
            if ($(this).val() === "participants") {
                // 「住人一覧」をクリックした場合「生存者のみ」チェックボックスを表示する
                $('.survivor').show();
                $('.participantsInfo').show();
            } else {
                // それ以外の場合は非表示にする
                $('.survivor').hide();
                $('.participantsInfo').hide();
            }

            if ($(this).val() === "voteHistory") {
                // 「投票履歴」をクリックした場合、カウンターを表示する
                $(".counterForVoteHistory").show();
                $(".voteHistoryInfo").show();
            } else {
                // それ以外の場合は非表示にする
                $(".counterForVoteHistory").hide();
                $(".voteHistoryInfo").hide();
            }

            if ($(this).val() === "fortuneTellingHistory") {
                // 「占い履歴」をクリックした場合、占い履歴情報を表示する
                $(".fortuneTellerHistoryInfo").show();
            } else {
                // それ以外の場合は非表示にする
                $(".fortuneTellerHistoryInfo").hide();
            }
        });
    });
    // 「投票履歴」のカウンターの処理
    $('.counter').each(function() {
        const minusButton = $(this).find('.minusButton');
        const plusButton = $(this).find('.plusButton');
        const value = $(this).find('.value');

        minusButton.on('click', function() {
            let num = parseInt(value.text());
            if (num > 1) {
                value.text(num - 1);
            }
        });

        plusButton.on('click', function() {
            let num = parseInt(value.text());
            value.text(num + 1);
        });
    });
[endscript]


;[ptext layer="1" x="400" y="100" text="現在のCO状況" color="white" size="60"]

; 占い師のCO状況表示
;[ptext layer="1" x="200" y="200" text="占い師" color="white" size="40"]
;[j_getAllFortuneTellerCOText]
;[ptext layer="1" x="240" y="250" text="&tf.allFortuneTellerCOText" color="white" size="40"]

;[glink color="blue" size="28" x="300" y="500" width="500" text="元の画面に戻る" target="*awake"]
[button graphic="button/button_status_click.png" target="*awake" x="1143" y="23" width="114" height="103" enterimg="button/button_status_hover.png"]

  ; キャラクタ－画像を表示
  [j_setDchForStatus]
  [call storage="jinroSubroutines.ks" target="*displayCharactersHorizontallyForStatus"]


; バックログボタン表示
[button graphic="button/button_backlog_normal.png" x="1005" y="23" width="114" height="103" fix="true" role="backlog" name="button_j_fix,button_j_backlog" enterimg="button/button_backlog_hover.png"]
[s]


*awake
; TODO:背景は元の画像に戻す。または人狼メニュー画面のbgはbgではなくレイヤー深めの画像を使うだけにするか。
;[bg storage="living_day_nc238325.jpg" time="100" wait="true"]

; バックログボタンを非表示にする
[clearfix name="button_j_backlog"]
[awakegame]
[s]
