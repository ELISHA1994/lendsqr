#!/bin/sh

export DIR_DATA_PATH="$PWD"
echo "DIR_DATA_PATH: $DIR_DATA_PATH"
export NGINX_COMMAND="nginx-debug, '-g', 'daemon off;'"
echo "NGINX-COMMAND: $NGINX_COMMAND"

export DATABASE_HOST="database"
echo "DATABASE_HOST: $DATABASE_HOST"
export REDIS_MASTER_HOST="6379"
export REDIS_SLAVE_HOST="redis-slave"
export REDIS_SLAVE_PORT="6379"

docker-compose -f docker-compose.yml up --force-recreate -d
