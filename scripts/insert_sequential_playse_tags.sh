#!/bin/bash

# 1. シナリオファイルに、ボイスを入れたい箇所に「; ボイス」というコメントを入れていく
# 2. 以下の例を参考にしてコマンドを実行すると、「; ボイス」の箇所が「001.ogg」から始まる連番のplayseタグに置換されていく
# $ scripts/insert_sequential_playse_tags.sh data/scenario/theater/p01/e01_c02.ks "theater/p01/e01/" 40

# 引数を取得
input_file="$1"       # 第一引数: 対象のテキストファイル
directory_path="$2"   # 第二引数: oggファイルのディレクトリパス
count="$3"            # 第三引数: 置換する開始番号

# 引数が不足している場合のエラーメッセージ
if [[ -z "$input_file" || -z "$directory_path" || -z "$count" ]]; then
    echo "Usage: $0 input_file directory_path start_number"
    exit 1
fi

# ループ処理
while grep -q "; ボイス" "$input_file"; do
    # 置換を行うためのsedコマンド
    sed -i -E "0,/; ボイス/s|; ボイス|[playse storage=\"${directory_path}$(printf "%03d" $count).ogg\" buf=\"1\"]|" "$input_file"
    
    # インクリメント
    count=$((count + 1))
done
