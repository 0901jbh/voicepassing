# FROM gradle:jdk11

# ARG DB_URL
# ARG DB_USER
# ARG DB_PASSWORD
# ARG DOMAIN_UNTRUNC
# ARG SPRING_RECORD_TEMP_DIR

# ENV DB_URL=${MYSQL_URL}
# ENV DB_USER=${MYSQL_USER}
# ENV DB_PASSWORD=${MYSQL_PASSWORD}
# ENV DOMAIN_UNTRUNC=${DOMAIN_UNTRUNC}
# ENV SPRING_RECORD_TEMP_DIR=/data

# ENV APP_HOME=/apps

# WORKDIR ${APP_HOME}

# COPY . ${APP_HOME}

# RUN cd ${APP_HOME}

# RUN chmod +x gradlew

# RUN ./gradlew bootJar

FROM openjdk:11
ARG JAR_FILE=backend/voicepassing/build/libs/voicepassing-0.0.1-SNAPSHOT.jar

RUN pwd
RUN ls ./var/

# COPY ${JAR_FILE} app.jar


EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "/app.jar" ]