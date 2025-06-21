import 'package:apps/i18n/translations.g.dart';
import 'package:apps/theme/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({required this.title, super.key});

  final String title;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  var _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.brightness_6),
            onSelected: (mode) {
              ref.read(themeModeNotifierProvider.notifier).setTheme(mode);
            },
            itemBuilder: (context) {
              return ThemeMode.values.map((mode) {
                return PopupMenuItem<ThemeMode>(
                  value: mode,
                  child: Row(
                    children: [
                      Icon(
                        switch (mode) {
                          ThemeMode.light => Icons.light_mode,
                          ThemeMode.dark => Icons.dark_mode,
                          ThemeMode.system => Icons.brightness_auto,
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(mode.name),
                      const SizedBox(width: 8),
                      if (themeMode == mode) const Icon(Icons.check),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.palette,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'テーマ切り替えデモ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '現在のテーマ: ${themeMode.name}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(themeModeNotifierProvider.notifier)
                            .toggleTheme();
                      },
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('テーマ切り替え'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(t.hello),
            const SizedBox(height: 16),
            Text(
              'カウンター: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
