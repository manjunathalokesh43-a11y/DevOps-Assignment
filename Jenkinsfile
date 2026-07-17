pipeline {

    agent any

    environment {

        AWS_REGION = "ap-south-1"

        CLUSTER_NAME = "devops-eks-cluster"

        AWS_ACCOUNT_ID = "123456789012"

        ECR_REPOSITORY = "flask-app"

        IMAGE_TAG = "${BUILD_NUMBER}"

        AWS_ACCESS_KEY_ID = credentials('aws-access-key')

        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')

    }

    stages {

        stage('Git Checkout') {

            steps {

                git branch: 'main',
                    credentialsId: 'github-creds',
                    url: 'https://github.com/YOUR_USERNAME/DevOps-Assignment.git'

            }

        }

        stage('Terraform Init') {

            steps {

                dir('terraform') {

                    sh 'terraform init'

                }

            }

        }

        stage('Terraform Format') {

            steps {

                dir('terraform') {

                    sh 'terraform fmt'

                }

            }

        }

        stage('Terraform Validate') {

            steps {

                dir('terraform') {

                    sh 'terraform validate'

                }

            }

        }

        stage('Terraform Plan') {

            steps {

                dir('terraform') {

                    sh 'terraform plan -out=tfplan'

                }

            }

        }

        stage('Terraform Apply') {

            steps {

                dir('terraform') {

                    sh 'terraform apply -auto-approve tfplan'

                }

            }

        }

        stage('Update Kubeconfig') {

            steps {

                sh """

                aws eks update-kubeconfig \
                --region ${AWS_REGION} \
                --name ${CLUSTER_NAME}

                """

            }

        }

        stage('Build Docker Image') {

            steps {

                dir('app') {

                    sh """

                    docker build \
                    -t ${ECR_REPOSITORY}:${IMAGE_TAG} .

                    """

                }

            }

        }

        stage('Login to Amazon ECR') {

            steps {

                sh """

                aws ecr get-login-password \
                --region ${AWS_REGION} |

                docker login \
                --username AWS \
                --password-stdin \
                ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

                """

            }

        }

        stage('Tag Docker Image') {

            steps {

                sh """

                docker tag \
                ${ECR_REPOSITORY}:${IMAGE_TAG} \
                ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}

                """

            }

        }

        stage('Push Docker Image') {

            steps {

                sh """

                docker push \
                ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}

                """

            }

        }

        stage('Helm Upgrade') {

            steps {

                sh """

                helm upgrade \
                --install flask-app \
                helm/sample-app \
                --set image.repository=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY} \
                --set image.tag=${IMAGE_TAG}

                """

            }

        }

        stage('Verify Kubernetes') {

            steps {

                sh "kubectl get nodes"

                sh "kubectl get pods"

                sh "kubectl get svc"

                sh "kubectl get ingress"

            }

        }

    }

    post {

        success {

            echo "======================================"

            echo "Infrastructure Created Successfully"

            echo "Docker Image Pushed Successfully"

            echo "Application Deployed Successfully"

            echo "======================================"

        }

        failure {

            echo "Pipeline Failed"

        }

        always {

            cleanWs()

        }

    }

}