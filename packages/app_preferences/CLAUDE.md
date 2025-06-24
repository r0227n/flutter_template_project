# app_preferences Package Development Guide

**AI-powered application preferences management package for Claude Code**

This document provides technical guidance for Claude Code when working with the `app_preferences` package. For human-readable documentation, see [README.md](README.md).

## Documentation Structure and Relationship

### CLAUDE.md - README.md Integration System

- **CLAUDE.md** (this file): Contains technical specifications and Claude Code instructions for app_preferences package
- **README.md**: Provides human-readable documentation that mirrors and explains the content in CLAUDE.md
- **1:1 Relationship**: Each section in this CLAUDE.md has an equivalent explanation in README.md. This constraint applies to the entire project structure.

## Package Overview

The `app_preferences` package provides centralized application settings management for Flutter applications with focus on locale (language) and theme (light/dark mode) preferences using SharedPreferences for data persistence.

## Core Architecture Components

### Repository Layer

**AppPreferencesRepository**:
- Abstracts SharedPreferences interactions
- Provides async methods for settings persistence
- Handles data serialization/deserialization
- Implements error handling for storage operations

### Provider Layer (Riverpod)

**State Management Providers**:
- `AppLocaleProvider`: Manages locale state with AsyncNotifier pattern
- `AppThemeProvider`: Manages theme mode state with AsyncNotifier pattern  
- `sharedPreferencesProvider`: Singleton SharedPreferences instance provider

**Code Generation Requirements**:
- Use `@riverpod` annotation for all providers
- Generate with `dart run build_runner build`
- Follow AsyncValue pattern for async operations

### Initialization System

**AppPreferencesInitializer**:
- Handles app startup settings initialization
- Provides callback-based locale configuration
- Manages device locale fallback logic
- Ensures SharedPreferences instance availability

### Theme System

**AppTheme**:
- Defines Material 3 compatible light/dark themes
- Uses Deep Purple color scheme for consistency
- Provides static theme configurations

## Development Commands

### Code Generation

```bash
# Navigate to package directory
cd packages/app_preferences

# Generate Riverpod providers and Freezed classes
dart run build_runner build

# Generate translations (slang)
dart run slang

# Clean and rebuild (if needed)
dart run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# Run package tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/providers/app_locale_provider_test.dart
```

### Static Analysis

```bash
# Analyze package code
dart analyze

# Check formatting
dart format --set-exit-if-changed .

# Custom lint checks
dart run custom_lint
```

## AI Development Guidelines

### When Implementing New Features

1. **Repository First**: Always create repository methods before providers
2. **Provider Pattern**: Use AsyncNotifierProvider for stateful operations
3. **Error Handling**: Implement comprehensive error handling with AsyncValue.error
4. **Code Generation**: Ensure all @riverpod annotations are properly configured
5. **Testing**: Create corresponding test files for new providers/repositories

### Package Structure Requirements

```
lib/
├── app_preferences.dart              # Main export file
├── widgets.dart                      # Widget export file  
├── i18n/                            # Generated translation files
└── src/
    ├── app_preferences_initializer.dart  # Initialization utilities
    ├── providers/                   # Riverpod providers
    │   ├── app_locale_provider.dart
    │   ├── app_theme_provider.dart
    │   └── shared_preferences_provider.dart
    ├── repositories/                # Data access layer
    │   └── app_preferences_repository.dart
    ├── theme/                       # Theme definitions
    │   └── app_theme.dart
    └── widgets/                     # UI components
        ├── locale_selection_dialog.dart
        ├── theme_selection_dialog.dart
        └── preferences_dialog_helpers.dart
```

## Implementation Patterns

### Async State Management

```dart
@riverpod
class AppLocaleProvider extends _$AppLocaleProvider {
  @override
  Future<Locale> build() async {
    // Initialize from repository
    final repository = ref.read(appPreferencesRepositoryProvider);
    final savedLocale = await repository.getLocale();
    return savedLocale ?? const Locale('ja');
  }

  Future<void> setLocale(Locale locale) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(appPreferencesRepositoryProvider);
      await repository.setLocale(locale);
      state = AsyncValue.data(locale);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

### Error Handling Pattern

```dart
// Always wrap async operations in try-catch
try {
  final result = await repository.someOperation();
  state = AsyncValue.data(result);
} catch (error, stackTrace) {
  state = AsyncValue.error(error, stackTrace);
}
```

### Dialog Implementation Pattern

```dart
static Future<void> showSelectionDialog({
  required BuildContext context,
  required String title,
  // Additional parameters
}) async {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: // Dialog content,
      actions: // Dialog actions,
    ),
  );
}
```

## Dependencies Management

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.x.x
  hooks_riverpod: ^2.x.x
  riverpod_annotation: ^2.x.x
  slang: ^3.x.x
  package_info_plus: ^4.x.x

dev_dependencies:
  build_runner: ^2.x.x
  freezed: ^2.x.x
  json_serializable: ^6.x.x
  riverpod_generator: ^2.x.x
  flutter_test:
    sdk: flutter
```

### Workspace Configuration

```yaml
# pubspec.yaml
name: app_preferences
description: Application preferences management package
version: 1.0.0+1
publish_to: 'none'

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

resolution: workspace
```

## Quality Assurance Requirements

### Code Coverage

- Minimum 80% coverage for providers
- 70% coverage for repositories  
- 60% coverage for widgets
- 100% coverage for utility functions

### Static Analysis

- Zero dart analyze warnings
- All custom_lint rules must pass
- Proper documentation for public APIs
- Consistent code formatting

### Testing Strategy

1. **Unit Tests**: All providers and repositories
2. **Widget Tests**: Dialog components and helpers
3. **Integration Tests**: End-to-end preference flows
4. **Golden Tests**: UI component visual regression

## AI Review-First Implementation

### Security Review (High Priority)

- No hardcoded secrets or API keys
- Proper input validation for locale/theme values
- Secure data storage practices
- Error message sanitization

### Architecture Review (Medium Priority)

- SOLID principles compliance
- Proper dependency injection
- Clean separation of concerns
- Testable code structure

### Performance Review (Low Priority)

- Efficient SharedPreferences usage
- Minimal memory allocations
- Appropriate async/await patterns
- No obvious performance bottlenecks

## Package Integration Points

### Main App Integration

```dart
// In main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final sharedPrefs = await AppPreferencesInitializer.initializeLocale(
    onLocaleFound: (languageCode) async {
      // Handle locale initialization
    },
    onUseDeviceLocale: () async {
      // Handle device locale fallback
    },
  );
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: MyApp(),
    ),
  );
}
```

### Provider Usage

```dart
// Reading state
final localeAsync = ref.watch(appLocaleProviderProvider);
final themeModeAsync = ref.watch(appThemeProviderProvider);

// Updating state
await ref.read(appLocaleProviderProvider.notifier).setLocale(locale);
await ref.read(appThemeProviderProvider.notifier).setThemeMode(themeMode);
```

## Internationalization Support

### Current Supported Languages

- Japanese (ja) - Primary
- English (en) - Secondary

### Translation File Structure

```
assets/i18n/
├── ja.i18n.json    # Japanese translations
└── en.i18n.json    # English translations
```

### Adding New Languages

1. Create new translation file in `assets/i18n/`
2. Add locale to available options in dialogs
3. Update `LocaleOption` configurations
4. Regenerate translation files with `dart run slang`

## Maintenance Guidelines

### Version Updates

- Follow semantic versioning
- Update CHANGELOG.md for all changes
- Test compatibility with main app
- Verify all dependencies are up to date

### Documentation Updates

- Keep README.md in sync with CLAUDE.md
- Update API documentation for public methods
- Maintain code examples in documentation
- Update integration guides when APIs change

## Related Files

- **Main Package Documentation**: [../CLAUDE.md](../CLAUDE.md)
- **Project Overview**: [../../README.md](../../README.md)
- **Best Practices**: [../../docs/CLAUDE_4_BEST_PRACTICES.md](../../docs/CLAUDE_4_BEST_PRACTICES.md)

---

**Note**: This CLAUDE.md file maintains 1:1 correspondence with README.md to ensure both AI and human developers have consistent understanding of the app_preferences package functionality and architecture.