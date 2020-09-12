#!/bin/bash
TIME=$(date '+%d-%m-%Y_%H-%M-%S')
FS_FILE=bk-$TIME.tar.gz
MYSQL_FILE=mysql.$TIME.sql.gz 

# EDIT BELOW
#.............
# MySQL USER & PASS
MYSQL_USR=
MYSQL_PASS=
#.............
 # Token ( https://www.dropbox.com/developers/apps )
TOKEN=
 # Backup Path (/root/your/path/)
BK_PATH=
 # DropBox Path (/backups/sites/)
DP_PATH=
#.............

# Archiving Sites
echo
echo "$(tput setaf 3) Archiving Sites..."
echo "$(tput setaf 2)"
tar -czf $FS_FILE $BK_PATH

#Uploading Site to dropbox
echo
echo "$(tput setaf 2) > $(tput setaf 3) Uploading files of bot to dropbox..."
echo "$(tput setaf 6)"
curl -X POST https://content.dropboxapi.com/2/files/upload  --header "Authorization: Bearer $TOKEN"  --header "Dropbox-API-Arg: {\"path\": \"$DP_PATH$FS_FILE\",\"mode\": \"add\",\"autorename\": true,\"mute\": false}"   --header "Content-Type: application/octet-stream"  --data-binary "@$FS_FILE"
echo

#Uploading database
echo
echo "$(tput setaf 2) > $(tput setaf 3) Uploading database to dropbox..."
echo "$(tput setaf 6)"
mysqldump -u $MYSQL_USR --password=$MYSQL_PASS --all-databases | gzip > $MYSQL_FILE
curl -X POST https://content.dropboxapi.com/2/files/upload  --header "Authorization: Bearer $TOKEN"  --header "Dropbox-API-Arg: {\"path\": \"$DP_PATH$MYSQL_FILE\",\"mode\": \"add\",\"autorename\": true,\"mute\": false}"   --header "Content-Type: application/octet-stream"  --data-binary "@$MYSQL_FILE"

#Cleaning up
echo
echo
echo  "$(tput setaf 2) > $(tput bold) $(tput setaf 8)[DONE]"
echo "$(tput sgr 0)"
unlink $FS_FILE
unlink $MYSQL_FILE
