#!/bin/bash

# WordPress 權限修復腳本
# 此腳本會修復 WordPress 目錄的權限，讓 WordPress 可以正常安裝、更新和刪除外掛

echo "🔧 修復 WordPress 目錄權限..."

# 檢查 Docker 容器是否運行
if ! docker-compose ps | grep -q "wordpress_php.*Up"; then
    echo "❌ 錯誤：PHP 容器未運行，請先執行: docker-compose up -d"
    exit 1
fi

echo "📁 設定 WordPress 核心目錄權限..."
docker-compose exec -u root php chown -R www-data:www-data /var/www/html/wp-admin /var/www/html/wp-includes
docker-compose exec -u root php chmod -R 755 /var/www/html/wp-admin /var/www/html/wp-includes

echo "📁 設定 WordPress 根目錄檔案權限..."
docker-compose exec -u root php find /var/www/html -maxdepth 1 -type f \( -name "*.php" -o -name "*.txt" -o -name "*.html" \) -exec chown www-data:www-data {} \;
docker-compose exec -u root php find /var/www/html -maxdepth 1 -type f \( -name "*.php" -o -name "*.txt" -o -name "*.html" \) -exec chmod 644 {} \;

echo "📁 設定 wp-content 目錄權限..."
docker-compose exec -u root php chown -R www-data:www-data /var/www/html/wp-content
docker-compose exec -u root php chmod -R 775 /var/www/html/wp-content

echo "📁 設定 plugins 目錄權限（允許開發者寫入）..."
docker-compose exec -u root php chown -R 1000:1000 /var/www/html/wp-content/plugins
docker-compose exec -u root php chmod -R 775 /var/www/html/wp-content/plugins

echo "📁 建立必要的目錄..."
docker-compose exec -u root php mkdir -p /var/www/html/wp-content/uploads
docker-compose exec -u root php mkdir -p /var/www/html/wp-content/upgrade
docker-compose exec -u root php mkdir -p /var/www/html/wp-content/cache

echo "🔐 設定上傳目錄權限..."
docker-compose exec -u root php chown -R www-data:www-data /var/www/html/wp-content/uploads
docker-compose exec -u root php chmod -R 775 /var/www/html/wp-content/uploads

echo "✅ 權限修復完成！"
echo ""
echo "現在 WordPress 應該可以："
echo "  - 安裝和刪除外掛"
echo "  - 安裝和刪除主題"
echo "  - 上傳媒體檔案"
echo "  - 更新 WordPress 核心"
echo "  - 在 plugins 目錄貼上開發中的外掛"

