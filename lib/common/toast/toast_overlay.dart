import 'package:flutter/material.dart';

class ToastOverlay {
  final BuildContext context;
  OverlayEntry? overlayEntry;
  ToastOverlay(this.context);

  void show(
      {ToastType type = ToastType.error, double cnt = 0, String msg = ''}) {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        // width: ,
        // height: ,
        top: 60 + cnt,
        left: 32,
        right: 32,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: type == ToastType.success
                  ? Colors.green
                  : type == ToastType.error
                      ? Colors.red
                      : type == ToastType.info
                          ? Colors.white
                          : type == ToastType.warning
                              ? Colors.orange
                              : Colors.red,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 2.0,
                color: type == ToastType.success
                    ? Colors.green
                    : type == ToastType.error
                        ? Colors.red
                        : type == ToastType.info
                            ? Colors.white
                            : type == ToastType.warning
                                ? Colors.orange
                                : Colors.red,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  type == ToastType.error
                      ? Icons.cancel
                      : type == ToastType.warning
                          ? Icons.error
                          : type == ToastType.info
                              ? Icons.info
                              : type == ToastType.success
                                  ? Icons.check_circle
                                  : Icons.cancel,
                  color: Colors.white
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    msg,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:  Colors.white,
                    ),
                  ),
                ),
                // Container(
                //   height: 36,
                //   width: 1,
                //   color: Colors.black45,
                // ),
                IconButton(
                  onPressed: () {
                    if (overlayEntry != null) {
                      overlayEntry!.remove();
                    }
                    overlayEntry = null;
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    if (overlayEntry != null) {
      Overlay.of(context).insert(overlayEntry!);
      Future.delayed(const Duration(seconds: 5), () {
        if (overlayEntry != null) {
          overlayEntry!.remove();
          overlayEntry = null;
        }
      });
    }
  }
}

enum ToastType {
  success,
  error,
  warning,
  info,
}
