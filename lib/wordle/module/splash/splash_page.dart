import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wordle/service/audio_service.dart';
import '../../../common/toast/toast_overlay.dart';
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
    // TODO: implement initState
    initConnect();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: Center(
        child: LottieBuilder.asset(
          'assets/loading.json',
          width: MediaQuery.of(context).size.width - 100,
        ),
      ),
    );
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  Future initConnect() async {
    // var audioStream = AudioService();
    // audioStream.init();
    if(await checkNetwork()){
      //audioStream.closeStream();
      //print('connected to internet');

      String id = idGenerator();
      await sharedPrefs.init();
      String? a = await sharedPrefs.getString('player');
      print('$a');

      if(await sharedPrefs.getString('player')==null){
        sharedPrefs.setString('player', id);
        a = await sharedPrefs.getString('player');
      }

      //coinStream.addCoin(500);

      bool? audioCheck = await sharedPrefs.getBool('audio');
      if(audioCheck == null){
        sharedPrefs.setBool('audio', true);
      }

      bool? isPlaying  = await sharedPrefs.getBool('isPlayed');
      //print('_SplashPageState.initConnect $isPlaying and $audioCheck' );
      if(isPlaying == null){
        audioStreamService.init();
      }else{
        if(isPlaying==true){
          audioStreamService.init();
        }else{
          audioStreamService.pauseAudio();
        }
      }

      await Future.delayed(const Duration(seconds: 1),(){
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginPage(player: a!,isPlaying: isPlaying ?? true,audioCheck: audioCheck ?? true,

        ),
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ),(route) => false,);

      });

      //initData();
    }else{
      //await sharedPrefs.init();
      //String? phone = await sharedPrefs.getString('phone');
      //String? password = await sharedPrefs.getString('password');
      await Future.delayed(const Duration(seconds: 3), () {
        ToastOverlay(context).show(type: ToastType.warning, msg: 'Vui lòng kết nối internet');
      });
    }
  }

}
