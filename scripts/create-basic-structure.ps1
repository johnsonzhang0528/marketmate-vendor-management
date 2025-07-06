# 創市通 MarketMate - 創建基本專案結構 (簡化版)

Write-Host "🏗️ 創建基本專案結構..." -ForegroundColor Cyan

# 檢查 worktrees 目錄
$WorktreeDir = "../worktrees"
if (-not (Test-Path $WorktreeDir)) {
    Write-Host "❌ worktrees 目錄不存在" -ForegroundColor Red
    exit 1
}

# 模組列表
$Modules = @("frontend", "backend", "inventory", "pos", "customer", "analytics", "mobile", "docs", "shared")

foreach ($ModuleName in $Modules) {
    $ModulePath = Join-Path $WorktreeDir $ModuleName
    
    if (Test-Path $ModulePath) {
        Write-Host "🔧 設定 $ModuleName 模組..." -ForegroundColor Yellow
        
        # 創建 src 目錄
        $SrcPath = Join-Path $ModulePath "src"
        if (-not (Test-Path $SrcPath)) {
            New-Item -ItemType Directory -Path $SrcPath -Force | Out-Null
        }
        
        # 創建 package.json
        $PackageJsonPath = Join-Path $ModulePath "package.json"
        $PackageJson = @{
            name = "marketmate-$ModuleName"
            version = "1.0.0"
            description = "MarketMate $ModuleName module"
            main = "src/index.js"
            scripts = @{
                dev = "echo 'Development server for $ModuleName'"
                build = "echo 'Build command for $ModuleName'"
                test = "echo 'Test command for $ModuleName'"
                start = "echo 'Start command for $ModuleName'"
            }
            dependencies = @{}
            devDependencies = @{}
            keywords = @("marketmate", "retail", $ModuleName)
            author = "MarketMate Team"
            license = "MIT"
            private = $true
        }
        
        $PackageJson | ConvertTo-Json -Depth 10 | Set-Content -Path $PackageJsonPath -Encoding UTF8
        
        # 創建 README.md
        $ReadmePath = Join-Path $ModulePath "README.md"
        $ReadmeContent = "# MarketMate $ModuleName Module`n`nThis is the $ModuleName module for MarketMate."
        $ReadmeContent | Set-Content -Path $ReadmePath -Encoding UTF8
        
        # 創建 index.ts
        $IndexPath = Join-Path $SrcPath "index.ts"
        $IndexContent = "console.log('MarketMate $ModuleName module loaded');"
        $IndexContent | Set-Content -Path $IndexPath -Encoding UTF8
        
        Write-Host "   ✅ $ModuleName 完成" -ForegroundColor Green
    }
}

Write-Host "`n🎉 所有模組結構創建完成！" -ForegroundColor Green
Write-Host "🚀 下一步可以執行:" -ForegroundColor Yellow
Write-Host "   code vendor-management.code-workspace" -ForegroundColor Gray
