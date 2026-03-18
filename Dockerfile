FROM eclipse-temurin:21-jre

WORKDIR /app

# Auto-scale JVM memory to available machine/container RAM.
ENV JVM_INITIAL_RAM_PERCENT=60.0
ENV JVM_MAX_RAM_PERCENT=85.0
ENV JVM_GC_FLAGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC"

# Copy only server jar
COPY server.jar .

# Accept EULA automatically
RUN echo "eula=true" > eula.txt

EXPOSE 25565

CMD ["sh", "-c", "java $JVM_GC_FLAGS -XX:InitialRAMPercentage=$JVM_INITIAL_RAM_PERCENT -XX:MaxRAMPercentage=$JVM_MAX_RAM_PERCENT -jar server.jar nogui"]