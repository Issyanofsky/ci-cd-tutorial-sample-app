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

        stage('Build') {
            steps {
                script {
                    sh 'docker-compose build'
                }
            }
        }
        stage('Start applicatin') {
            steps {
                script {
                    // Start the PostgreSQL and app services
                    sh 'docker-compose up -d postgres'
                    waitUntil {
                        script {
                            return sh(script: 'docker-compose exec -T postgres pg_isready -U admin', returnStatus: true) == 0
                        }
                    }
                    sh 'docker-compose exec -T postgres psql -U admin -d postgres -c "CREATE DATABASE test_DB;"'
                    sh 'docker-compose up -d app '
                    sh 'docker-compose exec -T app python3 seed.py'
                }
            }
        }
        stage('Run Migrations') {
            steps {
                script {
                    sh 'docker-compose exec -T app flask db upgrade'
                }
            }
        }
        stage('Run tests') {
            steps {
                script {
                    sh 'docker-compose exec -T app coverage run -m unittest discover'
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
