import 'dart:async';

import 'package:meta/meta.dart';

class CombinedSubscriber {
  Map<String,StreamSubscription> _subscriptions;

  static CombinedSubscriber _instance = new CombinedSubscriber(); 

  factory CombinedSubscriber.instance() {
    return _instance;
  }

  CombinedSubscriber(): this._subscriptions = new Map<String,StreamSubscription>();

  void remove({@required String name}) {
    _subscriptions[name].cancel();
    _subscriptions.remove(name);
    print('current list of subscriptions' + _subscriptions.keys.toString());
  }

  void removeAll() {
    _subscriptions.forEach((name,sub) => sub.cancel());
    _subscriptions = {};
  }

  void add({@required String name, @required StreamSubscription subscription}) {
    // assert(!_subscriptions.containsKey(name));
    _subscriptions.putIfAbsent(name, () => subscription);
    print('current list of subscriptions' + _subscriptions.keys.toString());
  }

  void addAll({@required CombinedSubscriber subscriptions}) {
    _subscriptions.addEntries(subscriptions.toList());
    print('current list of subscriptions' + _subscriptions.keys.toString());
  }

  void removeWhere(bool test(String name, StreamSubscription sub)) {
    _subscriptions.removeWhere(test);
    print('current list of subscriptions' + _subscriptions.keys.toString());
  }

  StreamSubscription get({@required String name}) {
    return _subscriptions[name];
  }

  bool contains({@required String name}) {
    return _subscriptions.containsKey(name);
  }

  List<MapEntry<String,StreamSubscription>> toList() {
    return this._subscriptions.entries.toList();
  }

  
}