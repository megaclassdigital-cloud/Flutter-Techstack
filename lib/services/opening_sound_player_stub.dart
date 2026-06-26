import 'package:flutter/services.dart';

Future<void> playOpeningSound({bool allowRetryOnInteraction = false}) async {
  try {
    await SystemSound.play(SystemSoundType.click);
  } catch (_) {}
}
