#!/bin/bash

set -e

echo "📦 Установка зависимостей..."
sudo apt update && sudo apt install -y curl git ufw fail2ban

echo "🛡 Настройка UFW..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22,25,80,110,143,443,465,587,993,995,4190/tcp
sudo ufw --force enable

echo "🛠 Установка Docker..."
curl -fsSL https://get.docker.com | sh
sudo systemctl enable --now docker

echo "🧰 Установка Docker Compose..."
sudo curl -sSL "https://github.com/docker/compose/releases/download/$(curl -Ls https://www.servercow.de/docker-compose/latest)/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "📬 Установка Mailcow..."
cd /opt
sudo git clone https://github.com/mailcow/mailcow-dockerized
cd mailcow-dockerized
sudo ./generate_config.sh

echo "⬇️ Загрузка образов Mailcow..."
sudo docker-compose pull

echo "🚀 Запуск Mailcow..."
sudo docker-compose up -d

echo "✅ Установка завершена!"
