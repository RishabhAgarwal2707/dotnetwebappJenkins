pipeline { 
	agent any

	environment{
		IMAGE_NAME = 'rishabhagarwal27072001/jenkinsdotnet'
		IMAGE_TAG = 'latest'
	}

	stages{		
		stage('Checkout'){
			steps {
				checkout scm
			}
		}
		stage('Dotnet Build'){
			steps{
				sh 'dotnet build jenkinsDemoDotnetProject/jenkinsDemoDotnetProject.csproj --configuration Release'
			}
		}
		stage('Test'){
			steps{
				sh 'dotnet test jenkinsDemoDotnetProject.sln --logger "trx;LogFileName=./aspnetapp.trx"'
			}
		}
		stage('Delete Existing Docker Container and Docker Image'){
		    steps{
		        script{
		            def fullImageName= "${IMAGE_NAME}:${IMAGE_TAG}"
		            
		            def exist = sh( script: "docker ps -a -q --filter name=aspdotnet", returnStdout:true ).trim()
		            
		            if(exist){
		                sh "docker stop aspdotnet"
		                sh "docker rm aspdotnet"
		            }
		            
		            def imageExist = sh(script: "docker images -q ${fullImageName}", returnStdout: true).trim()
		            
		            if(imageExist){
		                sh "docker rmi -f ${fullImageName}"
		            }
		        }
		    }
		}
		stage('Docker Build'){
			steps{
				script{
					docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
				}
			}
		}
		stage('Docker Push'){
			steps{
				script{
					docker.withRegistry('https://index.docker.io/v1/','docker_login'){
						docker.image("${IMAGE_NAME}:${IMAGE_TAG}").push()
					}
				}
			}
		}
		stage('Docker Run'){
			steps{
				script{
					sh 'docker rm -f ${IMAGE_NAME} || true'
					sh "docker run -d --name aspdotnet -p 8000:80 ${IMAGE_NAME}:${IMAGE_TAG}"
				}
			}
		}
	}
}