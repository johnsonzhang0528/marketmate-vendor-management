# 創市通 MarketMate - 快速測試腳本
# 用於測試基本功能和路徑問題

Write-Host "🔍 測試並行開發環境設定..." -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

# 顯示當前位置
Write-Host "📍 當前位置: $(Get-Location)" -ForegroundColor Yellow

# 檢查必要目錄
$ProjectRoot = Get-Location
Write-Host "📁 專案根目錄: $ProjectRoot" -ForegroundColor Green

# 檢查 Git 倉庫
if (Test-Path ".git") {
    Write-Host "✅ Git 倉庫檢查通過" -ForegroundColor Green
} else {
    Write-Host "❌ 不是 Git 倉庫根目錄" -ForegroundColor Red
    exit 1
}

# 檢查 scripts 目錄
if (Test-Path "scripts") {
    Write-Host "✅ scripts 目錄存在" -ForegroundColor Green
} else {
    Write-Host "❌ scripts 目錄不存在" -ForegroundColor Red
    exit 1
}

# 檢查主要腳本
$Scripts = @(
    "scripts\init-worktrees.ps1",
    "scripts\setup-complete.ps1",
    "scripts\start-dev-servers.ps1"
)

foreach ($Script in $Scripts) {
    if (Test-Path $Script) {
        Write-Host "✅ $Script 存在" -ForegroundColor Green
    } else {
        Write-Host "❌ $Script 不存在" -ForegroundColor Red
    }
}

# 檢查 worktrees 目錄
$WorktreeDir = "../worktrees"
if (Test-Path $WorktreeDir) {
    Write-Host "✅ worktrees 目錄已存在" -ForegroundColor Green
    $WorktreeCount = (Get-ChildItem $WorktreeDir -Directory).Count
    Write-Host "📊 已有 $WorktreeCount 個 worktree" -ForegroundColor Cyan
} else {
    Write-Host "⚠️ worktrees 目錄不存在，需要初始化" -ForegroundColor Yellow
}

# 檢查 Node.js 和 npm
try {
    $NodeVersion = node --version
    Write-Host "✅ Node.js: $NodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js 未安裝" -ForegroundColor Red
}

try {
    $NpmVersion = npm --version
    Write-Host "✅ npm: $NpmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm 未安裝" -ForegroundColor Red
}

# 檢查 Git
try {
    $GitVersion = git --version
    Write-Host "✅ Git: $GitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git 未安裝" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 測試完成！" -ForegroundColor Green
Write-Host "💡 如果所有檢查都通過，可以執行:" -ForegroundColor Yellow
Write-Host "   .\scripts\init-worktrees.ps1" -ForegroundColor Gray
Write-Host "   .\scripts\setup-complete.ps1" -ForegroundColor Gray
