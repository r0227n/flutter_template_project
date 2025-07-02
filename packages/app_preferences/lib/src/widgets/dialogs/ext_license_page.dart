import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Displays the application license page
///
/// Shows a standard Material Design license page with application information.
/// If application details are not provided, they will be automatically
/// retrieved
/// from the package information using [PackageInfo.fromPlatform].
///
/// The function handles navigation context safety and provides fallback
/// behavior
/// if package information cannot be retrieved.
///
/// Parameters:
/// - [context]: The build context for navigation
/// - [applicationName]: Optional application name (defaults to package name)
/// - [applicationVersion]: Optional version string (defaults to package
///   version)
/// - [applicationIcon]: Optional icon widget to display
/// - [applicationLegalese]: Optional legal text (defaults to copyright notice)
/// - [useRootNavigator]: Whether to use the root navigator for navigation
///
/// Example usage:
/// ```dart
/// await showLicense(
///   context,
///   applicationName: 'My App',
///   applicationIcon: Icon(Icons.app),
///   applicationLegalese: '© 2024 My Company',
/// );
/// ```
Future<void> showLicense(
  BuildContext context, {
  String? applicationName,
  String? applicationVersion,
  Widget? applicationIcon,
  String? applicationLegalese,
  bool useRootNavigator = false,
}) async {
  try {
    // PackageInfo からアプリケーション情報を取得
    final packageInfo = await PackageInfo.fromPlatform();

    // パラメータが指定されていない場合はPackageInfoから取得
    final name = applicationName ?? packageInfo.appName;
    final version = applicationVersion ?? packageInfo.version;
    final legalese = applicationLegalese ?? '© ${DateTime.now().year} $name';

    if (!context.mounted) {
      return;
    }

    // Material Design の LicensePage を表示
    await Navigator.of(context, rootNavigator: useRootNavigator).push(
      MaterialPageRoute<void>(
        builder: (context) => LicensePage(
          applicationName: name,
          applicationVersion: version,
          applicationIcon: applicationIcon,
          applicationLegalese: legalese,
        ),
      ),
    );
  } on Exception catch (_) {
    // フォールバック: 基本的なライセンスページを表示
    if (context.mounted) {
      await Navigator.of(context, rootNavigator: useRootNavigator).push(
        MaterialPageRoute<void>(
          builder: (context) => const LicensePage(),
        ),
      );
    }
  }
}
