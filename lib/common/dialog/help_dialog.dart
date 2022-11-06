import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HelpDialog {
  final BuildContext context;
  HelpDialog(this.context);
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
                        'HOW TO PLAY',
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
                    child: Image.asset(
                      'assets/helpimg.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
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
