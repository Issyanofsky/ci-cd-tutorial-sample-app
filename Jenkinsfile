@Library("my-shared-library")
pipeline {
    agent any

    environment {
        // Define the database connection parameters
        DB_HOST = 'your_db_host' // Replace with the actual DB host
        DB_PORT = '5432'         // Default PostgreSQL port
        DB_NAME = 'your_db_name' // Replace with the actual DB name
        DB_USER = 'your_db_user' // Replace with the actual DB user
        DB_PASSWORD = 'your_db_password' // Replace with the actual DB password
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                git 'https://github.com/Issyanofsky/ci-cd-tutorial-sample-app.git'
            }
        }
        
        stage('Build/Install Dependencies') {
            steps {
                // Run your build and install dependencies command
                sh 'npm install' // or any other build command relevant to your project
            }
        }

        stage('Test Coverage') {
            steps {
                // Run test coverage tool, e.g., for a Node.js application
                sh 'npm run test -- --coverage' // Adjust as necessary for your testing framework
            }
        }

        stage('Test the App') {
            steps {
                // Run your application tests
                sh 'npm test' // Adjust as necessary for your testing framework
            }
        }

        stage('Archive Artifacts') {
            steps {
                // Archive build artifacts
                archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true // Adjust the path based on your build
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
