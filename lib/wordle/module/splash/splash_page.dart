import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wordle/const/assets_const.dart';
import 'package:wordle/service/audio_service.dart';
import '../../../common/toast/toast_overlay.dart';
import '../../../generated/l10n.dart';
import '../../../service/app_state.dart';
import '../../../service/check_internet_connection.dart';
import '../../../service/shared_preferences_manager.dart';
import '../login/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    initConnect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppState().isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: LottieBuilder.asset(
          loading,
          width: MediaQuery.of(context).size.width - 100,
        ),
      ),
    );
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  Future<void> initConnect() async {
    if (await checkNetwork()) {
      String id = idGenerator();
      await sharedPrefs.init();
      String? a = await sharedPrefs.getString('player');
      print('$a');

      if (await sharedPrefs.getString('player') == null) {
        sharedPrefs.setString('player', id);
        a = await sharedPrefs.getString('player');
      }

      bool? audioCheck = await sharedPrefs.getBool('audio');
      if (audioCheck == null) {
        sharedPrefs.setBool('audio', true);
      }

      bool? isPlaying = await sharedPrefs.getBool('isPlayed');
      if (isPlaying == null) {
        audioStreamService.init();
      } else {
        if (isPlaying == true) {
          audioStreamService.init();
        } else {
          audioStreamService.pauseAudio();
        }
      }

      await Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginPage(
              player: a!,
              isPlaying: isPlaying ?? true,
            ),
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
          (route) => false,
        );
      });

      //initData();
    } else {
      await Future.delayed(const Duration(seconds: 3), () {
        ToastOverlay(context)
            .show(type: ToastType.warning, msg: S.of(context).errorInternet);
      });
    }
  }
}
