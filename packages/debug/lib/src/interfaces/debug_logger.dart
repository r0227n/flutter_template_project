/// Abstract interface for debug logging (Interface Segregation Principle)
abstract class DebugLogger {
  void log(String message);
  void error(String message, [Object? error, StackTrace? stackTrace]);
  void warning(String message);
  void info(String message);
}