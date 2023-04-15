import 'package:beat_pads/services/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tests', () {
    test('Print ASCII codes:', () {
      for (var i = 0x00; i <= 0xFF; i++) {
        Utils.logd(
          'Hex: ${i.toRadixString(16).toUpperCase()} / Dec: $i --->  ${String.fromCharCode(i)}',
        );
      }
      expect(true, true);
    });
  });
}
