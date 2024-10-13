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
        stage('Start Services') {
            steps {
                script {
                    // Start the PostgreSQL and app services
                    sh 'docker-compose up -d'
                }
            }
        }
        stage('Run Database Migrations') {
            steps {
                script {
                    sh 'docker-compose run --rm -w /sample-app devopstasksupdated_app coverage run -m unittest discover'
                    }
                }
            }

        stage('Run Tests') {
            steps {
                script {
                    sh 'docker-compose run --rm app python -m unittest discover'
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
