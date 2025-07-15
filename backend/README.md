# Backend (Spring Boot)

This directory contains the Spring Boot backend for the Family Time Tracker app.

## Running the application

You can run the application from your IDE by running the `main` method in `DemoApplication.java`.

Alternatively, you can use the Maven plugin:

```bash
mvn spring-boot:run
```

The application will be available at `http://localhost:8080`.

## Building a JAR file

To build a self-contained JAR file that you can run in production, use the following command:

```bash
mvn clean package
```

This will create a file named `demo-0.0.1-SNAPSHOT.jar` in the `target` directory. You can run it with:

```bash
java -jar target/demo-0.0.1-SNAPSHOT.jar
```
