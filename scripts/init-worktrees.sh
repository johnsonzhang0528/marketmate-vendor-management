#!/bin/bash

# 前端專案初始化
echo "���️ 初始化前端專案..."
cd ../worktrees/frontend
npx create-react-app . --template typescript
npm install @types/node @types/react @types/react-dom
npm install tailwindcss postcss autoprefixer
npm install axios react-query zustand
npm install @testing-library/jest-dom @testing-library/react @testing-library/user-event

# 後端專案初始化
echo "⚙️ 初始化後端專案..."
cd ../backend
npm init -y
npm install express cors helmet morgan
npm install @types/express @types/cors @types/node typescript ts-node nodemon --save-dev
npm install prisma @prisma/client
npm install jsonwebtoken bcryptjs joi
npm install @types/jsonwebtoken @types/bcryptjs --save-dev

# 庫存管理模組
echo "��� 初始化庫存管理模組..."
cd ../inventory
npm init -y
npm install react react-dom typescript
npm install @types/react @types/react-dom --save-dev

# POS 系統模組
echo "��� 初始化 POS 系統模組..."
cd ../pos
npm init -y
npm install react react-dom typescript
npm install @types/react @types/react-dom --save-dev

# 客戶管理模組
echo "��� 初始化客戶管理模組..."
cd ../customer
npm init -y
npm install react react-dom typescript
npm install @types/react @types/react-dom --save-dev

# 財務分析模組
echo "��� 初始化財務分析模組..."
cd ../analytics
npm init -y
npm install react react-dom typescript chart.js react-chartjs-2
npm install @types/react @types/react-dom --save-dev

# 行動應用模組
echo "��� 初始化行動應用模組..."
cd ../mobile
npx react-native init VendorManagementMobile --template react-native-template-typescript

# 文件模組
echo "��� 初始化文件模組..."
cd ../docs
npm init -y
npm install vitepress

echo "✅ 所有 Worktree 專案初始化完成！"
