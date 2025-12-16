# WordPress Docker 開發環境

這是一個使用 Docker 和 Docker Compose 建立的 WordPress 開發環境，包含 Nginx、PHP 8.4-FPM（含 Xdebug）、MySQL 8.0 和 phpMyAdmin。

## 📋 系統需求

- Docker
- Docker Compose

## 🚀 快速開始

### 1. 複製環境變數檔案

```bash
cp .env.example .env
```

### 2. 建立 wp-config.php

```bash
cp wp-config-sample.php wp-config.php
```

然後編輯 `wp-config.php`，設定資料庫連線資訊和安全金鑰。

### 3. 啟動服務

```bash
docker-compose up -d
```

### 4. 訪問 WordPress

- **WordPress 網站**: http://localhost
- **phpMyAdmin**: http://localhost:8080

## 🛠️ 服務說明

### Nginx
- 端口: 80 (HTTP), 443 (HTTPS)
- 配置檔案: `docker/nginx/default.conf`

### PHP 8.4-FPM
- 包含 Xdebug 3.4.0
- Xdebug 端口: 9003
- 配置檔案: `docker/php/xdebug.ini`

### MySQL 8.0
- 端口: 3306
- 資料庫名稱: wordpress（可在 .env 中修改）
- 使用者名稱: wordpress（可在 .env 中修改）

### phpMyAdmin
- 端口: 8080
- 自動連接到 MySQL 資料庫

## 🔧 開發設定

### Xdebug 設定

Xdebug 已預設啟用，配置如下：
- 模式: debug
- 客戶端主機: host.docker.internal
- 客戶端端口: 9003

在您的 IDE 中設定 Xdebug 監聽端口為 9003。

### 檔案權限

WordPress 檔案預設由 `www-data` 使用者擁有。如果需要修改檔案，可能需要調整權限：

```bash
docker-compose exec php chown -R www-data:www-data /var/www/html
```

## 📁 目錄結構

```
wordpress/
├── docker/
│   ├── nginx/
│   │   └── default.conf      # Nginx 配置
│   └── php/
│       └── xdebug.ini        # Xdebug 配置
├── wp-content/               # WordPress 內容目錄
├── docker-compose.yml        # Docker Compose 配置
├── Dockerfile                # PHP 映像檔配置
├── .env                      # 環境變數（需自行建立）
├── .env.example              # 環境變數範本
└── README.md                 # 本檔案
```

## 🛑 停止服務

```bash
docker-compose down
```

若要同時刪除資料庫資料：

```bash
docker-compose down -v
```

## 🔄 重建服務

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## 📝 注意事項

1. 首次啟動時，MySQL 需要一些時間來初始化資料庫
2. 確保端口 80、443、3306 和 8080 沒有被其他服務佔用
3. 建議在生產環境中修改預設的資料庫密碼
4. WordPress 檔案會掛載到容器中，可以直接在本地編輯

## 🐛 除錯

### 查看日誌

```bash
# 查看所有服務日誌
docker-compose logs

# 查看特定服務日誌
docker-compose logs nginx
docker-compose logs php
docker-compose logs db
```

### 進入容器

```bash
# 進入 PHP 容器
docker-compose exec php bash

# 進入 MySQL 容器
docker-compose exec db bash
```

## 📚 相關資源

- [WordPress 官方文件](https://wordpress.org/support/)
- [Docker 文件](https://docs.docker.com/)
- [Docker Compose 文件](https://docs.docker.com/compose/)

