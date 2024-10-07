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
                script {
                    docker.build("ci-cd_image", ".") // Adjust path as needed
                    echo 'Build completed successfully!'
                }
            }
        }

        stage('Run Tests') {
            steps {
                // Run your application tests in a container
                script {
                    docker.image("my_app_image").inside {
                        sh 'source venv/bin/activate && python your_test_script.py' // Adjust as necessary
                        echo 'Run completed successfully!'
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
