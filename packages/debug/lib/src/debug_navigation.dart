/// Minimal debug navigation implementation to pass tests
class DebugNavigation {
  // Private constructor to prevent instantiation
  DebugNavigation._();

  static String get talkerRoute => '/debug/talker';

  static void Function() get navigateToTalkerScreen => () {};
}
