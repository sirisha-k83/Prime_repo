pipeline {
    agent any
    tools {
        jdk 'JDK17'
        nodejs 'nodejs'
    }
    environment {
        SCANNER_HOME = tool 'SonarQube Scanner' // Correcting tool declaration
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
    stage('Checkout from Git') {
         steps {
         git branch: 'main', url: 'https://github.com/sirisha-k83/DevopsProject2.git'
    }
}
        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'sonar-user', installationName: 'sonar-server') {
                        sh '''
                            docker run --rm \
                            -e SONAR_HOST_URL="http://40.65.113.201:9000" \
                            -v "$(pwd):/usr/src" \
                            sonarsource/sonar-scanner-cli
                            $SCANNER_HOME/bin/sonar-scanner \
                            -Dsonar.projectName=amazon-prime \
                            -Dsonar.projectKey=amazon-prime
                        '''
                    }
                }
            }
        }
        stage("Quality Gate") {
            steps {
                script {
                    waitForQualityGate abortPipeline: true, credentialsId: 'sonar-user'  // Ensure correct SonarQube credentials ID
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('TRIVY FS Scan') {
            steps {
                sh "trivy fs . > trivyfs.txt"  // Results stored in a text file
            }
        }
        stage("Docker Build & Push") {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {   
                        sh "docker build -t amazonprime ."
                        sh "docker tag amazonprime sirishak83/amazonprime:latest"
                        sh "docker push sirishak83/amazonprime:latest"
                    }
                }
            }
        }
        stage('Deploy to Container') {
            steps {
                sh 'docker run -d --name amazonprime -p 3000:3000 sirishak83/amazonprime:latest'
            }
        }
    }
}
