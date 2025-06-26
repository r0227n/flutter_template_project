/// Abstract interface for shake detection (Interface Segregation Principle)
abstract class ShakeDetectorInterface {
  void initialize();
  void dispose();
  bool get isSupported;
  void simulateShake();
}