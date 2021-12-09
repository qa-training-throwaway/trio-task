# Trio-task

This is a Flask application that is set up and configured to work with a database and nginx. Write a docker-compose.yaml that will bring all these services up and allow the app to run on port `80`.


# App Image

docker build -t flask-image .

# App Container

docker run -d --network trio-network --name flask-app flask-image

# Nginx

docker run -d -p 80:80 --network trio-network --name proxy-container --mount type=bind,source=$(pwd)/nginx.conf,target=/etc/nginx/nginx.conf nginx

# SQL Image
docker build -t flask-db-image .

# SQL Container

docker run -d --network trio-network --name mysql flask-db-image