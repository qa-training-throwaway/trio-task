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
                echo 'Building.'
            }
        }
    }
}