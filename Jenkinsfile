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
                        docker login -u ${DOCKER_USERNAME} ${DOCKER_PASSWORD}
                        docker build -t ${DOCKER_USERNAME}/flask-db-image db/
                        docker push ${DOCKER_USERNAME}/flask-db-image
                    """
                }
            }
        }
    }
}