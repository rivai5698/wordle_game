import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wordle/common/toast/toast_overlay.dart';
import 'package:wordle/const/assets_const.dart';
import 'package:wordle/service/shared_preferences_manager.dart';
import 'package:wordle/wordle/module/game/coin_bloc.dart';

import '../../generated/l10n.dart';

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
      height: heightDevice < 680 ? 250 : 300,
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                            //height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.brown.shade300),
                            ),
                            child: TextField(
                              decoration:  InputDecoration(
                                labelText: '${S.of(context).ipc}: ',
                                counterText: '',
                              ),
                              textCapitalization: TextCapitalization.characters,
                              maxLength: 6,
                              maxLines: 1,

                              onSubmitted: (str) async {
                                if(str!=''){
                                  bool? claimed =
                                  await sharedPrefs.getBool('claimed');
                                  if (claimed == null) {
                                    if (str == 'WORDLE') {
                                      sharedPrefs.setBool('claimed', true);
                                      coinStream.addCoin(1000);
                                      Future.delayed(Duration.zero, () {
                                        ToastOverlay(context).show(
                                            type: ToastType.success,
                                            msg: S.of(context).claimSuccess);
                                      });
                                    } else {
                                      Future.delayed(Duration.zero, () {
                                        ToastOverlay(context).show(
                                            type: ToastType.error,
                                            msg: S.of(context).codeInvalid);
                                      });
                                    }
                                  } else {
                                    if (str == 'WORDLE') {
                                      Future.delayed(Duration.zero, () {
                                        ToastOverlay(context).show(
                                            type: ToastType.warning,
                                            msg: S.of(context).claimedCode);
                                      });
                                    } else {
                                      Future.delayed(Duration.zero, () {
                                        ToastOverlay(context).show(
                                            type: ToastType.error,
                                            msg: S.of(context).codeInvalid);
                                      });
                                    }
                                  }
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
                coinStream.initCoin();
                Navigator.pop(context);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.yellow.shade300,
                    border: Border.all(color: Colors.brown, width: 2)),
                child: LottieBuilder.asset(closeButton),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
