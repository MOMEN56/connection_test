import 'dart:async';

import 'package:connection_test/app_strings.dart';
import 'package:connection_test/checking_connection_screen.dart';
import 'package:connection_test/connection_service.dart';
import 'package:connection_test/no_connection_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  /// A custom service can be supplied to keep widget tests deterministic.
  const MyApp({super.key, this.connectionService});

  final ConnectionService? connectionService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Prevents a false offline screen while the first check is still running.
  ConnectionStatus _status = ConnectionStatus.checking;
  late final ConnectionService _connectionService;
  StreamSubscription<ConnectionStatus>? _subscription;

  @override
  void initState() {
    super.initState();
    _connectionService = widget.connectionService ?? ConnectionService();
    unawaited(_startMonitoring());
  }

  /// Checks the initial state before listening for future connection changes.
  Future<void> _startMonitoring() async {
    await _checkConnection();

    if (!mounted) {
      return;
    }

    _subscription = _connectionService.watch().listen(
      _updateStatus,
      onError: _handleConnectionError,
    );
  }

  /// Requests one connection decision from the shared service.
  Future<void> _checkConnection() async {
    try {
      final status = await _connectionService.checkNow();
      _updateStatus(status);
    } catch (error, stackTrace) {
      _handleConnectionError(error, stackTrace);
    }
  }

  /// Rebuilds the app only when the connection state actually changes.
  void _updateStatus(ConnectionStatus status) {
    if (!mounted || status == _status) {
      return;
    }

    setState(() => _status = status);
  }

  void _handleConnectionError(Object error, StackTrace _) {
    debugPrint('Connection check failed: $error');
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Chooses the screen that matches the current connection state.
      home: switch (_status) {
        ConnectionStatus.checking => const CheckingConnectionScreen(),
        ConnectionStatus.noNetwork => const NoConnectionScreen(
          status: ConnectionStatus.noNetwork,
        ),
        ConnectionStatus.noInternet => const NoConnectionScreen(
          status: ConnectionStatus.noInternet,
        ),
        ConnectionStatus.connected => const MyHomePage(
          title: AppStrings.homeTitle,
        ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(AppStrings.counterMessage),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: AppStrings.incrementTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
