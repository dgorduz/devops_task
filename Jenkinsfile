String cron_string = env.BRANCH_NAME == "dev" ? "*/1 * * * *" : ""

pipeline {
    agent any
    triggers { cron(cron_string) }
    stages {
        stage('Terraform init & change directoryy') {
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
                        sh 'echo should be Terraform plan, but it crashes'
                    }
                }
            }
        }
    }
}