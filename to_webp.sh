#!/bin/bash

# 檢查是否安裝 cwebp，若未安裝則自動安裝
if ! command -v cwebp &> /dev/null; then
    echo "cwebp not found. Installing..."
    sudo apt-get update && sudo apt-get install -y webp
fi

# 檢查是否安裝 imagemagick，若未安裝則自動安裝
if ! command -v convert &> /dev/null; then
    echo "ImageMagick not found. Installing..."
    sudo apt-get update && sudo apt-get install -y imagemagick
fi

# 創建 out 資料夾來儲存 WebP 圖片
mkdir -p out
mkdir -p original
# 遍歷並轉換當前目錄下所有的 .jpg, .jpeg, .png 圖片
find . -type f \( -iname "*.JPG" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r img; do
    # 修正圖片方向並移除 EXIF 資訊
    temp_file="out/$(basename "$img")"
    convert "$img" -auto-orient "$temp_file" && mogrify -strip "$temp_file"
    
    # 取得轉換後的目標檔案路徑
    outfile="./$(basename "${img%.*}.webp")"
    
    # 執行 WebP 轉換，品質設為 50，不保留 EXIF 資訊
    cwebp "$temp_file" -o "$outfile" -q 50
    echo "Converted $img to $outfile"
	mv "$img" original
    
    # 清理臨時檔案
    rm "$temp_file"
done
rm -rf out
echo "所有圖片已轉換為 WebP 格式並儲存在 out 資料夾中。"
