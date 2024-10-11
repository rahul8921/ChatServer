pipeline {
    agent any

    environment {
        AZURE_CLIENT_ID = credentials('azure-client-id')  // Jenkins Azure Service Principal ID
        AZURE_CLIENT_SECRET = credentials('azure-client-secret')  // Jenkins Azure Service Principal Secret
        AZURE_TENANT_ID = credentials('azure-tenant-id')  // Azure tenant ID
        AZURE_SUBSCRIPTION_ID = credentials('azure-subscription-id')  // Azure subscription ID
        IMAGE_NAME = 'chat-server'  // Docker image name
        RESOURCE_GROUP = 'your-resource-group'  // Azure resource group
        ACR_NAME = 'your-acr-name'  // Azure Container Registry name
        ACR_LOGIN_SERVER = "${ACR_NAME}.azurecr.io"
        APP_NAME = 'your-app-service-name'  // Your Azure Web App name
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from GitHub
                git url: 'https://github.com/your-username/your-repo.git', branch: 'main'  // Replace with your repo details
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using the Dockerfile
                    sh "docker build -t ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Login to Azure') {
            steps {
                script {
                    // Login to Azure using service principal credentials
                    sh '''
                    az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                    az acr login --name $ACR_NAME
                    '''
                }
            }
        }

        stage('Push Docker Image to ACR') {
            steps {
                script {
                    // Push Docker image to Azure Container Registry
                    sh "docker push ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy to Azure App Service') {
            steps {
                script {
                    // Deploy the Docker container to Azure App Service
                    sh '''
                    az webapp config container set --name $APP_NAME --resource-group $RESOURCE_GROUP --docker-custom-image-name ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:latest --registry-password $(az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv) --registry-username $ACR_NAME
                    az webapp restart --name $APP_NAME --resource-group $RESOURCE_GROUP
                    '''
                }
            }
        }
    }
}
