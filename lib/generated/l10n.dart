// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `EASY`
  String get easy {
    return Intl.message(
      'EASY',
      name: 'easy',
      desc: '',
      args: [],
    );
  }

  /// `CASUAL`
  String get casual {
    return Intl.message(
      'CASUAL',
      name: 'casual',
      desc: '',
      args: [],
    );
  }

  /// `HARD`
  String get hard {
    return Intl.message(
      'HARD',
      name: 'hard',
      desc: '',
      args: [],
    );
  }

  /// `Collection`
  String get collection {
    return Intl.message(
      'Collection',
      name: 'collection',
      desc: '',
      args: [],
    );
  }

  /// `You have collected`
  String get col_word {
    return Intl.message(
      'You have collected',
      name: 'col_word',
      desc: '',
      args: [],
    );
  }

  /// `words`
  String get word {
    return Intl.message(
      'words',
      name: 'word',
      desc: '',
      args: [],
    );
  }

  /// `SELECT THE LEVEL`
  String get sel {
    return Intl.message(
      'SELECT THE LEVEL',
      name: 'sel',
      desc: '',
      args: [],
    );
  }

  /// `SETTINGS`
  String get setting {
    return Intl.message(
      'SETTINGS',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `HOW TO PLAY`
  String get htp {
    return Intl.message(
      'HOW TO PLAY',
      name: 'htp',
      desc: '',
      args: [],
    );
  }

  /// `HINT`
  String get hint {
    return Intl.message(
      'HINT',
      name: 'hint',
      desc: '',
      args: [],
    );
  }

  /// `Input Code:`
  String get ipc {
    return Intl.message(
      'Input Code:',
      name: 'ipc',
      desc: '',
      args: [],
    );
  }

  /// `You have claimed 1000 coins`
  String get claimSuccess {
    return Intl.message(
      'You have claimed 1000 coins',
      name: 'claimSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Code is invalid`
  String get codeInvalid {
    return Intl.message(
      'Code is invalid',
      name: 'codeInvalid',
      desc: '',
      args: [],
    );
  }

  /// `You have claimed this code`
  String get claimedCode {
    return Intl.message(
      'You have claimed this code',
      name: 'claimedCode',
      desc: '',
      args: [],
    );
  }

  /// `You\'re run out of coins`
  String get runOutCoins {
    return Intl.message(
      'You\\\'re run out of coins',
      name: 'runOutCoins',
      desc: '',
      args: [],
    );
  }

  /// `Not in word list`
  String get wordInvalid {
    return Intl.message(
      'Not in word list',
      name: 'wordInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Please connect internet`
  String get errorInternet {
    return Intl.message(
      'Please connect internet',
      name: 'errorInternet',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations`
  String get win {
    return Intl.message(
      'Congratulations',
      name: 'win',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations, you won`
  String get congratulations {
    return Intl.message(
      'Congratulations, you won',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `The answer is`
  String get theAnswer {
    return Intl.message(
      'The answer is',
      name: 'theAnswer',
      desc: '',
      args: [],
    );
  }

  /// `better the next time!`
  String get betterNextTime {
    return Intl.message(
      'better the next time!',
      name: 'betterNextTime',
      desc: '',
      args: [],
    );
  }

  /// `You\'re failed`
  String get failed {
    return Intl.message(
      'You\\\'re failed',
      name: 'failed',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `New Game`
  String get newGame {
    return Intl.message(
      'New Game',
      name: 'newGame',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
