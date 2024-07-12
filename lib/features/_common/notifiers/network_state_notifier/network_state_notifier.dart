import 'dart:async';

import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_state_notifier.g.dart';

@riverpod

/// Watches network state
class NetworkStateNotifier extends _$NetworkStateNotifier {
  StreamSubscription<bool>? _intersetStateSubscription;
  @override
  Future<NetworkState> build() async {
    _watchNetWorkState();
    return NetworkState.connected;
  }

  /// Listen to internet state
  void _watchNetWorkState() {
    _intersetStateSubscription = InternetConnectivity()
        .observeInternetConnection
        .listen((bool hasInternetAccess) {
      final NetworkState? networkState = state.value;

      // When previous state is disconnected and how internet is avaliable
      if (networkState == NetworkState.disConnected && hasInternetAccess) {
        state = const AsyncValue<NetworkState>.data(NetworkState.connected);
        return;
      }

      // When previous state is connected and how internet is not avaliable
      if (networkState == NetworkState.connected && !hasInternetAccess) {
        state = const AsyncValue<NetworkState>.data(NetworkState.disConnected);
        return;
      }
    });
  }

  /// Referesh network state
  Future<void> refereshNetWorkState() async {
    state = const AsyncValue<NetworkState>.loading();

    final bool hasInternetAccess =
        await InternetConnectivity().hasInternetConnection;

    // simulate fake process
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    // When previous state is disconnected and how internet is avaliable
    if (hasInternetAccess) {
      state = const AsyncValue<NetworkState>.data(NetworkState.connected);
    } else {
      state = const AsyncValue<NetworkState>.data(NetworkState.disConnected);
    }
  }

  /// Close  network watcher stream
  Future<void> dispose() async {
    await _intersetStateSubscription?.cancel();
  }
}

/// Identifies current network state
enum NetworkState {
  /// When internet is avaliable
  connected,

  /// When internet is not
  disConnected,
}
