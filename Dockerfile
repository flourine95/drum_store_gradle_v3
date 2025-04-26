# Stage 1: Build WAR file
FROM gradle:jdk21-alpine as builder
WORKDIR /app
COPY . .
RUN gradle build war --no-daemon -Dorg.gradle.jvmargs=--enable-preview

# Stage 2: Deploy WAR to Tomcat
FROM tomcat:10.1
COPY --from=builder /app/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war
