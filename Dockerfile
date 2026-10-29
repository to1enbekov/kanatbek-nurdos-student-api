# Multi-stage build: official JDK for compiling, minimal JRE for running.
FROM eclipse-temurin:21-jdk-jammy AS build
WORKDIR /workspace
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*
COPY settings.gradle build.gradle gradle.properties gradlew ./
COPY gradle ./gradle
COPY scripts/setup_gradle_wrapper.sh ./scripts/setup_gradle_wrapper.sh
RUN chmod +x gradlew scripts/setup_gradle_wrapper.sh
COPY src ./src
RUN ./gradlew --no-daemon clean bootJar

FROM eclipse-temurin:21-jre-jammy AS runtime
WORKDIR /app
RUN useradd --system --create-home --uid 10001 appuser
COPY --from=build /workspace/build/libs/app.jar app.jar
USER appuser
EXPOSE 8080
ENV SERVER_PORT=8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
