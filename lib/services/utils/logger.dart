import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class DebugRiverpodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final provider = context.provider;
    Utils.logd('''

  Time: ${DateTime.timestamp()} Has name string?: ${provider.name != null}
  Provider: ${provider.name ?? provider.runtimeType},
  New Value: $newValue
  "---------------------------------------------------------------"
  ''');
  }
}
