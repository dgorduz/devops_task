pipeline {
    agent any

    stages {
        stage('Terraform init') {
            steps {
                sh 'ls'
                sh 'cd terraform'
                sh 'terraform init'
            }
        }
        stage('Terraform plan') {
            steps {
                sh 'terraform plan'
            }
        }
        
    }
}