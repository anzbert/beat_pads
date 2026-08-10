import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class DebugRiverpodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    Utils.logd('''

  Time: ${DateTime.timestamp()} Has name string?: ${context.provider.name != null}
  Provider: ${context.provider.name ?? context.provider.runtimeType},
  New Value: $newValue
  "---------------------------------------------------------------"
  ''');
  }
}
