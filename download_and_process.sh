#!/bin/bash -x

REMOTE="googledrive:Bettys Frame Pictures"
PIX_RAW=../pix-raw/
SCRATCH=/tmp/betty/
PIX_SCRATCH=$SCRATCH/$$/
PIX_FINAL=../pix-final/

mkdir -p "$SCRATCH" "$PIX_SCRATCH"
rclone sync --log-level=INFO --log-file="$SCRATCH/sync.log" --use-json-log "$REMOTE" "$PIX_RAW"
rclone lsjson "$REMOTE" --recursive --metadata > "$SCRATCH/remote.json"
rsync -rptgo -vv --checksum --delete "$PIX_RAW" "$PIX_SCRATCH"
python ./ProcessRclonedFiles.py --json="$SCRATCH/remote.json" --dir="$PIX_SCRATCH"
rsync -rptgo -vv --checksum --itemize-changes --delete "$PIX_SCRATCH" "$PIX_FINAL"
rm -rf "$PIX_SCRATCH"
