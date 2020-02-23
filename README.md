# bash-mongo-helper

# Usage:
```
db -h                   Display this help message.
db -b                   Backup the database.
db -r                   Restore the database.
```

# Examples:

## Backup:
`db backup --uri="mongodb://{username}:{password}@{url}"`

## Restore:
`db restore --uri="mongodb://test:test@localhost:27017/cfw-collab-mongodb" ~/projects/dbbakups/db_1578695675/dump`
`db restore --host=localhost --port=27017 --authenticationDatabase=collab-mongodb --username=test --password=test db_1578695633/`

## Migrate:
`db migrate --uri-source="mongodb://{username}:{password}@{url}" --uri-destination="mongodb://{username}:{password}@{url}"`

# Requirements

## mongodump
```
mongodump version: r4.2.2
git version: a0bbbff6ada159e19298d37946ac8dc4b497eadf
Go version: go1.12.13
   os: windows
   arch: amd64
   compiler: gc
```

## mongorestore
```
mongorestore version: r4.2.2
git version: a0bbbff6ada159e19298d37946ac8dc4b497eadf
Go version: go1.12.13
   os: windows
   arch: amd64
   compiler: gc
```
