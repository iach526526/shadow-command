# 設定輸出編碼為 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 取得當前資料夾路徑
$folderPath = "./"

# 取得所有 .md 檔案
$mdFiles = Get-ChildItem -Path $baseFolderPath -Recurse -File -Filter *.mdx
# 定義替換字典
$replacements = @{
    "原始詞" = "替換詞"
}

# 初始化一個列表來儲存修改過的檔名
$modifiedFiles = @()

foreach ($file in $mdFiles) {
    # 讀取文件內容
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalContent = $content # 保存原始內容

    # 對每個替換詞進行替換
    foreach ($key in $replacements.Keys) {
        $content = $content -replace [regex]::Escape($key), $replacements[$key]
    }

    # 如果內容被修改，寫回更新後的內容到文件
    if ($content -ne $originalContent) {
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
        # 將修改過的文件名添加到列表中
        $modifiedFiles += $file.FullName
    }
}

# 在 console 輸出已修改的檔案名稱
if ($modifiedFiles.Count -gt 0) {
    Write-Output "The following files were modified:"
    $modifiedFiles | ForEach-Object { Write-Output $_ }
} else {
    Write-Output "No files were modified."
}