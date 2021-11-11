pipeline {
    environment {
        HARBOR_URL = "harbor.skdev.kro.kr"
        CI_PROJECT_PATH="spring"
        APP_NAME="spring"
        CI_REGISTRY_USER="admin"
        CI_REGISTRY_PASSWORD="Harbor12345"
    }
    agent {
      kubernetes {
        yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - sleep
    args:
    - 99d
  - name: maven
    image: maven
    command:
    - sleep
    args:
    - 99d
'''
       }
     }
    stages {
      stage('build maven') {
        steps {
            sh 'ls -al'
            sh 'mvn -f ./pom.xml clean package -D maven.test.skip=true'
             }
           }
      stage('build kaniko') {
        steps {
          container('kaniko') {
            sh '/kaniko/executor --context ./ --dockerfile ./Dockerfile --destination $HARBOR_URL/$CI_PROJECT_PATH/$APP_NAME:${BUILD_TAG}'
                }
            }
        }
    }
}

