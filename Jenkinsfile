pipeline {
    agent any

    tools {
        maven "maven"
    }

    environment {
        registry = "shekharrr/maven"
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
                  sshagent(['kubernetes']) {
                        sh "scp -o StrictHostKeyChecking=no services.yaml hello-pod.yaml ubuntu@3.110.196.94:/home/ubuntu/jenkins/"
                        script{
                            try{
                                sh "ssh ubuntu@3.110.196.94 kubectl apply -f jenkins"
                            }catch(error){
                                sh "ssh ubuntu@3.110.196.94 kubectl create -f jenkins"
                        }
                    }
                }
            }
        }
    }
}
