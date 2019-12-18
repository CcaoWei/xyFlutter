import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/session/association_request_manager.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/firmware/firmware_manager.dart';
import 'package:xlive/session/session.dart';
import 'package:xlive/session/login_manager.dart';

import 'dart:async';

import 'add_home_center_page.dart';
import 'home_center_detail_page.dart';
import 'association_detail_page.dart';

class HomeCenterManagerPage extends StatefulWidget {
  State<StatefulWidget> createState() => _HomeCenterManagerState();
}

class _HomeCenterManagerState extends State<HomeCenterManagerPage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'HomeCenterManagerPage');

  final List<_Group> _groups = List();
  _HomeCenterGroup _homeCenterGroup; // = _HomeCenterGroup();
  _MessageGroup _messageGroup; // = _MessageGroup();

  StreamSubscription _subscription;

  void initState() {
    super.initState();

    // if (LoginManager().defaultHomeCenterUuid != '') {
    //   HomeCenterManager().defaultHomeCenterUuid = LoginManager().defaultHomeCenterUuid;
    // }

    _resetData();

    _start();
  }

  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _resetData() {
    print("------------------------------home_center_manager_page.dart");
    final String methodName = 'resetData';
    if (_homeCenterGroup != null) {
      _homeCenterGroup.clear();
    }
    if (_messageGroup != null) {
      _messageGroup.clear();
    }

    _homeCenterGroup = _HomeCenterGroup();
    _messageGroup = _MessageGroup();

    final Map<String, HomeCenter> homeCenters = HomeCenterManager().homeCenters;
    final String defaultHomeCenterUuid =
        HomeCenterManager().defaultHomeCenterUuid;
    for (var homeCenter in homeCenters.values) {
      if (homeCenter.state == ASSOCIATION_TYPE_NONE ||
          homeCenter.state == ASSOCIATION_TYPE_FROM) continue;
      _homeCenterGroup.add(
          homeCenter, (homeCenter.uuid == defaultHomeCenterUuid));
    }

    final List<HomeCenterNotification> notifications =
        AssociationRequestManager().associations;
    log.d('notifications size: ${notifications.length}', methodName);
    for (var notification in notifications) {
      _messageGroup.add(notification);
    }

    _groups.add(_homeCenterGroup);
    _groups.add(_messageGroup);
    setState(() {});
  }

  void _start() {
    final String methodName = 'start';
    _subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterNotification ||
            event is HomeCenterEvent ||
            event is DeviceAssociationNotificationEvent ||
            event is AssociationMessage)
        .listen((event) {
      if (event is HomeCenterNotification) {
        _resetData();
      } else if (event is HomeCenterEvent) {
        if (event.type == HOME_CENTER_CHANGED) {
          setState(() {});
        }
      } else if (event is DeviceAssociationNotificationEvent) {
        _resetData();
      } else if (event is AssociationMessage) {
        _resetData();
      }
    });
  }

  int getNumbersOfDevicesCanUpgrade(String homeCenterUuid) =>
      FirmwareManager().numberOfDevicesCanUpgrade(homeCenterUuid);

  bool get hasHomeCenterCanBeAdded {
    final List<HomeCenter> map = HomeCenterManager().localFoundHomeCenters;
    for (HomeCenter homeCenter in map) {
      if (homeCenter.state == ASSOCIATION_TYPE_NONE ||
          homeCenter.state == ASSOCIATION_TYPE_FROM) return true;
    }
    return false;
  }

  int _itemCount() => _messageGroup.size() + _homeCenterGroup.size();

  _UiEntity _getItem(int index) {
    int step = 0;
    if (index >= step && index < step + _homeCenterGroup.size()) {
      return _homeCenterGroup.get(index - step);
    }
    step += _homeCenterGroup.size();
    if (index >= step && index < step + _messageGroup.size()) {
      return _messageGroup.get(index - step);
    }
    return null;
  }

  String getHomeCenterStatusIconString(_HomeCenterUiEntity uiEntity) {
    if (uiEntity.homeCenter.state != ASSOCIATION_TYPE_BOTH)
      return 'images/home_center_icon_waiting.png';
    if (!uiEntity.homeCenter.online)
      return 'images/home_center_icon_offline.png';
    else
      return 'images/home_center_icon_online.png';
  }

  String getHomeCenterStatusString(
      _HomeCenterUiEntity uiEntity, BuildContext ctx) {
    if (uiEntity.homeCenter.state != ASSOCIATION_TYPE_BOTH)
      return DefinedLocalizations.of(ctx).toBeAuthorized;
    if (uiEntity.homeCenter.online)
      return DefinedLocalizations.of(ctx).online;
    else
      return DefinedLocalizations.of(ctx).offline;
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ListView.builder(
        padding: EdgeInsets.only(),
        itemCount: _itemCount(),
        itemBuilder: (BuildContext context, int index) {
          final _UiEntity uiEntity = _getItem(index);
          if (uiEntity is _GroupUiEntity) {
            return _buildGroup(context, uiEntity);
          }
          if (uiEntity is _HomeCenterUiEntity) {
            if (uiEntity.homeCenter == null) {
              return _buildAddHomeCenter(context);
            }
            return _buildHomeCenter(context, uiEntity);
          }
          return _buildMessage(context, uiEntity);
        },
      ),
    );
  }

  Widget _buildGroup(BuildContext context, _GroupUiEntity groupUiEntity) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 13.0),
      child: Text(
        groupUiEntity.getGroupName(context),
        style: TextStyle(
          color: const Color(0xFF9B9B9B),
          fontSize: 14.0,
          inherit: false,
        ),
      ),
    );
  }

  Widget _buildHomeCenter(
      BuildContext context, _HomeCenterUiEntity homeCenterUiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(left: 13.0, right: 0.0, top: 5.0),
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
        height: 80.0,
        color: homeCenterUiEntity.isDefault
            ? const Color(0xFF7CD0FE)
            : const Color(0xFFF5F5F5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Image(
                      image: AssetImage(homeCenterUiEntity.isDefault
                          ? 'images/home_center_selected.png'
                          : 'images/home_center_unselected.png'),
                      width: 33.0,
                      height: 33.0,
                    ),
                    Image.asset(
                      getHomeCenterStatusIconString(homeCenterUiEntity),
                      width: 10.0,
                      height: 10.0,
                      gaplessPlayback: true,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 15.0)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 140.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        homeCenterUiEntity.homeCenter.getName(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: homeCenterUiEntity.isDefault
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16.0,
                          inherit: false,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3.0),
                    ),
                    Text(
                      getHomeCenterStatusString(homeCenterUiEntity, context),
                      style: TextStyle(
                        color: homeCenterUiEntity.isDefault
                            ? Colors.white
                            : Colors.grey,
                        fontSize: 14.0,
                        inherit: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Offstage(
                  offstage: getNumbersOfDevicesCanUpgrade(
                          homeCenterUiEntity.homeCenter.uuid) ==
                      0,
                  child: Image(
                    image: AssetImage('images/red_point.png'),
                    width: 8.0,
                    height: 8.0,
                  ),
                ),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 39.0,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Image(
                          image: AssetImage(homeCenterUiEntity.isDefault
                              ? 'images/home_center_setting_selected.png'
                              : 'images/home_center_setting_unselected.png'),
                          width: 16.0,
                          height: 16.0,
                        ),
                      ),
                    ),
                    onTap: () {
                      //widget.close(context); //drawer
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              HomeCenterDetailPage(
                                homeCenterUuid:
                                    homeCenterUiEntity.homeCenter.uuid,
                                homeCenterName:
                                    homeCenterUiEntity.homeCenter.name,
                              ),
                          settings: RouteSettings(
                            name: '/HomeCenterDetail',
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (homeCenterUiEntity.homeCenter.state != ASSOCIATION_TYPE_BOTH)
          return;
        final String uuid = homeCenterUiEntity.homeCenter.uuid;
        _homeCenterGroup.setDefaultHomeCenter(uuid);
        HomeCenterManager().defaultHomeCenterUuid = uuid;
        setState(() {});
        //widget.close(context);
        Navigator.of(context).pop();
        LoginManager().storeDefaultHomeCenterUuid(uuid);
      },
    );
  }

  Widget _buildAddHomeCenter(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0),
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
        color: Color(0xFFF5F5F5),
        height: 80.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: AssetImage('images/add_new_home_center.png'),
                  width: 33.0,
                  height: 33.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                ),
                Text(
                  DefinedLocalizations.of(context).addHomeCenter,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    inherit: false,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Offstage(
                  offstage: !hasHomeCenterCanBeAdded,
                  child: Image(
                    image: AssetImage('images/red_point.png'),
                    width: 8.0,
                    height: 8.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                Container(
                  width: 16.0,
                  height: 16.0,
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('images/icon_next.png'),
                    width: 7.0,
                    height: 11.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        //widget.close(context); //close drawer
        Navigator.of(context).pop();
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AddHomeCenterPage(),
            settings: RouteSettings(
              name: '/AddHomeCenter',
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessage(BuildContext context, _MessageUiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 50.0,
        color: const Color(0x4CEEEEEE),
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0),
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 28.0,
              height: 26.0,
              image: AssetImage(uiEntity.imageUrl),
            ),
            Container(
              width: 180.0,
              child: Text(
                uiEntity.getContent(context),
                maxLines: 2,
                style: TextStyle(
                  inherit: false,
                  fontSize: 12.0,
                  color: const Color(0xFF2D3B46),
                ),
              ),
            ),
            Image(
              width: 7.0,
              height: 11.0,
              image: AssetImage('images/icon_next.png'),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) =>
                AssociationDetailPage(notification: uiEntity.notification),
            settings: RouteSettings(
              name: '/AssociationDetail',
            ),
          ),
        );
      },
    );
  }
}

abstract class _Group {
  int size();
  _UiEntity get(int index);
  void clear();
}

class _HomeCenterGroup extends _Group {
  final List<_UiEntity> _uiEntities = List();

  List<_UiEntity> get uiEntities {
    _uiEntities.sort((a, b) {
      if (a is _GroupUiEntity) return -1;
      if (b is _GroupUiEntity) return 1;
      final _HomeCenterUiEntity aa = a as _HomeCenterUiEntity;
      final _HomeCenterUiEntity bb = b as _HomeCenterUiEntity;
      if (aa.isDefault) return -1;
      if (bb.isDefault) return 1;
      if (aa.homeCenter == null) return 1;
      if (bb.homeCenter == null) return -1;
      if (aa.homeCenter.online && !bb.homeCenter.online) return -1;
      if (!aa.homeCenter.online && bb.homeCenter.online) return 1;
      return aa.homeCenter.uuid.compareTo(bb.homeCenter.uuid);
    });
    return _uiEntities;
  }

  _HomeCenterGroup() {
    _uiEntities.add(_GroupUiEntity(_GroupUiEntity.GROUP_HOME_CENTER));
    _uiEntities.add(_HomeCenterUiEntity(null));
  }

  void add(HomeCenter homeCenter, bool isDefault) {
    final _HomeCenterUiEntity homeCenterUiEntity =
        _HomeCenterUiEntity(homeCenter);
    homeCenterUiEntity.isDefault = isDefault;
    _uiEntities.add(homeCenterUiEntity);
  }

  int size() => _uiEntities.length;

  _UiEntity get(index) => uiEntities[index];

  void clear() {
    _uiEntities.clear();
  }

  void setDefaultHomeCenter(String uuid) {
    for (var uiEntity in _uiEntities) {
      if (!(uiEntity is _HomeCenterUiEntity)) continue;
      var homeCenterUiEntity = uiEntity as _HomeCenterUiEntity;
      if (homeCenterUiEntity.homeCenter == null) continue;
      if (homeCenterUiEntity.homeCenter.uuid == uuid) {
        homeCenterUiEntity.isDefault = true;
      } else {
        homeCenterUiEntity.isDefault = false;
      }
    }
  }
}

class _MessageGroup extends _Group {
  final List<_UiEntity> _uiEntities = List();

  _MessageGroup() {
    _uiEntities.add(_GroupUiEntity(_GroupUiEntity.GROUP_MESSAGE));
  }

  void add(HomeCenterNotification notification) {
    _uiEntities.add(_MessageUiEntity(notification));
  }

  int size() => _uiEntities.length < 2 ? 0 : _uiEntities.length;

  _UiEntity get(int index) => _uiEntities[index];

  void clear() {
    _uiEntities.clear();
  }
}

abstract class _UiEntity {}

class _GroupUiEntity extends _UiEntity {
  static const int GROUP_HOME_CENTER = 0;
  static const int GROUP_MESSAGE = 1;

  final int _groupType;

  _GroupUiEntity(this._groupType);

  String getGroupName(BuildContext context) {
    if (_groupType == GROUP_HOME_CENTER) {
      return DefinedLocalizations.of(context).homeCenter;
    } else {
      return DefinedLocalizations.of(context).homeCenterMessage;
    }
  }
}

class _HomeCenterUiEntity extends _UiEntity {
  final HomeCenter homeCenter;

  _HomeCenterUiEntity(this.homeCenter);

  bool isDefault = false;
}

class _MessageUiEntity extends _UiEntity {
  final HomeCenterNotification notification;

  _MessageUiEntity(this.notification);

  String get imageUrl {
    if (notification.type == HomeCenterNotification.REQUEST) {
      return 'images/icon_request.png';
    } else {
      return 'images/icon_invitation.png';
    }
  }

  String getContent(BuildContext context) {
    if (notification.type == HomeCenterNotification.REQUEST) {
      return notification.message.byDisplayName +
          ' ' +
          DefinedLocalizations.of(context).requestToJoinDes +
          ' ' +
          notification.message.deviceName;
    } else {
      return notification.message.byDisplayName +
          ' ' +
          DefinedLocalizations.of(context).inviteToJoinDes +
          ' ' +
          notification.message.deviceName;
    }
  }
}
