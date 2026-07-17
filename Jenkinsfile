pipeline {

    agent any

    options {
        skipDefaultCheckout(true)
        timestamps()
    }

    environment {
        AWS_REGION = 'ap-south-1'
        CLUSTER_NAME = 'devops-eks-cluster'
        AWS_ACCOUNT_ID = '186050466008'
        ECR_REPOSITORY = 'flask-app'
        IMAGE_TAG = "${BUILD_NUMBER}"

        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {

        stage('Git Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/manjunathalokesh43-a11y/DevOps-Assignment.git'
                    // credentialsId: 'github-creds'   // Uncomment if repository is private
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Format') {
            steps {
                dir('terraform') {
                    bat 'terraform fmt'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    bat 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Update Kubeconfig') {
            steps {
                bat '''
                aws eks update-kubeconfig --region %AWS_REGION% --name %CLUSTER_NAME%
                '''
            }
        }

        stage('Verify EKS Nodes') {
            steps {
                bat 'kubectl get nodes'
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    bat '''
                    docker build -t %ECR_REPOSITORY%:%IMAGE_TAG% .
                    '''
                }
            }
        }

        stage('Login to Amazon ECR') {
            steps {
                bat '''
                aws ecr get-login-password --region %AWS_REGION% > password.txt
                docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com < password.txt
                del password.txt
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                bat '''
                docker tag %ECR_REPOSITORY%:%IMAGE_TAG% %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPOSITORY%:%IMAGE_TAG%
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                bat '''
                docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPOSITORY%:%IMAGE_TAG%
                '''
            }
        }

        stage('Deploy using Helm') {
            steps {
                bat '''
                helm upgrade --install flask-app helm/sample-app ^
                --set image.repository=%AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPOSITORY% ^
                --set image.tag=%IMAGE_TAG%
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                bat 'kubectl get nodes'
                bat 'kubectl get pods'
                bat 'kubectl get svc'
                bat 'kubectl get ingress'
            }
        }
    }

    post {

        success {
            echo '============================================='
            echo 'Terraform Infrastructure Created Successfully'
            echo 'Amazon EKS Cluster Ready'
            echo 'Docker Image Built and Pushed to Amazon ECR'
            echo 'Helm Application Deployed Successfully'
            echo 'Pipeline Completed Successfully'
            echo '============================================='
        }

        failure {
            echo '============================================='
            echo 'Pipeline Failed'
            echo 'Check the failed stage in Console Output'
            echo '============================================='
        }

        always {
            cleanWs()
        }
    }
}