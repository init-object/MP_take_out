FROM maven:3.8.6-jdk-8-slim AS build
ARG BUILD_MODULE
COPY renren-generator /home/app/renren-generator
COPY renren-common /home/app/renren-common
COPY renren-dynamic-datasource /home/app/renren-dynamic-datasource
COPY renren-api /home/app/renren-api
COPY renren-admin /home/app/renren-admin
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml  clean package -pl ${BUILD_MODULE} -am

FROM openjdk:8-jdk-slim as builder
ARG BUILD_MODULE
WORKDIR /app
COPY --from=build  /home/app/${BUILD_MODULE}/target/${BUILD_MODULE}.jar ${BUILD_MODULE}.jar
RUN java -Djarmode=layertools -jar ${BUILD_MODULE}.jar extract

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
