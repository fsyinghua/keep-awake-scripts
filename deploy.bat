@echo off
echo ========================================
echo    GitHub自动部署脚本
echo ========================================
echo.

REM 设置仓库名称
set /p REPO_NAME=请输入GitHub仓库名称 (默认: keep-awake-scripts): 
if "%REPO_NAME%"=="" set REPO_NAME=keep-awake-scripts

echo.
echo 仓库名称: %REPO_NAME%
echo.

REM 检查GitHub token
if "%GITHUB_TOKEN%"=="" (
    echo 错误: 请先设置GITHUB_TOKEN环境变量
echo.
echo 设置步骤:
echo 1. 访问 https://github.com/settings/tokens
echo 2. 生成新的个人访问令牌（需要repo权限）
echo 3. 设置环境变量: setx GITHUB_TOKEN "你的令牌"
echo.
pause
exit /b 1
)

REM 检查Git仓库
if not exist ".git" (
    echo 错误: 当前目录不是Git仓库
echo.
pause
exit /b 1
)

echo 正在创建GitHub仓库...

REM 使用PowerShell调用GitHub API
powershell -Command "
$body = @{
    name = '%REPO_NAME%'
    description = 'Windows VBS scripts to prevent system sleep'
    private = $false
    auto_init = $false
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri 'https://api.github.com/user/repos' -Method POST -Headers @{'Authorization' = 'token %GITHUB_TOKEN%'; 'Accept' = 'application/vnd.github.v3+json'} -Body $body -ContentType 'application/json'
    Write-Host 'GitHub仓库创建成功: ' -NoNewline; Write-Host $response.html_url -ForegroundColor Green
} catch {
    Write-Host '创建仓库失败: ' -NoNewline; Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
"

if errorlevel 1 (
    echo.
    echo 创建仓库失败，请检查错误信息
    pause
    exit /b 1
)

echo.
echo 正在配置远程仓库...

REM 添加远程仓库
git remote add origin https://github.com/JoeHe/%REPO_NAME%.git 2>nul
if errorlevel 1 (
    echo 远程仓库已存在，更新URL...
    git remote set-url origin https://github.com/JoeHe/%REPO_NAME%.git
)

echo.
echo 正在推送代码到GitHub...

git push -u origin master

if errorlevel 1 (
    echo.
    echo 推送失败，请检查错误信息
    pause
    exit /b 1
)

echo.
echo ========================================
echo   部署完成！
echo ========================================
echo.
echo 仓库地址: https://github.com/JoeHe/%REPO_NAME%
echo.
pause