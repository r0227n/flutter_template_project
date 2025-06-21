import 'package:apps/i18n/translations.g.dart';
import 'package:apps/services/locale_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.title, super.key});

  final String title;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _changeLanguage(AppLocale locale) async {
    await LocaleService.saveLocale(locale);
    await LocaleSettings.setLocale(locale);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          PopupMenuButton<AppLocale>(
            icon: const Icon(Icons.language),
            onSelected: _changeLanguage,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AppLocale.ja,
                child: Text('日本語'),
              ),
              const PopupMenuItem(
                value: AppLocale.en,
                child: Text('English'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              t.hello,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _changeLanguage(AppLocale.ja),
                  child: const Text('日本語'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _changeLanguage(AppLocale.en),
                  child: const Text('English'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Counter:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '$_counter',
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
