import 'package:app/i18n/translations.g.dart';
import 'package:app/router/routes.dart';
import 'package:app_logger/app_logger.dart';
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

class _HomePageState extends ConsumerState<HomePage> with LoggerMixin {
  var _counter = 0;

  /// Performance measurement helper method
  void _measurePerformance(
    String operation,
    VoidCallback callback, {
    Map<String, dynamic>? metadata,
  }) {
    final stopwatch = Stopwatch()..start();
    callback();
    stopwatch.stop();

    logger.logPerformance(
      operation,
      stopwatch.elapsed,
      metadata,
    );
  }

  void _incrementCounter() {
    // Log user action with structured logging using mixin
    logUserAction(
      'counter_increment',
      {'previous_value': _counter, 'new_value': _counter + 1},
    );

    // Use performance measurement helper
    _measurePerformance('counter_update', () {
      setState(() {
        _counter++;
      });
    }, metadata: {'counter_value': _counter + 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => const SettingsRoute().push<void>(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(t.hello),
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
