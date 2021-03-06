pipeline {
    environment {
        HARBOR_URL = "harbor.skdev.kro.kr"
        CI_PROJECT_PATH="spring"
        APP_NAME="spring"
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
    volumeMounts:
    - name: dockerconfigjson
      mountPath: /kaniko/.docker/
  - name: maven
    image: maven
    command:
    - sleep
    args:
    - 99d
  volumes:
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
      stage('build kaniko') {
        steps {
          container('kaniko') {
            sh '/kaniko/executor --context ./ --dockerfile ./Dockerfile --destination $HARBOR_URL/$CI_PROJECT_PATH/$APP_NAME:${BUILD_TAG}'
                }
            }
        }
      stage('Deploy') {
        steps {
          git credentialsId: '123',
              branch: 'main',
              url: 'git@github.com:shingilyong/app.git'
          sh "sed -i 's/test:.*\$/test:${BUILD_TAG}/g' deploy.yaml"
          sh "git add deploy.yaml"
          sh "git commit -m 'application update ${BUILD_TAG}'"
          sshagent(credentials: ['test']) {
            sh "git remote set-url origin git@github.com:shingilyong/app.git"
            sh "git push -u origin main"
      }
    }
   }
    }
}

