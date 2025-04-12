#!/bin/bash
# 可以放在 /usr/local/bin 全域呼叫
# 預設壓縮品質
quality="${1:-40}"

if ! command -v cwebp &> /dev/null; then
    echo "cwebp not found. Installing..."
    sudo apt-get update && sudo apt-get install -y webp
fi

if ! command -v convert &> /dev/null; then
    echo "ImageMagick not found. Installing..."
    sudo apt-get update && sudo apt-get install -y imagemagick
fi

mkdir -p out
mkdir -p original

find . -type f \( -iname "*.JPG" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r img; do
    temp_file="out/$(basename "$img")"
    convert "$img" -auto-orient "$temp_file" && mogrify -strip "$temp_file"
    outfile="./$(basename "${img%.*}.webp")"
    cwebp "$temp_file" -o "$outfile" -q "$quality"
    echo "Converted $img to $outfile"
    mv "$img" original
    rm "$temp_file"
done

rm -rf out
echo "所有圖片已轉換為 WebP 格式，原始檔已移至 original/"
