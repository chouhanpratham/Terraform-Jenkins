pipeline {
    agent any

    environment {
        ARM_CLIENT_ID = credentials('AZURE_CREDENTIALS_CLIENT_ID')
        ARM_CLIENT_SECRET = credentials('AZURE_CREDENTIALS_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_CREDENTIALS_SUBSCRIPTION_ID')
        ARM_TENANT_ID = credentials('AZURE_CREDENTIALS_TENANT_ID')
        RESOURCE_GROUP = 'rg-jenkins'
        APP_SERVICE_NAME = 'webapijenkinspratham22025'
    }

    stages {
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan & Apply') {
            steps {
                sh 'terraform plan -out=tfplan'
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Publish .NET 8 Web API') {
            steps {
                dir('webapi') {
                    sh 'dotnet publish -c Release -o out'
                }
            }
        }

        stage('Deploy to Azure App Service') {
            steps {
                sh '''
                    az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
                    az account set --subscription $ARM_SUBSCRIPTION_ID
                    az webapp deploy --resource-group $RESOURCE_GROUP --name $APP_SERVICE_NAME --src-path webapi/out --type zip
                '''
            }
        }
    }
}
