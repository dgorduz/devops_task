pipeline {
    parameters {
        choice(name: 'nr_vms', choices: ['1', '2', '3'], description: 'Number of VMs')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any
    triggers { 
        pollSCM('*/1 * * * *') 
    }
    stages {
        stage('checkout'){
            steps{
                git branch: 'dev', 
                url: 'https://github.com/dgorduz/blazor_app_demo.git'
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
                    withCredentials([string(credentialsId: 'WIN_PASS', variable: 'WIN_PASS')]) {
                        dir('terraform_instance') {
                            sh "terraform apply -var=\"nr_vms=${params.nr_vms}\" -var='win_pass=$WIN_PASS' --auto-approve"
                        }
                    }
                }
            }
        }
    }
}
