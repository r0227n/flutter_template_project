import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CustomLicensePage extends StatefulWidget {
  const CustomLicensePage({super.key});

  @override
  State<CustomLicensePage> createState() => _CustomLicensePageState();
}

class _CustomLicensePageState extends State<CustomLicensePage> {
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
