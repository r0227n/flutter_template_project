import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// バージョン情報を表示するタップ可能なテキストウィジェット
class VersionText extends StatefulWidget {
  const VersionText({
    super.key,
    this.dummyVersion,
    this.style,
  });

  /// カスタムバージョンテキスト（デバッグ用）
  final String? dummyVersion;

  /// テキストスタイル
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

class _VersionTextState extends State<VersionText> {
  var _version = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadVersion().ignore();
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
