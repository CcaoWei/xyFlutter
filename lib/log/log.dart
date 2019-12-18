part of log_shared;

class Log {
  static const int NONE = -1;
  static const int INFO = 0;
  static const int DEBUG = 1;
  static const int WARNING = 2;
  static const int ERROR = 3;

  int level = INFO;
  String className = "";

  Log(int level, String className) {
    this.level = level;
    this.className = className;
  }

  void i(String message, String methodName) {
    if (LogFactory().globalLevel == NONE) {
      if (level == INFO) {
        log(message, methodName);
      }
    } else {
      if (LogFactory().globalLevel == INFO) {
        log(message, methodName);
      }
    }
  }

  void d(String message, String methodName) {
    if (LogFactory().globalLevel == NONE) {
      if (level == INFO || level == DEBUG) {
        log(message, methodName);
      }
    } else {
      if (LogFactory().globalLevel == INFO ||
          LogFactory().globalLevel == DEBUG) {
        log(message, methodName);
      }
    }
  }

  void w(String message, String methodName) {
    if (LogFactory().globalLevel == NONE) {
      if (level == INFO || level == DEBUG || level == WARNING) {
        log(message, methodName);
      }
    } else {
      if (LogFactory().globalLevel == INFO ||
          LogFactory().globalLevel == DEBUG ||
          LogFactory().globalLevel == WARNING) {
        log(message, methodName);
      }
    }
  }

  void e(String message, String methodName) {
    if (LogFactory().globalLevel == NONE) {
      log(message, methodName);
    } else {
      log(message, methodName);
    }
  }

  void log(String message, String methodName) {
    print('[$className: $methodName] -> $message');
  }
}
