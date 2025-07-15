# 后端 (Spring Boot)

该目录包含家庭时光追踪器应用的 Spring Boot 后端。

## 运行应用

您可以通过运行 `DemoApplication.java` 中的 `main` 方法从您的 IDE 运行本应用。

或者，您也可以使用 Maven 插件：

```bash
mvn spring-boot:run
```

应用将在 `http://localhost:8080` 上可用。

## 构建 JAR 文件

要构建一个可以在生产环境中运行的独立 JAR 文件，请使用以下命令：

```bash
mvn clean package
```

这将在 `target` 目录中创建一个名为 `demo-0.0.1-SNAPSHOT.jar` 的文件。您可以使用以下命令运行它：

```bash
java -jar target/demo-0.0.1-SNAPSHOT.jar
```
