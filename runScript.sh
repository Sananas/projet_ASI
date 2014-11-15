#!/bin/sh

IMAGE_NAME="jamesbrink/postgresql"
IMAGE_NAME_GEOSERVER="kartoza/geoserver"
SERVER_NAME="postgis"
SERVER_NAME_GEOSERVER="geoserver"

echo "== Trying to download docker image for ${IMAGE_NAME}..."
docker pull ${IMAGE_NAME}

echo "== Trying to download docker image for ${IMAGE_NAME_GEOSERVER}..."
docker pull ${IMAGE_NAME_GEOSERVER}

echo "== Killing all existing containers"
docker kill $(docker ps -a -q)
docker rm $(docker ps -a -q)


echo "== Launching postgreSQL image and waiting 2 seconds ..."
docker run --name ${SERVER_NAME} -p 5432:5432 -d -t ${IMAGE_NAME}

echo "=== Create two dynamics containers"
docker run --link postgis:db -ti -v /vagrant:/vagrant ${IMAGE_NAME} sh -c 'exec psql -h "$DB_PORT_5432_TCP_ADDR" -p "$DB_PORT_5432_TCP_PORT" -U postgres -f /vagrant/database.sql'
docker run --link postgis:db -ti -v /vagrant:/vagrant ${IMAGE_NAME} sh -c 'exec shp2pgsql -W "LATIN1" -I -s 2154 /vagrant/shapefile/ne_110m_ocean.shp public.database | psql -h "$DB_PORT_5432_TCP_ADDR" -p "$DB_PORT_5432_TCP_PORT" -U postgres -d database'

echo "== Launching Geoserver image and waiting 2 seconds ..."
docker run --name ${SERVER_NAME_GEOSERVER} -p 8080:8080 --link ${SERVER_NAME}:${SERVER_NAME} -d -t ${IMAGE_NAME_GEOSERVER}
sleep 10

echo "Liste des containers : "
docker ps

echo "Adresse IP du serveur POSTGIS :  "
docker inspect ${SERVER_NAME} | grep IPA
