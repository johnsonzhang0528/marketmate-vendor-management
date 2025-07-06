# 創市通 MarketMate - 創建基本專案結構
# 跳過依賴安裝，只創建基本的專案結構

Write-Host "🏗️ 創建基本專案結構..." -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

# 檢查 worktrees 目錄
$WorktreeDir = "../worktrees"
if (-not (Test-Path $WorktreeDir)) {
    Write-Host "❌ worktrees 目錄不存在，請先執行初始化腳本" -ForegroundColor Red
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
            Write-Host "   📁 創建 src 目錄" -ForegroundColor Green
        }
        
        # 創建基本 package.json
        $PackageJsonPath = Join-Path $ModulePath "package.json"
        $PackageJson = @{
            name = "marketmate-$ModuleName"
            version = "1.0.0"
            description = "MarketMate $ModuleName 模組"
            main = "src/index.js"
            scripts = @{
                dev = "echo 'Development server for $ModuleName - Port 400X'"
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
        Write-Host "   📦 創建 package.json" -ForegroundColor Green
        
        # 創建基本 README.md
        $ReadmePath = Join-Path $ModulePath "README.md"
        $ReadmeContent = @"
# MarketMate $ModuleName 模組

## 📝 說明
這是創市通 MarketMate 的 $ModuleName 模組。

## 🚀 快速開始

```bash
# 安裝依賴
npm install

# 啟動開發伺服器
npm run dev
```

## 📋 功能
- 待開發...

## 🔧 技術棧
- 待定義...
"@
        
        $ReadmeContent | Set-Content -Path $ReadmePath -Encoding UTF8
        Write-Host "   📖 創建 README.md" -ForegroundColor Green
        
        # 創建基本 index 文件
        $IndexPath = Join-Path $SrcPath "index.ts"
        $IndexContent = @"
/**
 * MarketMate $ModuleName 模組
 * 
 * @description 這是 MarketMate 的 $ModuleName 模組入口文件
 * @author MarketMate Team
 * @version 1.0.0
 */

console.log('🚀 MarketMate $ModuleName 模組已載入');

// TODO: 實作 $ModuleName 模組功能

export default {
  name: '$ModuleName',
  version: '1.0.0',
  description: 'MarketMate $ModuleName 模組'
};
"@
        
        $IndexContent | Set-Content -Path $IndexPath -Encoding UTF8
        Write-Host "   📄 創建 index.ts" -ForegroundColor Green
        
        # 創建 .gitignore
        $GitignorePath = Join-Path $ModulePath ".gitignore"
        $GitignoreContent = @"
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Production
dist/
build/

# Environment
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# nyc test coverage
.nyc_output

# Dependency directories
jspm_packages/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# next.js build output
.next

# nuxt.js build output
.nuxt

# vuepress build output
.vuepress/dist

# Serverless directories
.serverless

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/
"@
        
        $GitignoreContent | Set-Content -Path $GitignorePath -Encoding UTF8
        Write-Host "   🚫 創建 .gitignore" -ForegroundColor Green
        
        Write-Host "   ✅ $ModuleName 模組設定完成" -ForegroundColor Green
        
    } else {
        Write-Host "⚠️ 模組目錄不存在: $ModuleName" -ForegroundColor Yellow
    }
    
    Write-Host ""
}

Write-Host "🎉 所有模組基本結構創建完成！" -ForegroundColor Green
Write-Host "📊 創建的內容:" -ForegroundColor Cyan
Write-Host "   📦 package.json - 基本專案配置" -ForegroundColor Gray
Write-Host "   📖 README.md - 專案說明文件" -ForegroundColor Gray
Write-Host "   📄 src/index.ts - 入口文件" -ForegroundColor Gray
Write-Host "   🚫 .gitignore - Git 忽略文件" -ForegroundColor Gray

Write-Host "`n🚀 接下來可以:" -ForegroundColor Yellow
Write-Host "   1. 手動為每個模組安裝所需的依賴" -ForegroundColor Gray
Write-Host "   2. 或執行: .\scripts\create-package-json.ps1 (創建完整 package.json)" -ForegroundColor Gray
Write-Host "   3. 然後執行: .\scripts\install-all-deps.ps1 (安裝依賴)" -ForegroundColor Gray
Write-Host "   4. 最後執行: .\scripts\start-dev-servers.ps1 -All (啟動開發)" -ForegroundColor Gray

Write-Host "`n💡 或者直接開啟 VSCode 工作區開始開發:" -ForegroundColor Yellow
Write-Host "   code vendor-management.code-workspace" -ForegroundColor Gray
