pipeline {
    agent {
        label 'docker-slave'
    }

    environment {
        DATABASE_URL = "postgres://admin:a1a1a1@postgres/DB"
        TEST_DATABASE_URL = "postgres://admin:a1a1a1@postgres/test_db"
         DOCKER_IMAGE = "ecyanofsky/ci-cd-tuturial:${env.BUILD_NUMBER}"
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
                   // sh 'docker-compose exec -T postgres psql -U admin -d postgres -c "CREATE DATABASE test_db;"'
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
        stage('Show Databases') {
            steps {
                script {
                    sh 'docker-compose exec -T postgres psql -U admin -d postgres -c "\\l"'
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
        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                        
                        sh "docker tag ci-cd_image ${DOCKER_IMAGE}"
                        sh "docker push ${DOCKER_IMAGE}"
                        sh 'echo "The image as pushed to DockerHub Successfuly!!"'
                    }
                }
            }
        }
    }

    post {
        always {
            

            sh 'docker-compose down'
            cleanWs()
            echo 'workspace is Clean'
            chuckNorris()
        }
    }
}
