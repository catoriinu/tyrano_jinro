#!/bin/sh
# make_preload.sh ── ティラノスクリプト *preloadFiles 生成
# ---------------------------------------------------------------
# 使い方:
# $ sh scripts/make_preload.sh data/scenario/theater/p01/e01_c01.ks

############################################################
# 共通ユーティリティ
############################################################
uniq_lines() { awk '!seen[$0]++'; }
emit_array()  { awk 'NF{printf "        \"%s\",\n",$0}'; }

add_prefix() {                    # $1=type  $2=path
  type=$1 path=$2
  [ -z "$path" ] && return
  case "$path" in
    data/*) printf '%s\n' "$path" ;;                # 既に data/
    sound/*) printf 'data/%s\n' "$path" ;;          # sound/ 付きはそのまま
    se/*|other/*) printf 'data/sound/%s\n' "$path" ;;      # se/ → sound/se/
    theater/*)   printf 'data/sound/%s\n' "$path" ;;       # theater/ → sound/theater/
    bgm/*)   printf 'data/bgm/%s\n' "$path" ;;
    bgimage/*) printf 'data/bgimage/%s\n' "$path" ;;
    *)        # どこにも属さなければ type で振り分け
      case "$type" in
        bgm)   printf 'data/bgm/%s\n'      "$path" ;;
        img)   printf 'data/bgimage/%s\n'  "$path" ;;
        se)    printf 'data/sound/se/%s\n' "$path" ;;
        voice) printf 'data/sound/%s\n'    "$path" ;;
      esac ;;
  esac
}

[ $# -eq 0 ] && { echo "Usage: $0 scenario.ks [...]" >&2; exit 1; }

get_paths() { script=$1; shift; awk "$script" "$@"; }

############################################################
# 1. パス抽出（重複含む）
############################################################
voice_raw=$(get_paths '/\[playse/ && /buf="1"/ {if(match($0,/storage="([^"]+\.ogg)"/,m))print m[1]}' "$@")
se_raw=$(   get_paths '/\[playse/ && /buf="2"/ {if(match($0,/storage="([^"]+\.ogg)"/,m))print m[1]}' "$@")
bgm_raw=$(  get_paths '
  /\[playbgm/ {if(match($0,/storage="([^"]+\.ogg)"/,m))print m[1]}
  match($0,/storage[[:space:]]*:[[:space:]]*"([^"]+\.ogg)"/,m){print m[1]}
' "$@")
img_raw=$(  get_paths 'match($0,/storage[[:space:]]*[:=][[:space:]]*"([^"]+\.(jpg|png))"/,m){print m[1]}' "$@")

############################################################
# 2. プレフィックス補完 & 回数集計
############################################################
audio_all=$( {
  printf '%s\n' "$voice_raw" | while IFS= read -r p; do add_prefix voice "$p"; done
  printf '%s\n' "$se_raw"    | while IFS= read -r p; do add_prefix se    "$p"; done
  printf '%s\n' "$bgm_raw"   | while IFS= read -r p; do add_prefix bgm   "$p"; done
} )

audio_single=$(printf '%s\n' "$audio_all" | sort | uniq -u)
audio_multi=$( printf '%s\n' "$audio_all" | sort | uniq -d)

img_single=$(printf '%s\n' "$img_raw" |
             while IFS= read -r p; do add_prefix img "$p"; done |
             uniq_lines)

############################################################
# 3. リスト構築
############################################################
single_use_list=$( {
  printf '%s\n' "$audio_single"
  printf '%s\n' "$img_single"
} | uniq_lines)

bgm_multi=$(  printf '%s\n' "$audio_multi" | grep '/bgm/')
se_multi=$(   printf '%s\n' "$audio_multi" | grep -E '/(sound/)?se/')
voice_multi=$(printf '%s\n' "$audio_multi" | grep '/sound/theater/')

multi_use_list=$( {
  printf '%s\n' "$bgm_multi"
  printf '%s\n' "$se_multi"
  printf '%s\n' "$voice_multi"
} | uniq_lines)

############################################################
# 4. 出力
############################################################
#cat <<'HDR'
#; チャプター内で使うファイルをプリロードするサブルーチン
#*preloadFiles
#  [iscript]
cat <<'HDR'
    tf.preloadList = {
      singleUse: [
HDR
printf '%s\n' "$single_use_list" | emit_array
cat <<'MID'
      ],
      multiUse: [
MID
printf '%s\n' "$multi_use_list" | emit_array
cat <<'FTR'
      ]
    };
FTR
#  [endscript]
#  [preload storage="&tf.preloadList.singleUse" single_use="true"  name="chapterFilesSingleUse" cond="tf.preloadList.singleUse.length > 0"]
#  [preload storage="&tf.preloadList.multiUse"  single_use="false" name="chapterFilesMultiUse" cond="tf.preloadList.multiUse.length > 0"]
#
#  [return]
#[s]

