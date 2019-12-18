part of log_shared;

class LogFactory {
  static final LogFactory _factory = LogFactory._internal();

  LogFactory._internal();

  factory LogFactory() {
    return _factory;
  }

  int globalLevel = Log.NONE;

  void setGlobalLevel(int globalLevel) {
    this.globalLevel = globalLevel;
  }

  Log getLogger(int level, String className) {
    return Log(level, className);
  }
}
