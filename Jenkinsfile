pipeline { 
	agent any

	environment{
		DOCKER_IMAGE = 'JenkinsAssignmentDotnet'
		IMAGE_TAG = 'lastest'
	}

	stages{		
		stage('Checkout'){
			steps {
				checkout scm
			}
		}
		stage('Build'){
			steps{
				sh 'dotnet build jenkinsDemoDotnetProject/jenkinsDemoDotnetProject.csproj --configuration Release'
			}
		}
		stage('Test'){
			steps{
				sh 'dotnet test jenkinsDemoDotnetProject.sln --logger "trx;LogFileName=./aspnetapp.trx"'
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
			step{
				script{
					docker.withRegistry('https://index.docker.io/v1/','docker_login'){
						docker.image("${IMAGE_NAME}:${IAMGE_TAG}").push()
					}
				}
			}
		}
		stage('Run'){
			steps{
				script{
					sh 'docker rm -f ${IMAGE_NAME} || true'
					sh "docker run -d --name aspnetapp -p 8080:80 ${IMAGE_NAME}:${IMAGE_TAG}"
				}
			}
		}
	}
}