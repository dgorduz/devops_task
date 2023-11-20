pipeline {
    agent any
    triggers {
        pollSCM ''
    }

    stages {
        stage('Terraform init & change directoy') {
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
