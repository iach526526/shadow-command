#!/bin/bash
#用 aws s3 cli 上傳圖片到我的 cloudflare R2
FOLDER_PATH="${1:-./}"
bucket="${2:-blog-images}"
folder="${3:-}"

find "$FOLDER_PATH" -maxdepth 1 -type f -name '*.webp' | parallel -j 8 '
  full_path="{}"
  file_name=$(basename "$full_path")

  if [ -z "'"$folder"'" ]; then
    dest_path="s3://'"$bucket"'/$file_name"
  else
    dest_path="s3://'"$bucket"'/'"$folder"'/$file_name"
  fi

  echo "上傳中: $full_path -> $dest_path"
  aws s3 cp "$full_path" "$dest_path" --profile cf-blog
'
