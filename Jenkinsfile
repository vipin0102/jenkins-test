pipeline {
    agent any

    parameters {
        choice(
            name: 'IMAGE_NAME',
            choices: ['vipin0102/jenkins-test-main', 'vipin0102/jenkins-test-dev'],
            description: 'Choose the Docker image repository'
        )
        string(
            name: 'IMAGE_TAG',
            defaultValue: 'v_0.0.1',
            description: 'Please provide the image tag'
        )
        string(
            name: 'CONTAINER_NAME',
            defaultValue: 'web',
            description: 'Name of the container to run'
        )
        string(
            name: 'HOST_PORT',
            defaultValue: '5555',
            description: 'Host port to expose the app on'
        )
        booleanParam(
            name: 'BUILD',
            defaultValue: true,
            description: 'Build and push the image?'
        )
        booleanParam(
            name: 'DEPLOY',
            defaultValue: true,
            description: 'Pull and deploy the image?'
        )
    }

    stages {

        stage('Build & Push') {
            when { expression { params.BUILD } }
            steps {
                echo "Building ${params.IMAGE_NAME}:${params.IMAGE_TAG}"

                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockercreds',
                        usernameVariable: 'dockerbuild',
                        passwordVariable: 'dockerpassword'
                    )
                ]) {
                    sh '''
                        echo "$dockerpassword" | docker login -u "$dockerbuild" --password-stdin
                        docker build --no-cache -t $IMAGE_NAME:$IMAGE_TAG .
                        docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Pull & Deploy') {
            when { expression { params.DEPLOY } }
            steps {
                echo "Deploying ${params.IMAGE_NAME}:${params.IMAGE_TAG} on port ${params.HOST_PORT}"

                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockercreds',
                        usernameVariable: 'dockerbuild',
                        passwordVariable: 'dockerpassword'
                    )
                ]) {
                    sh '''
                        echo "$dockerpassword" | docker login -u "$dockerbuild" --password-stdin
                        docker pull $IMAGE_NAME:$IMAGE_TAG
                        docker rm -f $CONTAINER_NAME || true
                        docker run --name $CONTAINER_NAME -d -p $HOST_PORT:80 $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }
    }

    post {
        always {
            script {
                currentBuild.displayName = "#${env.BUILD_NUMBER} ${params.IMAGE_NAME}:${params.IMAGE_TAG}"
            }
        }
    }
}