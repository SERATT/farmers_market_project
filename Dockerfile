FROM maven:3.8.5-openjdk-17 AS build

ENV TZ=Asia/Aqtobe

WORKDIR /app

COPY pom.xml .

COPY src ./src

RUN mvn clean package -DskipTests

# Stage 2: Package the application in a lightweight image
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8989

ENTRYPOINT ["java", "-jar", "/app/app.jar"]

