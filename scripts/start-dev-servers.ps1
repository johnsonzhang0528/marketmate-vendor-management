# 創市通 MarketMate - 一鍵啟動所有開發伺服器
# PowerShell 版本，適用於 Windows 環境

param(
  [switch]$Frontend,
  [switch]$Backend,
  [switch]$All,
  [string]$BaseDir = "../worktrees",
  [int]$Delay = 3
)

Write-Host "🚀 創市通 MarketMate - 一鍵啟動並行開發環境" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

# 檢查參數
if (-not $Frontend -and -not $Backend -and -not $All) {
  Write-Host "💡 請指定要啟動的模組:" -ForegroundColor Yellow
  Write-Host "   -Frontend  : 只啟動前端伺服器" -ForegroundColor Gray
  Write-Host "   -Backend   : 只啟動後端伺服器" -ForegroundColor Gray
  Write-Host "   -All       : 啟動所有開發伺服器" -ForegroundColor Gray
  Write-Host ""
  Write-Host "範例:" -ForegroundColor Yellow
  Write-Host "   .\start-dev-servers.ps1 -All" -ForegroundColor Gray
  Write-Host "   .\start-dev-servers.ps1 -Frontend -Backend" -ForegroundColor Gray
  exit 1
}

# 獲取所有 worktree 路徑
$WorktreeDir = Resolve-Path $BaseDir -ErrorAction SilentlyContinue
if (-not $WorktreeDir) {
  Write-Error "❌ Worktree 目錄不存在: $BaseDir"
  Write-Host "💡 請先執行 init-worktrees.ps1 初始化專案" -ForegroundColor Yellow
  exit 1
}

# 定義要啟動的伺服器
$Servers = @()

if ($Frontend -or $All) {
  $Servers += @{
    Name        = "frontend"
    Description = "🖥️ React 前端伺服器"
    Command     = "npm run dev"
    Port        = 4000
    Color       = "Blue"
  }
}

if ($Backend -or $All) {
  $Servers += @{
    Name        = "backend"
    Description = "⚙️ Node.js 後端伺服器"
    Command     = "npm run dev"
    Port        = 4001
    Color       = "Green"
  }
}

if ($All) {
  $Servers += @(
    @{
      Name        = "docs"
      Description = "📚 VitePress 文件伺服器"
      Command     = "npm run dev"
      Port        = 4173
      Color       = "Magenta"
    },
    @{
      Name        = "inventory"
      Description = "📦 庫存管理伺服器"
      Command     = "npm run dev"
      Port        = 4002
      Color       = "Yellow"
    },
    @{
      Name        = "pos"
      Description = "💰 POS 系統伺服器"
      Command     = "npm run dev"
      Port        = 4003
      Color       = "Cyan"
    }
  )
}

# 檢查所有模組是否存在
$MissingModules = @()
foreach ($Server in $Servers) {
  $ModulePath = Join-Path $WorktreeDir $Server.Name
  if (-not (Test-Path $ModulePath)) {
    $MissingModules += $Server.Name
  }
}

if ($MissingModules.Count -gt 0) {
  Write-Host "❌ 以下模組不存在:" -ForegroundColor Red
  foreach ($Module in $MissingModules) {
    Write-Host "   - $Module" -ForegroundColor Red
  }
  Write-Host "💡 請先執行 init-worktrees.ps1 初始化專案" -ForegroundColor Yellow
  exit 1
}

# 啟動所有伺服器
Write-Host "🔥 開始啟動開發伺服器..." -ForegroundColor Green
Write-Host ""

$Jobs = @()

foreach ($Server in $Servers) {
  $ModulePath = Join-Path $WorktreeDir $Server.Name

  Write-Host "🚀 啟動 $($Server.Description)" -ForegroundColor $Server.Color
  Write-Host "   📁 路徑: $ModulePath" -ForegroundColor Gray
  Write-Host "   🔗 Port: $($Server.Port)" -ForegroundColor Gray
  Write-Host "   ⚡ 命令: $($Server.Command)" -ForegroundColor Gray

  # 檢查 package.json 是否存在
  $PackageJsonPath = Join-Path $ModulePath "package.json"
  if (-not (Test-Path $PackageJsonPath)) {
    Write-Host "   ⚠️ 找不到 package.json，跳過此模組" -ForegroundColor Yellow
    continue
  }

  # 在新的 PowerShell 視窗中啟動伺服器
  $ScriptBlock = {
    param($Path, $Command, $Name, $Description)

    # 設定視窗標題
    $Host.UI.RawUI.WindowTitle = "創市通 MarketMate - $Description"

    # 切換到模組目錄
    Set-Location $Path

    # 顯示啟動資訊
    Write-Host "🚀 $Description" -ForegroundColor Green
    Write-Host "📁 工作目錄: $Path" -ForegroundColor Gray
    Write-Host "⚡ 執行命令: $Command" -ForegroundColor Gray
    Write-Host "===========================================" -ForegroundColor Cyan
    Write-Host ""

    # 執行命令
    Invoke-Expression $Command
  }

  # 啟動新 PowerShell 視窗
  $Job = Start-Job -ScriptBlock $ScriptBlock -ArgumentList $ModulePath, $Server.Command, $Server.Name, $Server.Description
  $Jobs += @{
    Job    = $Job
    Server = $Server
    Path   = $ModulePath
  }

  # 等待延遲
  Start-Sleep -Seconds $Delay
}

# 顯示啟動結果
Write-Host ""
Write-Host "🎉 所有開發伺服器已啟動！" -ForegroundColor Green
Write-Host "============================" -ForegroundColor Green
Write-Host ""

Write-Host "📊 啟動的伺服器:" -ForegroundColor Cyan
foreach ($JobInfo in $Jobs) {
  $Server = $JobInfo.Server
  Write-Host "   $($Server.Description)" -ForegroundColor $Server.Color
  Write-Host "     🔗 http://localhost:$($Server.Port)" -ForegroundColor Gray
  Write-Host "     📁 $($JobInfo.Path)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "💡 使用方式:" -ForegroundColor Yellow
Write-Host "   - 每個伺服器都在獨立的 PowerShell 視窗中運行" -ForegroundColor Gray
Write-Host "   - 關閉視窗即可停止對應的伺服器" -ForegroundColor Gray
Write-Host "   - 使用 Ctrl+C 可停止當前伺服器" -ForegroundColor Gray
Write-Host "   - 在瀏覽器中訪問對應的 localhost 端口" -ForegroundColor Gray

Write-Host ""
Write-Host "🔥 並行開發環境已就緒！Happy Coding! 🎯" -ForegroundColor Green

# 監控任務狀態
Write-Host ""
Write-Host "📊 監控任務狀態 (按 Ctrl+C 退出監控):" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

try {
  while ($true) {
    Clear-Host
    Write-Host "🚀 創市通 MarketMate - 開發伺服器監控" -ForegroundColor Cyan
    Write-Host "======================================" -ForegroundColor Cyan
    Write-Host ""

    $AliveCount = 0
    foreach ($JobInfo in $Jobs) {
      $Job = $JobInfo.Job
      $Server = $JobInfo.Server

      if ($Job.State -eq "Running") {
        Write-Host "✅ $($Server.Description) - 運行中" -ForegroundColor Green
        Write-Host "   🔗 http://localhost:$($Server.Port)" -ForegroundColor Gray
        $AliveCount++
      }
      else {
        Write-Host "❌ $($Server.Description) - 已停止" -ForegroundColor Red
      }
    }

    Write-Host ""
    Write-Host "📈 統計: $AliveCount/$($Jobs.Count) 個伺服器正在運行" -ForegroundColor Cyan
    Write-Host "⏰ 最後更新: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
    Write-Host ""
    Write-Host "💡 按 Ctrl+C 退出監控..." -ForegroundColor Yellow

    Start-Sleep -Seconds 5
  }
}
catch {
  Write-Host ""
  Write-Host "👋 監控已停止" -ForegroundColor Yellow
}

# 清理任務
Write-Host ""
Write-Host "🧹 清理背景任務..." -ForegroundColor Yellow
foreach ($JobInfo in $Jobs) {
  Remove-Job -Job $JobInfo.Job -Force -ErrorAction SilentlyContinue
}

Write-Host "✅ 腳本執行完成！" -ForegroundColor Green
