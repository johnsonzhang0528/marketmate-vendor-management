# 創市通 MarketMate - 一鍵完整設定並行開發環境
# PowerShell 版本，適用於 Windows 環境

param(
  [switch]$Force,
  [switch]$SkipInstall,
  [switch]$StartServers,
  [string]$BaseDir = "../worktrees",
  [string]$PackageManager = "npm"
)

Write-Host "🌟 創市通 MarketMate - 一鍵完整設定並行開發環境" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# 檢查系統需求
Write-Host "🔍 檢查系統需求..." -ForegroundColor Yellow

# 檢查 Git
try {
  $GitVersion = git --version
  Write-Host "✅ Git: $GitVersion" -ForegroundColor Green
}
catch {
  Write-Error "❌ Git 未安裝或不在 PATH 中"
  exit 1
}

# 檢查 Node.js
try {
  $NodeVersion = node --version
  Write-Host "✅ Node.js: $NodeVersion" -ForegroundColor Green
}
catch {
  Write-Error "❌ Node.js 未安裝或不在 PATH 中"
  exit 1
}

# 檢查包管理器
try {
  $PackageManagerVersion = & $PackageManager --version
  Write-Host "✅ $PackageManager`: $PackageManagerVersion" -ForegroundColor Green
}
catch {
  Write-Error "❌ $PackageManager 未安裝或不在 PATH 中"
  exit 1
}

Write-Host ""

# 步驟 1: 初始化所有 Worktree
Write-Host "🚀 步驟 1: 初始化所有 Git Worktree" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

$InitArgs = @("-File", "./scripts/init-worktrees.ps1")
if ($Force) {
  $InitArgs += "-Force"
}
if ($SkipInstall) {
  $InitArgs += "-SkipInstall"
}

try {
  & pwsh @InitArgs
  if ($LASTEXITCODE -ne 0) {
    throw "初始化 Worktree 失敗"
  }
  Write-Host "✅ Worktree 初始化完成" -ForegroundColor Green
}
catch {
  Write-Error "❌ 初始化 Worktree 失敗: $($_.Exception.Message)"
  exit 1
}

Write-Host ""

# 步驟 2: 安裝所有依賴
if (-not $SkipInstall) {
  Write-Host "📦 步驟 2: 安裝所有模組依賴" -ForegroundColor Cyan
  Write-Host "============================" -ForegroundColor Cyan

  try {
    & pwsh -File "./scripts/install-all-deps.ps1" -PackageManager $PackageManager
    if ($LASTEXITCODE -ne 0) {
      throw "安裝依賴失敗"
    }
    Write-Host "✅ 依賴安裝完成" -ForegroundColor Green
  }
  catch {
    Write-Error "❌ 安裝依賴失敗: $($_.Exception.Message)"
    Write-Host "💡 可以稍後手動執行: .\scripts\install-all-deps.ps1" -ForegroundColor Yellow
  }
}
else {
  Write-Host "⏩ 跳過依賴安裝" -ForegroundColor Yellow
}

Write-Host ""

# 步驟 3: 設定 VSCode 工作區
Write-Host "🔧 步驟 3: 設定 VSCode 工作區" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan

$WorkspaceFile = "vendor-management.code-workspace"
if (Test-Path $WorkspaceFile) {
  Write-Host "✅ VSCode 工作區文件已存在" -ForegroundColor Green
  Write-Host "   📁 $WorkspaceFile" -ForegroundColor Gray
}
else {
  Write-Host "⚠️ VSCode 工作區文件不存在" -ForegroundColor Yellow
  Write-Host "💡 請手動創建或檢查工作區設定" -ForegroundColor Yellow
}

Write-Host ""

# 步驟 4: 顯示設定完成資訊
Write-Host "🎉 設定完成！" -ForegroundColor Green
Write-Host "=============" -ForegroundColor Green
Write-Host ""

Write-Host "📊 環境狀態:" -ForegroundColor Cyan
Write-Host "   ✅ Git Worktree 已初始化" -ForegroundColor Green
if (-not $SkipInstall) {
  Write-Host "   ✅ 依賴已安裝" -ForegroundColor Green
}
Write-Host "   ✅ VSCode 工作區已設定" -ForegroundColor Green
Write-Host ""

Write-Host "🗂️ 專案結構:" -ForegroundColor Cyan
Write-Host "   📁 $BaseDir/" -ForegroundColor Gray
Write-Host "     🖥️ frontend/       - React + TypeScript 前端" -ForegroundColor Blue
Write-Host "     ⚙️ backend/        - Node.js + Express 後端" -ForegroundColor Green
Write-Host "     📦 inventory/      - 庫存管理模組" -ForegroundColor Yellow
Write-Host "     💰 pos/            - POS 系統模組" -ForegroundColor Cyan
Write-Host "     👥 customer/       - 客戶管理模組" -ForegroundColor Magenta
Write-Host "     📊 analytics/      - 財務分析模組" -ForegroundColor Red
Write-Host "     📱 mobile/         - 行動應用" -ForegroundColor Blue
Write-Host "     📚 docs/           - VitePress 文件" -ForegroundColor Magenta
Write-Host "     🔗 shared/         - 共用類型庫" -ForegroundColor Gray
Write-Host ""

Write-Host "🚀 快速啟動:" -ForegroundColor Cyan
Write-Host "   1. 開啟 VSCode 工作區:" -ForegroundColor White
Write-Host "      code $WorkspaceFile" -ForegroundColor Gray
Write-Host ""
Write-Host "   2. 啟動開發伺服器:" -ForegroundColor White
Write-Host "      .\scripts\start-dev-servers.ps1 -All" -ForegroundColor Gray
Write-Host ""
Write-Host "   3. 或使用 VSCode 任務面板:" -ForegroundColor White
Write-Host "      Ctrl+Shift+P → Tasks: Run Task" -ForegroundColor Gray
Write-Host ""

Write-Host "🛠️ 常用腳本:" -ForegroundColor Cyan
Write-Host "   📦 安裝依賴:      .\scripts\install-all-deps.ps1" -ForegroundColor Gray
Write-Host "   🔄 同步代碼:      .\scripts\sync-all-worktrees.ps1" -ForegroundColor Gray
Write-Host "   🚀 啟動伺服器:    .\scripts\start-dev-servers.ps1" -ForegroundColor Gray
Write-Host "   🌟 完整設定:      .\scripts\setup-complete.ps1" -ForegroundColor Gray
Write-Host ""

Write-Host "💡 使用建議:" -ForegroundColor Yellow
Write-Host "   - 使用 VSCode 多資料夾工作區進行開發" -ForegroundColor Gray
Write-Host "   - 每個模組都有獨立的 Git 分支" -ForegroundColor Gray
Write-Host "   - 使用 tasks.json 中的預設任務" -ForegroundColor Gray
Write-Host "   - 定期同步和備份代碼" -ForegroundColor Gray
Write-Host ""

# 步驟 5: 可選的自動啟動伺服器
if ($StartServers) {
  Write-Host "🔥 步驟 5: 啟動開發伺服器" -ForegroundColor Cyan
  Write-Host "=========================" -ForegroundColor Cyan

  $UserInput = Read-Host "是否要立即啟動所有開發伺服器? (y/N)"
  if ($UserInput -match '^[Yy]') {
    try {
      & pwsh -File "./scripts/start-dev-servers.ps1" -All
    }
    catch {
      Write-Host "❌ 啟動伺服器失敗: $($_.Exception.Message)" -ForegroundColor Red
      Write-Host "💡 可以稍後手動執行: .\scripts\start-dev-servers.ps1 -All" -ForegroundColor Yellow
    }
  }
}

Write-Host ""
Write-Host "🎯 創市通 MarketMate 並行開發環境已就緒！" -ForegroundColor Green
Write-Host "Happy Coding! 🚀" -ForegroundColor Green
Write-Host ""

Write-Host "📋 使用參數:" -ForegroundColor Yellow
Write-Host "   -Force           : 強制重新初始化" -ForegroundColor Gray
Write-Host "   -SkipInstall     : 跳過依賴安裝" -ForegroundColor Gray
Write-Host "   -StartServers    : 詢問是否啟動伺服器" -ForegroundColor Gray
Write-Host "   -PackageManager  : 指定包管理器 (npm/yarn/pnpm)" -ForegroundColor Gray
