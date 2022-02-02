import 'package:flutter/services.dart';

void useFullScreen() {
  // to hide only bottom bar:
  SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

// to hide only status bar:
  SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

// to hide both:
  SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: []);
}