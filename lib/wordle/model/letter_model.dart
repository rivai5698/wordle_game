import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wordle/const/const_color.dart';
import 'package:wordle/service/app_state.dart';

class Letter extends Equatable {
  final String val;
  final LetterStatus status;
  const Letter({
    required this.val,
    this.status = LetterStatus.init,
  });

  factory Letter.empty() => const Letter(val: '');

  Color get backGroundColor {
    switch (status) {
      case LetterStatus.init:
        return Colors.transparent;
      case LetterStatus.correct:
        return correctColor.withOpacity(0.8);
      case LetterStatus.inWord:
        return inWordColor.withOpacity(0.8);
      case LetterStatus.notInWord:
        return notInWordColor.withOpacity(0.8);
    }
  }

  Color get borderColor {
    switch (status) {
      case LetterStatus.init:
        return Colors.white;
      default:
        return Colors.transparent;
    }
  }

  Letter copyWith({
    String? val,
    LetterStatus? status,
  }) {
    return Letter(val: val ?? this.val, status: status ?? this.status);
  }

  @override
  List<Object?> get props => [val, status];
}

enum LetterStatus { init, correct, inWord, notInWord}
