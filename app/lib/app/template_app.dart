import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 翻訳・テーマ・ルーティングを接続するアプリの root widget。
class TemplateApp extends ConsumerWidget {
  /// Router の生存期間は呼び出し元が管理する。
  const TemplateApp({required this.router, super.key});

  /// 起動時に一度だけ生成する router。
  final GoRouter router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(
      appPreferencesControllerProvider.select((value) => value.locale),
    );
    final themeMode = ref.watch(
      appPreferencesControllerProvider.select((value) => value.themeMode),
    );
    return TranslationProvider(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => Translations.of(context).appName,
        locale: locale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routerConfig: router,
      ),
    );
  }
}
