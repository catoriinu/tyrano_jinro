; playselistプラグインで使用する外部JSファイルを読み込む
[loadjs storage="plugin/playselist/impl.js"]

; [add_playselist]で登録しておいたSEを連続再生するマクロ
; @param buf 再生するスロット（[add_playselist]で登録したスロットと同じもの）を指定する。デフォルト="0"
; @param no_init "true"指定時は、再生終了後もそのbufに追加済みのSEを初期化しない。デフォルト=false(初期化する)
[macro name="playselist"]
  [iscript]
    // 引数bufはデフォルト"0"
    if (!('buf' in mp)) {
      mp.buf = "0";
    }
    // 指定されたbufにSEが一つも登録されていなかった場合は警告を出す
    if (!('playSeListSubjects' in tf) || !(mp.buf in tf.playSeListSubjects) || tf.playSeListSubjects[mp.buf].constructor.name != "PlaySeListSubject") {
      alert('事前に[add_playselist]を実行してください buf=' + mp.buf);
    }
    // 登録しておいたSEを非同期処理で連続再生していく
    tf.playSeListSubjects[mp.buf].playSeList();
    // 以下の処理は、playSeList()内の非同期処理が完了する前に実行されることに注意

    // tf.playselist[mp.buf]を初期化する。ただし引数no_initで指定された場合は初期化しない
    let dontInit = ('no_init' in mp && (mp.no_init === 'true' || mp.no_init === true));
    if (!dontInit) {
      delete tf.playSeListSubjects[mp.buf];
    }
  [endscript]
[endmacro]


; [playselist]で連続再生したいSEを事前に登録しておくマクロ
; 基本的にティラノスクリプトの[playse]タグと同じ引数を受け付ける
;
; 以下は[playse]には存在しない、本マクロ独自の引数
; @param init "true"指定時は、事前に同じスロット（buf）へ[add_playselist]実行済みであっても初期化を行い、1番目のSEとして追加する。デフォルト=false(初期化しない)
; @param interval 単位=ミリ秒。指定した時間分だけ、そのSEが再生完了してから次のSEを再生開始するまでの間にインターバルを空ける。
;                 デフォルト=0ミリ秒。ただし、最悪で100ミリ秒のインターバルが発生する可能性あり。
;                 詳細はimpl.jsのPlaySeObserverオブジェクト内のloopTimeのコメント参照。
;
; 以下は[playse]には存在するが、本マクロで登録するにあたって注意事項がある引数
; @param loop "true"を指定したSEを再生し始めると、同じスロット（buf）で新しい効果音を再生するか、[stopse]するまで止まらないため。
; @param sprite_time sprite_timeを指定し、かつその終了時間が実際のSEの再生時間よりも長い場合、
;                    そのSEが再生完了したと判定されるのは、sprite_timeの終了時間の方となる
; @param stop（通常はタグの引数としては指定できない）
;             [playselist]実行時に自動的に、プレイリストの最後のSEのみfalse（nextOrderする）、それ以外のSEはtrue（nextOrderしない）で固定される
[macro name="add_playselist"]
  [iscript]
    // 引数bufはデフォルト"0"
    if (!('buf' in mp)) {
      mp.buf = "0";
    }
    // 最初はオブジェクト型で初期化
    if (!('playSeListSubjects' in tf)) {
      tf.playSeListSubjects = {};
    }
    // 引数initで指定されているなら、tf.playSeListSubjects[mp.buf]が残っていても初期化する
    let doInit = ('init' in mp && (mp.init === 'true' || mp.init === true));
    if (doInit && mp.buf in tf.playSeListSubjects) {
      delete tf.playSeListSubjects[mp.buf];
    }
    // まだ存在しないならPlaySeListSubjectを生成する
    if (!(mp.buf in tf.playSeListSubjects)) {
      tf.playSeListSubjects[mp.buf] = new PlaySeListSubject();
    }
    // observerを生成し、PlaySeListSubjectに登録する。ここで登録したPlaySeObserverは[playselist]したときに実行される
    const playSeObserver = new PlaySeObserver(mp);
    tf.playSeListSubjects[mp.buf].addPlaySeList(playSeObserver);
  [endscript]
[endmacro]

[return ]
