import 'dart:async';

import '../../../service/shared_preferences_manager.dart';

class CollectionBloc{
  final _collectionStreamController = StreamController<List<String>>.broadcast();
  Stream<List<String>> get collectionStream  => _collectionStreamController.stream;
  List<String> collection = [];

  CollectionBloc(){
    //init();
  }

  Future init() async {
    collection.clear();
    await sharedPrefs.init();
    List<String>? a = await sharedPrefs.getStringList('collections');
    print('CollectionBloc.init $a');
    Future.delayed(Duration.zero,(){
      if(a!=null){
        collection.addAll(a);
        print('CollectionBloc.init $collection');
        _collectionStreamController.add(collection);
      }else{
        collection.addAll([]);
        _collectionStreamController.add(collection);
      }
    });

  }

  addString(List<String> list){
    collection.addAll(list);
    _collectionStreamController.add(collection);
  }

}

var collectionService = CollectionBloc();