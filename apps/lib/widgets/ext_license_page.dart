import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// ライセンスページを表示する関数
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
  } on Exception catch (e) {
    // エラーが発生した場合はデバッグ出力
    if (kDebugMode) {
      print('Error showing license page: $e');
    }

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
