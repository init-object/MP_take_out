FROM openjdk:8-jdk-slim as builder
WORKDIR /app
ARG JAR_FILE
ADD target/${JAR_FILE} renren-api.jar
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

