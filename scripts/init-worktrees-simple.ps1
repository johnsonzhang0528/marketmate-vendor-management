# 創市通 MarketMate - 簡化版初始化腳本
# 解決路徑問題的版本

param(
    [switch]$Force,
    [switch]$SkipInstall,
    [string]$BaseDir = "../worktrees"
)

Write-Host "🚀 創市通 MarketMate - 簡化版初始化" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# 記錄原始位置
$OriginalPath = Get-Location
Write-Host "📍 原始位置: $OriginalPath" -ForegroundColor Gray

try {
    # 檢查 Git 倉庫
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

    # 定義模組
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

    # 處理每個模組
    foreach ($Module in $Modules) {
        $ModulePath = Join-Path $WorktreeDir $Module.Name
        $BranchExists = git branch --list $Module.Branch
        
        Write-Host "`n🔧 處理模組: $($Module.Description)" -ForegroundColor Yellow
        
        # 檢查 worktree 是否已存在
        if (Test-Path $ModulePath) {
            if ($Force) {
                Write-Host "   🗑️ 強制刪除現有 worktree: $ModulePath" -ForegroundColor Red
                git worktree remove $ModulePath --force
                Remove-Item -Path $ModulePath -Recurse -Force -ErrorAction SilentlyContinue
            } else {
                Write-Host "   ✅ Worktree 已存在，跳過: $ModulePath" -ForegroundColor Green
                continue
            }
        }
        
        # 創建分支（如果不存在）
        if (-not $BranchExists) {
            Write-Host "   🌿 創建新分支: $($Module.Branch)" -ForegroundColor Blue
            git branch $Module.Branch
        }
        
        # 創建 worktree
        Write-Host "   📁 創建 worktree: $ModulePath" -ForegroundColor Blue
        git worktree add $ModulePath $Module.Branch
        
        if (Test-Path $ModulePath) {
            Write-Host "   ✅ Worktree 創建成功" -ForegroundColor Green
            
            # 創建基本 package.json
            $PackageJsonPath = Join-Path $ModulePath "package.json"
            if (-not (Test-Path $PackageJsonPath)) {
                Write-Host "   📦 創建基本 package.json" -ForegroundColor Blue
                
                $PackageJson = @{
                    name = "marketmate-$($Module.Name)"
                    version = "1.0.0"
                    description = $Module.Description
                    main = "index.js"
                    scripts = @{
                        dev = "echo 'Development server for $($Module.Name)'"
                        build = "echo 'Build command for $($Module.Name)'"
                        test = "echo 'Test command for $($Module.Name)'"
                    }
                    dependencies = @{}
                    devDependencies = @{}
                }
                
                $PackageJson | ConvertTo-Json -Depth 10 | Set-Content -Path $PackageJsonPath -Encoding UTF8
            }
            
            # 創建基本 README
            $ReadmePath = Join-Path $ModulePath "README.md"
            if (-not (Test-Path $ReadmePath)) {
                Write-Host "   📖 創建基本 README" -ForegroundColor Blue
                
                $ReadmeLines = @(
                    "# $($Module.Description)",
                    "",
                    "## 🚀 快速開始",
                    "",
                    "```bash",
                    "# 安裝依賴",
                    "npm install",
                    "",
                    "# 啟動開發伺服器",
                    "npm run dev",
                    "",
                    "# 建置專案",
                    "npm run build",
                    "```",
                    "",
                    "## 📝 說明",
                    "",
                    "這是創市通 MarketMate 的 $($Module.Name) 模組。",
                    "",
                    "## 🔧 開發",
                    "",
                    "- 開發伺服器：``npm run dev``",
                    "- 建置：``npm run build``",
                    "- 測試：``npm run test``"
                )
                
                $ReadmeLines | Out-File -FilePath $ReadmePath -Encoding UTF8
            }
        } else {
            Write-Host "   ❌ Worktree 創建失敗" -ForegroundColor Red
        }
    }

    # 安裝依賴（如果需要）
    if (-not $SkipInstall) {
        Write-Host "`n📦 安裝依賴..." -ForegroundColor Cyan
        
        foreach ($Module in $Modules) {
            $ModulePath = Join-Path $WorktreeDir $Module.Name
            $PackageJsonPath = Join-Path $ModulePath "package.json"
            
            if ((Test-Path $ModulePath) -and (Test-Path $PackageJsonPath)) {
                Write-Host "   📦 安裝 $($Module.Name) 依賴..." -ForegroundColor Yellow
                
                # 進入模組目錄
                Set-Location $ModulePath
                
                # 安裝依賴
                if (Get-Command npm -ErrorAction SilentlyContinue) {
                    npm install --silent 2>$null
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host "   ✅ $($Module.Name) 依賴安裝成功" -ForegroundColor Green
                    } else {
                        Write-Host "   ⚠️ $($Module.Name) 依賴安裝失敗" -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "   ⚠️ 未找到 npm，請手動安裝依賴" -ForegroundColor Yellow
                }
                
                # 回到原始目錄
                Set-Location $OriginalPath
            }
        }
    }

    Write-Host "`n✅ 初始化完成！" -ForegroundColor Green
    Write-Host "📁 Worktrees 位置: $WorktreeDir" -ForegroundColor Cyan
    Write-Host "🚀 下一步：" -ForegroundColor Yellow
    Write-Host "   1. code vendor-management.code-workspace" -ForegroundColor Gray
    Write-Host "   2. .\scripts\start-dev-servers.ps1 -All" -ForegroundColor Gray

} catch {
    Write-Host "`n❌ 初始化失敗: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # 確保回到原始位置
    Set-Location $OriginalPath
}
