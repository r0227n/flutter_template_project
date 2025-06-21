import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:apps/widgets/ext_license_page.dart';

/// バージョン情報を表示するタップ可能なテキストウィジェット
class VersionText extends StatefulWidget {
  const VersionText({
    super.key,
    this.dummyVersion,
    this.style,
    this.applicationName,
    this.applicationIcon, 
    this.applicationLegalese,
    this.useRootNavigator = false,
  });
  
  /// カスタムバージョンテキスト（デバッグ用）
  final String? dummyVersion;
  
  /// テキストスタイル
  final TextStyle? style;
  
  /// ライセンスページ表示時のオプション
  final String? applicationName;
  final Widget? applicationIcon;
  final String? applicationLegalese;
  final bool useRootNavigator;

  @override
  State<VersionText> createState() => _VersionTextState();
}

class _VersionTextState extends State<VersionText> {
  var _version = 'Loading...';
  
  @override
  void initState() {
    super.initState();
    _loadVersion();
  }
  
  /// バージョン情報を読み込む
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
  
  /// ライセンスページを表示
  Future<void> _showLicensePage() async {
    await showLicense(
      context,
      applicationName: widget.applicationName,
      applicationIcon: widget.applicationIcon,
      applicationLegalese: widget.applicationLegalese,
      useRootNavigator: widget.useRootNavigator,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showLicensePage,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          _version,
          style: widget.style ?? 
              Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ),
              ),
        ),
      ),
    );
  }
}