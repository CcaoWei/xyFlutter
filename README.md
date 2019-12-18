# xiaoyan app based on flutter

Flutter sdk 有几处修改，具体修改之处参照文件 flutter_sdk_modification.patch 文件。

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

1. flutter packages get
1. flutter inject-plugins
1. flutter build apk --release
1. flutter build ios --release
1. Start xcode and build ios/Runner.xcworkspace project
1. Or to build in command line for ios: ./build_ios_ipa.sh

注意，需要发布android版本时，需要配置正确keystore文件，将（https://gitlab.com/xiaoyan/android-key-store/） 项目clone到本项目相同级别的目录下。如下：
    .
    ├── android-key-store
    │   └── keystore_xiaoyan.jks
    ├── xiaoyan-app
        └── xiaoyan-app-source-files ...

##protobuf 配置

1. 安装 protobuf
  $ brew install protobuf

2. 执行
  $ pub global activate protoc_plugin

3. 添加以下路径到 ~/.bash_profile中
  export PATH=$PATH:$HOME/.pub-cache/bin

4. 在proto文件所在目录执行 
 $ protoc --dart_out=dart const.proto
 $ protoc --dart_out=dart entity.proto
 $ protoc --dart_out=dart message.proto
 $ protoc --dart_out=dart event.proto

5.  将所有生成在dart目录下的文件覆盖到xiaoyan-app/lib/protocol 目录下

6. 如果需要更新proto文件, 先执行第4步, 在对新的proto文件执行第9步

## 运行单元测试
在mac os上运行单元测试(flutter test)时，可能会碰到flutter 命令意外退出的错误。可能是由于macos默认允许的打开文件数太少（256），需要调整进程可打开的文件个数。使用 ulimit -n 2048 命令。
