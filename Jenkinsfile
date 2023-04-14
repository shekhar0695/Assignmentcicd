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

        stage('Upload Image'){
            steps{
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push("V$BUILD_NUMBER")
                    }
                }
            }
        }
        stage('Kubernetes Deploy') {
            steps {
                  sh "chmod +x changetag.sh"
                  sh "./changetag.sh V$BUILD_NUMBER"
                  sshagent(['kops-login']) {
                        sh "scp -o StrictHostKeyChecking=no services.yaml hello-pod.yaml ubuntu@34.207.252.152:/home/ubuntu/jenkins/"
                        scripts {
                            try {
                                sh "ssh ubuntu@34.207.252.152 kubectl apply -f ."
                            }catch(error) {
                                sh "ssh ubuntu@34.207.252.152 kubectl create -f ."
                        }
                    }
                }
            }
        }
    }
}
