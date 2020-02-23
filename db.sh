#!/bin/bash
IFS='='

if ! [[ $(command -v mongodump) ]] && [[ $(command -v mongorestore)  ]]; 
then
        echo "You need mongodump and mongorestore to use this tool"
        echo "Please download them from: https://www.mongodb.com/download-center/community?jmp=docs"
        exit 0
fi

#while (( "$#" )); do
case "$1" in
        -h|--help)
                echo 'Usage:'
                echo '    db -h                   Display this help message.'
                echo '    db -b                   Backup the database.'
                echo '    db -r                   Restore the database.'
                echo "====================================================="
                echo 'Examples:'
                echo "====================================================="
                echo 'Backup:'
                echo -e '\e[32mdb backup --uri="mongodb://{username}:{password}@{url}"'
                echo -e '\e[39mRestore:'
                echo -e '\e[32mdb restore --uri="mongodb://test:test@localhost:27017/cfw-collab-mongodb" ~/projects/dbbakups/db_1578695675/dump'
                echo -e '\e[32mdb restore --host=localhost --port=27017 --authenticationDatabase=collab-mongodb --username=test --password=test db_1578695633/'
                echo -e '\e[39mMigrate:'
                echo -e '\e[32mdb migrate --uri-source="mongodb://{username}:{password}@{url}" --uri-destination="mongodb://{username}:{password}@{url}"'
                exit 0
                ;; 
        -v|--version)
                echo "Version 1.0.0"
                echo "====================================================="
                echo "Tested with the following versions"
                echo "====================================================="
                echo "mongodump version: r4.2.2"
                echo "git version: a0bbbff6ada159e19298d37946ac8dc4b497eadf"
                echo "Go version: go1.12.13"
                echo "   os: windows"
                echo "   arch: amd64"
                echo "   compiler: gc"
                echo "-----------------------------------------------------"
                echo "mongorestore version: r4.2.2"
                echo "git version: a0bbbff6ada159e19298d37946ac8dc4b497eadf"
                echo "Go version: go1.12.13"
                echo "   os: windows"
                echo "   arch: amd64"
                echo "   compiler: gc"
                exit 0
                ;;
        backup|restore|migrate)
                subcommand=$1
                shift
                ;;
        *)
                echo "Invalid Option: $1"
                exit 1
                ;;
esac

case "$subcommand" in
        backup)
                timestamp=$(date +"%s")
                backup_directory="$(pwd)/db_${timestamp}"
                echo "Performing backup to path ${backup_directory}"
                mkdir "$backup_directory"
                cd "$backup_directory"
                mongodump $@
                echo "Backup path $backup_directory"
                exit 0
                ;;
        restore)
                echo "Performing restore"
                mongorestore $@
                exit 0
                ;;
        migrate)
                echo 'Perfoming migration'
                while (( "$#" )); do
                        case "$1" in
                                --uri-source=*)
                                        read -ra ARGS <<< "$1"
                                        source="${ARGS[1]}"
                                        shift
                                        ;;
                                --uri-destination=*)
                                        read -ra ARGS <<< "$1"
                                        destination="${ARGS[1]}"
                                        shift
                                        ;;
                                *)
                                        echo "Invalid Option: $1"
                                        exit 1
                                        ;;
                        esac
                done

                timestamp=$(date +"%s")
                backup_directory="$(pwd)/db_${timestamp}"
                echo "Performing backup to path ${backup_directory}"
                mkdir "$backup_directory"
                cd "$backup_directory"
                mongodump --uri=$source
                echo "Backup path $backup_directory"
                destDir="$backup_directory/dump/"
                
                IFS='/'
                read -ra SRC <<< "$source"
                read -ra DESTS <<< "$destination"

                mv "$destDir/${SRC[3]}" "$destDir/${DESTS[3]}"

                IFS=' '
                echo "Performing restore"
                mongorestore --uri="$destination" $destDir
                exit 0
                ;;
esac

exit 0
