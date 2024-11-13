#!/bin/bash

# Путь к логам Docker контейнеров
LOG_PATH="/var/lib/docker/containers"

# Проверка, что директория существует
if [ -d "$LOG_PATH" ]; then
    echo "Обнуляем логи контейнеров Docker в $LOG_PATH"
    # Находим и обнуляем все файлы логов контейнеров
    find "$LOG_PATH" -name "*-json.log" -exec sh -c 'cat /dev/null > {}' \;
    echo "Очистка завершена."
else
    echo "Ошибка: Директория $LOG_PATH не найдена."
    exit 1
fi
