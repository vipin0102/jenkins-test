
pipeline {
    agent any

    environment {
        IMAGE_NAME = "vipin0102/jenkins-test"
        IMAGE_TAG = "v_0.0.1"
    }

    stages {

        stage('Build') {
            when {
                branch 'main'
            }

            steps {
                echo 'Docker Login & Docker push'

                withCredentials([
                    usernamePassword(
                        credentialsId: 'github-token',
                        passwordVariable: 'dockerpassword',
                        usernameVariable: 'dockerbuild'
                    )
                ]) {
                    sh '''
                        docker login -u $dockerbuild -p $dockerpassword
                        docker build --no-cache -t $IMAGE_NAME:$IMAGE_TAG .
                        docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Pull & Deploy Image') {
            when {
                branch 'main'
            }

            steps {
                echo 'Docker Login & Docker push'

                withCredentials([
                    usernamePassword(
                        credentialsId: 'github-token',
                        passwordVariable: 'dockerpassword',
                        usernameVariable: 'dockerbuild'
                    )
                ]) {
                    sh '''
                        docker login -u $dockerbuild -p $dockerpassword
                        docker pull $IMAGE_NAME:$IMAGE_TAG
                        docker run --name -itd -p 5555:80 $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }
    }
}
