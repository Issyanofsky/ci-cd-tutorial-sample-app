pipeline {
    agent {
        label 'docker-slave'
    }

    environment {
        DATABASE_URL = "postgres://admin:a1a1a1@db/DB"
        TEST_DATABASE_URL = "postgres://admin:a1a1a1@db/test_DB"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/edonosotti/ci-cd-tutorial-sample-app'
            }
        }

        stage('Build and Install Dependencies') {
            steps {
                script {
                    sh 'docker-compose up -d db' // Start the database service
                    sh 'docker-compose build' // Build the app container
                }
            }
        }

        stage('Run Migrations') {
            steps {
                script {
                    sh 'docker-compose run app flask db upgrade' // Run migrations
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests with coverage
                    def result = sh(script: 'docker-compose run app coverage run -m unittest discover', returnStatus: true)
                    if (result != 0) {
                        error "Tests failed."
                    }
                }
            }
        }

        stage('Archive Results') {
            steps {
                script {
                    sh 'docker-compose run app coverage report' // Generate coverage report
                    // You can add commands to archive the report if needed
                }
            }
        }
    }

    post {
        always {
            
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
