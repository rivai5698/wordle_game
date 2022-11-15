import 'dart:async';

import 'package:wordle/service/shared_preferences_manager.dart';

class CoinBloc{
  final _coinStreamController = StreamController<int>.broadcast();
  Stream<int> get coinStream => _coinStreamController.stream;
  int? coin=0;



  initCoin() async {
    coin = await sharedPrefs.getInt('coin');
    if(await sharedPrefs.getInt('coin')==null){
    sharedPrefs.setInt('coin', 5);
    coin = await sharedPrefs.getInt('coin');
    }
    //print('coin $coin');
    _coinStreamController.add(coin!);
  }

  removeCoin(){
    if(coin!>0){
      coin = coin!-1;
    }
    sharedPrefs.setInt('coin', coin!);
    _coinStreamController.add(coin!);
  }

  addCoin(int coins){
    coin = coin!+coins;
    sharedPrefs.setInt('coin', coin!);
    _coinStreamController.add(coin!);
  }

  getCoin(){
    sharedPrefs.getInt('coin');
  }

}

var coinStream = CoinBloc();