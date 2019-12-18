import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/session/associate_account_manager.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'user_information_page.dart';
import 'common_page.dart';

import 'dart:async';

const int MY_FAMILY = 1;
const int HOST_ACCOUNT = 2;

class AssociateAccountPage extends StatefulWidget {
  final String homeCenterUuid;
  final int type;

  AssociateAccountPage({
    @required this.type,
    @required this.homeCenterUuid,
  });

  State<StatefulWidget> createState() => _AssociateAccountState();
}

class _AssociateAccountState extends State<AssociateAccountPage> {
  static const String className = 'AssociateAccountPage';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  final List<_UiGroup> _groups = List();
  List<_UiGroup> get groups {
    _groups.sort((a, b) {
      return a.homeCenterUuid.compareTo(b.homeCenterUuid);
    });
    return _groups;
  }

  StreamSubscription subscription;

  void initState() {
    super.initState();

    _resetData();
    start();
  }

  void _resetData() {
    print("------------------------------associate_account_page.dart");
    final String methodName = 'resetData';
    _groups.clear();
    if (widget.homeCenterUuid == null || widget.homeCenterUuid == '') {
      final Map<String, Map<String, Account>> accountsMap =
          AssociateAccountManager().cacheMap;
      for (var uuid in accountsMap.keys) {
        final HomeCenter homeCenter = HomeCenterManager().getHomeCenter(uuid);
        if (homeCenter == null) continue;
        final _UiGroup group = _UiGroup(homeCenter);
        for (var account in accountsMap[uuid].values) {
          group.add(_FamilyUiEntity(account.username, account.nickname));
        }
        _groups.add(group);
      }
      setState(() {});
    } else {
      final HomeCenter homeCenter =
          HomeCenterManager().getHomeCenter(widget.homeCenterUuid);
      if (homeCenter == null) return;
      final _UiGroup group = _UiGroup(homeCenter);
      final List<Account> accounts = AssociateAccountManager()
          .associateAccountOfHomeCenter(widget.homeCenterUuid);
      for (var account in accounts) {
        group.add(_FamilyUiEntity(account.username, account.nickname));
      }
      _groups.add(group);
      setState(() {});
    }
  }

  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => event is UserAssociationEvent)
        .listen((event) {
      _resetData();
    });
  }

  int get _itemCount {
    var size = 0;
    for (var group in _groups) {
      size += group.size;
    }
    return size;
  }

  _UiEntity _getUiEntity(int index) {
    int step = 0;
    for (var group in groups) {
      if (index >= step && index < step + group.size) {
        return group.get(index - step);
      } else {
        step += group.size;
      }
    }
    return null;
  }

  _UiGroup findGroup(_UiEntity uiEntity) {
    for (_UiGroup group in _groups) {
      if (group.contains(uiEntity)) {
        return group;
      }
    }
    return null;
  }

  String get title {
    switch (widget.type) {
      case MY_FAMILY:
        return DefinedLocalizations.of(context).myFamily;
      case HOST_ACCOUNT:
        return DefinedLocalizations.of(context).associatedAccount;
      default:
        return '';
    }
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: title,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(),
      child: ListView.builder(
          padding: EdgeInsets.only(),
          itemCount: _itemCount,
          itemBuilder: (BuildContext context, int index) {
            final _UiEntity uiEntity = _getUiEntity(index);
            if (uiEntity is _GroupUiEntity) {
              return _buildGroup(context, uiEntity);
            } else if (uiEntity is _FamilyUiEntity) {
              return _buildItem(context, uiEntity);
            }
            return Text("");
          }),
    );
  }

  Widget _buildGroup(BuildContext context, _GroupUiEntity groupUiEntity) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0, bottom: 5.0, top: 15.0),
      child: Text(
        groupUiEntity.homeCenter.getName(),
        style: TextStyle(
          inherit: false,
          fontSize: 14.0,
          color: const Color(0xFFD4D4D4),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, _FamilyUiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 80.0,
        padding: EdgeInsets.only(top: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 13.0),
            ),
            Divider(
              height: 2.0,
              color: const Color(0x33101B25),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 17.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 13.0),
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('images/avatar_default.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                ),
                Text(
                  uiEntity.nickname == null ? '???' : uiEntity.nickname,
                  style: TextStyle(
                    inherit: false,
                    color: const Color(0xBA2D3B46),
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        final _UiGroup group = findGroup(uiEntity);
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (BuildContext context) {
              return UserInformationPage(
                username: uiEntity._username,
                nickname: uiEntity._nickname,
                homeCenterUuid: group == null ? '' : group.homeCenterUuid,
                homeCenterName: group == null ? '' : group.homeCenterName,
              );
            },
            settings: RouteSettings(
              name: '/UserInformation',
            ),
          ),
        );
      },
    );
  }
}

class _UiGroup {
  final List<_UiEntity> _uiEntities = List();

  _UiGroup(HomeCenter homeCenter) {
    _uiEntities.add(_GroupUiEntity(homeCenter));
  }

  String get homeCenterUuid {
    final _GroupUiEntity groupUiEntity = _uiEntities[0] as _GroupUiEntity;
    return groupUiEntity.homeCenter.uuid;
  }

  String get homeCenterName {
    final _GroupUiEntity groupUiEntity = _uiEntities[0] as _GroupUiEntity;
    return groupUiEntity.homeCenter.getName();
  }

  void add(_FamilyUiEntity familyUiEntity) {
    _uiEntities.add(familyUiEntity);
  }

  bool contains(_UiEntity uiEntity) => _uiEntities.contains(uiEntity);

  _UiEntity get(int index) => _uiEntities[index];

  int get size => _uiEntities.length >= 2 ? _uiEntities.length : 0;
}

abstract class _UiEntity {}

class _GroupUiEntity extends _UiEntity {
  final HomeCenter _homeCenter;
  HomeCenter get homeCenter => _homeCenter;

  _GroupUiEntity(this._homeCenter);
}

class _FamilyUiEntity extends _UiEntity {
  final String _username;
  String get username => _username;

  final String _nickname;
  String get nickname => _nickname;

  _FamilyUiEntity(this._username, this._nickname);
}
