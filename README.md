# mailcow-setup
his repository contains a complete automated setup script to deploy a secure Mailcow email server on a Debian/Ubuntu-based system.
📦 Как использовать:
Сохрани файл:
nano setup-mailcow-server.sh
Вставь туда содержимое выше, нажми Ctrl + O, затем Enter и Ctrl + X.

Сделай исполняемым:
chmod +x mailcow_setup.sh
Запусти:
./mailcow_setup.sh
🔐 Рекомендации после установки

Убедись, что DNS-записи настроены (MX, A, SPF, DKIM, DMARC);
Проверь, чтобы fail2ban работал (sudo fail2ban-client status);
Разреши HTTPS (443) доступ к панели управления почтой;
Mailcow будет доступен по адресу https://<твой_домен>.

