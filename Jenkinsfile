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

        stage('Run Tests') {
            steps {
                // Run your application tests in a container
               script {
                    try {
                        // Run tests inside the Docker container
                        sh 'docker run --rm ci-cd_image pytest --cov=./tests > result.log' // Replace with your test command
                        echo 'Tests executed successfully!'
                    } catch (Exception e) {
                        echo 'Tests failed!'
                        echo "Error: ${e.message}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                // Deploy the application using Docker Compose
                sh 'docker-compose up -d' // Start services in detached mode
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
