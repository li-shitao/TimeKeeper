# 前端 (Flutter)

该目录包含家庭时光追踪器应用的 Flutter 前端。

## 运行应用

首先，请确保您已经安装了 Flutter SDK，并且有一个正在运行的设备（或模拟器/仿真器）。

然后，获取依赖项：

```bash
flutter pub get
```

最后，运行应用：

```bash
flutter run
```

## 构建发布版本

### Android

要为 Android 构建一个发布的 APK：

```bash
flutter build apk --release
```

输出文件将位于 `build/app/outputs/flutter-apk/app-release.apk`。

### iOS

要为 iOS 构建一个发布的 IPA：

```bash
flutter build ios --release
```

这需要您拥有一个有效的 Apple Developer 帐户，并在 Xcode 中设置好代码签名。输出文件将位于 `build/ios/archive/` 目录中。
