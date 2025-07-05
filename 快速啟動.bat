@echo off
chcp 65001 > nul
echo 🚀 創市通 MarketMate - 快速啟動並行開發環境
echo ============================================
echo.

echo 🔍 檢查 PowerShell...
powershell -Command "if ($PSVersionTable.PSVersion.Major -lt 5) { exit 1 }"
if errorlevel 1 (
    echo ❌ 需要 PowerShell 5.0 或更高版本
    pause
    exit /b 1
)

echo ✅ PowerShell 版本檢查通過
echo.

echo 🌟 啟動完整設定腳本...
echo.

powershell -ExecutionPolicy Bypass -File ".\scripts\setup-complete.ps1" -StartServers

echo.
echo 🎯 腳本執行完成！
echo.
echo 💡 如需手動啟動開發伺服器，請執行：
echo    .\scripts\start-dev-servers.ps1 -All
echo.
echo 📚 查看完整說明：
echo    type QUICK_START.md
echo.
pause
