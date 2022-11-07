import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wordle/common/toast/toast_overlay.dart';
import 'package:wordle/service/shared_preferences_manager.dart';
import 'package:wordle/wordle/module/game/coin_bloc.dart';

class CoinDialog {
  final BuildContext context;
  final int coins;
  CoinDialog(this.context, this.coins);
  void showDialog() {
    showGeneralDialog(
        barrierDismissible: false,
        barrierColor: Colors.grey.withOpacity(0.2),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        context: context,
        pageBuilder: (_, __, ___) {
          return Container(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: _myDialog(),
              ),
            ),
          );
        });
  }

  Widget _myDialog() {
    //var stream = AudioService();
    double heightDevice = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: heightDevice < 680 ? 400 : 450,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.brown.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            child: SizedBox(
              //height: 350,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'COINS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(color: Colors.yellow.shade200),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder<int>(
                                  stream: coinStream.coinStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        '${snapshot.data}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      );
                                    }
                                    return Text(
                                      coins.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    );
                                  }),
                              const Icon(
                                Icons.currency_bitcoin,
                                size: 18,
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            height: 150,
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Input Code: ',
                              ),
                              textCapitalization: TextCapitalization.characters,
                              onSubmitted: (str) async {
                                bool? claimed = await sharedPrefs.getBool('claimed');
                                if(claimed == null){
                                  if (str == 'WORDLE') {
                                    sharedPrefs.setBool('claimed', true);
                                    coinStream.addCoin(1000);
                                    Future.delayed(Duration.zero,(){
                                      ToastOverlay(context).show(
                                          type: ToastType.success,
                                          msg: 'You have claimed 1000 coins');
                                    });
                                  } else {
                                    Future.delayed(Duration.zero,(){
                                      ToastOverlay(context).show(
                                          type: ToastType.success,
                                          msg: 'Code is invalid');
                                    });
                                  }
                                }else{
                                  Future.delayed(Duration.zero,(){
                                    ToastOverlay(context).show(
                                        type: ToastType.warning,
                                        msg: 'You have claimed this code');
                                  });
                                }

                              },
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.yellow.shade300,
                    border: Border.all(color: Colors.brown, width: 2)),
                child: LottieBuilder.asset('assets/closebutton.json'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
