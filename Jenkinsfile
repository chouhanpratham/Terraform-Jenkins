pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'azure-service-principal-new'
        RESOURCE_GROUP = 'rg-jenkins'
        APP_SERVICE_NAME = 'webapijenkinspratham22025'
    }

    
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/chouhanpratham/Terraform-Jenkins.git'
            }
        }
        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan & Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Publish .NET 8 Web API') {
            steps {
                dir('webapi') {
                    sh 'dotnet publish -c Release -o out'
                    sh 'zip -r webapi.zip -j out/*'
                }
            }
        }

        stage('Deploy to Azure App Service') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    sh "az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID"
                    sh "az account set --subscription $AZURE_SUBSCRIPTION_ID"
                    sh "az webapp deploy --resource-group rg-jenkins --name webapijenkinspratham22025 --src-path $WORKSPACE/webapi/webapi.zip --type zip"
                }
            }
        }
    }
}
