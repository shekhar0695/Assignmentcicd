pipeline {
	agent any

    tools {
        maven "maven"
    }

    environment {
        registry = "shekharrr/maven1"
        registryCredential = 'dockerhub-pwd'
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
                  dockerImage = sudo docker.build registry + ":V$BUILD_NUMBER"
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
                        sh "scp -o StrictHostKeyChecking=no services.yaml hello-pod.yaml ubuntu@43.205.128.116:/home/ubuntu/jenkins/"
                        script{
                            try{
                                sh "ssh ubuntu@43.205.128.116 kubectl apply -f jenkins"
                            }catch(error){
                                sh "ssh ubuntu@43.205.128.116 kubectl create -f jenkins"
                        }
                    }
                }
            }
        }
    }
}
