pipeline {
	agent any

	tools {
		maven "maven3"
	}

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
}