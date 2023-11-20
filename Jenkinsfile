pipeline {
    agent any
    triggers {
        pollSCM ''
    }

    stages {
        stage('Terraform init & change directory') {
            steps {
                sh 'ls'
                sh 'cd terraform_instance'
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
