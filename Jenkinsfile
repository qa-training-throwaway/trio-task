pipeline {
    agent any
    triggers {
        githubPush()
    }
    stages {
        stage('Setup') {
            steps {
                deleteDir()
                checkout scm
                sh """
                echo "Stopping All Containers..."
                docker stop \$(docker ps -a --format "{{.ID}}")

                echo "Removing All Containers..."
                docker rm \$(docker ps -a --format "{{.ID}}")

                echo "Removing all Images..."
                docker rmi \$(docker images --format "{{.ID}}")
                """
            }
        }
        stage('Build and Push DB Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_CREDENTIALS', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]){
                    sh """
                        docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                        docker build -t ${DOCKER_USERNAME}/flask-db-image db
                        docker push ${DOCKER_USERNAME}/flask-db-image
                    """
                }
            }
        }
        stage('Build and Push Flask Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_CREDENTIALS', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]){
                    sh """
                        docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                        docker build -t ${DOCKER_USERNAME}/flask-image flask-app
                        docker push ${DOCKER_USERNAME}/flask-image
                    """
                }
            }
        }
        stage('Run Containers') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_CREDENTIALS', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD'),
                usernamePassword(credentialsId: 'MYSQL_CREDENTIALS', usernameVariable: 'MYSQL_USERNAME', passwordVariable: 'MYSQL_PASSWORD'),
                ]){
                    sh """
                    docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                    docker run -d \
                        --network trio-network \
                        -e MYSQL_ROOT_PASSWORD=${MYSQL_PASSWORD} \
                        --name mysql flask-db-image

                    docker run -d \
                        --network trio-network \
                        --name flask-app flask-image

                    docker run -d -p 80:80 --network trio-network --name proxy-container --mount type=bind,source=/home/ubuntu/docker-exercises/trio-task/nginx/nginx.conf,target=/etc/nginx/nginx.conf nginx
                    """
                }
            }
        }
    }
}