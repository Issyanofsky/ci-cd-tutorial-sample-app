pipeline {
    agent {
      label 'docker-slave'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git credentialsId: 'github-creds', url: 'https://github.com/Issyanofsky/ci-cd-tutorial-sample-app.git'
                echo 'Git completed successfully!'
            }
        }
        
        stage('Build Docker Images') {
            steps {
                // Build the Docker images
                echo 'Start of Build stage!'
                sh 'ls -alh'
                script {
                    try {
                        sh 'docker build . -t ci-cd_image'
                        echo 'Build completed successfully!'
                    } catch (Exception e) {
                        echo 'Build failed!'
                        error "Error: ${e.message}"
                    }
                }
            }
        }
        stage('Deploy images') {
            steps {
                // Start the PostgreSQL service using Docker Compose
                sh 'docker-compose up -d' // Only start the PostgreSQL container
                echo 'Deploy completed successfully!'
            }
        }
        stage('Run Tests') {
            steps {
                // Run your application tests in a container
               script {
                    try {
                        // Run tests inside the Docker container
                        sh 'docker run --rm ci-cd_image python3 -m unittest discover -s ./tests'
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
                    // Display test coverage report
                    sh 'docker run --rm ci-cd_image pytest --cov-report html:cov_html --cov=your_app_directory'
                    echo 'Coverage report generated!'
                }
            }
        }
        stage('Deploy') {
            steps {
                // Deploy the application using Docker Compose
                sh 'docker-compose up -d' // Start services in detached mode
            }
        }
    
        stage('Clean Up') {
            steps {
                // Stop and remove services after deployment
                sh 'docker-compose down'
            }
        }
}
    post {
        always {
            // Cleanup actions, if necessary
            echo 'Cleaning up...'
            cleanWs() // Clean workspace if needed
        }
        
        success {
            echo 'Pipeline completed successfully!'
        }
        
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
