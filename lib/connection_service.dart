import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Represents the connection states that the UI can display.
///
/// [noNetwork] and [noInternet] are separate so the app can explain whether
/// the device lacks a network or the current network lacks internet access.
enum ConnectionStatus { checking, noNetwork, noInternet, connected }

/// Makes all connection decisions in one place for the rest of the app.
class ConnectionService {
  ConnectionService({
    Connectivity? connectivity,
    InternetConnection? internetConnection,
  }) : _connectivity = connectivity ?? Connectivity(),
       _internetConnection = internetConnection ?? InternetConnection();

  final Connectivity _connectivity;
  final InternetConnection _internetConnection;

  /// Checks the current connection once.
  ///
  /// It first checks for a network, then checks whether that network provides
  /// real internet access.
  Future<ConnectionStatus> checkNow() async {
    // connectivity_plus detects network availability, not internet access.
    final results = await _connectivity.checkConnectivity();
    final hasNetwork = results.any(
      (result) => result != ConnectivityResult.none,
    );

    if (!hasNetwork) {
      return ConnectionStatus.noNetwork;
    }

    // A network exists, so verify that it can reach the internet.
    final hasInternet = await _internetConnection.hasInternetAccess;
    return hasInternet
        ? ConnectionStatus.connected
        : ConnectionStatus.noInternet;
  }

  /// Watches network and internet changes as one stream for the UI.
  ///
  /// Every event runs the same two-stage decision used by [checkNow].
  Stream<ConnectionStatus> watch() {
    late final StreamController<void> changes;
    StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
    StreamSubscription<InternetStatus>? internetSubscription;

    changes = StreamController<void>(
      onListen: () {
        connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (_) => changes.add(null),
          onError: changes.addError,
        );
        internetSubscription = _internetConnection.onStatusChange.listen(
          (_) => changes.add(null),
          onError: changes.addError,
        );
      },
      onCancel: () async {
        await connectivitySubscription?.cancel();
        await internetSubscription?.cancel();
      },
    );

    return changes.stream.asyncMap((_) => checkNow()).distinct();
  }
}
