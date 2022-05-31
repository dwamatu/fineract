FROM gradle:7.4.2-jdk17-alpine as build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src

RUN gradle clean bootJar


FROM openjdk:17-alpine

EXPOSE 8080

RUN mkdir /app

ADD https://downloads.mariadb.com/Connectors/java/connector-java-2.7.5/mariadb-java-client-2.7.5.jar /app/

COPY --from=build /home/gradle/src/fineract-provider/build/libs/fineract-provider-*.jar /app/spring-boot-application.jar

ENTRYPOINT ["java", "-Dloader.path=/app/." ,"-Djava.security.egd=file:/dev/./urandom","-jar","/app/spring-boot-application.jar"]

