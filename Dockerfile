# Use a base image for Gradle
FROM gradle:7.6.0-jdk17 as builder

# Set the working directory
WORKDIR /app

# Copy the build.gradle and settings.gradle first to cache dependencies
COPY build.gradle .
COPY settings.gradle .

# Download dependencies
RUN gradle build --no-daemon

# Copy the rest of your application code
COPY . .

# Build the application
RUN gradle bootJar --no-daemon

# Use a smaller image for the runtime
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the builder image
COPY --from=builder /app/build/libs/chat-server-*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
