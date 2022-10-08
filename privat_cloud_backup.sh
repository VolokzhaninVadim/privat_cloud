#!/bin/bash

# Создаем резервную копию
cd /home/ubuntu/docker/privat_cloud
tar cvpzf /mnt/backup/backup/vvy_privat_cloud/"$(date '+%Y-%m-%d').tar.gz" ./
# Удаляем архивы резервной копии старше n дней
find /mnt/backup/backup/vvy_privat_cloud/ -mtime +3 -type f -delete

# restore 
# sudo rsync -arvh --progress /mnt/backup/backup/vvy_privat_cloud/2021-06-20/ ./
# Получаем container id 
# docker ps
# Заходим в контейнер 
# docker exec -it container_id   bash
# Даем верные права
# chown -R www-data:www-data data/ config/


