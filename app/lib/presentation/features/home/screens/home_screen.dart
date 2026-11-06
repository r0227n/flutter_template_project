import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 新しいアプリの最初の feature として置き換えるホーム画面。
class HomeScreen extends StatelessWidget {
  /// ホーム画面を生成する。
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(translations.home)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.appSpacing.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  translations.welcome,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.appSpacing.l),
                FilledButton.icon(
                  onPressed: () => const SettingsRoute().go(context),
                  icon: const Icon(Icons.settings_outlined),
                  label: Text(translations.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
