import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/widget/system_padding.dart';
import 'package:xlive/homekit_page/homekit_device_detail_page.dart';
import 'package:xlive/widget/switch_button.dart';

import 'package:xlive/page/common_page.dart';
import 'homekit_add_device_page.dart';

import 'dart:async';

class HomekitDevicePage extends StatefulWidget {
  State<StatefulWidget> createState() => _HomekitDeviceState();
}

class _HomekitDeviceState extends State<HomekitDevicePage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'HomekitDevicePage');

  final List<_Group> _groups = List();

  StreamSubscription _subscription;

  final TextEditingController _accessoryNameController =
      TextEditingController();

  void initState() {
    super.initState();
    _resetData();
    _start();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    context.inheritFromWidgetOfExactType(HomekitDevicePage);
  }

  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _resetData() {
    final String methodName = 'resetData';
    final Home home = HomeManager().primaryHome;
    if (home == null) return;
    _groups.clear();
    final List<Room> rooms = home.rooms;
    for (var room in rooms) {
      _groups.add(_Group(room));
    }
    final List<Accessory> accessories = home.accessories;
    for (var accessory in accessories) {
      if (accessory.isDelete) continue;
      final _Group group = _findGroup(accessory.roomIdentifier);
      if (group != null) {
        group.add(accessory);
      }
    }
    setState(() {});
  }

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) => event is HomekitEvent)
        .listen((event) {
      if (event is HomekitEntityIncomingCompleteEvent) {
        _resetData();
      } else if (event is AccessoryAvailableStatusChangedEvent) {
        _resetData();
      } else if (event is AccessoryUpdatingStatusChangedEvent) {
        _resetData();
      } else if (event is CharacteristicValueChangedEvent) {
        _resetData();
      } else if (event is PrimaryHomeUpdatedEvent) {
        _resetData();
      } else if (event is CharacteristicVaulueUpdatedEvent) {
        print('Characteristic value updated event');
        final Home home = HomeManager().findHome(event.homeIdentifier);
        if (home != null) {
          final Accessory accessory =
              home.findAccessory(event.accessoryIdentifier);
          if (accessory != null) {
            final Service service =
                accessory.findService(event.serviceIdentifier);
            if (service != null) {
              final Characteristic characteristic =
                  service.findCharacteristic(event.characteristicIdentifier);
              if (characteristic != null &&
                  characteristic.type == C_CURRENT_POSITION) {
                final _Group group = _findGroup(accessory.homeIdentifier);
                if (group != null) {
                  final _DeviceUiEntity deviceUiEntity =
                      group.findUiEntity(accessory.identifier);
                  if (deviceUiEntity != null) {
                    deviceUiEntity.showIndicator = false;
                  }
                }
              }
            }
          }
        }
        _resetData();
      }
    });
  }

  void setOnOff(_DeviceUiEntity uiEntity) {
    Service service;
    if (uiEntity.accessory.isLightSocket) {
      service = uiEntity.accessory.findServiceByType(S_LIGHT_SOCKET);
    } else if (uiEntity.accessory.isSmartPlug) {
      service = uiEntity.accessory.findServiceByType(S_PLUG);
    }
    if (service == null) {
      uiEntity.showIndicator = false;
      setState(() {});
      return;
    }
    final Characteristic characteristic =
        service.findCharacteristicByType(C_ON_OFF);
    if (characteristic == null) {
      uiEntity.showIndicator = false;
      setState(() {});
      return;
    }
    final String homeIdentifier = uiEntity.accessory.homeIdentifier;
    final String accessoryIdentifier = uiEntity.accessory.identifier;
    final String serviceIdentifier = service.identifier;
    final String characteristicIdentifier = characteristic.identifier;
    final int value = uiEntity.isButtonChecked ? 0 : 1;
    methodChannel
        .writeValue(homeIdentifier, accessoryIdentifier, serviceIdentifier,
            characteristicIdentifier, value)
        .then((response) {
      uiEntity.showIndicator = false;
      setState(() {});
      final int code = response['code'];
      if (code != 0) {
        final String messageType = DefinedLocalizations.of(context).error;
        final String message = response['message'];
        displayMessage(messageType, message);
      }
    });
  }

  void setCurtainPercent(_DeviceUiEntity uiEntity) {
    final Service service = uiEntity.accessory.findServiceByType(S_CURTAIN);
    if (service == null) {
      uiEntity.showIndicator = false;
      setState(() {});
      return;
    }
    final Characteristic characteristic =
        service.findCharacteristicByType(C_TARGET_POSITION);
    if (characteristic == null) {
      uiEntity.showIndicator = false;
      setState(() {});
      return;
    }
    final String homeIdentifier = uiEntity.accessory.homeIdentifier;
    final String accessoryIdentifier = uiEntity.accessory.identifier;
    final String serviceIdentifier = service.identifier;
    final String characteristicIdentifier = characteristic.identifier;
    final int value = uiEntity.isButtonChecked ? 0 : 100;
    methodChannel
        .writeValue(homeIdentifier, accessoryIdentifier, serviceIdentifier,
            characteristicIdentifier, value)
        .then((response) {
      //uiEntity.showIndicator = false;
      setState(() {});
      final int code = response['code'];
      if (code != 0) {
        final String messageType = DefinedLocalizations.of(context).error;
        final String message = response['message'];
        displayMessage(messageType, message);
      }
    });
  }

  void displayMessage(String messageType, String message) {
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
            ),
          ],
        );
      },
    );
  }

  _Group _findGroup(String roomIdentifier) {
    for (var group in _groups) {
      final _UiEntity uiEntity = group.uiEntities.elementAt(0);
      if (uiEntity is _GroupUiEntity) {
        if (uiEntity.room.identifier == roomIdentifier) {
          return group;
        }
      }
    }
    return null;
  }

  int get _itemCount {
    int count = 0;
    for (var group in _groups) {
      count += group.size;
    }
    return count;
  }

  _UiEntity _getUiEntity(int index) {
    int step = 0;
    for (var group in _groups) {
      if (index < group.size + step && index >= step) {
        return group.get(index - step);
      } else {
        step += group.size;
      }
    }
    return null;
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).device,
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
          _displayAddDevice(context);
        },
      ),
      showBackIcon: false,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: ListView.builder(
        itemCount: _itemCount,
        padding: EdgeInsets.only(),
        itemBuilder: (BuildContext context, int index) {
          final _UiEntity uiEntity = _getUiEntity(index);
          if (uiEntity is _GroupUiEntity) {
            return _buildGroup(context, uiEntity);
          } else if (uiEntity is _DeviceUiEntity) {
            return _buildDevice(context, uiEntity);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildGroup(BuildContext context, _GroupUiEntity uiEntity) {
    return Container(
      height: 24.0,
      color: Colors.white,
      margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 2.5),
      child: Text(
        uiEntity.room.name,
        style: TEXT_STYLE_ROOM_NAME,
      ),
    );
  }

  Widget _buildDevice(BuildContext context, _DeviceUiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 80.0,
        color: const Color(0xFFF9F9F9),
        margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 2.5, bottom: 2.5),
        child: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 40.0,
                height: 40.0,
                margin: EdgeInsets.only(left: 15.0),
                alignment: Alignment.center,
                child: _buildDeviceIcon(context, uiEntity),
              ),
              Container(
                width: 130.0,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      uiEntity.accessory.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF2D3B46),
                        fontSize: 16.0,
                        inherit: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.0),
                    ),
                    Text(
                      uiEntity.getAccessoryType(context),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                        inherit: false,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 60.0,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    //SwitchButton
                    Offstage(
                      offstage: !uiEntity.displaySwitchButton,
                      child: SwitchButton(
                        activeColor: const Color(0xFF7CD0FF),
                        value: uiEntity.isButtonChecked,
                        showIndicator: uiEntity.showIndicator,
                        showText: false,
                        onChanged: (bool value) {
                          uiEntity.showIndicator = true;
                          setState(() {});
                          if (uiEntity.accessory.isLightSocket ||
                              uiEntity.accessory.isSmartPlug) {
                            setOnOff(uiEntity);
                          } else if (uiEntity.accessory.isCurtain) {
                            setCurtainPercent(uiEntity);
                          }
                        },
                      ),
                    ),
                    Offstage(
                      offstage: !(!uiEntity.accessory.available &&
                          uiEntity.accessory.updating),
                      child: Text(
                        DefinedLocalizations.of(context).updating,
                        style: TextStyle(
                          inherit: false,
                          fontSize: 14.0,
                          color: const Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !(!uiEntity.accessory.available &&
                          !uiEntity.accessory.updating),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Image(
                            width: 10.0,
                            height: 10.0,
                            image: AssetImage('images/icon_offline.png'),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0),
                          ),
                          Text(
                            DefinedLocalizations.of(context).offline,
                            style: TextStyle(
                              inherit: false,
                              fontSize: 14.0,
                              color: const Color(0xFFE0E0E0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 5.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          //进入下一个页面
          CupertinoPageRoute(
            builder: (context) => HomekitDeviceDetailPage(
                deviceId:
                    uiEntity.accessory.identifier), //传一个参数给下一页  下一页要是一个带参数的类
            settings: RouteSettings(
              name: '/HomekitDeviceDetail',
            ),
          ),
        );
      },
      onLongPress: () {
        _displayDeviceSettings(context, uiEntity.accessory);
      },
    );
  }

  Widget _buildDeviceIcon(BuildContext context, _DeviceUiEntity uiEntity) {
    final Accessory accessory = uiEntity.accessory;
    if (accessory.isLightSocket) {
      String imageUrl;
      if (accessory.available) {
        if (accessory.isOnOff) {
          imageUrl = 'images/icon_light_on.png';
        } else {
          imageUrl = 'images/icon_light_off.png';
        }
      } else {
        imageUrl = 'images/icon_light_offline.png';
      }
      return Image.asset(
        imageUrl,
        width: 35.0,
        height: 36.0,
        gaplessPlayback: true,
      );
    } else if (accessory.isSmartPlug) {
      String imageUrl;
      if (accessory.available) {
        if (accessory.isOnOff) {
          imageUrl = 'images/icon_plug_on.png';
        } else {
          imageUrl = 'images/icon_plug_off.png';
        }
      } else {
        imageUrl = 'images/icon_plug_offline.png';
      }
      return Image.asset(
        imageUrl,
        width: 25.0,
        height: 25.0,
        gaplessPlayback: true,
      );
    } else if (accessory.isAwarenessSwitch) {
      String imageUrl;
      if (accessory.available) {
        imageUrl = 'images/icon_pir.png';
      } else {
        imageUrl = 'images/icon_pir_offline.png';
      }
      return Image.asset(
        imageUrl,
        width: 30.0,
        height: 30.0,
        gaplessPlayback: true,
      );
    } else if (accessory.isDoorSensor) {
      String imageUrl;
      if (accessory.available) {
        imageUrl = 'images/icon_dc.png';
      } else {
        imageUrl = 'images/icon_dc_offline.png';
      }
      return Image.asset(
        imageUrl,
        width: 24.0,
        height: 24.0,
        gaplessPlayback: true,
      );
    } else if (accessory.isCurtain) {
      String imageUrl;
      if (accessory.available) {
        imageUrl = 'images/icon_curtain.png';
      } else {
        imageUrl = 'images/icon_curtain_offline.png';
      }
      return Image.asset(
        imageUrl,
        width: 25.0,
        height: 22.0,
        gaplessPlayback: true,
      );
    } else if (accessory.isWallSwitch) {
      String imageUrl;
      if (accessory.available) {
        imageUrl = 'images/icon_ws.png';
      } else {
        imageUrl = 'images/icon_ws_offline.png';
      }
      return Image.asset(
        imageUrl,
        width: 26.0,
        height: 26.0,
        gaplessPlayback: true,
      );
    } else if (accessory.isHomeCenter) {
      String imageUrl;
      if (accessory.available) {
        imageUrl = 'images/home_center_unselected.png';
      } else {
        imageUrl = 'images/home_center_unselected.png';
      }
      return Image.asset(
        imageUrl,
        width: 30.0,
        height: 30.0,
        gaplessPlayback: true,
      );
    } else if (accessory.isWallSwitchUS) {
      String imageUrl;
      if (accessory.available) {
        imageUrl = 'images/icon_ws_us.png';
      } else {
        imageUrl = 'images/icon_ws_us_offline.png';
      }
      return Image.asset(
        imageUrl,
        width: 22.0,
        height: 33.0,
        gaplessPlayback: true,
      );
    } else if (accessory.isSmartDial) {
      String imageUrl;
      if (accessory.available) {
        imageUrl = 'images/icon_sd_online.png';
      } else {
        imageUrl = 'images/icon_sd_offline.png';
      }
      return Image.asset(
        imageUrl,
        width: 26.0,
        height: 24.0,
        gaplessPlayback: true,
      );
    } else if (accessory.isSwitchModule) {
      String imageUrl;
      if (accessory.available) {
        imageUrl = 'images/icon_switch_module.png';
      } else {
        imageUrl = 'images/icon_switch_module_offline.png';
      }
      return Image.asset(
        imageUrl,
        width: 40.0,
        height: 40.0,
        gaplessPlayback: true,
      );
    } else {
      return Container(
        width: 40.0,
        height: 40.0,
      );
    }
  }

  void _displayDeviceSettings(BuildContext context, Accessory accessory) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              DefinedLocalizations.of(context).deviceSetting,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).rename,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _displayRenameHome(context, accessory);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).transfer,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _displayTransferDevice(context, accessory);
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).delete,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _displayDeleteAccessoryMessage(context, accessory);
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

  void _displayRenameHome(BuildContext context, Accessory accessory) {
    _accessoryNameController.text = accessory.name;
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
                    controller: _accessoryNameController,
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
                    Navigator.of(context, rootNavigator: true).pop();
                    final String homeIdentifier = accessory.homeIdentifier;
                    final String accessoryIdentifier = accessory.identifier;
                    final String newName = _accessoryNameController.text;
                    methodChannel
                        .updateAccessoryName(
                            homeIdentifier, accessoryIdentifier, newName)
                        .then((response) {
                      final int code = response['code'];
                      if (code != 0) {
                        final String message = response['message'];
                        final String messageType =
                            DefinedLocalizations.of(context).error;
                        displayMessage(messageType, message);
                      } else {
                        _resetData();
                      }
                    });
                  },
                ),
              ],
            ),
          );
        });
  }

  void _displayTransferDevice(BuildContext context, Accessory accessory) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              DefinedLocalizations.of(context).transfer,
            ),
            content: Text(
              DefinedLocalizations.of(context).chooseARoom,
            ),
            actions: buildActions(context, accessory),
          );
        });
  }

  List<Widget> buildActions(BuildContext context, Accessory accessory) {
    final List<CupertinoDialogAction> actions = List();
    final Home home = HomeManager().findHome(accessory.homeIdentifier);
    if (home == null) return null;
    final List<Room> rooms = home.rooms;
    for (var room in rooms) {
      print('room identifier: ${room.identifier}');
      final CupertinoDialogAction action = CupertinoDialogAction(
        child: Text(
          room.name,
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          final String homeIdentifier = accessory.homeIdentifier;
          final String accessoryIdentifier = accessory.identifier;
          final String roomIdentifier = room.identifier;
          methodChannel
              .updateAccessoryRoom(
                  homeIdentifier, accessoryIdentifier, roomIdentifier)
              .then((response) {
            final int code = response['code'];
            if (code != 0) {
              final String messageType = DefinedLocalizations.of(context).error;
              final String message = response['message'];
              displayMessage(messageType, message);
            } else {
              _resetData();
            }
          });
        },
      );
      actions.add(action);
    }
    ;
    actions.add(CupertinoDialogAction(
      child: Text(
        DefinedLocalizations.of(context).cancel,
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    ));
    return actions;
  }

  void _displayDeleteAccessoryMessage(
      BuildContext context, Accessory accessory) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              DefinedLocalizations.of(context).warning,
            ),
            content: Text(
              DefinedLocalizations.of(context).sureToDeleteDevice,
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
                  if (accessory.isHomeCenter) {
                    methodChannel
                        .removeAccessory(
                            accessory.homeIdentifier, accessory.identifier)
                        .then((response) {
                      final int code = response['code'];
                      print('code: $code');
                      if (code != 0) {
                        final String messageType =
                            DefinedLocalizations.of(context).error;
                        final String message = response['message'];
                        displayMessage(messageType, message);
                      } else {
                        _resetData();
                      }
                    });
                  } else {
                    final Service service =
                        accessory.findServiceByType(S_DELETE);
                    if (service == null) return;
                    final Characteristic characteristic =
                        service.findCharacteristicByType(C_DELETE);
                    if (characteristic == null) return;
                    final String homeIdentifier = accessory.homeIdentifier;
                    final String accessoryIdentifier = accessory.identifier;
                    final String serviceIdentifier = service.identifier;
                    final String characteristicIdentifier =
                        characteristic.identifier;
                    final bool value = true;
                    methodChannel
                        .writeValue(homeIdentifier, accessoryIdentifier,
                            serviceIdentifier, characteristicIdentifier, value)
                        .then((response) {
                      final int code = response['code'];
                      if (code != 0) {
                        final String messageType =
                            DefinedLocalizations.of(context).error;
                        final String message = response['message'];
                        displayMessage(messageType, message);
                      } else {
                        _resetData();
                      }
                    });
                  }
                },
              ),
            ],
          );
        });
  }

  void _displayAddDevice(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  DefinedLocalizations.of(context).addHomeCenter,
                  style: TextStyle(
                    color: const Color(0xFF2D3B46),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  final String homeIdentifier =
                      HomeManager().primaryHome.identifier;
                  methodChannel.addHomeCenter(homeIdentifier).then((response) {
                    final int code = response['code'];
                    print('code: $code');
                    if (code != 0) {
                      //final String message = response['message'];
                      //_displayErrorMessage(context, message);
                    } else {
                      //TODO:
                    }
                  });
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  DefinedLocalizations.of(context).addEndDevice,
                  style: TextStyle(
                    color: const Color(0xFF2D3B46),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                      builder: (BuildContext context) => HomekitAddDevicePage(),
                      settings: RouteSettings(
                        name: '/HomekitAddDevice',
                      ),
                    ),
                  );
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
}

class _Group {
  final List<_UiEntity> uiEntities = List();

  _Group(Room room) {
    uiEntities.add(_GroupUiEntity(room));
  }

  void add(Accessory accessory) {
    uiEntities.add(_DeviceUiEntity(accessory: accessory));
  }

  int get size => uiEntities.length > 1 ? uiEntities.length : 0;

  _UiEntity get(int index) => uiEntities[index];

  _DeviceUiEntity findUiEntity(String accessoryIdentifier) {
    for (_UiEntity uiEntity in uiEntities) {
      if (uiEntity is _GroupUiEntity) continue;
      final _DeviceUiEntity deviceUiEntity = uiEntity as _DeviceUiEntity;
      if (deviceUiEntity.accessory.identifier == accessoryIdentifier)
        return deviceUiEntity;
    }
    return null;
  }
}

class _UiEntity {}

class _GroupUiEntity extends _UiEntity {
  final Room room;

  _GroupUiEntity(this.room);
}

class _DeviceUiEntity extends _UiEntity {
  final Accessory accessory;
  bool showIndicator;

  _DeviceUiEntity({
    this.accessory,
    this.showIndicator = false,
  });

  bool get displaySwitchButton =>
      accessory.available &&
      !accessory.updating &&
      (accessory.isLightSocket || accessory.isSmartPlug || accessory.isCurtain);

  bool get isButtonChecked => accessory.isOnOff;

  String getAccessoryType(BuildContext context) {
    return accessory.getTypeLocalDes(context) ?? accessory.model;
  }
}
