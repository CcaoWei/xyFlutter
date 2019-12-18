import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//修改源码 管理页面栈
class AppStateManager {
  static final AppStateManager _manager = AppStateManager._internal();

  AppStateManager._internal();

  factory AppStateManager() {
    return _manager;
  }

  List<Route> history;
}
