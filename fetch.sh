#!/bin/bash

REMOTE="googledrive:Bettys Frame Pictures"
PIX_RAW=../pix-raw/
PIX_FINAL=../pix-final/
rclone sync --log-level=INFO --log-file=./sync.log --use-json-log "$REMOTE" "$PIX_RAW"
rclone lsjson "$REMOTE" --recursive --metadata > ./remote.json
rsync -av --delete "$PIX_RAW" "$PIX_FINAL"
