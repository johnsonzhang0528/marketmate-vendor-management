# 創市通 MarketMate - 超簡化初始化腳本
# 最基本的版本，避免複雜語法

param(
    [switch]$Force
)

Write-Host "🚀 創市通 MarketMate - 超簡化初始化" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# 檢查基本環境
Write-Host "🔍 檢查環境..." -ForegroundColor Yellow

# 檢查是否在正確目錄
if (-not (Test-Path ".git")) {
    Write-Host "❌ 請在專案根目錄執行此腳本" -ForegroundColor Red
    exit 1
}

# 檢查 Git
try {
    git --version | Out-Null
    Write-Host "✅ Git 可用" -ForegroundColor Green
} catch {
    Write-Host "❌ Git 不可用" -ForegroundColor Red
    exit 1
}

# 創建 worktrees 目錄
$WorktreeDir = "../worktrees"
if (-not (Test-Path $WorktreeDir)) {
    Write-Host "📁 創建 worktrees 目錄..." -ForegroundColor Blue
    New-Item -ItemType Directory -Path $WorktreeDir -Force | Out-Null
}

# 定義模組（簡化版）
$Modules = @("frontend", "backend", "inventory", "pos", "customer", "analytics", "mobile", "docs", "shared")

Write-Host "🌿 開始創建 worktrees..." -ForegroundColor Cyan

foreach ($ModuleName in $Modules) {
    Write-Host "   🔧 處理模組: $ModuleName" -ForegroundColor Yellow
    
    $ModulePath = Join-Path $WorktreeDir $ModuleName
    $BranchName = "feature/$ModuleName"
    
    # 如果目錄已存在且需要強制重建
    if (Test-Path $ModulePath) {
        if ($Force) {
            Write-Host "   🗑️ 刪除現有目錄..." -ForegroundColor Red
            try {
                git worktree remove $ModulePath --force 2>$null
                Remove-Item -Path $ModulePath -Recurse -Force -ErrorAction SilentlyContinue
            } catch {
                # 忽略錯誤，繼續
            }
        } else {
            Write-Host "   ✅ 目錄已存在，跳過" -ForegroundColor Green
            continue
        }
    }
    
    # 創建分支
    try {
        $BranchExists = git branch --list $BranchName
        if (-not $BranchExists) {
            Write-Host "   🌿 創建分支: $BranchName" -ForegroundColor Blue
            git branch $BranchName 2>$null
        }
    } catch {
        Write-Host "   ⚠️ 分支創建失敗，使用 main 分支" -ForegroundColor Yellow
        $BranchName = "main"
    }
    
    # 創建 worktree
    try {
        Write-Host "   📁 創建 worktree..." -ForegroundColor Blue
        git worktree add $ModulePath $BranchName 2>$null
        
        if (Test-Path $ModulePath) {
            Write-Host "   ✅ $ModuleName 創建成功" -ForegroundColor Green
            
            # 創建基本 package.json
            $PackageJsonPath = Join-Path $ModulePath "package.json"
            if (-not (Test-Path $PackageJsonPath)) {
                $PackageContent = @{
                    name = "marketmate-$ModuleName"
                    version = "1.0.0"
                    scripts = @{
                        dev = "echo 'Development server for $ModuleName'"
                    }
                }
                $PackageContent | ConvertTo-Json | Out-File -FilePath $PackageJsonPath -Encoding UTF8
            }
            
            # 創建基本 README
            $ReadmePath = Join-Path $ModulePath "README.md"
            if (-not (Test-Path $ReadmePath)) {
                "# MarketMate $ModuleName Module`n`nThis is the $ModuleName module for MarketMate." | Out-File -FilePath $ReadmePath -Encoding UTF8
            }
            
        } else {
            Write-Host "   ❌ $ModuleName 創建失敗" -ForegroundColor Red
        }
    } catch {
        Write-Host "   ❌ $ModuleName 創建失敗: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n✅ 初始化完成！" -ForegroundColor Green
Write-Host "📁 Worktrees 位置: $WorktreeDir" -ForegroundColor Cyan

# 顯示創建的目錄
Write-Host "`n📊 創建的模組:" -ForegroundColor Cyan
try {
    $CreatedDirs = Get-ChildItem $WorktreeDir -Directory -ErrorAction SilentlyContinue
    foreach ($Dir in $CreatedDirs) {
        Write-Host "   ✅ $($Dir.Name)" -ForegroundColor Green
    }
} catch {
    Write-Host "   ⚠️ 無法列出目錄" -ForegroundColor Yellow
}

Write-Host "`n🚀 下一步:" -ForegroundColor Yellow
Write-Host "   1. code vendor-management.code-workspace" -ForegroundColor Gray
Write-Host "   2. 或執行: .\scripts\start-dev-servers.ps1 -All" -ForegroundColor Gray
