#!/bin/bash
set -e

# === Настройки пользователя ===
MAILCOW_HOSTNAME="mail.lapitskaya.com"         # ← Укажи здесь свой FQDN
MAILCOW_TIMEZONE="America/New_York"        # ← Укажи свой часовой пояс
DISABLE_CLAMAV="y"                         # y или n
MAILCOW_BRANCH="master"                    # master, nightly, legacy

# === Установка зависимостей ===
echo "📦 Installing dependencies..."
sudo apt update && sudo apt install -y curl git ufw fail2ban

# === Настройка UFW ===
echo "🛡 Configuring firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22,25,80,110,143,443,465,587,993,995,4190/tcp
sudo ufw --force enable

# === Установка Docker ===
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com | sh
sudo systemctl enable --now docker

# === Установка Docker Compose (плагин) ===
echo "🧩 Installing Docker Compose plugin..."
sudo apt install -y docker-compose-plugin

# === Скачивание Mailcow ===
echo "📬 Cloning Mailcow..."
cd /opt
sudo git clone https://github.com/mailcow/mailcow-dockerized
cd mailcow-dockerized
sudo git checkout $MAILCOW_BRANCH

# === Генерация конфигурации без запросов ===
echo "⚙️ Generating mailcow.conf..."
cat <<EOF | sudo tee mailcow.conf > /dev/null
MAILCOW_HOSTNAME=$MAILCOW_HOSTNAME
MAILCOW_TIMEZONE=$MAILCOW_TIMEZONE
SKIP_CLAMD=$DISABLE_CLAMAV
EOF

# === Генерация .env и сертификата ===
echo "🔐 Generating environment files and SSL cert..."
sudo ./generate_config.sh --force

# === Загрузка и запуск контейнеров ===
echo "⬇️ Pulling Docker images..."
sudo docker compose pull

echo "🚀 Starting Mailcow..."
sudo docker compose up -d

echo "✅ Mailcow installation complete!"
echo "🌐 Access it at: https://$MAILCOW_HOSTNAME"
