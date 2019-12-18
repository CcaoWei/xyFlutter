import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/session/associate_account_manager.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/firmware/firmware_manager.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/session/session.dart';
import 'package:xlive/session/account_manager.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'system_information_page.dart';
import 'set_name_page.dart';
import 'associate_account_page.dart';
import 'firmware_upgrade_page.dart';
import 'add_home_center_page.dart';
import 'home_page.dart';
import 'manage_room_page.dart';
import 'common_page.dart';
import 'set_upgrade_policy_page.dart';

import 'dart:async';
import 'dart:convert';

class HomeCenterDetailPage extends StatefulWidget {
  final String homeCenterUuid;
  final String homeCenterName;

  HomeCenterDetailPage({
    this.homeCenterUuid,
    this.homeCenterName,
  });

  State<StatefulWidget> createState() => _HomeCenterDetailState();
}

class _HomeCenterDetailState extends State<HomeCenterDetailPage> {
  static const String className = 'HomeCenterDetail';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  HomeCenter _homeCenter;

  final List<_UiEntity> _uiEntities = List();

  StreamSubscription _subscription;

  void initState() {
    super.initState();

    _resetData();
    _start();
  }

  void dispose() {
    print('homeCenterDetail dispose');
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _resetData() {
    print("------------------------------home_center_detail_page.dart");
    _homeCenter = HomeCenterManager().getHomeCenter(widget.homeCenterUuid);
    if (_homeCenter == null) {
      _homeCenter =
          HomeCenter(uuid: widget.homeCenterUuid, name: widget.homeCenterName);
      _homeCenter.state == ASSOCIATION_TYPE_NONE;
      _homeCenter.online = true;
      HomeCenterManager().addHomeCenter(_homeCenter);
    }
    _uiEntities.clear();
    if (_homeCenter.state == ASSOCIATION_TYPE_BOTH) {
      _uiEntities.add(_UiEntity(type: HEADER, content: ''));
      _uiEntities
          .add(_UiEntity(type: DEVICE_NAME, content: _homeCenter.getName()));
      _uiEntities.add(_UiEntity(type: DEVICE_TYPE, content: 'TERNCY-GW01'));
      _uiEntities.add(
          _UiEntity(type: SERIAL_NUMBER, content: _homeCenter.serialNumber));
      _uiEntities.add(_UiEntity(type: MANAGE_ROOMS, content: ''));
      _uiEntities.add(_UiEntity(
          type: ASSOCIATED_ACCOUNT,
          content: numberOfAssociateAccount.toString()));
      _uiEntities.add(_UiEntity(type: FIRMWARE_UPGRADE, content: ''));
      _uiEntities.add(_UiEntity(type: CHECK_NEW_VERSION, content: ''));
      _uiEntities.add(_UiEntity(type: UPGRADE_POLICY, content: ''));
      _uiEntities.add(_UiEntity(type: SYSTEM_INFORMATION, content: ''));
      _uiEntities.add(_UiEntity(type: FOOTER, content: ''));
    } else {
      _uiEntities.add(_UiEntity(type: HEADER, content: ''));
      _uiEntities.add(_UiEntity(type: ADD, content: ''));
    }
    setState(() {});
  }

  void _start() {
    final String methodName = 'start';
    _subscription = RxBus().toObservable().where((event) {
      if (event is HomeCenterCacheEvent) {
        return event.homeCenterUuid == widget.homeCenterUuid;
      } else {
        return true;
      }
    }).listen((event) {
      if (event is EntityInfoConfigureEvent) {
        if (event.uuid == widget.homeCenterUuid) {
          setState(() {});
        }
      } else if (event is HomeCenterEvent) {
        if (event.homeCenter.uuid == widget.homeCenterUuid) {
          setState(() {});
        }
      } else if (event is AssociationMessage) {
        log.d('event type: ${event.eventType}', methodName);
        if (event.eventType == REMOVE) {
          if (HomeCenterManager().numberOfAddedHomeCenter > 0) {
            _resetData();
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => AddHomeCenterPage(
                        showBackIcon: false,
                      ),
                  settings: RouteSettings(
                    name: '/AddHomeCenter',
                  ),
                ),
                (route) => false);
          }
        } else if (event.eventType == REQUEST_APPROVE) {
          if (HomeCenterManager().numberOfAddedHomeCenter == 1) {
            //TODO:
            //_resetData(_homeCenter);
            Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => HomePage(),
                  settings: RouteSettings(
                    name: '/Home',
                  ),
                ),
                (route) => false);
          } else {
            _resetData();
          }
        } else if (event.eventType == REQUEST_REJECT) {
          _resetData();
        } else if (event.eventType == CANCEL) {
          _resetData();
        }
      }
    });
  }

  void _checkNewVersion(BuildContext context) {
    final String methodName = 'checkNewVersion';
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.checkNewVersion(homeCenterUuid).listen((response) {
      if (response is CheckNewVersionResponse) {
        if (!response.success) {
          log.e('check new version failed: ${response.code}', methodName);
        }
      }
    });
  }

  void _associateHomeCenter(String action) {
    final String methodName = 'associateHomeCenter';
    final String token = LoginManager().token;
    final String username = LoginManager().username;
    final String nickname = AccountManager().nickname;
    final String deviceName =
        _homeCenter == null ? widget.homeCenterUuid : _homeCenter.getName();
    HttpProxy.associateHomeCenter(token, widget.homeCenterUuid, action,
            username, nickname, username, nickname, deviceName)
        .then((response) {
      var body = json.decode(response.body);
      final statusCode = body[API_STATUS_CODE];
      final message = body[API_MESSAGE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        log.d('associate home center succeed: $action', methodName);
        if (action == ACTION_REQUEST) {
          _resetData();
          //_homeCenter.state = ASSOCIATION_TYPE_TO;
          //setState(() {});
        } else if (action == ACTION_CANCEL_REQUEST) {
          //_homeCenter.state = ASSOCIATION_TYPE_NONE;
          //setState(() {});
          _resetData();
        }
      } else {
        log.e('HTTP RESPONSE MESSAGE: $message', methodName);
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed +
              ': $statusCode, $message',
        );
      }
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
  }

  String getContent(int type) {
    switch (type) {
      case DEVICE_NAME:
        return _homeCenter.getName();
      case DEVICE_TYPE:
        return 'TERNCY-GW01';
      case SERIAL_NUMBER:
        return _homeCenter.serialNumber;
      case ASSOCIATED_ACCOUNT:
        return numberOfAssociateAccount.toString();
      default:
        return '';
    }
  }

  int get numberOfAssociateAccount =>
      AssociateAccountManager().numberOfAssociateAccount(widget.homeCenterUuid);

  int get numberOfDevicesCanUpgrade =>
      FirmwareManager().numberOfDevicesCanUpgrade(widget.homeCenterUuid);

  Widget build(BuildContext context) {
    return CommonPage(
      title: _homeCenter == null
          ? DefinedLocalizations.of(context).xiaoyanHomeCenter
          : _homeCenter.getName(),
      child: buildChild(context),
      isHomeCenterDetail: true,
    );
  }

  Widget buildChild(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(),
      itemCount: _uiEntities.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(context, _uiEntities[index]);
      },
    );
  }

  Widget _buildItem(BuildContext context, _UiEntity uiEntity) {
    if (uiEntity.type == HEADER) {
      return _buildHeader(context, uiEntity);
    } else if (uiEntity.type == FOOTER) {
      return _buildFooter(context, uiEntity);
    } else if (uiEntity.type == ADD) {
      return _buildAddItem(context, uiEntity);
    } else {
      return _buildBody(context, uiEntity);
    }
  }

  Widget _buildHeader(BuildContext context, _UiEntity uiEntity) {
    bool displayOffline = _homeCenter == null ||
        !(_homeCenter.state == ASSOCIATION_TYPE_BOTH && !_homeCenter.online);
    return Container(
      padding: EdgeInsets.only(top: 0.0),
      color: _homeCenter == null
          ? const Color(0xFF9CA8B6)
          : _homeCenter.online
              ? const Color(0xFF9CA8B6)
              : const Color(0xFFD6D6D6),
      height: 240.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Center(
              child: Image(
                width: 189.0,
                height: 189.0,
                image: AssetImage('images/home_center.png'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Offstage(
              offstage: !displayOffline,
              child: Text(
                DefinedLocalizations.of(context).xiaoyanHomeCenter,
                style: TEXT_STYLE_OFFLINE,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Offstage(
              offstage: displayOffline,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 15.0,
                    height: 15.0,
                    image: AssetImage('images/icon_offline_white.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                  ),
                  Text(
                    DefinedLocalizations.of(context).offline,
                    style: TEXT_STYLE_OFFLINE,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, _UiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 53.0,
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 0.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 51.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    uiEntity.getTypeString(context),
                    style: TEXT_STYLE_INFORMATION_TYPE,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Offstage(
                        offstage: !uiEntity.contentShown,
                        child: Text(
                          getContent(uiEntity.type),
                          style: TEXT_STYLE_INFORMATION_CONTENT,
                        ),
                      ),
                      Offstage(
                        offstage: uiEntity.type == FIRMWARE_UPGRADE
                            ? (numberOfDevicesCanUpgrade == 0)
                            : true,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: Colors.red),
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Offstage(
                        offstage: !uiEntity.arrowShown,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Image(
                            width: 7.0,
                            height: 11.0,
                            image: AssetImage('images/icon_next.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 2.0,
              color: const Color(0x33000000),
            ),
          ],
        ),
      ),
      onTap: () {
        if (uiEntity.type == DEVICE_NAME) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => SetNamePage(
                    homeCenter: _homeCenter,
                  ), //SetNamePage.initWithHomeCenter(_homeCenter),
              settings: RouteSettings(
                name: '/SetName',
              ),
            ),
          );
        } else if (uiEntity.type == SYSTEM_INFORMATION) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  SystemInformationPage(homeCenter: _homeCenter),
              settings: RouteSettings(
                name: '/SystemInformation',
              ),
            ),
          );
        } else if (uiEntity.type == ASSOCIATED_ACCOUNT) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) => AssociateAccountPage(
                    homeCenterUuid: widget.homeCenterUuid,
                    type: HOST_ACCOUNT,
                  ),
              settings: RouteSettings(
                name: '/AssociateAccount',
              ),
            ),
          );
        } else if (uiEntity.type == CHECK_NEW_VERSION) {
          showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(
                    DefinedLocalizations.of(context).checkNewVersionDes,
                    style: TEXT_STYLE_ALERT_DIALOG_TITLE,
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text(DefinedLocalizations.of(context).cancel),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).maybePop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        DefinedLocalizations.of(context).confirm,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).maybePop();
                        _checkNewVersion(context);
                      },
                    ),
                  ],
                ),
          );
        } else if (uiEntity.type == FIRMWARE_UPGRADE) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  FirmwareUpgradePage(homeCenterUuid: widget.homeCenterUuid),
              settings: RouteSettings(
                name: '/FirmwareUpgrade',
              ),
            ),
          );
        } else if (uiEntity.type == MANAGE_ROOMS) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  ManageRoomPage(homeCenterUuid: widget.homeCenterUuid),
              settings: RouteSettings(
                name: '/ManageRoom',
              ),
            ),
          );
        } else if (uiEntity.type == UPGRADE_POLICY) {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) => SetUpgradePolicyPage(
                    homeCenterUuid: widget.homeCenterUuid,
                  ),
              settings: RouteSettings(
                name: '/SetUpgradePolicy',
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildFooter(BuildContext context, _UiEntity uiEntity) {
    return Container(
      margin: EdgeInsets.only(top: 136.0, bottom: 62.0),
      alignment: Alignment.center,
      child: CupertinoButton(
        child: Text(
          DefinedLocalizations.of(context).delete,
          style: TEXT_STYLE_DELETE_BUTTON,
        ),
        color: const Color(0xFFFF8443),
        pressedOpacity: 0.8,
        borderRadius: BorderRadius.circular(22.0),
        padding: EdgeInsets.only(left: 90.0, right: 90.0),
        onPressed: () {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text(
                    DefinedLocalizations.of(context).sureToDeleteHomeCenter,
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text(
                        DefinedLocalizations.of(context).cancel,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).maybePop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text(
                        DefinedLocalizations.of(context).delete,
                      ),
                      onPressed: () {
                        _associateHomeCenter(ACTION_REMOVE);
                        Navigator.of(context, rootNavigator: true).maybePop();
                      },
                    ),
                  ],
                ),
          );
        },
      ),
    );
  }

  Widget _buildAddItem(BuildContext context, _UiEntity uiEntity) {
    return Container(
      padding: EdgeInsets.only(top: 100.0),
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          Text(
            _homeCenter.state != ASSOCIATION_TYPE_NONE
                ? DefinedLocalizations.of(context).toBeAuthorizedByOthers
                : "",
            textAlign: TextAlign.center,
            style: TEXT_STYLE_INFORMATION_TYPE,
          ),
          Container(
            width: 200.0,
            height: 44.0,
            margin: EdgeInsets.only(top: 80.0),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x3397BAC6)),
              borderRadius: BorderRadius.circular(22.0),
            ),
            child: CupertinoButton(
              minSize: 44.0,
              padding: EdgeInsets.only(),
              child: Text(
                _homeCenter.state == ASSOCIATION_TYPE_NONE
                    ? DefinedLocalizations.of(context).add
                    : DefinedLocalizations.of(context).cancelAdd,
                style: TEXT_STYLE_BUTTON,
              ),
              borderRadius: BorderRadius.circular(22.0),
              color: Colors.white,
              disabledColor: Colors.white,
              onPressed: () {
                if (_homeCenter.state == ASSOCIATION_TYPE_NONE) {
                  _associateHomeCenter(ACTION_REQUEST);
                } else if (_homeCenter.state == ASSOCIATION_TYPE_TO) {
                  _associateHomeCenter(ACTION_CANCEL_REQUEST);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const int HEADER = 0;
const int DEVICE_NAME = 1;
const int DEVICE_TYPE = 2;
const int SERIAL_NUMBER = 3;
const int ASSOCIATED_ACCOUNT = 4;
const int FIRMWARE_UPGRADE = 5;
const int CHECK_NEW_VERSION = 6;
const int SYSTEM_INFORMATION = 7;
const int FOOTER = 8;
const int ADD = 9;
const int MANAGE_ROOMS = 10;
const int UPGRADE_POLICY = 11;

class _UiEntity {
  int type;
  String content;

  _UiEntity({this.type, this.content});

  String getTypeString(BuildContext context) {
    switch (type) {
      case HEADER:
        return DefinedLocalizations.of(context).xiaoyanHomeCenter;
      case DEVICE_NAME:
        return DefinedLocalizations.of(context).deviceName;
      case DEVICE_TYPE:
        return DefinedLocalizations.of(context).deviceType;
      case SERIAL_NUMBER:
        return DefinedLocalizations.of(context).serialNumber;
      case ASSOCIATED_ACCOUNT:
        return DefinedLocalizations.of(context).associatedAccount;
      case FIRMWARE_UPGRADE:
        return DefinedLocalizations.of(context).firmwareUpgrade;
      case CHECK_NEW_VERSION:
        return DefinedLocalizations.of(context).checkNewVersion;
      case SYSTEM_INFORMATION:
        return DefinedLocalizations.of(context).systemInformation;
      case FOOTER:
        return DefinedLocalizations.of(context).delete;
      case MANAGE_ROOMS:
        return DefinedLocalizations.of(context).manageRooms;
      case UPGRADE_POLICY:
        return DefinedLocalizations.of(context).upgradePolicy;
      default:
        return '';
    }
  }

  bool get contentShown =>
      type == DEVICE_NAME ||
      type == DEVICE_TYPE ||
      type == SERIAL_NUMBER ||
      (type == ASSOCIATED_ACCOUNT);

  bool get arrowShown =>
      type == DEVICE_NAME ||
      type == CHECK_NEW_VERSION ||
      type == SYSTEM_INFORMATION ||
      type == MANAGE_ROOMS ||
      (type == ASSOCIATED_ACCOUNT && content != '0') ||
      type == UPGRADE_POLICY;
}
