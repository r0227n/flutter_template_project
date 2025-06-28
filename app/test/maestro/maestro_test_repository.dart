import 'dart:io';

/// Repository interface for Maestro operations following SOLID principles
abstract class MaestroTestRepository {
  Future<bool> isMaestroInstalled();
  Future<bool> isTestFileValid(String testFilePath);
  Future<MaestroTestResult> validateTestContent(String testFilePath);
}

/// Data class for Maestro test results
class MaestroTestResult {
  final bool isValid;
  final List<String> validationErrors;
  final Map<String, dynamic> testMetadata;

  const MaestroTestResult({
    required this.isValid,
    required this.validationErrors,
    required this.testMetadata,
  });

  factory MaestroTestResult.success(Map<String, dynamic> metadata) {
    return MaestroTestResult(
      isValid: true,
      validationErrors: [],
      testMetadata: metadata,
    );
  }

  factory MaestroTestResult.failure(List<String> errors) {
    return MaestroTestResult(
      isValid: false,
      validationErrors: errors,
      testMetadata: {},
    );
  }
}

/// Concrete implementation of MaestroTestRepository with performance optimizations
class MaestroTestRepositoryImpl implements MaestroTestRepository {
  final ProcessValidator _validator;
  final FileSystemService _fileService;

  // Performance: Cache validation results to avoid repeated file I/O
  final Map<String, MaestroTestResult> _validationCache =
      <String, MaestroTestResult>{};
  final Map<String, bool> _installationCache = <String, bool>{};

  MaestroTestRepositoryImpl({
    required ProcessValidator validator,
    required FileSystemService fileService,
  }) : _validator = validator,
       _fileService = fileService;

  @override
  Future<bool> isMaestroInstalled() async {
    // Performance: Cache installation check result
    const cacheKey = 'maestro_installed';
    if (_installationCache.containsKey(cacheKey)) {
      return _installationCache[cacheKey]!;
    }

    try {
      final result = await _validator.runSecurely('/bin/bash', [
        '-c',
        'export PATH="\$PATH":\$HOME/.maestro/bin && which maestro',
      ]);
      final isInstalled = result.exitCode == 0;
      _installationCache[cacheKey] = isInstalled;
      return isInstalled;
    } on SecurityException {
      _installationCache[cacheKey] = false;
      return false;
    }
  }

  @override
  Future<bool> isTestFileValid(String testFilePath) async {
    return await _fileService.fileExists(testFilePath) &&
        await _fileService.isReadableFile(testFilePath);
  }

  @override
  Future<MaestroTestResult> validateTestContent(String testFilePath) async {
    // Performance: Cache validation results with file modification check
    if (_validationCache.containsKey(testFilePath)) {
      final cachedResult = _validationCache[testFilePath]!;
      // Simple cache validation - in production, would check file modification time
      if (await _fileService.fileExists(testFilePath)) {
        return cachedResult;
      }
    }

    try {
      if (!await isTestFileValid(testFilePath)) {
        final failureResult = MaestroTestResult.failure([
          'Test file does not exist or is not readable',
        ]);
        _validationCache[testFilePath] = failureResult;
        return failureResult;
      }

      final content = await _fileService.readFile(testFilePath);
      final errors = <String>[];
      final metadata = <String, dynamic>{};

      // Performance: Use compiled RegExp for faster repeated matching
      final appIdPattern = RegExp(r'appId:\s*\$\{APP_ID\}');
      final launchAppPattern = RegExp(r'launchApp');
      final assertVisiblePattern = RegExp(r'assertVisible');
      final floatingActionButtonPattern = RegExp(r'FloatingActionButton');

      // Validate required elements with optimized pattern matching
      if (!appIdPattern.hasMatch(content)) {
        errors.add('Missing appId configuration with environment variable');
      }
      if (!launchAppPattern.hasMatch(content)) {
        errors.add('Missing launchApp step');
      }
      if (!assertVisiblePattern.hasMatch(content)) {
        errors.add('Missing assertion steps');
      }
      if (!floatingActionButtonPattern.hasMatch(content)) {
        errors.add('Missing FloatingActionButton interaction');
      }

      // Extract metadata efficiently
      metadata['hasAppId'] = appIdPattern.hasMatch(content);
      metadata['hasLaunchApp'] = launchAppPattern.hasMatch(content);
      metadata['hasAssertions'] = assertVisiblePattern.hasMatch(content);
      metadata['hasFloatingActionButton'] = floatingActionButtonPattern
          .hasMatch(content);

      final result = errors.isEmpty
          ? MaestroTestResult.success(metadata)
          : MaestroTestResult.failure(errors);

      // Cache the result for future use
      _validationCache[testFilePath] = result;
      return result;
    } catch (e) {
      final failureResult = MaestroTestResult.failure([
        'Validation failed: ${e.toString()}',
      ]);
      _validationCache[testFilePath] = failureResult;
      return failureResult;
    }
  }
}

/// Single responsibility: Process validation and execution
class ProcessValidator {
  Future<ProcessResult> runSecurely(
    String executable,
    List<String> arguments,
  ) async {
    // Input validation - prevent null bytes and control characters
    final sanitizedArgs = arguments
        .map((arg) => arg.replaceAll(RegExp(r'[\x00-\x1f\x7f-\x9f]'), ''))
        .toList();

    // Validate executable path to prevent path traversal
    if (executable.contains('..') || executable.contains('\x00')) {
      throw SecurityException('Invalid executable path: $executable');
    }

    return await Process.run(executable, sanitizedArgs);
  }
}

/// Single responsibility: File system operations
class FileSystemService {
  Future<bool> fileExists(String path) async {
    try {
      return await File(path).exists();
    } catch (e) {
      return false;
    }
  }

  Future<bool> isReadableFile(String path) async {
    try {
      final file = File(path);
      final stat = await file.stat();
      return stat.type == FileSystemEntityType.file;
    } catch (e) {
      return false;
    }
  }

  Future<String> readFile(String path) async {
    try {
      return await File(path).readAsString();
    } catch (e) {
      throw FileSystemException('Failed to read file: $path', path);
    }
  }
}

/// Custom exceptions for better error handling
class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}

class ValidationException implements Exception {
  final String message;
  final List<String> validationErrors;

  ValidationException(this.message, this.validationErrors);

  @override
  String toString() => 'ValidationException: $message';
}
