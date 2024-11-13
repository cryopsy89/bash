#!/bin/bash

# Версия node-exporter
NODE_EXPORTER_VERSION="1.5.0"

# Проверка, выполняется ли скрипт с правами суперпользователя
if [ "$(id -u)" -ne 0 ]; then
  echo "Этот скрипт необходимо запускать с правами суперпользователя."
  exit 1
fi

# Создание временной директории и переход в нее
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
wget "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
tar xvf "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
cp "node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter" /usr/local/bin/
useradd --no-create-home --shell /bin/false node_exporter

# Создание системного юнит-файла для node-exporter
cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter --web.listen-address=:9182

[Install]
WantedBy=default.target
EOF
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter
# Очистка временной директории
rm -rf "$TMP_DIR"

echo "Node Exporter версии ${NODE_EXPORTER_VERSION} успешно установлен и запущен на порту 9182."
