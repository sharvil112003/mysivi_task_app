import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class IConnectivityService {
  Stream<bool> get connectionStream;
  Future<void> checkConnection();
  void dispose();
}

class ConnectivityService implements IConnectivityService {
  // Poll interval for periodic checks
  final Duration _pollInterval = const Duration(seconds: 5);

  // Internal guards & resources
  StreamSubscription<dynamic>? _connectivitySub;
  Timer? _timer;
  bool _isChecking = false;

  ConnectivityService._internal() {
    _connectivitySub = _connectivity.onConnectivityChanged.listen((_) => _checkConnection());

    _checkConnection();
   _timer = Timer.periodic(_pollInterval, (_) => _checkConnection());
  }

  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _controller.stream;

  Future<void> checkConnection() => _checkConnection();

  Future<void> _checkConnection() async {
    if (_isChecking) return;
    _isChecking = true;
    bool hasConnection = false;
    try {
      final results = await InternetAddress.lookup('example.com').timeout(const Duration(seconds: 5));
      if (results.isNotEmpty && results[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      }
    } catch (_) {
      hasConnection = false;
    } finally {
      _isChecking = false;
      _controller.add(hasConnection);
    }
  }

  void dispose() {
    _timer?.cancel();
    _connectivitySub?.cancel();
    _controller.close();
  }
}
