pipeline {
    agent any
    
    tools {
        jdk "jdk17"
        maven "maven3"
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/niiadu/Boardgame.git'
            }
        }

        
        stage("Clean with Maven") {
            steps {
                sh "mvn clean"
            }
        }

        stage("Testing with Maven") {
            steps {
                sh "mvn test"
            }
        }

        stage("Package with Maven") {
            steps {
                sh "mvn package"
            }
        }

        stage('Sonarqube Analysis') {
            environment {
                ScannerHome = tool 'sonar-scanner'
            }
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''${ScannerHome}/bin/sonar-scanner -Dsonar.projectName=Webapp -Dsonar.projectKey=Webapp \
                            -Dsonar.java.binaries=. '''
                }
            }
        }
        
        
        stage('Upload to Nexus') {
            steps {
               withMaven(globalMavenSettingsConfig: 'global-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh "mvn deploy"
                }
            }
        }
        
        stage("Deploy to UAT") {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'tomcat-credential', path: '', url: 'http://51.20.72.221:8080/')], contextPath: null, war: 'target/*.jar'
            }
        }
    }
}
