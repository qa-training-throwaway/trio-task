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
                withCredentials([usernamePassword(credentialsId: 'MYSQL_CREDENTIALS', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    sh """
                        echo ${USERNAME}
                    """
                }
            }
        }
    }
}