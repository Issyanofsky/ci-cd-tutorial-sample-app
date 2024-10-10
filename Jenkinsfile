pipeline {
    agent {
        label 'docker-slave'
    }

    environment {
        DOCKER_IMAGE = 'ci-cd_image' // Change this to your image name
        POSTGRES_IMAGE = 'postgres:latest'
        DB_NAME = 'DB' // Replace with your database name
        DB_USER = 'admin' // Replace with your database user
        DB_PASSWORD = 'a1a1a1' // Replace with your database password
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-creds', url: 'https://github.com/Issyanofsky/ci-cd-tutorial-sample-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image for the application
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }
        stage('Run Application') {
            steps {
                script {
                    // Start the app and db services in detached mode
                    sh 'docker-compose up -d'
                }
            }
        }
        stage('Run Database') {
            steps {
                script {
                    // Run the PostgreSQL container
                    sh """
                    docker run --name postgres-db -d \
                        -e POSTGRES_DB=${DB_NAME} \
                        -e POSTGRES_USER=${DB_USER} \
                        -e POSTGRES_PASSWORD=${DB_PASSWORD} \
                        -p 5432:5432 \
                        ${POSTGRES_IMAGE}
                    """
                }
            }
        }

        stage('Run Application') {
            steps {
                script {
                    // Run the application container
                    sh """
                    docker run --name rest-api -d \
                        --link postgres-db:postgres \
                        -e DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@postgres/${DB_NAME} \
                        -p 8000:8000 \
                        ${DOCKER_IMAGE} python -m unittest discover
                    """
                }
            }
        }

    }

    post {
        always {
            // Clean up
//            sh 'docker stop rest-api || true'
//            sh 'docker rm rest-api || true'
//            sh 'docker stop postgres-db || true'
//            sh 'docker rm postgres-db || true'
            sh 'docker-compose down'
            cleanWs()
            echo 'workspace is Clean'
            chuckNorris()
        }
    }
}
