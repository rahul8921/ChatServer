pipeline {
    environment {
        DOCKER_REGISTRY_URL = 'myregistry.azurecr.io'  // Replace with your ACR login server
        DOCKER_IMAGE_NAME = 'chat-server'
        AZURE_CREDENTIALS_ID = 'azure-service-principal'  // The ID of your Jenkins credentials
        RESOURCE_GROUP = 'myResourceGroup'  // Replace with your resource group name
    }

    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE_NAME .'
                }
            }
        }

        stage('Login to Azure') {
            steps {
                withCredentials([usernamePassword(credentialsId: AZURE_CREDENTIALS_ID,
                        usernameVariable: 'AZURE_APP_ID', passwordVariable: 'AZURE_SECRET')]) {
                    script {
                        sh '''
                            az login --service-principal -u $AZURE_APP_ID -p $AZURE_SECRET --tenant 87654321-4321-4321-4321-abcdef987654
                        '''
                    }
                }
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                script {
                    sh '''
                        az acr login --name ${DOCKER_REGISTRY_URL}
                        docker tag $DOCKER_IMAGE_NAME:latest ${DOCKER_REGISTRY_URL}/$DOCKER_IMAGE_NAME:latest
                        docker push ${DOCKER_REGISTRY_URL}/$DOCKER_IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                script {
                    sh '''
                        az container create --resource-group $RESOURCE_GROUP \
                        --name chat-server-container \
                        --image ${DOCKER_REGISTRY_URL}/$DOCKER_IMAGE_NAME:latest \
                        --cpu 1 --memory 1 \
                        --registry-login-server ${DOCKER_REGISTRY_URL} \
                        --registry-username $(az acr credential show --name ${DOCKER_REGISTRY_URL} --query username --output tsv) \
                        --registry-password $(az acr credential show --name ${DOCKER_REGISTRY_URL} --query passwords[0].value --output tsv) \
                        --ports 8080
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
