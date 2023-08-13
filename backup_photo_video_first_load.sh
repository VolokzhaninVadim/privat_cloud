#!/bin/bash

echo $(date '+%Y-%m-%d %H %M %S') 'Create variables'
FILE=$(date '+%Y-%m-%d_%H_%M_%S')
ARCHIVE_TYPE='zst'
GPG_TYPE='gpg'
PROJECT='photo_video'
DIRECTORY_SOURCE='/mnt/backup/my videos/ /mnt/backup/photo/ /mnt/backup/backup/angel_smartphones/ /mnt/backup/backup/vvy_smartphones/'
DIRECTORY_TARGET='/mnt/backup/backup/backup'
DIRECTORY_S3='/mnt/s3/backup/'$PROJECT
GPG_KEY=634064C6
GPG_PASSPHRASE=/home/volokzhanin/.gnupg/backup_passphrase

echo $(date '+%Y-%m-%d %H %M %S') 'Create archive'
tar --create \
    --zstd \
    --file=$DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE \
    --ignore-failed-read \
    --preserve-permissions \
    --verbose \
    --listed-incremental='/home/volokzhanin/server/repos/cloud/private_cloud/'$PROJECT.snar \
$DIRECTORY_SOURCE

echo $(date '+%Y-%m-%d %H %M %S') 'Create encrypted archive'
gpg --recipient $GPG_KEY \
    --symmetric \
    --batch \
    --passphrase-file $GPG_PASSPHRASE \
    --no-tty \
    --encrypt $DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE

echo $(date '+%Y-%m-%d %H %M %S') 'Remove archive'
rm $DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE

echo $(date '+%Y-%m-%d %H %M %S') 'Split encrypted archive'
split --bytes=20GB \
    $DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE.$GPG_TYPE \
    $DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE.$GPG_TYPE.part_
rm $DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE.$GPG_TYPE

echo $(date '+%Y-%m-%d %H %M %S') 'Move file'
for i in $DIRECTORY_TARGET/$FILE'_'$PROJECT'_''.'$ARCHIVE_TYPE.$GPG_TYPE.part_*;
do
rsync --partial --progress $i $DIRECTORY_S3
rm $i;
done;