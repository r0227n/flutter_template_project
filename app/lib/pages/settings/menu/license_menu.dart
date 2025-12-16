import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// PAGE-3 License-Menu
///
/// ライセンス画面を表示する
class LicenseMenu extends StatefulWidget {
  const LicenseMenu({super.key});

  @override
  State<LicenseMenu> createState() => _LicenseMenuState();
}

class _LicenseMenuState extends State<LicenseMenu> {
  late final Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: _packageInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final packageInfo = snapshot.data!;

          return LicensePage(
            // applicationNameを必須にするため、環境変数から取得
            // ignore: do_not_use_environment
            applicationName: const String.fromEnvironment('APP_NAME'),
            applicationVersion: packageInfo.version,
          );
        }

        return const LicensePage();
      },
    );
  }
}
