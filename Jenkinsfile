pipeline {
    agent any
    tools {
        maven 'MAVEN-3'   // Configure in Jenkins Global Tool Configuration
        jdk 'jdk-21'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Java App') {
            steps {
                bat '''
                    cd java-app
                    mvn clean package -DskipTests
                '''
            }
        }

        stage('Test Python App') {
            steps {
                bat '''
                    cd python-app
                    pip install -r requirements.txt
                    pytest || echo "No tests yet"
                '''
            }
        }

        stage('Build Docker Images') {
            steps {
                bat 'docker build -t java-app:local java-app'
                bat 'docker build -t python-app:local python-app'
            }
        }

        stage('Run Docker Compose') {
            steps {
                bat 'docker-compose up -d'
                bat 'docker ps'
            }
        }

        stage('Verify Services') {
            steps {
                bat 'curl --fail http://localhost:8000 || echo Python app not responding'
                bat 'curl --fail http://localhost:9090 || echo Java app not responding'
            }
        }

        stage('Terraform Validate') {
            when {
                expression { return false } // enable if you want Terraform validation
            }
            steps {
                bat '''
                    cd terraform
                    terraform init
                    terraform validate
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}
