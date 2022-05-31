FROM gradle:7.4.2-jdk17-alpine as build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle clean bootJar

FROM openjdk:17-alpine

EXPOSE 8080

RUN mkdir /app

RUN ls

COPY --from=build fineract-provider/build/libs/*.jar /app/spring-boot-application.jar

ENTRYPOINT ["java",  "-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]