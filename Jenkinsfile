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
    //                docker run --rm --network host ${DOCKER_IMAGE} python seed.py
                    sleep 20
                }
            }
        }
        stage('Run test') {
            steps {
                script {
                    sh 'docker run --rm -w /sample-app devopstasksupdated_app coverage run -m unittest discover || (echo "Tests failed" && exit 1)' 
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
