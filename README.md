# backup-ghost-to-gdrive

Bash scripts for backing up Ghost Blog contents to GDrive

## Prerequisites

We assume at least one `Ghost` instance is configured and running on your server. 

To check, run `ghost ls` and confirm the instance you want to backup is listed. If not, you may have to manually edit the `~/.ghost/config` file and add the instance to this JSON config.

### 1. Install and configure `rclone`

See `rclone` documentation for installation here: https://rclone.org/install

See `rclone` documentation for setting up Drive here: https://rclone.org/drive

For Linux, run:
```shell
curl https://rclone.org/install.sh | sudo bash

rclone config
```

**Tip:** Set up a common *remote* for all servers where this task will run, so you can reuse for multiple servers' backups. This will allow you to run `rclone config` only once and then copy the `rclone.conf` file to each server without needing to go through configuration again. You can differentiate between the backups for each server using the `SERVER_ALIAS` environment variable outlined below.

### 3. Setup Environment Variables

Make a copy of `.env.example` in the root of this application and name it `.env`. Change the variables as needed.

**NOTE: These should be kept secret and not checked-in to any source control.**

```shell
RCLONE_REMOTE=The name of the remote you set up in Step 2
SERVER_ALIAS=The name of the folder into which the server's backup is stored within the remote. Name as appropriate to help differentiate between servers
```

## How To Run

```shell
sh backup.sh
```

## Run Weekly Backups Using Cron

Open Cron (use Nano if asked):
```shell
crontab -e
```

Add the following line to your Cron file (change the path to `backup.sh` as needed):
```shell
@weekly sh /home/user/backup-ghost-to-gdrive/backup.sh >> /home/user/backup-ghost-to-gdrive/logs/cron.log 2>&1
```
