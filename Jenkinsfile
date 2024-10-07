pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git 'https://github.com/Issyanofsky/ci-cd-tutorial-sample-app.git'
            }
        }
        
        stage('Build Docker Images') {
            steps {
                // Build the Docker images
                script {
                    docker.build("my_app_image", "./path/to/your/app") // Adjust path as needed
                }
            }
        }

        stage('Run Tests') {
            steps {
                // Run your application tests in a container
                script {
                    docker.image("my_app_image").inside {
                        sh 'source venv/bin/activate && python your_test_script.py' // Adjust as necessary
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
