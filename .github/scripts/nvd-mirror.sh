#!/usr/bin/env bash
# Mirror the NVD 2.0 feeds vulnix asks for into a local directory.
# nvd.nist.gov throttles cloud ranges to a crawl in the middle of a transfer,
# so every file is fetched with resume and a speed floor until it is whole.
set -euo pipefail

dir=${1:-nvd}
base=https://nvd.nist.gov/feeds/json/cve/2.0
year=$(date -u +%Y)
mkdir -p "$dir"

fetch() {
  local name=$1 part="$dir/$1.part" final="$dir/$1" rc=1 attempt
  local cond=()
  [ -f "$final" ] && cond=(-z "$final")
  for attempt in $(seq 1 30); do
    rc=0
    curl -fsS -o "$part" -C - --speed-limit 50000 --speed-time 30 --max-time 900 \
      "${cond[@]}" "$base/$name" || rc=$?
    case $rc in
      0) break ;;
      22)
        # 416 when the part file is already complete, 404 when the name does not exist
        if [ -s "$part" ]; then rc=0; break; fi
        rm -f "$part"
        return 22
        ;;
      *) echo "$name: attempt $attempt stopped with curl exit $rc, resuming"; sleep 5 ;;
    esac
  done
  if [ "$rc" -ne 0 ]; then
    echo "$name: giving up after 30 attempts"
    return 1
  fi
  if [ -s "$part" ]; then
    mv "$part" "$final"
    echo "$name: fetched $(stat -c %s "$final") bytes"
  else
    rm -f "$part"
    echo "$name: unchanged"
  fi
}

for name in $(seq $((year - 5)) "$year") modified; do
  fetch "nvdcve-2.0-$name.json.gz" || fetch "nvdcve-2.0-$name.json.zip"
done
