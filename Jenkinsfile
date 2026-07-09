pipeline {
    agent any

    environment {
        IMAGE_NAME = "multi-auth-app"
        CONTAINER_NAME = "multi-auth-container"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                export DOCKER_BUILDKIT=0
                docker build --no-cache -t $IMAGE_NAME .
                '''
            }
        }

        stage('Stop Existing Container') {
            steps {
                sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true
                '''
            }
        }

        stage('Prepare Environment') {
            steps {
            sh '''
            cp /home/ubuntu/Multi-Auth/.env.docker .
            ls -la .env*
            '''
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                docker run -d \
                  --name $CONTAINER_NAME \
                  -p 5000:5000 \
                  --env-file .env.docker \
                  $IMAGE_NAME
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'curl http://localhost:5000/'
            }
        }
    }
}
