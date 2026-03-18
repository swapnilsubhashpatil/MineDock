FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy only server jar
COPY server.jar .

# Accept EULA automatically
RUN echo "eula=true" > eula.txt

EXPOSE 25565

CMD ["java", "-Xms1G", "-Xmx3G", "-jar", "server.jar", "nogui"]