import 'package:app/i18n/translations.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// A page that displays the application licenses using Navigator 2.0 routing
/// 
/// This replaces the showLicensePage dialog with a proper route that supports
/// browser back navigation and better integration with go_router.
class CustomLicensePage extends StatelessWidget {
  const CustomLicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings.licenses),
      ),
      body: const Center(
        child: Text('License information will be displayed here'),
      ),
    );
  }
}

/// Content widget for license page that displays all packages and their licenses
class CustomLicensePageContent extends StatelessWidget {
  const CustomLicensePageContent({
    required this.applicationName,
    required this.applicationVersion,
    super.key,
  });
  
  final String applicationName;
  final String applicationVersion;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LicenseEntry>(
      stream: LicenseRegistry.licenses,
      builder: (context, snapshot) {
        return switch (snapshot.connectionState) {
          ConnectionState.waiting => const Center(
              child: CircularProgressIndicator(),
            ),
          ConnectionState.done => const Center(
              child: Text('No licenses found'),
            ),
          _ => snapshot.hasData
              ? _buildLicensesList(context, snapshot.data!)
              : const Center(child: Text('Loading licenses...')),
        };
      },
    );
  }

  Widget _buildLicensesList(BuildContext context, LicenseEntry license) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Application header
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applicationName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Version: $applicationVersion',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'This application uses the following open source packages:',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // License entry
        Card(
          child: ExpansionTile(
            title: Text(license.packages.join(', ')),
            children: license.paragraphs.map((paragraph) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  paragraph.text,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}