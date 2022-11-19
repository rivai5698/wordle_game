import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/service/app_state.dart';
import 'package:wordle/wordle/model/letter_model.dart';

class BoardTitle extends StatelessWidget {
  final Letter letter;
  final double height;
  final double width;
  const BoardTitle({Key? key, required this.letter, required this.height, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (_,state,__){
        return Container(
          margin: const EdgeInsets.all(4),
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: letter.backGroundColor,
            border: Border.all(color: state.isDarkMode ? Colors.white : Colors.black),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            letter.val,
            style:  TextStyle(
              color: state.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        );
      },
    );
  }
}
