#!/bin/bash -x

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
echo "Script directory: ${SCRIPT_DIR}"

REMOTE="googledrive:Bettys Frame Pictures"
PIX_RAW=../pix-raw/
SCRATCH=/tmp/betty/
PIX_SCRATCH=$SCRATCH/$$/
PIX_FINAL=../pix-final/

mkdir -p "$SCRATCH" "$PIX_SCRATCH"
rclone sync --log-level=INFO --log-file="$SCRATCH/sync.log" --use-json-log "$REMOTE" "$PIX_RAW"
rclone lsjson "$REMOTE" --recursive --metadata > "$SCRATCH/remote.json"
rsync -r -vv --checksum --delete "$PIX_RAW" "$PIX_SCRATCH"
python $SCRIPT_DIR/ProcessRclonedFiles.py --json="$SCRATCH/remote.json" --dir="$PIX_SCRATCH"
rsync -r -vv --checksum --itemize-changes --delete "$PIX_SCRATCH" "$PIX_FINAL"
rm -rf "$PIX_SCRATCH"
