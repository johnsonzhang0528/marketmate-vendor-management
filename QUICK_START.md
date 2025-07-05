# 🚀 創市通 MarketMate - 並行開發環境快速啟動指南

## 🎯 一鍵啟動步驟

### 🌟 方法一：完整自動化設定
```powershell
# 在專案根目錄執行
.\scripts\setup-complete.ps1 -StartServers
```

### 🚀 方法二：分步驟執行
```powershell
# 1. 初始化 Git Worktree
.\scripts\init-worktrees.ps1

# 2. 安裝所有依賴
.\scripts\install-all-deps.ps1

# 3. 啟動所有開發伺服器
.\scripts\start-dev-servers.ps1 -All
```

### 🔧 方法三：使用 VSCode 任務面板
1. 按 `Ctrl+Shift+P` 開啟命令面板
2. 輸入 `Tasks: Run Task`
3. 選擇以下任務：
   - `🌟 Setup: Complete Environment` - 完整設定
   - `🚀 Dev: Start All Servers` - 啟動所有伺服器
   - `📦 Install: All Dependencies` - 安裝依賴

## 📊 開發伺服器端口配置

| 模組 | 端口 | 網址 | 說明 |
|------|------|------|------|
| 🖥️ Frontend | 4000 | http://localhost:4000 | React + TypeScript 前端 |
| ⚙️ Backend | 4001 | http://localhost:4001 | Node.js + Express 後端 |
| 📦 Inventory | 4002 | http://localhost:4002 | 庫存管理模組 |
| 💰 POS | 4003 | http://localhost:4003 | POS 系統模組 |
| 👥 Customer | 4004 | http://localhost:4004 | 客戶管理模組 |
| 📊 Analytics | 4005 | http://localhost:4005 | 財務分析模組 |
| 📱 Mobile | 4006 | http://localhost:4006 | 行動應用 |
| 📚 Docs | 4173 | http://localhost:4173 | VitePress 文件 |

## 🗂️ 專案結構

```
vendor-management-system/
├── .vscode/                    # VSCode 設定
│   ├── settings.json          # 編輯器設定
│   ├── tasks.json             # 任務設定
│   ├── launch.json            # 除錯設定
│   └── extensions.json        # 建議擴展
├── scripts/                   # 自動化腳本
│   ├── setup-complete.ps1     # 🌟 完整設定
│   ├── init-worktrees.ps1     # 初始化 Worktree
│   ├── install-all-deps.ps1   # 安裝依賴
│   ├── start-dev-servers.ps1  # 啟動伺服器
│   └── sync-all-worktrees.ps1 # 同步代碼
├── ../worktrees/              # Git Worktree 目錄
│   ├── frontend/              # 前端模組
│   ├── backend/               # 後端模組
│   ├── inventory/             # 庫存模組
│   ├── pos/                   # POS 模組
│   ├── customer/              # 客戶模組
│   ├── analytics/             # 分析模組
│   ├── mobile/                # 行動應用
│   ├── docs/                  # 文件
│   └── shared/                # 共用庫
└── vendor-management.code-workspace  # VSCode 工作區
```

## 🛠️ 常用腳本命令

### 🔄 同步與版本控制
```powershell
# 拉取所有模組的最新更新
.\scripts\sync-all-worktrees.ps1 -Pull

# 推送所有模組的更改
.\scripts\sync-all-worktrees.ps1 -Push

# 同時拉取和推送
.\scripts\sync-all-worktrees.ps1 -Pull -Push
```

### 📦 依賴管理
```powershell
# 安裝所有依賴
.\scripts\install-all-deps.ps1

# 清理並重新安裝
.\scripts\install-all-deps.ps1 -Clean

# 更新所有依賴
.\scripts\install-all-deps.ps1 -Update

# 使用 yarn 或 pnpm
.\scripts\install-all-deps.ps1 -PackageManager yarn
```

### 🚀 開發伺服器
```powershell
# 啟動所有伺服器
.\scripts\start-dev-servers.ps1 -All

# 只啟動前端
.\scripts\start-dev-servers.ps1 -Frontend

# 只啟動後端
.\scripts\start-dev-servers.ps1 -Backend

# 前端+後端
.\scripts\start-dev-servers.ps1 -Frontend -Backend
```

### 🌟 完整設定
```powershell
# 完整設定（推薦）
.\scripts\setup-complete.ps1

# 強制重新初始化
.\scripts\setup-complete.ps1 -Force

# 跳過依賴安裝
.\scripts\setup-complete.ps1 -SkipInstall

# 設定後詢問是否啟動伺服器
.\scripts\setup-complete.ps1 -StartServers
```

## 🎯 快速開發流程

### 🌅 每日開發啟動
```powershell
# 1. 更新所有代碼
.\scripts\sync-all-worktrees.ps1 -Pull

# 2. 啟動開發環境
.\scripts\start-dev-servers.ps1 -All

# 3. 開啟 VSCode 工作區
code vendor-management.code-workspace
```

### 🌙 每日開發結束
```powershell
# 1. 同步並推送更改
.\scripts\sync-all-worktrees.ps1 -Push

# 2. 關閉所有開發伺服器（關閉 PowerShell 視窗）
```

## 🔧 VSCode 使用技巧

### 📋 任務快捷鍵
- `Ctrl+Shift+P` → `Tasks: Run Task` - 執行任務
- `Ctrl+Shift+P` → `Tasks: Restart Running Task` - 重新啟動任務
- `Ctrl+Shift+P` → `Tasks: Terminate Task` - 終止任務

### 🔍 多資料夾搜尋
- `Ctrl+Shift+F` - 在所有資料夾中搜尋
- `Ctrl+Shift+H` - 在所有資料夾中取代

### 🚀 快速切換
- `Ctrl+P` - 快速開啟檔案
- `Ctrl+Shift+E` - 檔案總管
- `Ctrl+Shift+G` - 原始檔控制

## 🐛 常見問題解決

### ❓ 如果腳本無法執行
```powershell
# 設定執行政策
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### ❓ 如果端口被佔用
```powershell
# 查看端口使用情況
netstat -an | findstr :4000

# 殺死佔用端口的進程
Get-Process -Id (Get-NetTCPConnection -LocalPort 4000).OwningProcess | Stop-Process
```

### ❓ 如果 Git Worktree 出現問題
```powershell
# 清理 Worktree
git worktree prune

# 重新初始化
.\scripts\init-worktrees.ps1 -Force
```

## 📚 進階使用

### 🔧 自訂模組配置
編輯 `scripts/init-worktrees.ps1` 中的 `$Modules` 陣列來新增或修改模組。

### 🎨 自訂 VSCode 設定
- 編輯 `.vscode/settings.json` - 編輯器設定
- 編輯 `.vscode/tasks.json` - 任務設定
- 編輯 `.vscode/launch.json` - 除錯設定

### 🔍 監控開發伺服器
腳本會自動監控伺服器狀態，按 `Ctrl+C` 可退出監控。

## 🎉 開始開發！

現在您已經擁有一個完整的並行開發環境！

1. 🚀 執行 `.\scripts\setup-complete.ps1` 開始
2. 🌐 在瀏覽器中訪問 http://localhost:4000
3. 💻 開始您的創市通 MarketMate 開發之旅！

Happy Coding! 🎯
