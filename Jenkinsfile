pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'dev', credentialsId: 'jenkins-git-ssh', url: 'https://github.com/dgorduz/devops_task/tree/dev'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'ls'
                sh 'cd terraform'
                sh 'terraform init'
            }
        }
        stage('Terraform apply') {
            steps {
                sh 'terraform plan'
            }
        }
        
    }
}