import 'package:app/core/gen/slang.g.dart';
import 'package:app/core/localization/app_locale_resolver.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// ProviderScope の生成前に失敗した場合の再試行画面。
class BootstrapFailureApp extends StatefulWidget {
  /// 再試行の完了までボタンを無効化する。
  const BootstrapFailureApp({required this.onRetry, super.key});

  /// 失敗を処理して再度 root widget を起動する callback。
  final Future<void> Function() onRetry;

  @override
  State<BootstrapFailureApp> createState() => _BootstrapFailureAppState();
}

class _BootstrapFailureAppState extends State<BootstrapFailureApp> {
  bool _isRetrying = false;

  Future<void> _retry() async {
    if (_isRetrying) return;
    setState(() => _isRetrying = true);
    try {
      await widget.onRetry();
    } finally {
      if (mounted) setState(() => _isRetrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = resolveAppLocale(
      null,
      WidgetsBinding.instance.platformDispatcher.locales,
    );
    final translations = locale.translations;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.l),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    translations.bootstrapFailed,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.l),
                  FilledButton(
                    onPressed: _isRetrying ? null : _retry,
                    child: Text(translations.retry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
