param(
    [string]$RepoName = "keep-awake-scripts",
    [string]$Description = "Windows VBS scripts to prevent system sleep",
    [switch]$Private = $false
)

# 检查是否已设置GitHub token
if (-not $env:GITHUB_TOKEN) {
    Write-Host "错误：请先设置GITHUB_TOKEN环境变量" -ForegroundColor Red
    Write-Host "1. 访问 https://github.com/settings/tokens"
    Write-Host "2. 生成新的个人访问令牌（需要repo权限）"
    Write-Host "3. 设置环境变量：`$env:GITHUB_TOKEN = '你的令牌'`"
    exit 1
}

# 检查当前目录是否是Git仓库
if (-not (Test-Path ".git")) {
    Write-Host "错误：当前目录不是Git仓库" -ForegroundColor Red
    exit 1
}

# 创建GitHub仓库
Write-Host "正在创建GitHub仓库: $RepoName" -ForegroundColor Yellow

$body = @{
    name = $RepoName
    description = $Description
    private = $Private
    auto_init = $false
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" \
        -Method POST \
        -Headers @{
            "Authorization" = "token $env:GITHUB_TOKEN"
            "Accept" = "application/vnd.github.v3+json"
        } \
        -Body $body \
        -ContentType "application/json"
    
    Write-Host "✅ GitHub仓库创建成功: $($response.html_url)" -ForegroundColor Green
} catch {
    Write-Host "❌ 创建仓库失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# 添加远程仓库
$remoteUrl = "https://github.com/JoeHe/$RepoName.git"
Write-Host "正在添加远程仓库: $remoteUrl" -ForegroundColor Yellow

try {
    git remote add origin $remoteUrl
    Write-Host "✅ 远程仓库添加成功" -ForegroundColor Green
} catch {
    Write-Host "⚠️ 远程仓库可能已存在，尝试更新..." -ForegroundColor Yellow
    git remote set-url origin $remoteUrl
}

# 推送代码
Write-Host "正在推送代码到GitHub..." -ForegroundColor Yellow

try {
    git push -u origin master
    Write-Host "✅ 代码推送成功！" -ForegroundColor Green
    Write-Host "🔗 仓库地址: $($response.html_url)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ 推送失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎉 自动化部署完成！" -ForegroundColor Green