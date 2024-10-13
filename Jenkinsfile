pipeline {
    agent {
        label 'docker-slave'
    }

    environment {
        DATABASE_URL = "postgres://admin:a1a1a1@postgres/DB"
        TEST_DATABASE_URL = "postgres://admin:a1a1a1@postgres/test_DB"
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-creds', url: 'https://github.com/Issyanofsky/ci-cd-tutorial-sample-app.git'

            }
        }

        stage('Build and Install Dependencies') {
            steps {
                script {
                    sh 'docker-compose up -d postgres' 
                    sleep 20
                    sh 'docker-compose up -d app'
                    sh 'docker-compose build'
                }
            }
        }
        stage ('Test'){
                steps {
                   sh 'docker exec --rm app ls -alh' 
                   sh 'docker-compose run --rm app pytest ./tests/testRoutes.py'
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
