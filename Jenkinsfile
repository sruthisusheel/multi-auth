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

        stage('Run Docker Container') {
            steps {
                sh '''
                    docker run -d \
                      --name $CONTAINER_NAME \
                      -p 5000:5000 \
                      --env-file /home/ubuntu/Multi-Auth/.env.docker \
                      $IMAGE_NAME
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    sleep 10
                    curl http://localhost:5000/
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully!"
        }

        failure {
            echo "❌ Pipeline failed."
        }

        always {
            sh 'docker ps -a'
        }
    }
}
