import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugRiverpodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    Utils.logd('''

  Time: ${DateTime.timestamp()} Has name string?: ${provider.name != null}
  Provider: ${provider.name ?? provider.runtimeType},
  New Value: $newValue
  "---------------------------------------------------------------"
  ''');
  }
}
