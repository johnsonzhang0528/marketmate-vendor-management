# 創市通 MarketMate - Git Worktree 自動初始化腳本
# PowerShell 版本，適用於 Windows 環境

param(
  [switch]$Force,
  [switch]$SkipInstall,
  [string]$BaseDir = "../worktrees"
)

Write-Host "🚀 創市通 MarketMate - 自動初始化並行開發環境" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# 檢查是否在 Git 倉庫中
if (-not (Test-Path ".git")) {
  Write-Error "❌ 當前目錄不是 Git 倉庫根目錄"
  exit 1
}

# 創建 worktrees 目錄
$WorktreeDir = Resolve-Path $BaseDir -ErrorAction SilentlyContinue
if (-not $WorktreeDir) {
  New-Item -ItemType Directory -Path $BaseDir -Force | Out-Null
  $WorktreeDir = Resolve-Path $BaseDir
  Write-Host "📁 創建 worktrees 目錄: $WorktreeDir" -ForegroundColor Green
}

# 定義模組配置
$Modules = @(
  @{ Name = "frontend"; Branch = "feature/frontend"; Description = "🖥️ React + TypeScript 前端" },
  @{ Name = "backend"; Branch = "feature/backend"; Description = "⚙️ Node.js + Express 後端" },
  @{ Name = "inventory"; Branch = "feature/inventory"; Description = "📦 庫存管理模組" },
  @{ Name = "pos"; Branch = "feature/pos"; Description = "💰 POS 系統模組" },
  @{ Name = "customer"; Branch = "feature/customer"; Description = "👥 客戶管理模組" },
  @{ Name = "analytics"; Branch = "feature/analytics"; Description = "📊 財務分析模組" },
  @{ Name = "mobile"; Branch = "feature/mobile"; Description = "📱 行動應用" },
  @{ Name = "docs"; Branch = "feature/docs"; Description = "📚 VitePress 文件" },
  @{ Name = "shared"; Branch = "feature/shared"; Description = "🔗 共用類型庫" }
)

# 初始化每個模組的 worktree
foreach ($Module in $Modules) {
  $ModulePath = Join-Path $WorktreeDir $Module.Name
  $BranchExists = git branch --list $Module.Branch

  Write-Host "`n🔧 處理模組: $($Module.Description)" -ForegroundColor Yellow

  # 檢查 worktree 是否已存在
  if (Test-Path $ModulePath) {
    if ($Force) {
      Write-Host "   🗑️ 強制刪除現有 worktree: $ModulePath" -ForegroundColor Red
      git worktree remove $ModulePath --force 2>$null
      Remove-Item $ModulePath -Recurse -Force -ErrorAction SilentlyContinue
    }
    else {
      Write-Host "   ✅ Worktree 已存在: $ModulePath" -ForegroundColor Green
      continue
    }
  }

  # 創建或切換分支
  if (-not $BranchExists) {
    Write-Host "   🌿 創建新分支: $($Module.Branch)" -ForegroundColor Cyan
    git checkout -b $Module.Branch 2>$null
    git checkout main 2>$null
  }

  # 創建 worktree
  Write-Host "   📁 創建 worktree: $ModulePath" -ForegroundColor Green
  $Result = git worktree add $ModulePath $Module.Branch 2>&1

  if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ 成功創建 worktree: $($Module.Name)" -ForegroundColor Green

    # 創建基本的專案結構
    $PackageJsonPath = Join-Path $ModulePath "package.json"
    if (-not (Test-Path $PackageJsonPath)) {
      New-ModuleStructure -ModulePath $ModulePath -ModuleName $Module.Name
    }
  }
  else {
    Write-Host "   ❌ 創建 worktree 失敗: $Result" -ForegroundColor Red
  }
}

# 創建模組基本結構的函數
function New-ModuleStructure {
  param($ModulePath, $ModuleName)

  Write-Host "   📦 初始化 $ModuleName 專案結構..." -ForegroundColor Cyan

  # 基本目錄結構
  $Dirs = @("src", "tests", ".vscode")
  foreach ($Dir in $Dirs) {
    New-Item -ItemType Directory -Path (Join-Path $ModulePath $Dir) -Force | Out-Null
  }

  # 根據模組類型創建不同的 package.json
  $PackageJson = Get-ModulePackageJson -ModuleName $ModuleName
  $PackageJson | ConvertTo-Json -Depth 10 | Out-File -FilePath (Join-Path $ModulePath "package.json") -Encoding UTF8

  # 創建基本的 TypeScript 配置
  $TsConfig = @{
    "compilerOptions" = @{
      "target"                           = "ES2022"
      "module"                           = "ESNext"
      "moduleResolution"                 = "node"
      "strict"                           = $true
      "esModuleInterop"                  = $true
      "skipLibCheck"                     = $true
      "forceConsistentCasingInFileNames" = $true
      "resolveJsonModule"                = $true
      "isolatedModules"                  = $true
      "noEmit"                           = $true
    }
    "include"         = @("src/**/*", "tests/**/*")
    "exclude"         = @("node_modules", "dist")
  }
  $TsConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath (Join-Path $ModulePath "tsconfig.json") -Encoding UTF8

  # 創建 README
  $ReadmeContent = @"
# $ModuleName Module

## 開發指南

### 安裝依賴
``````bash
pnpm install
``````

### 開發模式
``````bash
pnpm dev
``````

### 建置
``````bash
pnpm build
``````

### 測試
``````bash
pnpm test
``````
"@
  $ReadmeContent | Out-File -FilePath (Join-Path $ModulePath "README.md") -Encoding UTF8
}

# 獲取模組特定的 package.json 配置
function Get-ModulePackageJson {
  param($ModuleName)

  $BasePackage = @{
    "name"            = "@marketmate/$ModuleName"
    "version"         = "1.0.0"
    "private"         = $true
    "type"            = "module"
    "scripts"         = @{
      "dev"        = "echo 'Please configure dev script for $ModuleName'"
      "build"      = "echo 'Please configure build script for $ModuleName'"
      "test"       = "vitest"
      "lint"       = "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0"
      "lint:fix"   = "eslint . --ext ts,tsx --fix"
      "type-check" = "tsc --noEmit"
    }
    "devDependencies" = @{
      "@types/node"                      = "^20.0.0"
      "typescript"                       = "^5.0.0"
      "vitest"                           = "^1.0.0"
      "eslint"                           = "^8.0.0"
      "@typescript-eslint/eslint-plugin" = "^6.0.0"
      "@typescript-eslint/parser"        = "^6.0.0"
    }
  }

  # 根據模組類型添加特定依賴
  switch ($ModuleName) {
    "frontend" {
      $BasePackage.scripts.dev = "vite"
      $BasePackage.scripts.build = "vite build"
      $BasePackage.scripts.preview = "vite preview"
      $BasePackage.scripts.storybook = "storybook dev -p 6006"
      $BasePackage.scripts."build-storybook" = "storybook build"
      $BasePackage.dependencies = @{
        "react"                 = "^18.0.0"
        "react-dom"             = "^18.0.0"
        "@tanstack/react-query" = "^5.0.0"
        "zustand"               = "^4.0.0"
        "react-hook-form"       = "^7.0.0"
        "@hookform/resolvers"   = "^3.0.0"
        "zod"                   = "^3.0.0"
      }
      $BasePackage.devDependencies."@vitejs/plugin-react" = "^4.0.0"
      $BasePackage.devDependencies."vite" = "^5.0.0"
      $BasePackage.devDependencies."@storybook/react-vite" = "^7.0.0"
    }
    "backend" {
      $BasePackage.scripts.dev = "tsx watch src/index.ts"
      $BasePackage.scripts.build = "tsup"
      $BasePackage.scripts.start = "node dist/index.js"
      $BasePackage.scripts."db:generate" = "prisma generate"
      $BasePackage.scripts."db:migrate" = "prisma migrate dev"
      $BasePackage.scripts."db:seed" = "tsx src/seed.ts"
      $BasePackage.dependencies = @{
        "express"        = "^4.0.0"
        "@prisma/client" = "^5.0.0"
        "hono"           = "^3.0.0"
        "zod"            = "^3.0.0"
      }
      $BasePackage.devDependencies."prisma" = "^5.0.0"
      $BasePackage.devDependencies."tsx" = "^4.0.0"
      $BasePackage.devDependencies."tsup" = "^8.0.0"
    }
    "mobile" {
      $BasePackage.scripts.dev = "expo start"
      $BasePackage.scripts.android = "expo start --android"
      $BasePackage.scripts.ios = "expo start --ios"
      $BasePackage.scripts.web = "expo start --web"
      $BasePackage.dependencies = @{
        "expo"               = "~49.0.0"
        "react-native"       = "0.72.0"
        "@expo/vector-icons" = "^13.0.0"
      }
    }
    "docs" {
      $BasePackage.scripts.dev = "vitepress dev"
      $BasePackage.scripts.build = "vitepress build"
      $BasePackage.scripts.preview = "vitepress preview"
      $BasePackage.devDependencies."vitepress" = "^1.0.0"
    }
  }

  return $BasePackage
}

# 安裝依賴（如果不跳過）
if (-not $SkipInstall) {
  Write-Host "`n📦 安裝所有模組依賴..." -ForegroundColor Cyan
  foreach ($Module in $Modules) {
    $ModulePath = Join-Path $WorktreeDir $Module.Name
    if (Test-Path $ModulePath) {
      Write-Host "   📦 安裝 $($Module.Name) 依賴..." -ForegroundColor Yellow
      Set-Location $ModulePath
      if (Get-Command pnpm -ErrorAction SilentlyContinue) {
        pnpm install --silent
      }
      elseif (Get-Command npm -ErrorAction SilentlyContinue) {
        npm install --silent
      }
      else {
        Write-Warning "   ⚠️ 未找到 npm 或 pnpm，請手動安裝依賴"
      }
      Set-Location $PSScriptRoot
    }
  }
}

Write-Host "`n✅ 並行開發環境初始化完成！" -ForegroundColor Green
Write-Host "📁 Worktrees 位置: $WorktreeDir" -ForegroundColor Cyan
Write-Host "🚀 接下來請執行: code vendor-management.code-workspace" -ForegroundColor Yellow

# 顯示下一步指引
Write-Host "`n📋 下一步操作:" -ForegroundColor Cyan
Write-Host "1. 在 VSCode 中開啟工作區: code vendor-management.code-workspace" -ForegroundColor White
Write-Host "2. 安裝建議的擴展" -ForegroundColor White
Write-Host "3. 執行開發任務: Ctrl+Shift+P > Tasks: Run Task > 🚀 Start Full Development Environment" -ForegroundColor White
