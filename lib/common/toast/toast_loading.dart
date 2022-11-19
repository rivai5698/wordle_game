import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/service/app_state.dart';

import '../../generated/l10n.dart';

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
        body: Consumer<AppState>(
            builder: (_,state,__){
              return Container(
                color: state.isDarkMode ? Colors.black:Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        S.of(context).loading,
                        textStyle:  TextStyle(
                            fontSize: 32.0, fontWeight: FontWeight.bold, color: state.isDarkMode ? Colors.white:Colors.black),
                      ),
                      ScaleAnimatedText(
                        S.of(context).loading,
                        textStyle:
                        TextStyle(fontSize: 70.0, fontFamily: 'Canterbury',color: state.isDarkMode ? Colors.white:Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            }
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
