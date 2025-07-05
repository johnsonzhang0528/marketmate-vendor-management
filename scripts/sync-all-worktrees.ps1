# 創市通 MarketMate - 同步所有 Worktree 腳本
# PowerShell 版本，適用於 Windows 環境

param(
  [switch]$Pull,
  [switch]$Push,
  [string]$BaseDir = "../worktrees",
  [string]$Message = "Auto sync from main"
)

Write-Host "🔄 創市通 MarketMate - 同步所有 Worktree" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# 檢查是否在 Git 倉庫中
if (-not (Test-Path ".git")) {
  Write-Error "❌ 當前目錄不是 Git 倉庫根目錄"
  exit 1
}

# 獲取所有 worktree 路徑
$WorktreeDir = Resolve-Path $BaseDir -ErrorAction SilentlyContinue
if (-not $WorktreeDir) {
  Write-Error "❌ Worktree 目錄不存在: $BaseDir"
  Write-Host "💡 請先執行 init-worktrees.ps1 初始化專案" -ForegroundColor Yellow
  exit 1
}

# 定義模組配置
$Modules = @(
  @{ Name = "frontend"; Branch = "feature/frontend" },
  @{ Name = "backend"; Branch = "feature/backend" },
  @{ Name = "inventory"; Branch = "feature/inventory" },
  @{ Name = "pos"; Branch = "feature/pos" },
  @{ Name = "customer"; Branch = "feature/customer" },
  @{ Name = "analytics"; Branch = "feature/analytics" },
  @{ Name = "mobile"; Branch = "feature/mobile" },
  @{ Name = "docs"; Branch = "feature/docs" },
  @{ Name = "shared"; Branch = "feature/shared" }
)

# 同步主分支
Write-Host "`n🔄 同步主分支..." -ForegroundColor Yellow
git fetch origin
git pull origin main

$SyncResults = @()

# 同步每個模組
foreach ($Module in $Modules) {
  $ModulePath = Join-Path $WorktreeDir $Module.Name

  if (-not (Test-Path $ModulePath)) {
    Write-Host "⚠️ 跳過不存在的模組: $($Module.Name)" -ForegroundColor Yellow
    continue
  }

  Write-Host "`n🔧 同步模組: $($Module.Name)" -ForegroundColor Cyan

  try {
    Push-Location $ModulePath

    # 檢查當前分支
    $CurrentBranch = git branch --show-current
    Write-Host "   📍 當前分支: $CurrentBranch" -ForegroundColor Gray

    # 如果需要拉取更新
    if ($Pull) {
      Write-Host "   📥 拉取最新更新..." -ForegroundColor Blue
      git fetch origin
      git pull origin $Module.Branch
    }

    # 檢查是否有更改
    $Status = git status --porcelain
    if ($Status) {
      Write-Host "   📝 發現更改:" -ForegroundColor Green
      git status --short

      # 如果需要推送
      if ($Push) {
        Write-Host "   📤 提交並推送更改..." -ForegroundColor Blue
        git add .
        git commit -m $Message
        git push origin $Module.Branch
      }
    }
    else {
      Write-Host "   ✅ 沒有更改" -ForegroundColor Green
    }

    $SyncResults += @{
      Module = $Module.Name
      Status = "✅ 成功"
      Branch = $CurrentBranch
    }

  }
  catch {
    Write-Host "   ❌ 同步失敗: $($_.Exception.Message)" -ForegroundColor Red
    $SyncResults += @{
      Module = $Module.Name
      Status = "❌ 失敗"
      Error  = $_.Exception.Message
    }
  }
  finally {
    Pop-Location
  }
}

# 顯示同步結果
Write-Host "`n📊 同步結果摘要" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
foreach ($Result in $SyncResults) {
  Write-Host "   $($Result.Module): $($Result.Status)" -ForegroundColor White
  if ($Result.Branch) {
    Write-Host "     分支: $($Result.Branch)" -ForegroundColor Gray
  }
  if ($Result.Error) {
    Write-Host "     錯誤: $($Result.Error)" -ForegroundColor Red
  }
}

Write-Host "`n✅ 同步完成！" -ForegroundColor Green
Write-Host "💡 使用參數:" -ForegroundColor Yellow
Write-Host "   -Pull    : 拉取所有模組的最新更新" -ForegroundColor Gray
Write-Host "   -Push    : 推送所有模組的更改" -ForegroundColor Gray
Write-Host "   -Message : 自訂提交訊息" -ForegroundColor Gray
