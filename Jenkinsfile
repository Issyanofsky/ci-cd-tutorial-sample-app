pipeline {
    agent {
        label 'docker-slave'
    }

    environment {
        DOCKER_IMAGE = 'ci-cd_image' 
        POSTGRES_IMAGE = 'postgres:latest'
        DB_NAME = 'DB' 
        DB_USER = 'admin' 
        DB_PASSWORD = 'a1a1a1' 
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
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }
        stage('Run Application') {
            steps {
                script {
                    sh 'docker-compose up -d postgres'
    //                docker run --rm --network host ${DOCKER_IMAGE} python seed.py
                    sleep 20
                    sh 'docker-compose up -d app'
                    sh 'docker run --rm -w /sample-app app coverage run -m unittest discover' 
                    sh 'echo ${DATABASE_URL}'
                }
            }
        }
        stage('Run test') {
            steps {
                script {
           //         sh 'docker run --rm -w /sample-app devopstasksupdated_app coverage run -m unittest discover' // || (echo "Tests failed" && exit 1)' 
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
