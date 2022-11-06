import 'dart:io';

import 'package:flutter/foundation.dart';

Future<bool> checkNetwork() async {
  if(!kIsWeb){
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }
  return true;

}
