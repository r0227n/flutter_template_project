import 'package:app/services/debug_time_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Security: Only allow debug page in debug mode
    if (!kDebugMode) {
      return const Scaffold(
        body: Center(
          child: Text('Debug page not available in release mode'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Page'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TimeSettingSection(),
          ],
        ),
      ),
    );
  }
}

/// UI component responsible only for displaying time information
/// Follows Single Responsibility Principle
class _TimeSettingSection extends StatelessWidget {
  const _TimeSettingSection({this.timeService = debugTimeService});
  
  final DebugTimeService timeService;

  @override
  Widget build(BuildContext context) {
    late final DateTime currentTime;
    late final String formattedTime;
    
    try {
      currentTime = timeService.getCurrentTime();
      formattedTime = timeService.formatTime(currentTime);
    } catch (e) {
      // Handle service errors gracefully
      return const _ErrorTimeDisplay();
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Time Setting',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Time: $formattedTime',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/// Separate widget for error display
/// Follows Single Responsibility Principle
class _ErrorTimeDisplay extends StatelessWidget {
  const _ErrorTimeDisplay();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Setting',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Error accessing system clock',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}