#!/bin/bash

CHKUSERNAME=`echo $PG_USERNAME`
if [[ ! $CHKUSERNAME = '' ]]; then
    exit 1
fi

#POSTGRES='postgres'
POSTGRES='postgresql'
### for new release of PostgreSQL.
##POSTGRES='postgres-9.6'

sudo service $POSTGRES restart
if [ $? -ne 0 ]; then
    exit 1
fi

ADMINNAME='postgres'
PROFILE="$HOME/.bashrc"
# for BourneShell.
#PROFILE="$HOME/.profile"

while :
do
    echo -n "username> "
    read USERNAME
    
    USERNAME=`echo $USERNAME | tr -d ' '`
    if [[ ! $USERNAME = '' ]]; then
        break
    fi
done

while :
do
    echo -n "password> "
    read PASSWORD
    
    PASSWORD=`echo $PASSWORD | tr -d ' '`
    if [[ ! $PASSWORD = '' ]]; then
        break
    fi
done

sudo sudo -u $ADMINNAME psql <<EOSQL
    create user $USERNAME createdb password '$PASSWORD';
    update pg_database set datistemplate = false where datname = 'template1';
    drop database template1;
    create database template1 with template = template0 encoding = 'UNICODE';
    update pg_database set datistemplate = true where datname = 'template1';
    VACUUM FREEZE;
EOSQL

if [ $? -eq 0 ]; then
    echo "export PG_USERNAME=$USERNAME" >> $PROFILE
    echo "export PG_PASSWORD=$PASSWORD" >> $PROFILE
    echo 'export TZ=JST-9' >> $PROFILE
    exec bash -l
    echo "Complete!"
fi
