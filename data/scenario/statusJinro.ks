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

        <div class="openedVoteDaycounter" style="display: none;"><!-- 初期状態では非表示 -->
            <button type="button" class="minusButton">-</button>
            <span class="value" style="padding: 0px 0px 0px 10px;">1</span><span style="padding: 0px 10px 0px 0px;">日目</span><!-- ボタンとの間隔を空けるため左右にpaddingする -->
            <button type="button" class="plusButton">+</button>
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
        // ラジオボタンをクリックした時の処理
        $('input[type="radio"]').click(function() {
            // 「住人一覧」をクリックしたら情報を表示。それ以外の場合は非表示
            if ($(this).val() === "participants") {
                $('.participantsInfo').show();
            } else {
                $('.participantsInfo').hide();
            }

            // 「投票履歴」をクリックしたら情報とカウンターを表示。それ以外の場合は非表示
            if ($(this).val() === "voteHistory") {
                $(".openedVoteDaycounter").show();
                // 最後に表示していた開票日の情報を表示する。ステータス画面を開いた直後なら1。1以外に変えて別ボタンに移って再度表示したときは最後に表示していた開票日
                changeDisplayVoteDayHistory(parseInt($('.value').text()));
            } else {
                $(".openedVoteDaycounter").hide();
                $(".voteHistoryInfo").hide();
            }

            // 「占い履歴」をクリックしたら情報を表示。それ以外の場合は非表示
            if ($(this).val() === "fortuneTellingHistory") {
                $(".fortuneTellerHistoryInfo").show();
            } else {
                $(".fortuneTellerHistoryInfo").hide();
            }
        });

        // 「投票履歴」のカウンターボタンの色の初期設定
        // デフォルトの1日目以下には減らせないので、マイナスボタンの色を変える
        $('.minusButton').css({'background': '#80da87'});
        // 1日目までしか投票結果がないなら増やせないので、プラスボタンの色を変える
        const maxDay = Math.max(...Object.keys(f.openedVote));
        if (maxDay <= 1) {
            $('.plusButton').css({'background': '#80da87'});
        }

    });
    // 「投票履歴」のカウンターの処理
    $('.openedVoteDaycounter').each(function() {
        const $minusButton = $(this).find('.minusButton');
        const $plusButton = $(this).find('.plusButton');
        const $value = $(this).find('.value');
        const disableCssObject = {'background': '#80da87'};

        // 開票オブジェクトのキーの最大値、すなわち表示可能な最新の開票日を取得
        const maxDay = Math.max(...Object.keys(f.openedVote));

        $minusButton.on('click', function() {
            const nowDay = parseInt($value.text());
            // 最低値は1まで
            if (nowDay > 1) {
                const displayDay = nowDay - 1;
                changeDisplayVoteDayHistory(displayDay, nowDay, $value);

                // 1日目以下には減らせないので、マイナスボタンの色を変える
                if (displayDay <= 1) {
                    $minusButton.css(disableCssObject);
                }
                // 減らせた=増やせるなので、プラスボタンの色をリセットする
                $plusButton.removeAttr('style');
            }
        });

        $plusButton.on('click', function() {
            const nowDay = parseInt($value.text());
            // 最大値は最新の開票日まで
            if (nowDay < maxDay) {
                const displayDay = nowDay + 1;
                changeDisplayVoteDayHistory(displayDay, nowDay, $value);

                // 最新の開票日以上には増やせないので、プラスボタンの色を変える
                if (displayDay >= maxDay) {
                    $plusButton.css(disableCssObject);
                }
                // 増やせた=減らせるなので、マイナスボタンの色をリセットする
                $minusButton.removeAttr('style');
            }
        });
    });
    // 表示する開票日を変更
    function changeDisplayVoteDayHistory(displayDay, nowDay = null, $value = {}) {
        if (nowDay !== null) {
            $('.voteDay' + nowDay).hide();
        }

        $('.voteDay' + displayDay).show();
        
        if ($value instanceof jQuery) {
            $value.text(displayDay);
        }
    }
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
