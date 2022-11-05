import 'package:flutter/material.dart';
import 'package:wordle/const/keyboard.dart';

import '../../wordle/model/letter_model.dart';

class MyKeyBoard extends StatelessWidget {
  const MyKeyBoard(
      {super.key,
      required this.height,
      required this.width,
      required this.letters,
      required this.onKeyTap,
      required this.onDelTap,
      required this.onEnterTap});
  final double height;
  final double width;
  final Set<Letter> letters;
  final Function(String) onKeyTap;
  final VoidCallback onDelTap;
  final VoidCallback onEnterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: kb
            .map(
              (kRow) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: kRow.map((letter) {
                  final letterKey = letters.firstWhere((e) => e.val == letter,
                      orElse: () => Letter.empty());
                  if (letter == 'DEL') {
                    return Expanded(
                        //child: _KeyBoardButton.delete(onTap: onDelTap));
                        child: _KeyBoardButton(
                      backgroundColor: letterKey != Letter.empty()
                          ? letterKey.backGroundColor
                          : Colors.grey,
                      height: height,
                      width: width,
                      onTap: onDelTap,
                      letter: letter,
                    ));
                  } else if (letter == 'ENTER') {
                    return Expanded(
                      child: _KeyBoardButton(
                        backgroundColor: letterKey != Letter.empty()
                            ? letterKey.backGroundColor
                            : Colors.grey,
                        height: height,
                        width: width,
                        onTap: onEnterTap,
                        letter: letter,
                      ),
                    );
                    //child: _KeyBoardButton.enter(onTap: onEnterTap));
                  }

                  // final letterKey = letters.firstWhere((e) => e.val == letter,
                  //     orElse: () => Letter.empty());

                  return _KeyBoardButton(
                      backgroundColor: letterKey != Letter.empty()
                          ? letterKey.backGroundColor
                          : Colors.grey,
                      height: height,
                      width: width,
                      onTap: () => onKeyTap(letter),
                      letter: letter);
                }).toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _KeyBoardButton extends StatelessWidget {
  final double height;
  final double width;
  final VoidCallback? onTap;
  final String letter;
  final Color backgroundColor;

  const _KeyBoardButton(
      {required this.backgroundColor,
      required this.height,
      required this.width,
      required this.onTap,
      required this.letter});

  // factory _KeyBoardButton.delete({required VoidCallback onTap}) =>
  //     _KeyBoardButton(
  //         backgroundColor: Colors.grey,
  //         height: 40,
  //         width: 56,
  //         onTap: onTap,
  //         letter: 'DEL');
  //
  // factory _KeyBoardButton.enter({required VoidCallback onTap}) =>
  //     _KeyBoardButton(
  //         backgroundColor: Colors.grey,
  //         height: 40,
  //         width: 56,
  //         onTap: onTap,
  //         letter: 'ENTER');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
