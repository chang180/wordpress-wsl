#!/bin/bash

# WordPress Docker 開發環境啟動腳本

echo "🚀 啟動 WordPress 開發環境..."

# 確保使用 docker compose（新版）而非 docker-compose（舊版）
COMPOSE_CMD="docker compose"

# 檢查 Docker daemon 是否可用
# 注意：Docker Desktop 在 WSL2 中應該通過 WSL Integration 設定自動建立 /var/run/docker.sock
# 如果沒有，請在 Docker Desktop Settings → Resources → WSL Integration 中啟用你的 WSL distro
if ! docker info >/dev/null 2>&1; then
    echo ""
    echo "❌ 無法連線到 Docker daemon。"
    echo ""
    echo "請按照以下步驟操作："
    echo "1. 確認 Windows 端 Docker Desktop 正在執行"
    echo "2. 開啟 Docker Desktop → Settings → Resources → WSL Integration"
    echo "3. 確保「Enable integration with my default WSL distro」已勾選"
    echo "4. 在下方列表中勾選你的 WSL distro（例如：Ubuntu）"
    echo "5. 點擊「Apply & Restart」"
    echo ""
    echo "完成後，在 WSL 中執行以下命令確認："
    echo "   ls -la /var/run/docker.sock"
    echo "   docker info"
    echo ""
    echo "如果仍無法連線，請嘗試重啟 Docker Desktop 或 WSL。"
    exit 1
fi

# 檢查 .env 檔案是否存在
if [ ! -f .env ]; then
    echo "📝 建立 .env 檔案..."
    cp .env.example .env
    echo "✅ .env 檔案已建立，請根據需要修改其中的設定值"
fi

# 檢查 wp-config.php 是否存在
if [ ! -f wp-config.php ]; then
    echo "📝 建立 wp-config.php 檔案..."
    cp wp-config-sample.php wp-config.php
    echo "✅ wp-config.php 檔案已建立，請根據需要修改其中的設定值"
fi

# 啟動 Docker Compose 服務
echo "🐳 啟動 Docker 容器..."
${COMPOSE_CMD} up -d --build

# 等待服務啟動
echo "⏳ 等待服務啟動..."
sleep 5

# 檢查服務狀態
echo "📊 服務狀態："
${COMPOSE_CMD} ps

echo ""
echo "✅ WordPress 開發環境已啟動！"
echo ""
echo "🌐 訪問地址："
echo "   - WordPress: http://wordpress.test  (或 http://localhost)"
echo "   - phpMyAdmin: http://localhost:8080"
echo ""
echo "📝 提示："
echo "   - 首次訪問 WordPress 時，請按照安裝精靈完成設定"
echo "   - 資料庫資訊可在 .env 檔案中找到"
echo "   - 使用 '${COMPOSE_CMD} logs' 查看日誌"
echo "   - 使用 '${COMPOSE_CMD} down' 停止服務"

