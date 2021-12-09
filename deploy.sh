#!/bin/bash

# Teardown
echo "Stopping All Containers..."
docker stop $(docker ps -a --format "{{.ID}}")

echo "Removing All Containers..."
docker rm $(docker ps -a --format "{{.ID}}")

echo "Removing all Images..."
docker rmi $(docker images --format "{{.ID}}")

echo "Removing Network..."
docker network rm trio-network

# Create Network
echo "Creating Network..."
docker network create trio-network

# Create Volume db-volume

# DB
echo "Building and Starting DB..."
docker build -t flask-db-image db/
docker run -d \
    --network trio-network \
    --volume db-volume:/var/lib/mysql \
    --name mysql flask-db-image

# Flask
echo "Building and Starting Flask..."
docker build -t flask-image flask-app/
docker run -d \
    --network trio-network \
    --name flask-app flask-image

# NGINX
echo "Building and Starting Nginx..."
docker run -d -p 80:80 --network trio-network --name proxy-container --mount type=bind,source=/home/ubuntu/docker-exercises/trio-task/nginx/nginx.conf,target=/etc/nginx/nginx.conf nginx