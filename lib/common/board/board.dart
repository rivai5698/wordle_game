import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:wordle/common/board/board_title.dart';
import 'package:wordle/wordle/model/letter_model.dart';
import '../../wordle/model/word_model.dart';

class MyBoard extends StatelessWidget {
  final List<Word> board;
  final List<List<GlobalKey<FlipCardState>>> flipCardKey;
  final double height;
  final double width;
  const MyBoard(
      {Key? key,
      required this.board,
      required this.height,
      required this.width,
      required this.flipCardKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: board
            .asMap()
            .map((i, word) => MapEntry(
                  i,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: word.letters
                        .asMap()
                        .map(
                          (j, letter) => MapEntry(
                            j,
                            FlipCard(
                              key: flipCardKey[i][j],
                              flipOnTouch: false,
                              direction: FlipDirection.HORIZONTAL,
                              front: BoardTitle(
                                height: height,
                                width: width,
                                letter: Letter(
                                  val: letter.val,
                                  status: LetterStatus.init,
                                ),
                              ),
                              back: BoardTitle(
                                  height: height, width: width, letter: letter),
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }
}
