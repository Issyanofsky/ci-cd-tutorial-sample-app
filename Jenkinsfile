pipeline {
    agent {
        label 'docker-slave'
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-creds', url: 'https://github.com/Issyanofsky/ci-cd-tutorial-sample-app.git'
                echo 'Git checkout completed successfully!'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Starting build stage...'
                script {
                    try {
                        // Build the Docker image
                        sh 'docker build . -t ci-cd_image'
                        echo 'Docker image built successfully!'
                    } catch (Exception e) {
                        echo 'Build failed!'
                        error "Error: ${e.message}"
                    }
                }
            }
        }

        stage('Deploy PostgreSQL') {
            steps {
                echo 'Starting PostgreSQL service...'
                // Start PostgreSQL using Docker Compose
                sh 'docker-compose up -d postgres'
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    try {
                        // Run tests inside the Docker container using python3
                       sh 'docker run --rm --network=host ci-cd_image python3 -m unittest discover -s ./tests'
                        echo 'Tests executed successfully!'
                    } catch (Exception e) {
                        echo 'Tests failed!'
                        echo "Error: ${e.message}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Test Coverage') {
            steps {
                script {
                    // Generate test coverage report
                    sh 'docker run --rm --network=host ci-cd_image python3 -m pytest --cov-report html:cov_html --cov=./sample-app'
                    echo 'Coverage report generated!'
                }
            }
        }

        stage('Deploy Application') {
            steps {
                echo 'Deploying application...'
                // Deploy the application using Docker Compose
                sh 'docker-compose up -d'
            }
        }

        stage('Clean Up') {
            steps {
                echo 'Cleaning up...'
                // Stop and remove services after deployment
                sh 'docker-compose down'
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace
        }
        
        success {
            echo 'Pipeline completed successfully!'
        }
        
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
