import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordle/generated/l10n.dart';
import 'package:wordle/service/app_state.dart';
import 'package:wordle/service/shared_preferences_manager.dart';
import 'package:wordle/wordle/module/splash/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await sharedPrefs.init();
  AppState();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: Consumer<AppState>(
        builder: (_, state, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WORDLE',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: Locale(state.languageCode),
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
