pipeline {
    agent any

    stages {
        stage('Terraform init & change directory') {
            steps {
                sh 'ls'
                sh 'cd terraform/'
                sh 'pwd'
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
