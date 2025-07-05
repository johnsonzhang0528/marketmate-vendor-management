# 創市通 MarketMate - VSCode 快速啟動指南

## 🚀 立即開始

### 1. 開啟工作區
```bash
# 在 VSCode 中開啟工作區文件
code vendor-management.code-workspace
```

### 2. 安裝建議擴展
VSCode 會自動提示安裝建議的擴展，請接受安裝以獲得最佳開發體驗。

**核心擴展：**
- GitHub Copilot & Copilot Chat
- TypeScript 支援
- Prettier & ESLint
- Tailwind CSS IntelliSense
- Prisma 支援
- Git Worktrees

### 3. 初始化開發環境
使用 VSCode 命令面板 (`Ctrl+Shift+P`):
```
Tasks: Run Task > 🔧 Setup Development Environment
```

這會自動執行：
- 初始化所有 Git Worktrees
- 安裝依賴套件
- 設定資料庫
- 填充測試資料

## 🛠️ 日常開發流程

### 啟動開發環境
```
Ctrl+Shift+P > Tasks: Run Task > 🚀 Start Full Development Environment
```

這會同時啟動：
- 🖥️ 前端開發伺服器 (Vite)
- ⚙️ 後端開發伺服器 (Node.js)
- 🗄️ 資料庫管理介面 (Prisma Studio)

### 除錯模式
按 `F5` 選擇除錯配置：
- 🚀 Debug Full Stack - 同時除錯前後端
- 🧪 Debug Tests - 除錯測試
- 🛠️ Debug Tools - 除錯開發工具

### 執行測試
```
Ctrl+Shift+P > Tasks: Run Task > 🧪 Run Complete Test Suite
```

### 代碼品質檢查
```
Ctrl+Shift+P > Tasks: Run Task > 🔍 Lint: Fix All
```

## 📁 Git Worktree 結構

```
vendor-management-system/
├── .vscode/                     # VSCode 配置
│   ├── copilot-instructions.md  # GitHub Copilot 指導
│   ├── new-copilot-instructions.md # 進階開發指導
│   ├── settings.json            # 工作區設定
│   ├── launch.json              # 除錯配置
│   └── tasks.json               # 任務定義
├── worktrees/                   # Git Worktree 目錄
│   ├── frontend/                # React + TypeScript
│   ├── backend/                 # Node.js + Express + Prisma
│   ├── inventory/               # 庫存管理模組
│   ├── pos/                     # POS 系統模組
│   ├── customer/                # 客戶管理模組
│   ├── analytics/               # 財務分析模組
│   ├── mobile/                  # 行動應用
│   ├── docs/                    # VitePress 文件
│   └── shared/                  # 共用類型和工具
├── scripts/                     # 自動化腳本
└── vendor-management.code-workspace # 工作區文件
```

## 🎯 開發模式

### 單一模組開發
如果只想開發特定模組：
```
Ctrl+Shift+P > Tasks: Run Task > 📦 Dev: [選擇模組]
```

### 並行開發
可以同時開發多個模組：
```
Ctrl+Shift+P > Tasks: Run Task > 📦 Start All Modules
```

### 設計系統開發
同時啟動前端和 Storybook：
```
Ctrl+Shift+P > Tasks: Run Task > 🎨 Start Design System
```

## 🔧 常用快捷鍵

| 功能 | 快捷鍵 | 說明 |
|------|--------|------|
| 命令面板 | `Ctrl+Shift+P` | 執行任務和命令 |
| 檔案搜尋 | `Ctrl+P` | 快速開啟檔案 |
| 全域搜尋 | `Ctrl+Shift+F` | 跨專案搜尋 |
| 啟動除錯 | `F5` | 啟動除錯器 |
| 整合終端 | `Ctrl+`` | 開啟終端 |
| 格式化代碼 | `Shift+Alt+F` | 格式化當前文件 |
| 修復問題 | `Ctrl+.` | 快速修復建議 |

## 🌐 開發 URL

啟動開發環境後可存取：

- **前端應用**: http://localhost:4173
- **後端 API**: http://localhost:4001
- **Prisma Studio**: http://localhost:5555
- **Storybook**: http://localhost:6006
- **文件網站**: http://localhost:8080

## 📝 與 Claude Code 協作

### 使用 Copilot 指導文件
在開發時，可以參考：
- `.vscode/copilot-instructions.md` - 基礎開發指導
- `.vscode/new-copilot-instructions.md` - 進階技術指導

### 提示詞範本
向 Claude Code 提問時使用此格式：

```markdown
## 🎯 開發任務
**模組**: [frontend/backend/inventory/pos/customer/analytics]
**功能**: [具體功能描述]
**技術需求**: TypeScript + React/Node.js + Git Worktree

## 📁 專案結構
基於 Git Worktree 的模組化架構，使用 VSCode 工作區管理。

## 🔧 需求
請遵循 .vscode/copilot-instructions.md 中的開發規範。
```

## 🚨 常見問題解決

### 1. TypeScript 錯誤
```bash
# 重新載入 TypeScript 服務
Ctrl+Shift+P > TypeScript: Reload Project
```

### 2. ESLint 錯誤
```bash
# 自動修復 ESLint 問題
Ctrl+Shift+P > Tasks: Run Task > 🔍 Lint: Fix All
```

### 3. 依賴問題
```bash
# 重新安裝所有依賴
Ctrl+Shift+P > Tasks: Run Task > 🧹 Clean: Node Modules
Ctrl+Shift+P > Tasks: Run Task > 📦 Install: All Dependencies
```

### 4. Git Worktree 問題
```bash
# 重新初始化 Worktrees
Ctrl+Shift+P > Tasks: Run Task > 🚀 Setup: Initialize All Worktrees
```

### 5. 資料庫問題
```bash
# 重置資料庫
Ctrl+Shift+P > Tasks: Run Task > 🗄️ Database: Reset
```

## 📊 專案監控

### 效能分析
```bash
# 分析前端 Bundle 大小
Ctrl+Shift+P > Tasks: Run Task > 📊 Analysis: Bundle Size

# 執行效能測試
Ctrl+Shift+P > Tasks: Run Task > 📊 Analysis: Performance
```

### 測試覆蓋率
```bash
# 生成測試覆蓋率報告
Ctrl+Shift+P > Tasks: Run Task > 🧪 Test: Coverage Report
```

## 🚀 部署流程

### 測試環境
```bash
Ctrl+Shift+P > Tasks: Run Task > 🚀 Deploy: Staging
```

### 生產環境
```bash
Ctrl+Shift+P > Tasks: Run Task > 🚀 Deploy: Production
```

---

這個配置為創市通 MarketMate 提供了完整的 VSCode + Git Worktree 開發環境，支援並行開發和 Claude Code 協作。所有任務都可以通過 VSCode 的命令面板輕鬆執行，提高開發效率。
