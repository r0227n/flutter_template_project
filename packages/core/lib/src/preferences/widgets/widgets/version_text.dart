import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// A text widget that displays the application version
///
/// This widget automatically retrieves and displays the application version
/// from the package information. It handles loading states and error cases
/// gracefully, providing fallback display text when version information
/// cannot be retrieved.
///
/// The widget is stateful and loads version information asynchronously
/// during initialization. It respects the widget lifecycle and only
/// updates state when the widget is still mounted.
///
/// Example usage:
/// ```dart
/// // Basic usage with automatic version detection
/// VersionText()
///
/// // With custom styling
/// VersionText(
///   style: TextStyle(fontSize: 12, color: Colors.grey),
/// )
///
/// // With dummy version for testing
/// VersionText(
///   dummyVersion: 'v1.0.0-dev',
/// )
/// ```
class VersionText extends StatefulWidget {
  /// Creates a version text widget
  const VersionText({
    super.key,
    this.dummyVersion,
    this.style,
  });

  /// Custom version text override (primarily for testing/debugging)
  ///
  /// When provided, this text will be displayed instead of the actual
  /// package version. Useful for testing UI without relying on actual
  /// package information.
  final String? dummyVersion;

  /// Optional text style for the version text
  ///
  /// If not provided, defaults to a muted body small text style
  /// that adapts to the current theme.
  final TextStyle? style;

  @override
  State<VersionText> createState() => _VersionTextState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('dummyVersion', dummyVersion));
    properties.add(DiagnosticsProperty<TextStyle?>('style', style));
  }
}

/// State class for [VersionText]
///
/// Manages the asynchronous loading of version information and
/// handles the widget lifecycle appropriately.
class _VersionTextState extends State<VersionText> {
  /// Current version text to display
  var _version = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadVersion().ignore();
  }

  /// Loads version information from package info or uses dummy version
  ///
  /// This method:
  /// 1. Uses dummyVersion if provided
  /// 2. Attempts to load version from [PackageInfo.fromPlatform]
  /// 3. Handles errors gracefully with fallback text
  /// 4. Only updates state if widget is still mounted
  Future<void> _loadVersion() async {
    if (widget.dummyVersion != null) {
      setState(() {
        _version = widget.dummyVersion!;
      });
      return;
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = 'v${packageInfo.version}';
        });
      }
    } on Exception {
      if (mounted) {
        setState(() {
          _version = 'v?.?.?';
        });
      }
    }
  }

  /// Builds the version text widget
  ///
  /// Displays the version text with either the provided style or
  /// a default muted style that adapts to the current theme.
  @override
  Widget build(BuildContext context) {
    return Text(
      _version,
      style:
          widget.style ??
          Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(
              alpha: 0.6,
            ),
          ),
    );
  }
}
