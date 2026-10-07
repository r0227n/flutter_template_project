// Melos 7.3's launcher assumes a pub snapshot path and may resolve dependencies.
// This adapter runs the prepared CLI in the current workspace without relaunch.
import 'dart:io';

// cli_launcher is pinned transitively by Melos in the workspace lockfile.
// ignore: depend_on_referenced_packages
import 'package:cli_launcher/cli_launcher.dart';
// Melos does not expose its CLI entrypoint through the public library.
// ignore: implementation_imports
import 'package:melos/src/command_runner.dart';

Future<void> main(List<String> arguments) async {
  final root = Directory.current;
  await melosEntryPoint(
    arguments,
    LaunchContext(
      directory: root,
      localInstallation: ExecutableInstallation(
        name: ExecutableName('melos'),
        isSelf: false,
        packageRoot: root,
      ),
    ),
  );
}
