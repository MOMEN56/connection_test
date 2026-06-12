import 'package:connection_test/app_strings.dart';
import 'package:flutter/material.dart';

/// Shown while the app checks for network and real internet access.
class CheckingConnectionScreen extends StatelessWidget {
  const CheckingConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(AppStrings.checkingConnection),
          ],
        ),
      ),
    );
  }
}
