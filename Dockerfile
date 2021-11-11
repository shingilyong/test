FROM maven:3-jdk-8-alpine

WORKDIR /usr/src/app

COPY . /usr/src/app
#RUN mvn -f ./pom.xml clean package -D maven.test.skip=true

ENV PORT 80
EXPOSE $PORT
#CMD [ "sh", "-c", "mvn -Dserver.port=${PORT} spring-boot:run" ]
CMD [ "sh", "java", "-jar", "target/demo-0.0.1-SNAPSHOT.jar" ]
