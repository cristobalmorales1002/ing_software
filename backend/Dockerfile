FROM maven:3.8.5-openjdk-17 AS build

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jdk
WORKDIR /app
# El comodín *.jar está bien, pero asegúrate de que solo haya uno generado
COPY --from=build /app/target/*.jar app.jar

# CORRECCIÓN: Mantenemos el 8080 porque es donde "vive" Java internamente.
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]