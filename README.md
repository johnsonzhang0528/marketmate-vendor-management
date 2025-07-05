# 🏪 創市通 MarketMate - 智能零售管理系統

一個現代化的零售管理系統，採用 Git Worktree 並行開發架構，支援多模組同步開發。

## 🚀 一鍵啟動

### 🎯 方法一：雙擊啟動（推薦）
```
雙擊 快速啟動.bat
```

### 🌟 方法二：PowerShell 完整設定
```powershell
.\scripts\setup-complete.ps1 -StartServers
```

### 🔧 方法三：VSCode 任務面板
1. 按 `Ctrl+Shift+P` 開啟命令面板
2. 輸入 `Tasks: Run Task`
3. 選擇 `🌟 Setup: Complete Environment`

## 📊 系統架構

### 🗂️ 模組結構
```
創市通 MarketMate
├── 🖥️ Frontend (React + TypeScript)    - 前端界面
├── ⚙️ Backend (Node.js + Express)      - 後端API
├── 📦 Inventory                        - 庫存管理
├── 💰 POS                             - 收銀系統
├── 👥 Customer                        - 客戶管理
├── 📊 Analytics                       - 財務分析
├── 📱 Mobile                          - 行動應用
├── 📚 Docs                            - 技術文件
└── 🔗 Shared                          - 共用類型庫
```

### 🌐 服務端口
| 模組 | 端口 | 網址 | 說明 |
|------|------|------|------|
| 🖥️ Frontend | 4000 | http://localhost:4000 | React 前端 |
| ⚙️ Backend | 4001 | http://localhost:4001 | Node.js 後端 |
| 📦 Inventory | 4002 | http://localhost:4002 | 庫存管理 |
| 💰 POS | 4003 | http://localhost:4003 | POS 系統 |
| 👥 Customer | 4004 | http://localhost:4004 | 客戶管理 |
| 📊 Analytics | 4005 | http://localhost:4005 | 財務分析 |
| 📱 Mobile | 4006 | http://localhost:4006 | 行動應用 |
| 📚 Docs | 4173 | http://localhost:4173 | VitePress 文件 |

## 🛠️ 技術棧

### 前端技術
- ⚛️ **React 18** - 用戶界面庫
- 🔷 **TypeScript** - 類型安全
- 🎨 **Tailwind CSS** - 樣式框架
- 🏪 **Zustand** - 狀態管理
- 🔀 **React Router** - 路由管理
- 📱 **Responsive Design** - 響應式設計

### 後端技術
- 🟢 **Node.js** - 運行環境
- 🚀 **Express** - Web 框架
- 🔒 **tRPC** - 類型安全API
- 🗄️ **Prisma** - 資料庫ORM
- 🔐 **JWT** - 身份驗證
- 📊 **PostgreSQL** - 主資料庫

### 開發工具
- 🔧 **VSCode** - 開發環境
- 🌿 **Git Worktree** - 並行開發
- 🧪 **Vitest** - 單元測試
- 🎨 **ESLint + Prettier** - 代碼規範
- 📚 **VitePress** - 文件系統
- 🤖 **GitHub Copilot** - AI 協助

## 🚀 快速開發

### 📋 日常開發流程
```powershell
# 1. 同步最新代碼
.\scripts\sync-all-worktrees.ps1 -Pull

# 2. 啟動開發環境
.\scripts\start-dev-servers.ps1 -All

# 3. 開啟 VSCode 工作區
code vendor-management.code-workspace
```

### 🔄 常用腳本
```powershell
# 完整設定環境
.\scripts\setup-complete.ps1

# 初始化 Worktree
.\scripts\init-worktrees.ps1

# 安裝所有依賴
.\scripts\install-all-deps.ps1

# 啟動開發伺服器
.\scripts\start-dev-servers.ps1 -All

# 同步所有代碼
.\scripts\sync-all-worktrees.ps1 -Pull
```

## 🎯 功能特色

### 🏪 核心功能
- **📦 智能庫存** - 自動補貨、庫存追蹤、批次管理
- **💰 快速收銀** - 條碼掃描、多重支付、發票管理
- **👥 客戶管理** - 會員系統、消費記錄、忠誠度計劃
- **📊 商業分析** - 銷售報表、趨勢分析、利潤追蹤

### 🔧 技術特色
- **🌿 Git Worktree** - 多分支並行開發
- **⚡ 熱重載** - 快速開發反饋
- **🔒 類型安全** - 全棧 TypeScript
- **🎨 現代UI** - 響應式設計
- **📱 多平台** - Web + Mobile

### 🤖 AI 協助
- **GitHub Copilot** - 代碼智能補全
- **Claude Code** - 架構設計協助
- **自動化腳本** - 一鍵部署與測試

## 📚 詳細說明

### 📖 快速入門
詳細的設定與使用說明請參考：
- 📋 [快速啟動指南](QUICK_START.md)
- 🔧 [VSCode 設定說明](.vscode/README.md)
- 🤖 [AI 協作指南](.vscode/copilot-instructions.md)

### 🗂️ 專案結構
```
vendor-management-system/
├── 📁 .vscode/                    # VSCode 設定
├── 📁 scripts/                   # 自動化腳本
├── 📁 config/                    # 設定檔案
├── 📁 docs/                      # 專案文件
├── 📁 ../worktrees/              # Git Worktree 目錄
│   ├── 📁 frontend/              # React 前端
│   ├── 📁 backend/               # Node.js 後端
│   ├── 📁 inventory/             # 庫存管理
│   ├── 📁 pos/                   # POS 系統
│   ├── 📁 customer/              # 客戶管理
│   ├── 📁 analytics/             # 財務分析
│   ├── 📁 mobile/                # 行動應用
│   ├── 📁 docs/                  # VitePress 文件
│   └── 📁 shared/                # 共用類型庫
└── 📄 vendor-management.code-workspace  # VSCode 工作區
```

## 🔧 系統需求

### 💻 開發環境
- **作業系統**: Windows 10/11
- **Node.js**: 18.0+
- **Git**: 2.30+
- **PowerShell**: 5.0+
- **VSCode**: 1.80+

### 🔌 必要擴展
- TypeScript and JavaScript Language Features
- ESLint
- Prettier
- Tailwind CSS IntelliSense
- Prisma
- GitLens
- GitHub Copilot

## 🚀 部署

### 🏗️ 建置專案
```powershell
# 建置所有模組
.\scripts\build-all.ps1

# 建置特定模組
.\scripts\build-module.ps1 -Module frontend
```

### 🌐 部署生產環境
```powershell
# 部署到 production
.\scripts\deploy-production.ps1

# 部署到 staging
.\scripts\deploy-staging.ps1
```

## 🤝 貢獻指南

### 🌿 分支策略
- `main` - 主分支
- `feature/*` - 功能分支
- `hotfix/*` - 修復分支
- `release/*` - 發布分支

### 📝 提交規範
```
feat: 新功能
fix: 修復bug
docs: 文件更新
style: 格式修改
refactor: 重構
test: 測試
chore: 其他修改
```

### 🔄 開發流程
1. 從 `main` 分支建立功能分支
2. 在對應的 worktree 中開發
3. 提交代碼並推送到遠端
4. 建立 Pull Request
5. 代碼審查後合併

## 📄 授權

本專案採用 MIT 授權條款 - 詳見 [LICENSE](LICENSE) 文件。

## 👥 團隊

- **專案負責人**: Johnson
- **前端開發**: Frontend Team
- **後端開發**: Backend Team
- **UI/UX 設計**: Design Team

## 📞 聯絡我們

- **Email**: marketmate@example.com
- **GitHub**: https://github.com/your-org/vendor-management-system
- **文件**: https://docs.marketmate.com

---

<div align="center">
  <h3>🎯 創市通 MarketMate - 讓零售變得更智能</h3>
  <p>現代化 • 智能化 • 自動化</p>
  <p>Happy Coding! 🚀</p>
</div>
