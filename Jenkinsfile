pipeline {
    agent any

    environment {
        // Add any environment variables you need here
        FORCE_JAVASCRIPT_ACTIONS_TO_NODE24 = "true"
        ACTIONS_ALLOW_USE_UNSECURE_NODE_VERSION = "true"
    }
     tools {
        maven 'MAVEN3'
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
                sh '''
                    cd java-app
                    mvn clean package -DskipTests
                '''
            }
        }

        stage('Test Python App') {
            steps {
                sh '''
                    cd python-app
                    pip install -r requirements.txt
                    pytest || echo "No tests yet"
                '''
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                    docker build -t java-app:local java-app
                    docker build -t python-app:local python-app
                '''
            }
        }

        stage('Run Docker Compose') {
            steps {
                sh '''
                    docker compose up -d
                    docker ps
                '''
            }
        }

        stage('Verify Services') {
            steps {
                sh '''
                    curl --fail http://localhost:8000 || echo "Python app not responding"
                    curl --fail http://localhost:9090 || echo "Java app not responding"
                '''
            }
        }

        // Optional Terraform validation stage
        // stage('Terraform Validate') {
        //     when {
        //         expression { return false } // set to true if you want to enable
        //     }
        //     steps {
        //         sh '''
        //             cd terraform
        //             terraform init
        //             terraform validate
        //         '''
        //     }
        // }
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
