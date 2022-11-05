import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ToastLoadingOverlay {
  final BuildContext context;
  OverlayEntry? entry;
  ToastLoadingOverlay(this.context);

  void show() {
    if (entry != null) {
      entry!.remove();
      entry = null;
    }
    entry = OverlayEntry(builder: (BuildContext context) {
      return Scaffold(
        body: Container(
          color: Colors.white.withOpacity(0.2),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(
                  'Loading',
                  textStyle: const TextStyle(
                      fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
                ScaleAnimatedText(
                  'Loading',
                  textStyle:
                      const TextStyle(fontSize: 70.0, fontFamily: 'Canterbury'),
                ),
              ],
            ),
          ),
        ),
      );
    });
    Overlay.of(context).insert(entry!);
  }

  void hide() {
    if (entry != null) {
      entry!.remove();
      entry = null;
    }
  }
}
