pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from Git...'
                git credentialsId: 'rdev8921git', url: 'https://github.com/rahul8921/ChatServer.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Building the project...'
                // Add build steps here
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                // Add test steps here
            }
        }
    }
}
