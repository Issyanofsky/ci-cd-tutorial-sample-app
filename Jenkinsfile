pipeline {
    agent {
        label 'docker-slave'
    }

    environment {
        DOCKER_IMAGE = 'ci-cd_image' // Change this to your image name
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-creds', url: 'https://github.com/Issyanofsky/ci-cd-tutorial-sample-app.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    // Build the Docker images
                    sh 'docker-compose build'
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    // Start the application
                    sh 'docker-compose up -d app'
                }
            }
        }
    }

    post {
        always {
            // Clean up
            sh 'docker-compose down'
            cleanWs()
            echo 'workspace is Clean'
        }
    }
}
