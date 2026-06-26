// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

const _soundAssetUrl = 'assets/harudusfx.mp3';

var _played = false;
var _retryAttached = false;

Future<void> playOpeningSound({bool allowRetryOnInteraction = false}) async {
  if (html.window.sessionStorage['techstack_opening_sound_started'] == '1') {
    _played = true;
    return;
  }
  if (_played) return;
  final audio =
      html.AudioElement(_soundAssetUrl)
        ..volume = 0.45
        ..preload = 'auto';
  try {
    await audio.play();
    _played = true;
    html.window.sessionStorage['techstack_opening_sound_started'] = '1';
  } catch (_) {
    if (!allowRetryOnInteraction || _retryAttached) return;
    _retryAttached = true;
    void retry(html.Event _) {
      html.document.removeEventListener('pointerdown', retry);
      playOpeningSound();
    }

    html.document.addEventListener('pointerdown', retry);
  }
}
