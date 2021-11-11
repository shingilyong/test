pipeline {
    environment {
        HARBOR_URL = "harbor.skdev.kro.kr"
        CI_PROJECT_PATH="spring"
        APP_NAME="spring"
        CI_REGISTRY_USER="admin"
        CI_REGISTRY_PASSWORD="Harbor12345"
        HARBOR_CREDENTIAL= credentials('admin')
    }
    agent {
      kubernetes {
        yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: docker
    image: docker
    command:
    - cat
    tty: true
    volumeMounts:
    - name: docker
      mountPath: /var/run/docker.sock
    - name: dockerconfigjson
      mountPath: /home/ubuntu/.docker
  - name: maven
    image: maven
    command:
    - sleep
    args:
    - 99d
  volumes:
  - name: docker
    hostPath:
      path: /var/run/docker.sock
  - name: dockerconfigjson
    secret:
      secretName: harbor-cred
      items:
      - key: ".dockerconfigjson"
        path: "config.json"
  imagePullSecrets:
  - name: harbor-cred
'''
       }
     }
    stages {
      stage('build maven') {
        steps {
          container('maven') {
            sh 'ls -al'
            sh 'mvn -f ./pom.xml clean package -D maven.test.skip=true'
             }
           }
         }
      stage('build docker') {
        steps {
          container('docker') {
            sh 'docker build -t $HARBOR_URL/$CI_PROJECT_PATH/$APP_NAME:${BUILD_TAG} .'
            sh '''echo $HARBOR_CREDENTIAL_PSW | docker login $HARBOR_URL -u admin --password-stdin'''
            sh 'docker push ${HARBOR_URL}/${CI_PROJECT_PATH}/${APP_NAME}:${BUILD_TAG}'
                }
            }
        }
    }
}
