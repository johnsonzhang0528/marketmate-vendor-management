# 創市通 MarketMate - 創建完整的 package.json 文件
# 為每個模組創建適合的 package.json

Write-Host "📦 創建完整的 package.json 文件..." -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# 檢查 worktrees 目錄
$WorktreeDir = "../worktrees"
if (-not (Test-Path $WorktreeDir)) {
    Write-Host "❌ worktrees 目錄不存在，請先執行初始化腳本" -ForegroundColor Red
    exit 1
}

# 定義每個模組的詳細配置
$ModuleConfigs = @{
    "frontend" = @{
        description = "React + TypeScript 前端應用"
        dependencies = @{
            "react" = "^18.2.0"
            "react-dom" = "^18.2.0"
            "react-router-dom" = "^6.8.0"
            "zustand" = "^4.3.0"
            "@tanstack/react-query" = "^4.20.0"
            "axios" = "^1.3.0"
            "tailwindcss" = "^3.2.0"
            "clsx" = "^1.2.0"
        }
        devDependencies = @{
            "@types/react" = "^18.0.0"
            "@types/react-dom" = "^18.0.0"
            "@vitejs/plugin-react" = "^3.1.0"
            "vite" = "^4.1.0"
            "typescript" = "^4.9.0"
            "autoprefixer" = "^10.4.0"
            "postcss" = "^8.4.0"
            "eslint" = "^8.34.0"
            "prettier" = "^2.8.0"
            "vitest" = "^0.28.0"
        }
        scripts = @{
            "dev" = "vite --host 0.0.0.0 --port 4000"
            "build" = "tsc && vite build"
            "preview" = "vite preview"
            "test" = "vitest"
            "lint" = "eslint . --ext ts,tsx --report-unused-disable-directives --max-warnings 0"
            "format" = "prettier --write ."
        }
    }
    
    "backend" = @{
        description = "Node.js + Express 後端 API"
        dependencies = @{
            "express" = "^4.18.0"
            "cors" = "^2.8.0"
            "helmet" = "^6.0.0"
            "morgan" = "^1.10.0"
            "dotenv" = "^16.0.0"
            "jsonwebtoken" = "^9.0.0"
            "bcryptjs" = "^2.4.0"
            "joi" = "^17.7.0"
            "prisma" = "^4.10.0"
            "@prisma/client" = "^4.10.0"
            "winston" = "^3.8.0"
        }
        devDependencies = @{
            "@types/express" = "^4.17.0"
            "@types/cors" = "^2.8.0"
            "@types/morgan" = "^1.9.0"
            "@types/jsonwebtoken" = "^9.0.0"
            "@types/bcryptjs" = "^2.4.0"
            "@types/node" = "^18.14.0"
            "typescript" = "^4.9.0"
            "ts-node" = "^10.9.0"
            "nodemon" = "^2.0.0"
            "jest" = "^29.4.0"
            "supertest" = "^6.3.0"
            "@types/jest" = "^29.4.0"
            "@types/supertest" = "^2.0.0"
        }
        scripts = @{
            "dev" = "nodemon --exec ts-node src/index.ts --port 4001"
            "build" = "tsc"
            "start" = "node dist/index.js"
            "test" = "jest"
            "test:watch" = "jest --watch"
            "db:migrate" = "prisma migrate dev"
            "db:seed" = "prisma db seed"
            "db:studio" = "prisma studio"
        }
    }
    
    "docs" = @{
        description = "VitePress 技術文件"
        dependencies = @{
            "vitepress" = "^1.0.0-alpha.0"
            "vue" = "^3.2.0"
        }
        devDependencies = @{
            "@types/node" = "^18.14.0"
            "typescript" = "^4.9.0"
        }
        scripts = @{
            "dev" = "vitepress dev --port 4173"
            "build" = "vitepress build"
            "preview" = "vitepress preview"
        }
    }
}

# 為其他模組創建基本配置
$BasicModules = @("inventory", "pos", "customer", "analytics", "mobile", "shared")
foreach ($ModuleName in $BasicModules) {
    $ModuleConfigs[$ModuleName] = @{
        description = "MarketMate $ModuleName 模組"
        dependencies = @{
            "react" = "^18.2.0"
            "react-dom" = "^18.2.0"
        }
        devDependencies = @{
            "@types/react" = "^18.0.0"
            "@types/react-dom" = "^18.0.0"
            "vite" = "^4.1.0"
            "typescript" = "^4.9.0"
        }
        scripts = @{
            "dev" = "vite --port 400$($BasicModules.IndexOf($ModuleName) + 2)"
            "build" = "tsc && vite build"
            "test" = "echo 'No tests specified'"
        }
    }
}

# 創建每個模組的 package.json
foreach ($ModuleName in $ModuleConfigs.Keys) {
    $ModulePath = Join-Path $WorktreeDir $ModuleName
    
    if (Test-Path $ModulePath) {
        Write-Host "📦 創建 $ModuleName 的 package.json..." -ForegroundColor Yellow
        
        $Config = $ModuleConfigs[$ModuleName]
        
        $PackageJson = @{
            name = "marketmate-$ModuleName"
            version = "1.0.0"
            description = $Config.description
            main = "index.js"
            scripts = $Config.scripts
            dependencies = $Config.dependencies
            devDependencies = $Config.devDependencies
            keywords = @("marketmate", "retail", "management", $ModuleName)
            author = "MarketMate Team"
            license = "MIT"
            private = $true
        }
        
        $PackageJsonPath = Join-Path $ModulePath "package.json"
        $PackageJson | ConvertTo-Json -Depth 10 | Set-Content -Path $PackageJsonPath -Encoding UTF8
        
        Write-Host "   ✅ $ModuleName package.json 創建成功" -ForegroundColor Green
        
        # 創建基本目錄結構
        $SrcPath = Join-Path $ModulePath "src"
        if (-not (Test-Path $SrcPath)) {
            New-Item -ItemType Directory -Path $SrcPath -Force | Out-Null
        }
        
        # 創建基本 index 文件
        $IndexPath = Join-Path $SrcPath "index.ts"
        if (-not (Test-Path $IndexPath)) {
            "// MarketMate $ModuleName Module`nconsole.log('MarketMate $ModuleName module loaded');" | Set-Content -Path $IndexPath -Encoding UTF8
        }
        
    } else {
        Write-Host "⚠️ 模組目錄不存在: $ModuleName" -ForegroundColor Yellow
    }
}

Write-Host "`n✅ 所有 package.json 創建完成！" -ForegroundColor Green
Write-Host "📋 下一步可以執行:" -ForegroundColor Cyan
Write-Host "   .\scripts\install-all-deps.ps1    # 安裝所有依賴" -ForegroundColor Gray
Write-Host "   .\scripts\start-dev-servers.ps1 -All  # 啟動開發伺服器" -ForegroundColor Gray
