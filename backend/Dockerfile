# Usamos Eclipse Temurin (el Java estándar actual para Docker)
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copia el jar
COPY target/*.jar app.jar

# Expone el puerto
EXPOSE 8080

# Ejecuta la app
ENTRYPOINT ["java", "-jar", "app.jar"]