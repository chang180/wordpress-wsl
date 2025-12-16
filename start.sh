#!/bin/bash

# WordPress Docker 開發環境啟動腳本

echo "🚀 啟動 WordPress 開發環境..."

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
docker-compose up -d

# 等待服務啟動
echo "⏳ 等待服務啟動..."
sleep 5

# 檢查服務狀態
echo "📊 服務狀態："
docker-compose ps

echo ""
echo "✅ WordPress 開發環境已啟動！"
echo ""
echo "🌐 訪問地址："
echo "   - WordPress: http://localhost"
echo "   - phpMyAdmin: http://localhost:8080"
echo ""
echo "📝 提示："
echo "   - 首次訪問 WordPress 時，請按照安裝精靈完成設定"
echo "   - 資料庫資訊可在 .env 檔案中找到"
echo "   - 使用 'docker-compose logs' 查看日誌"
echo "   - 使用 'docker-compose down' 停止服務"

