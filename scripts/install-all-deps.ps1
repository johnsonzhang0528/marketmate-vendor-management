# 創市通 MarketMate - 安裝所有模組依賴腳本
# PowerShell 版本，適用於 Windows 環境

param(
  [switch]$Clean,
  [switch]$Update,
  [string]$BaseDir = "../worktrees",
  [string]$PackageManager = "npm"
)

Write-Host "📦 創市通 MarketMate - 安裝所有模組依賴" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# 檢查包管理器
$ValidManagers = @("npm", "yarn", "pnpm")
if ($PackageManager -notin $ValidManagers) {
  Write-Error "❌ 不支援的包管理器: $PackageManager"
  Write-Host "💡 支援的包管理器: $($ValidManagers -join ', ')" -ForegroundColor Yellow
  exit 1
}

# 檢查包管理器是否安裝
try {
  & $PackageManager --version | Out-Null
}
catch {
  Write-Error "❌ 找不到包管理器: $PackageManager"
  Write-Host "💡 請先安裝 $PackageManager" -ForegroundColor Yellow
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
  @{ Name = "frontend"; HasPackageJson = $true; Description = "🖥️ React + TypeScript 前端" },
  @{ Name = "backend"; HasPackageJson = $true; Description = "⚙️ Node.js + Express 後端" },
  @{ Name = "inventory"; HasPackageJson = $true; Description = "📦 庫存管理模組" },
  @{ Name = "pos"; HasPackageJson = $true; Description = "💰 POS 系統模組" },
  @{ Name = "customer"; HasPackageJson = $true; Description = "👥 客戶管理模組" },
  @{ Name = "analytics"; HasPackageJson = $true; Description = "📊 財務分析模組" },
  @{ Name = "mobile"; HasPackageJson = $true; Description = "📱 行動應用" },
  @{ Name = "docs"; HasPackageJson = $true; Description = "📚 VitePress 文件" },
  @{ Name = "shared"; HasPackageJson = $true; Description = "🔗 共用類型庫" }
)

$InstallResults = @()

# 安裝每個模組的依賴
foreach ($Module in $Modules) {
  $ModulePath = Join-Path $WorktreeDir $Module.Name
  $PackageJsonPath = Join-Path $ModulePath "package.json"

  if (-not (Test-Path $ModulePath)) {
    Write-Host "⚠️ 跳過不存在的模組: $($Module.Name)" -ForegroundColor Yellow
    continue
  }

  if (-not $Module.HasPackageJson -or -not (Test-Path $PackageJsonPath)) {
    Write-Host "⚠️ 跳過沒有 package.json 的模組: $($Module.Name)" -ForegroundColor Yellow
    continue
  }

  Write-Host "`n📦 安裝模組依賴: $($Module.Description)" -ForegroundColor Cyan

  try {
    Push-Location $ModulePath

    # 清理 node_modules
    if ($Clean) {
      Write-Host "   🗑️ 清理舊依賴..." -ForegroundColor Red
      if (Test-Path "node_modules") {
        Remove-Item -Recurse -Force "node_modules"
      }
      if (Test-Path "package-lock.json") {
        Remove-Item -Force "package-lock.json"
      }
      if (Test-Path "yarn.lock") {
        Remove-Item -Force "yarn.lock"
      }
      if (Test-Path "pnpm-lock.yaml") {
        Remove-Item -Force "pnpm-lock.yaml"
      }
    }

    # 安裝依賴
    Write-Host "   📥 安裝依賴套件..." -ForegroundColor Blue

    switch ($PackageManager) {
      "npm" {
        if ($Update) {
          npm update
        }
        else {
          npm install
        }
      }
      "yarn" {
        if ($Update) {
          yarn upgrade
        }
        else {
          yarn install
        }
      }
      "pnpm" {
        if ($Update) {
          pnpm update
        }
        else {
          pnpm install
        }
      }
    }

    # 檢查安裝結果
    if ($LASTEXITCODE -eq 0) {
      Write-Host "   ✅ 安裝成功" -ForegroundColor Green
      $InstallResults += @{
        Module      = $Module.Name
        Status      = "✅ 成功"
        Description = $Module.Description
      }
    }
    else {
      Write-Host "   ❌ 安裝失敗" -ForegroundColor Red
      $InstallResults += @{
        Module      = $Module.Name
        Status      = "❌ 失敗"
        Description = $Module.Description
      }
    }

  }
  catch {
    Write-Host "   ❌ 安裝失敗: $($_.Exception.Message)" -ForegroundColor Red
    $InstallResults += @{
      Module = $Module.Name
      Status = "❌ 失敗"
      Error  = $_.Exception.Message
    }
  }
  finally {
    Pop-Location
  }
}

# 顯示安裝結果
Write-Host "`n📊 安裝結果摘要" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
foreach ($Result in $InstallResults) {
  Write-Host "   $($Result.Module): $($Result.Status)" -ForegroundColor White
  if ($Result.Description) {
    Write-Host "     $($Result.Description)" -ForegroundColor Gray
  }
  if ($Result.Error) {
    Write-Host "     錯誤: $($Result.Error)" -ForegroundColor Red
  }
}

# 統計結果
$SuccessCount = ($InstallResults | Where-Object { $_.Status -eq "✅ 成功" }).Count
$FailCount = ($InstallResults | Where-Object { $_.Status -eq "❌ 失敗" }).Count

Write-Host "`n📈 安裝統計" -ForegroundColor Cyan
Write-Host "============" -ForegroundColor Cyan
Write-Host "   ✅ 成功: $SuccessCount 個模組" -ForegroundColor Green
Write-Host "   ❌ 失敗: $FailCount 個模組" -ForegroundColor Red

if ($FailCount -eq 0) {
  Write-Host "`n🎉 所有模組依賴安裝完成！" -ForegroundColor Green
}
else {
  Write-Host "`n⚠️ 部分模組安裝失敗，請檢查上述錯誤訊息" -ForegroundColor Yellow
}

Write-Host "`n💡 使用參數:" -ForegroundColor Yellow
Write-Host "   -Clean          : 清理舊依賴後重新安裝" -ForegroundColor Gray
Write-Host "   -Update         : 更新依賴到最新版本" -ForegroundColor Gray
Write-Host "   -PackageManager : 指定包管理器 (npm/yarn/pnpm)" -ForegroundColor Gray
