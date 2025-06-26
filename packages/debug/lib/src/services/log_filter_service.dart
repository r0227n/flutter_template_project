/// Service for filtering sensitive data from logs
/// (Single Responsibility Principle)
class LogFilterService {
  /// Singleton factory constructor (Performance optimization)
  factory LogFilterService() {
    return _instance ??= LogFilterService._();
  }

  /// Private constructor for singleton pattern (Performance optimization)
  LogFilterService._({
    List<RegExp>? patterns,
    List<String>? replacements,
  })  : _patterns = patterns ?? _getCompiledPatterns(),
        _replacements = replacements ?? _defaultReplacements;

  static LogFilterService? _instance;
  
  static List<RegExp>? _compiledPatterns;
  static final List<String> _patternStrings = [
    r'password[:\s]*[^\s]+',
    r'token[:\s]*[^\s]+', 
    r'key[:\s]*[^\s]+',
    r'secret[:\s]*[^\s]+',
  ];

  static const List<String> _defaultReplacements = [
    'password: [FILTERED]',
    'token: [FILTERED]',
    'key: [FILTERED]',
    'secret: [FILTERED]',
  ];

  final List<RegExp> _patterns;
  final List<String> _replacements;

  /// Lazy compilation of RegExp patterns (Performance optimization)
  static List<RegExp> _getCompiledPatterns() {
    return _compiledPatterns ??= _patternStrings
        .map((pattern) => RegExp(pattern, caseSensitive: false))
        .toList();
  }

  /// Filter sensitive data from message
  String filter(String message) {
    var filtered = message;
    
    for (var i = 0; i < _patterns.length && i < _replacements.length; i++) {
      filtered = filtered.replaceAll(_patterns[i], _replacements[i]);
    }
    
    return filtered;
  }

  /// Add custom pattern (Open/Closed Principle)
  LogFilterService withPattern(RegExp pattern, String replacement) {
    return LogFilterService._(
      patterns: [..._patterns, pattern],
      replacements: [..._replacements, replacement],
    );
  }

  /// Clean up cached patterns (Performance optimization)
  static void dispose() {
    _compiledPatterns?.clear();
    _compiledPatterns = null;
    _instance = null;
  }
}
