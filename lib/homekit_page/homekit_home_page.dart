import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/widget/system_padding.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;

import 'package:xlive/page/common_page.dart';

import 'dart:async';

class HomekitHomePage extends StatefulWidget {
  State<StatefulWidget> createState() => _HomekitHomeState();
}

class _HomekitHomeState extends State<HomekitHomePage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'HomekitHomePage');

  final List<_UiEntity> _uiEntities = List();

  StreamSubscription _subscription; //消息通道

  TextEditingController _homeNameController = TextEditingController();

  void initState() {
    super.initState();
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
    _uiEntities.clear();
    List<Home> homes = HomeManager().homes;
    for (var home in homes) {
      _uiEntities.add(_UiEntity(home));
    }
    setState(() {});
  }

  void _start() {
    final String methodName = 'start';
    _subscription = RxBus()
        .toObservable()
        .where((event) => event is HomekitEvent)
        .listen((event) {
      if (event is HomesUpdatedEvent) {
        log.d('homes updated event', methodName);
        _resetData();
      } else if (event is HomeAddedEvent) {
        _resetData();
      } else if (event is HomeRemovedEvent) {
        _resetData();
      } else if (event is HomeNameUpdatedEvent) {
        _resetData();
      } else if (event is PrimaryHomeUpdatedEvent) {
        _resetData();
      } else if (event is HomekitEntityIncomingCompleteEvent) {
        _resetData();
      }
    });
  }

  void _showAddHomeActionSheet(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  DefinedLocalizations.of(context).addHome,
                  style: TextStyle(
                    color: const Color(0xFF2D3B46),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _showAddHomeDialog(context);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                DefinedLocalizations.of(context).cancel,
                style: TextStyle(
                  color: const Color(0xFF2D3B46),
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          );
        });
  }

  void _showAddHomeDialog(BuildContext context) async {
    await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return SystemPadding(
            child: CupertinoAlertDialog(
              title: Text(
                DefinedLocalizations.of(context).addHome,
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DefinedLocalizations.of(context).inputName,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  CupertinoTextField(
                    autofocus: true,
                    controller: _homeNameController,
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    DefinedLocalizations.of(context).cancel,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    DefinedLocalizations.of(context).addHome,
                  ),
                  onPressed: () {
                    methodChannel
                        .addHome(_homeNameController.text)
                        .then((response) {
                      final int code = response['code'];
                      switch (code) {
                        case 0:
                          Navigator.of(context, rootNavigator: true).pop();
                          _homeNameController.text = '';
                          _resetData();
                          break;
                        case 36:
                          Fluttertoast.showToast(
                              msg: DefinedLocalizations.of(context)
                                  .badHomeKitRoomName,
                              timeInSecForIos: 5,
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: Colors.pinkAccent,
                              gravity: ToastGravity.CENTER);
                          break;
                        default:
                          final String messageType =
                              DefinedLocalizations.of(context).error;
                          final String message = response['message'];
                          _displayMessage(messageType, message, context);
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  void _displayHomeSettings(BuildContext context, Home home) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(DefinedLocalizations.of(context).homeSetting),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).rename,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _displayRenameHome(context, home);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).setAsPrimaryHome,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _setAsPrimaryHome(context, home.identifier);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).delete,
                ),
                onPressed: () {
                  //final String messageType = DefinedLocalizations.of(context).warning;
                  //final String message = DefinedLocalizations.of(context).sureToDeleteHome;
                  Navigator.of(context, rootNavigator: true).pop();
                  _displayDeleteHomeMessage(context, home.identifier);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).cancel,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        });
  }

  void _displayRenameHome(BuildContext context, Home home) {
    _homeNameController.text = home.name;
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return SystemPadding(
            child: CupertinoAlertDialog(
              title: Text(
                DefinedLocalizations.of(context).rename,
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    DefinedLocalizations.of(context).inputName,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  CupertinoTextField(
                    autofocus: true,
                    controller: _homeNameController,
                  ),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    DefinedLocalizations.of(context).cancel,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: Text(
                    DefinedLocalizations.of(context).rename,
                  ),
                  onPressed: () {
                    final String homeIdentifier = home.identifier;
                    final String newName = _homeNameController.text;
                    methodChannel
                        .updateHomeName(homeIdentifier, newName)
                        .then((response) {
                      final int code = response['code'];
                      switch (code) {
                        case 0:
                          Navigator.of(context, rootNavigator: true).pop();
                          _resetData();
                          break;
                        case 36:
                          Fluttertoast.showToast(
                              msg: DefinedLocalizations.of(context)
                                  .badHomeKitRoomName,
                              timeInSecForIos: 5,
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: Colors.pinkAccent,
                              gravity: ToastGravity.CENTER);
                          break;
                        default:
                          final String messageType =
                              DefinedLocalizations.of(context).error;
                          final String message = response['message'];
                          _displayMessage(messageType, message, context);
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  void _setAsPrimaryHome(BuildContext context, String homeIdentifier) {
    methodChannel.updatePrimaryHome(homeIdentifier).then((response) {
      final int code = response['code'];
      if (code != 0) {
        final String messageType = DefinedLocalizations.of(context).error;
        final String message = response['message'];
        _displayMessage(messageType, message, context);
      } else {
        _resetData();
      }
    });
  }

  void _displayDeleteHomeMessage(BuildContext context, String homeIdentifier) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              DefinedLocalizations.of(context).warning,
            ),
            content: Text(
              DefinedLocalizations.of(context).sureToDeleteHome,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).cancel,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).delete,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  methodChannel.removeHome(homeIdentifier).then((response) {
                    final int code = response['code'];
                    if (code != 0) {
                      final String messageType =
                          DefinedLocalizations.of(context).warning;
                      final String message = response['message'];
                      _displayMessage(messageType, message, context);
                    } else {
                      List<Home> homes = HomeManager().homes;
                      for (var h in homes) {
                        _setAsPrimaryHome(context, h.identifier);
                        break;
                      }
                      _resetData();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  void _displayMessage(
      String messageType, String message, BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(messageType),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).confirm),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).home,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 40.0,
          height: 40.0,
          alignment: Alignment.center,
          child: Image(
            width: 27.0,
            height: 27.0,
            image: AssetImage('images/add.png'),
          ),
        ),
        onTap: () {
          _showAddHomeActionSheet(context);
        },
      ),
      showBackIcon: false,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildEmpty(context),
          _buildHomes(context),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Offstage(
      offstage: _uiEntities.length > 0,
      child: Center(
        child: Text(
          DefinedLocalizations.of(context).homesEmpty,
          style: TextStyle(inherit: false, color: Colors.grey, fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildHomes(BuildContext context) {
    return Offstage(
      offstage: _uiEntities.length == 0,
      child: ListView.builder(
        padding: EdgeInsets.only(),
        itemCount: _uiEntities.length,
        itemBuilder: (BuildContext context, int index) {
          final _UiEntity uiEntity = _uiEntities.elementAt(index);
          return _buildHomeItem(context, uiEntity);
        },
      ),
    );
  }

  Widget _buildHomeItem(BuildContext context, _UiEntity uiEntity) {
    final String methodName = 'buildHomeItem';
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        height: 80.0,
        color: const Color(0xFFF9F9F9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image(
                  width: 24.0,
                  height: 24.0,
                  image: AssetImage('images/home.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30.0),
                ),
                Text(
                  uiEntity.home.name +
                      (uiEntity.home.primary
                          ? DefinedLocalizations.of(context).currentHome
                          : ''),
                  style: TextStyle(
                    inherit: false,
                    color: const Color(0xFF2D3B46),
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Container(
              width: 21.0,
              height: 21.0,
              alignment: Alignment.center,
              child: Image(
                width: uiEntity.home.primary ? 21.0 : 10.5,
                height: uiEntity.home.primary ? 21.0 : 10.5,
                image: AssetImage(uiEntity.imageUrl),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        _setAsPrimaryHome(context, uiEntity.home.identifier);
      },
      onLongPress: () {
        _displayHomeSettings(context, uiEntity.home);
      },
    );
  }
}

class _UiEntity {
  final Home home;

  _UiEntity(this.home);

  String get imageUrl =>
      home.primary ? 'images/icon_check.png' : 'images/icon_uncheck.png';
}
