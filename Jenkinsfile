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
            }
        }
        stage('Build and Push DB Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_CREDENTIALS', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]){
                    sh """
                        docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                        docker build -t ${DOCKER_USERNAME}/flask-db-image db/
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
                        docker build -t ${DOCKER_USERNAME}/flask-image db/
                        docker push ${DOCKER_USERNAME}/flask-image
                    """
                }
            }
        }
        stage('Create Network') {
            steps {
                sh """
                docker network create trio-network
                """
            }
        }
        stage('Run Containers') {
            steps {
                sh """
                docker run -d \
                    --network trio-network \
                    --volume db-volume:/var/lib/mysql \
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