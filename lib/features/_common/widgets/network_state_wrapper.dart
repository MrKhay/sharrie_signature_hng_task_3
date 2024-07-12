import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features.dart';

/// Wraps Parent widget widget with Network state watcher
class NetworkStateWrapper extends ConsumerStatefulWidget {
  /// Parent widgte
  final Widget child;

  /// Optional no Network widget
  final Widget? noNetworkWidget;

  ///
  const NetworkStateWrapper(
      {super.key, required this.child, this.noNetworkWidget});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NetworkStateWrapperState();
}

class _NetworkStateWrapperState extends ConsumerState<NetworkStateWrapper> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<NetworkState> state =
        ref.watch(networkStateNotifierProvider);

    return state.maybeWhen(
      data: _body,
      loading: () => progressAnimation(context),
      orElse: () => progressAnimation(context),
    );
  }

  Widget _body(NetworkState state) {
    if (state == NetworkState.connected) {
      return widget.child;
    } else {
      return Center(child: widget.noNetworkWidget ?? noNetworkWidget());
    }
  }

  Widget noNetworkWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          kNoInternetAccess,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: kGap_1),
        Text(
          kNoInternetAccessInfo,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.theme.hintColor,
          ),
        ),
        const SizedBox(height: kGap_3),
        OutlinedButton(
            onPressed: () async {
              await ref
                  .read(networkStateNotifierProvider.notifier)
                  .refereshNetWorkState();
            },
            child: const Text(kRetry))
      ],
    );
  }
}
