String cron_string = env.BRANCH_NAME == "dev" ? "*/1 * * * *" : ""

pipeline {
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any
    triggers { cron(cron_string) }
    stages {
        stage('Git checkout'){
            steps{
                git branch: 'dev', url: 'https://github.com/dgorduz/devops_task'
            }
        }
        stage('Terraform init') {
            steps {
                script {
                    dir('terraform_instance') {
                        // Execute 'terraform init'
                        sh 'ls'
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Terraform plan') {
            steps {
                script {
                    // Change directory to the Terraform working directory
                    dir('terraform_instance') {
                        // Execute 'terraform plan'
                        sh 'terraform apply'
                    }
                }
            }
        }
    }
}
