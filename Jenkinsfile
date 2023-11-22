String cron_string = env.BRANCH_NAME == "dev" ? "*/1 * * * *" : ""

pipeline {
    parameters {
        string(name: 'nr_vms', defaultValue: '1', description: 'Number of VMs (integer)')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        WIN_PASS              = credentials('WIN_PASS')
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
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Terraform plan') {
            steps {
                script {
                    dir('terraform_instance') {
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('Terraform apply') {
            steps {
                script {
                    dir('terraform_instance') {
                        sh 'terraform apply -var="nr_vms=1" -var="win_pass=Suuuper$ecret1" --auto-approve'
                    }
                }
            }
        }
    }
}
