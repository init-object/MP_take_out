FROM maven:3.8.6-jdk-8-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

FROM openjdk:8-jdk-slim as builder
WORKDIR /app
ARG JAR_FILE
COPY --from=build  /home/app/target/${JAR_FILE} renren-api.jar
RUN java -Djarmode=layertools -jar renren-api.jar extract

FROM openjdk:8-jdk-slim
MAINTAINER wangkun_king@live.com

RUN apt-get update; apt-get install -y fontconfig libfreetype6

ENV TZ=Asia/Shanghai

ENV JVM_OPTS=""
ENV JAVA_OPTS="-Dspring.profiles.active=prod"

WORKDIR /app
COPY --from=builder app/dependencies ./
COPY --from=builder app/spring-boot-loader ./
COPY --from=builder app/snapshot-dependencies ./
COPY --from=builder app/application ./

ENTRYPOINT ["sh","-c","java $JVM_OPTS $JAVA_OPTS org.springframework.boot.loader.JarLauncher"]

