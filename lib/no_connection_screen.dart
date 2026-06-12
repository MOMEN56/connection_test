import 'package:connection_test/app_strings.dart';
import 'package:connection_test/assets_data.dart';
import 'package:connection_test/connection_service.dart';
import 'package:flutter/material.dart';

/// Displays offline UX without performing connection checks itself.
///
/// [ConnectionService] decides the status and passes it to this widget.
class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({super.key, required this.status})
    // This screen only supports the two offline states.
    : assert(
        status == ConnectionStatus.noNetwork ||
            status == ConnectionStatus.noInternet,
      );

  final ConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    // noInternet means a network exists but cannot reach the internet.
    final hasNetwork = status == ConnectionStatus.noInternet;
    final image = hasNetwork ? AssetsData.slow : AssetsData.noWifi;
    final title =
        hasNetwork ? AppStrings.noInternetTitle : AppStrings.noNetworkTitle;
    final message =
        hasNetwork ? AppStrings.noInternetMessage : AppStrings.noNetworkMessage;

    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(image, height: 250, fit: BoxFit.contain),
                const SizedBox(height: 24),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
