*statusJinroMain
[cm]
[clearfix]

; ステータス画面から戻るときに復元すべきボタン状況を保存しておく。
; これはsleepgameをしてステータス画面を開いた瞬間に一度だけ行うこと。
; （ステータス画面→メニュー画面→2度目のステータス画面の方では行わない。awakegameするときに復元するのは、あくまで最初に開いた瞬間の状態なので）
[j_saveFixButton buf="status"]
; [clearfix]でfixボタンが全て消えてしまっているので、ボタン表示フラグを一旦全てfalseにしたうえで、必要なボタンを再表示する
[j_clearFixButton]
[j_displayFixButton backlog="true" status="nofix_click"]

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

; キャラクタ－画像を表示
[j_setDchForStatus winnerFaction="&f.winnerFaction"]
[call storage="jinroSubroutines.ks" target="*displayCharactersHorizontallyForStatus"]


; 【チュートリアル】
[call storage="tutorial/firstInstruction.ks" target="*statusButton" cond="('statusButton' in f.tutorialList) && !f.tutorialList.statusButton"]

[s]


*awake
; ボタンの画像の表示状況は[awakegame]することで復元されるが、f.displaingButton内の変数は復元されないので、変数の復元のために以下を行う
; ステータス画面表示時に保存しておいた状態を復元する（メニューボタンの状態も消去される）
[j_loadFixButton buf="status"]
[awakegame]
[s]
