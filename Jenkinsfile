pipeline {
	agent any

    tools {
        maven "maven3"
    }

    environment {
        registry = "gauthambappalige12/hello"
        registryCredential = 'dockerhub'
    }


    stages{
        stage('Build') {
            steps{
                sh 'mvn install'
            }
            post {
                success {
                    echo 'Now Archiving it...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
        stage('Build App Image') {
            steps {
                script {
                  dockerImage = docker.build registry + ":V$BUILD_NUMBER"
               }
            }
        }
    }
}