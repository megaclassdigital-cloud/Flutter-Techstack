import 'opening_sound_player_stub.dart'
    if (dart.library.html) 'opening_sound_player_web.dart'
    as impl;

class OpeningSoundPlayer {
  const OpeningSoundPlayer._();

  static bool _played = false;

  static Future<void> playOnFirstOpen() async {
    await impl.playOpeningSound(allowRetryOnInteraction: true);
  }

  static Future<void> playOnceAfterLogin() async {
    if (_played) return;
    _played = true;
    await impl.playOpeningSound(allowRetryOnInteraction: true);
  }
}
