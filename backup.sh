#!/bin/sh

echo "** STARTING BACKUP PROCESS **\n"

cd "$(dirname "$0")"
export $(cat .env | xargs)

# Backup folder name
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_DIR="$SERVER_ALIAS/$TIMESTAMP"

# Create backup directory in case it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get list of Ghost instances that need to backed up
instances=$(cat ~/.ghost/config | grep -oP '(?<="cwd": "/var/www/).*?(?=")')

for inst in $instances; do
    echo "* Backing up $inst *\n"

    # Create temporary backup
    gzip $BACKUP_DIR/$inst

    # Use rclone to upload files to the remote backup server
    rclone copy $BACKUP_DIR/ $RCLONE_REMOTE:$BACKUP_DIR

    # Delete file
    rm $BACKUP_DIR/$inst.gz

    echo "* Finished backing up $inst *\n"
done

# Delete backup file
rmdir $BACKUP_DIR

echo "** BACKUP PROCESS DONE. **"
