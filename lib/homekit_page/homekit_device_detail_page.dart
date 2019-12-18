import 'package:flutter/material.dart'; //安卓风格控件
import 'package:flutter/cupertino.dart'; //ios风格控件
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xlive/localization/defined_localization.dart'; //字符
import 'package:xlive/page/common_page.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/widget/switch_button.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/homekit_page/homekit_set_curtain_direction_page.dart';
import 'package:xlive/homekit_page/homekit_set_curtain_type_page.dart';
import 'package:xlive/widget/system_padding.dart';
import 'dart:async';

class HomekitDeviceDetailPage extends StatefulWidget {
  //这个一定要跟着createstate
  final String deviceId; //带参数的类的实现方法

  HomekitDeviceDetailPage({
    @required
        this.deviceId, //带参数的类的实现方法 和上面一起的  下面的类_DeviceDetailPage要在怎么用呢 就是widgei.参数名 就行了
  });
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DeviceDetailPage();
  }
}

class _DeviceDetailPage extends State<HomekitDeviceDetailPage> {
  //这个一定要跟着一个build
  final List<_DeviceDetailGroup> _deviceDetail = List();
  String updateText = "";
  StreamSubscription _subscription; //消息通道

  void initState() {
    //onshow
    super.initState();
    _resetData();
    _start();
  }

  void _resetData() {
    //初始化数据
    final Home home = HomeManager().primaryHome; //拿到家庭

    if (home == null) return; //判断家庭是否为空
    _deviceDetail.clear(); //每次执行时吧数据清空
    final Accessory accessory =
        home.findAccessory(widget.deviceId); //拿到accessory

    for (Service service in accessory.services) {
      //循环services
      final _DeviceDetailGroup group = _DeviceDetailGroup(); //添加service到group
      if (service.type == S_PLUG) {
        //插座
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_ON_OFF || cha.type == C_PLUG_BEING_USED) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_LOCK_MECHANISM) {
        //门锁
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_LOCK_CURRENT_STATE ||
              cha.type == C_LOCK_TARGET_STATE) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_PLUG_POWER) {
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_ACTIVE_POWER) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_PROPERTY) {
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_NAME ||
              cha.type == C_FIRMWARE_VERSION ||
              cha.type == C_SERIAL_NUMBER ||
              cha.type == C_MODEL ||
              cha.type == C_MANUFACTURER) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_CONTACT_SENSOR) {
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_CONTACT_SENSOR) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_WALL_SWITCH_LIGHT) {
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_ON_OFF || cha.type == C_NAME) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_MOTION) {
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_MOTION) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_TEMPERATURE) {
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_TEMPERATURE) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_LIGHT_SENSOR) {
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_LIGHT_LEVEL) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_CURTAIN) {
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_CURRENT_STATE ||
              cha.type == C_TARGET_POSITION ||
              cha.type == C_CURRENT_POSITION) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_CURTAIN_SETTNG) {
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_TYPE ||
              cha.type == C_DIRECTION ||
              cha.type == C_TRIP_CONFIGURED) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_LIGHT_SOCKET) {
        group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_ON_OFF) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      } else if (service.type == S_NEW_VERSION) {
        // group.addName(service.type);
        for (Characteristic cha in service.characteristics) {
          if (cha.type == C_NEW_VERSION_AVAILABLE) {
            group.addCharacteristic(cha);
          }
        }
        _deviceDetail.add(group);
      }
    }
    setState(() {}); //相当于标记是否要刷新
  }

  void dispose() {
    //页面卸载是执行的
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  void _start() {
    //数据监听 接受事件
    _subscription = RxBus()
        .toObservable()
        .where((event) => event is HomekitEvent)
        .listen((event) {
      // AccessoryFirmwareVersionUpdatedEvent
      var acc = HomeManager().primaryHome.findAccessory(widget.deviceId);

      final Service service = acc.findServiceByType(S_NEW_VERSION);
      if (service == null) return;
      final Characteristic characteristic =
          service.findCharacteristicByType(C_OTA_STATUS);
      if (characteristic == null) return;
      if (event is CharacteristicVaulueUpdatedEvent &&
          event.accessoryIdentifier == widget.deviceId &&
          event.characteristicIdentifier == characteristic.identifier) {
        updateText = event.value.toString() + " %";
        if (event.value == "FINISHED") {
          updateText = DefinedLocalizations.of(context).upgradeComplete;
        }
        setState(() {}); //刷新界面 相当于setData
      } else {
        _resetData();
      }
    });
  }

  String nameString(int nameType) {
    String btName = '';
    switch (nameType) {
      case S_PROPERTY:
        btName = DefinedLocalizations.of(context).deviceInformation;
        break;
      case S_LIGHT_SOCKET:
        btName = DefinedLocalizations.of(context).lightbult;
        break;
      case S_PLUG:
        btName = DefinedLocalizations.of(context).outlet;
        break;
      case S_LOCK_MECHANISM:
        btName = DefinedLocalizations.of(context).smartDoorLock;
        break;
      case S_PLUG_POWER:
        btName = DefinedLocalizations.of(context).energy;
        break;
      case S_WALL_SWITCH_LIGHT:
        btName = DefinedLocalizations.of(context).wallSwitchLight;
        break;
      case S_TEMPERATURE:
        btName = DefinedLocalizations.of(context).temperature;
        break;
      case S_AWARENESS_SWITCH:
        btName = DefinedLocalizations.of(context).motionSensor;
        break;
      case S_CONTACT_SENSOR:
        btName = DefinedLocalizations.of(context).contactSensor;
        break;
      case S_MOTION:
        btName = DefinedLocalizations.of(context).motionSensor;
        break;
      case S_CURTAIN:
        btName = DefinedLocalizations.of(context).curtain;
        break;
      case S_LIGHT_SENSOR:
        btName = DefinedLocalizations.of(context).lightSensor;
        break;
      case S_CURTAIN_SETTNG:
        btName = DefinedLocalizations.of(context).curtainSetting;
        break;
      case S_NEW_VERSION:
        btName = DefinedLocalizations.of(context).latestFirmwareVersion;
        break;
    }
    return btName;
  }

  String getContentString(int types) {
    String val = "";
    switch (types) {
      case C_NAME:
        val = DefinedLocalizations.of(context).name;
        break;
      case C_MANUFACTURER:
        val = DefinedLocalizations.of(context).manufacture;
        break;
      case C_MODEL:
        val = DefinedLocalizations.of(context).model;
        break;
      case C_SERIAL_NUMBER:
        val = DefinedLocalizations.of(context).serialNumber;
        break;
      case C_FIRMWARE_VERSION:
        val = DefinedLocalizations.of(context).firmwareVersion;
        break;
      case C_MOTION:
        val = DefinedLocalizations.of(context).motionDetected;
        break;
      case C_TEMPERATURE:
        val = DefinedLocalizations.of(context).temperature;
        break;
      case C_CONTACT_SENSOR:
        val = DefinedLocalizations.of(context).contactSensorState;
        break;
      case C_PLUG_BEING_USED:
        val = DefinedLocalizations.of(context).plugBeingUsed;
        break;
      case C_LOCK_CURRENT_STATE:
        val = DefinedLocalizations.of(context).lockCurrentState;
        break;
      case C_ACTIVE_POWER:
        val = DefinedLocalizations.of(context).energy;
        break;
      case C_TARGET_POSITION:
        val = DefinedLocalizations.of(context).targetPosition;
        break;
      case C_CURRENT_POSITION:
        val = DefinedLocalizations.of(context).currentPosition;
        break;
      case C_CURRENT_STATE:
        val = DefinedLocalizations.of(context).currentState;
        break;
      case C_LIGHT_LEVEL:
        val = DefinedLocalizations.of(context).lightLevel;
        break;
      case C_TYPE:
        val = DefinedLocalizations.of(context).curtainType;
        break;
      case C_DIRECTION:
        val = DefinedLocalizations.of(context).curtainDirection;
        break;
      case C_TRIP_CONFIGURED:
        val = DefinedLocalizations.of(context).curtainTripLearned;
        break;
      case C_ON_OFF:
        val = DefinedLocalizations.of(context).powerState;
        break;
      case C_NEW_VERSION_AVAILABLE:
        val = DefinedLocalizations.of(context).latestFirmwareVersion;
        break;
    }

    return val;
  }

  String state(int types, stateNum) {
    String stateVal = "";
    if (stateNum is String) {
      if (types == C_NEW_VERSION_AVAILABLE) {
        if (stateNum == -1 ||
            stateNum == "" ||
            stateNum == null ||
            stateNum == "0") {
          stateVal = DefinedLocalizations.of(context).noNewVersion;
        } else {
          stateVal = stateNum;
        }
        return stateVal;
      } else {
        return stateNum;
      }
    } else if (stateNum is bool) {
      if (types == C_ON_OFF || types == C_LOCK_CURRENT_STATE) {
        if (stateNum == true) {
          stateVal = DefinedLocalizations.of(context).deviceOpen;
        } else if (stateNum == false) {
          stateVal = DefinedLocalizations.of(context).deviceClose;
        }
      } else if (types == C_PLUG_BEING_USED ||
          types == C_MOTION ||
          types == C_CONTACT_SENSOR) {
        if (stateNum == true) {
          stateVal = DefinedLocalizations.of(context).yes;
        } else if (stateNum == false) {
          stateVal = DefinedLocalizations.of(context).no;
        }
      } else {
        stateVal = stateNum.toString();
      }
      return stateVal;
    } else if (stateNum is int) {
      if (types == C_ON_OFF) {
        if (stateNum == 0) {
          stateVal = DefinedLocalizations.of(context).deviceClose;
        } else {
          stateVal = DefinedLocalizations.of(context).deviceOpen;
        }
        return stateVal;
      }
      if (types == C_MOTION ||
          types == C_LOCK_CURRENT_STATE ||
          types == C_PLUG_BEING_USED ||
          types == C_CONTACT_SENSOR) {
        if (stateNum == 0) {
          stateVal = DefinedLocalizations.of(context).no;
        } else if (stateNum == 1) {
          stateVal = DefinedLocalizations.of(context).yes;
        }
        if (types == C_LOCK_CURRENT_STATE) {
          if (stateNum == 0) {
            stateVal = DefinedLocalizations.of(context).deviceClose;
          } else if (stateNum == 1) {
            stateVal = DefinedLocalizations.of(context).deviceOpen;
          }
        }
      } else if (types == C_NEW_VERSION_AVAILABLE) {
        if (stateNum == -1 || stateNum == null || stateNum == 0) {
          stateVal = DefinedLocalizations.of(context).noNewVersion;
        } else {
          stateVal = stateNum.toString();
        }
      } else if (types == C_TRIP_CONFIGURED) {
        if (stateNum == 1) {
          stateVal = DefinedLocalizations.of(context).yes;
        } else {
          stateVal = DefinedLocalizations.of(context).no;
        }
      } else if (types == C_TYPE) {
        if (stateNum == 0) {
          stateVal = DefinedLocalizations.of(context).leftCurtain;
        } else if (stateNum == 1) {
          stateVal = DefinedLocalizations.of(context).rightCurtain;
        } else {
          stateVal = DefinedLocalizations.of(context).doubleCurtain;
        }
      } else if (types == C_DIRECTION) {
        if (stateNum == 1) {
          stateVal = DefinedLocalizations.of(context).reverse;
        } else {
          stateVal = DefinedLocalizations.of(context).origin;
        }
      } else if (types == C_ACTIVE_POWER) {
        if (stateNum < 10) {
          stateVal = (stateNum * 100).toString() +
              "  " +
              DefinedLocalizations.of(context).milliWatt;
        } else {
          var sv = stateNum / 10.0;
          stateVal =
              sv.toString() + "  " + DefinedLocalizations.of(context).watt;
        }
      } else {
        stateVal = stateNum.toString();
      }
      return stateVal;
    } else {
      return stateNum.toString();
    }
  }

  bool writable(types) {
    if (types == C_ON_OFF ||
        types == C_LOCK_TARGET_STATE ||
        types == C_LOCK_CURRENT_STATE) {
      return false;
    } else {
      return true;
    }
  }

  bool valShows(val) {
    if (val == 0 || val == false) {
      return false;
    } else if (val == 1 || val == 100 || val == true) {
      return true;
    } else {
      return false;
    }
  }

  updateVal(_ContentUiEntity entity) {
    var accid = entity.contentItem.accessoryIdentifier;
    var serviceid = entity.contentItem.serviceIdentifier;
    if (HomeManager().primaryHome != null) {
      if (HomeManager().primaryHome.findAccessory(accid) != null) {
        if (HomeManager()
                .primaryHome
                .findAccessory(accid)
                .findService(serviceid) !=
            null) {
          for (Characteristic ccc in HomeManager()
              .primaryHome
              .findAccessory(accid)
              .findService(serviceid)
              .characteristics) {
            if (ccc.type == C_UPGRADE) {
              return ccc.identifier;
            }
          }
        }
      }
    }
    return null;
  }

  bool isNewVersionAvailableChar(_ContentUiEntity entity) {
    var accid = entity.contentItem.accessoryIdentifier;
    var serid = entity.contentItem.serviceIdentifier;
    var chaid = entity.contentItem.identifier;
    if (HomeManager().primaryHome != null) {
      if (HomeManager().primaryHome.findAccessory(accid) != null) {
        if (HomeManager().primaryHome.findAccessory(accid).findService(serid) !=
            null) {
          for (Service ser
              in HomeManager().primaryHome.findAccessory(accid).services) {
            //  S_NEW_VERSION
            if (ser.type == S_NEW_VERSION) {
              for (Characteristic cha in HomeManager()
                  .primaryHome
                  .findAccessory(accid)
                  .findService(serid)
                  .characteristics) {
                if (cha.type == C_NEW_VERSION_AVAILABLE) {
                  return false;
                } else {
                  return true;
                }
              }
            }
          }
        }
      }
    }
    return true;
  }

  bool isUpdatebtn(_ContentUiEntity entity) {
    var accid = entity.contentItem.accessoryIdentifier;
    var serid = entity.contentItem.serviceIdentifier;
    var chaid = entity.contentItem.identifier;
    if (HomeManager().primaryHome != null) {
      if (HomeManager().primaryHome.findAccessory(accid) != null) {
        if (HomeManager().primaryHome.findAccessory(accid).findService(serid) !=
            null) {
          var oldVersion =
              HomeManager().primaryHome.findAccessory(accid).firmwareVersion;
          var serStr = HomeManager()
              .primaryHome
              .findAccessory(accid)
              .findServiceByType(S_NEW_VERSION);
          if (serStr == null) return true;
          var chaStr = serStr.findCharacteristicByType(C_NEW_VERSION_AVAILABLE);
          if (chaStr == null) return true;
          var newVersion = chaStr.value;
          if (newVersion == oldVersion) {
            return true;
          }
          if (HomeManager().primaryHome.findAccessory(accid).isHomeCenter) {
            if (newVersion == -1) {
              return true;
            }
            var boxV1 = Accessory.getVersionNumber(newVersion);
            var boxV2 = Accessory.getVersionNumber(oldVersion);

            if (boxV1 > boxV2) {
              return false;
            } else {
              return true;
            }
          }
          if (newVersion == -1 || newVersion == "" || newVersion == null) {
            return true;
          }
          var v1 = num.parse(newVersion);
          var v2 = num.parse(oldVersion);
          if (v1 > v2) {
            return false;
          }
          return true;
        }
      }
    }
    return true;
  }

  bool isCurtain(String accid, String serid) {
    if (HomeManager().primaryHome != null) {
      if (HomeManager().primaryHome.findAccessory(accid) != null) {
        if (HomeManager().primaryHome.findAccessory(accid).isCurtain) {
          for (Service ser
              in HomeManager().primaryHome.findAccessory(accid).services) {
            //  S_NEW_VERSION
            if (ser.type == S_CURTAIN_SETTNG) {
              for (Characteristic cha in HomeManager()
                  .primaryHome
                  .findAccessory(accid)
                  .findService(serid)
                  .characteristics) {
                if (cha.type == C_TRIP_CONFIGURED ||
                    cha.type == C_DIRECTION ||
                    cha.type == C_TYPE) {
                  return false;
                }
              }
            }
          }
        }
      }
    }
    return true;
  }

  bool isCurtainPosition(int types) {
    if (types == C_TARGET_POSITION) {
      return false;
    }
    return true;
  }

  int get itemCount {
    int allCount = 0;
    for (var detail in _deviceDetail) {
      allCount += detail.size;
    }
    return allCount;
  }

  _UiEntity getItem(int index) {
    //把组里面的组变成每一项
    int step = 0;
    for (_DeviceDetailGroup group in _deviceDetail) {
      if (index - step >= 0 && index - step < group.size) {
        return group.getUiEntity(index - step);
      } else {
        step += group.size;
      }
    }
    return null;
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return CommonPage(
        title: DefinedLocalizations.of(context).deviceInformation,
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            //final _DeviceDetailGroup deviceDetailGroup = _deviceDetail.elementAt(index);
            final _UiEntity uiEntity = getItem(index); //多个entity
            return _buildContentItem(uiEntity);
          },
        ));
  }

  Widget _buildContentItem(_UiEntity uiEntity) {
    if (uiEntity is _BtUiEntity) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(right: 15.0),
        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        child: Text(nameString(uiEntity.type),
            style: TextStyle(
              color: Color(0XFF000000),
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            )),
      );
    } else if (uiEntity is _ContentUiEntity) {
      return _buildContent(context, uiEntity);
    } else {
      return Text(DefinedLocalizations.of(context).error);
    }
  }

  void _displayMessage(
      String messageType, String message, BuildContext context) {
    //错误消息提示模板
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

  Widget _buildContent(BuildContext context, _ContentUiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        height: 60.0,
        color: Color(0xFFfafafa),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15.0),
                  child: Text(
                    getContentString(uiEntity.contentItem.type),
                    style: TextStyle(color: Color.fromARGB(60, 0, 0, 0)),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 15.0),
                  child: Text(state(
                      uiEntity.contentItem.type, uiEntity.contentItem.value)),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Offstage(
                  offstage: writable(uiEntity.contentItem.type),
                  child: SwitchButton(
                    activeColor: Color(0xFF7CD0FF),
                    value: valShows(uiEntity.contentItem.value),
                    showIndicator: false,
                    showText: false,
                    onChanged: (bool value) {
                      //可写设置
                      num val;
                      if (value == true) {
                        val = 1;
                      } else if (value == false) {
                        val = 0;
                      }
                      var charid = uiEntity.contentItem.identifier;
                      if (uiEntity.contentItem.type == C_LOCK_TARGET_STATE) {
                        methodChannel
                            .setAuthorizationData(
                                uiEntity.contentItem.homeIdentifier,
                                uiEntity.contentItem.accessoryIdentifier,
                                uiEntity.contentItem.serviceIdentifier,
                                uiEntity.contentItem.identifier,
                                "terncyauthdata")
                            .then((response) {
                          final int code = response['code'];
                          // if (code != 0) {
                          final String messageType =
                              DefinedLocalizations.of(context).warning;
                          print(code);
                          final String message = response['message'];
                          _displayMessage(messageType, message, context);
                          // } else {
                          _resetData();
                          // }
                        });
                      } else {
                        methodChannel
                            .writeValue(
                                uiEntity.contentItem.homeIdentifier,
                                uiEntity.contentItem.accessoryIdentifier,
                                uiEntity.contentItem.serviceIdentifier,
                                uiEntity.contentItem.identifier,
                                val)
                            .then((response) {
                          final int code = response['code'];
                          if (code != 0) {
                            final String messageType =
                                DefinedLocalizations.of(context).warning;
                            print(code);
                            final String message = response['message'];
                            _displayMessage(messageType, message, context);
                          } else {
                            _resetData();
                          }
                        });
                      }

                      setState(() {}); //开关
                    },
                  ),
                ),
                Offstage(
                  offstage: isNewVersionAvailableChar(uiEntity),
                  child: Offstage(
                    offstage: isUpdatebtn(uiEntity),
                    child: Container(
                        margin: EdgeInsets.only(right: 15.0),
                        child: CupertinoButton(
                          color: Color(0xFFc8cdcd),
                          minSize: 29.0,
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          child: Text(
                            updateText == ""
                                ? DefinedLocalizations.of(context).upgrade
                                : updateText,
                            style: TextStyle(fontSize: 12.0),
                          ),
                          onPressed: () {
                            if (updateVal(uiEntity) != null) {
                              updateText =
                                  DefinedLocalizations.of(context).upgrading;
                              _resetData();
                              methodChannel
                                  .writeValue(
                                      uiEntity.contentItem.homeIdentifier,
                                      uiEntity.contentItem.accessoryIdentifier,
                                      uiEntity.contentItem.serviceIdentifier,
                                      updateVal(uiEntity),
                                      uiEntity.contentItem.value)
                                  .then((response) {
                                final int code = response['code'];
                                if (code != 0) {
                                  final String messageType =
                                      DefinedLocalizations.of(context).warning;
                                  final String message = response['message'];
                                  _displayMessage(
                                      messageType, message, context);
                                } else {
                                  _resetData();
                                }
                              });
                            } else {
                              print("升级错误");
                            }
                          },
                        )),
                  ),
                ),
                Offstage(
                  offstage: isNewVersionAvailableChar(uiEntity),
                  child: Offstage(
                    offstage: !(HomeManager()
                            .primaryHome
                            .findAccessory(
                                uiEntity.contentItem.accessoryIdentifier)
                            .isHomeCenter &&
                        isUpdatebtn(uiEntity)),
                    child: Container(
                        margin: EdgeInsets.only(right: 15.0),
                        child: CupertinoButton(
                          color: Color(0xFFc8cdcd),
                          minSize: 29.0,
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          child: Text(
                            DefinedLocalizations.of(context).checkNewVersion,
                            style: TextStyle(fontSize: 12.0),
                          ),
                          onPressed: () {
                            var acc = HomeManager().primaryHome.findAccessory(
                                uiEntity.contentItem.accessoryIdentifier);

                            final Service service =
                                acc.findServiceByType(S_DEFINED_PERMIT_JOIN);
                            if (service == null) return;
                            final Characteristic characteristic = service
                                .findCharacteristicByType(C_CHECK_NEW_VERSION);
                            if (characteristic == null) return;
                            final String accessoryIdentifier = acc.identifier;
                            final String serviceIdentifier = service.identifier;
                            final String characteristicIdentifier =
                                characteristic.identifier;
                            methodChannel
                                .writeValue(
                                    uiEntity.contentItem.homeIdentifier,
                                    uiEntity.contentItem.accessoryIdentifier,
                                    serviceIdentifier,
                                    characteristicIdentifier,
                                    1)
                                .then((response) {
                              final int code = response['code'];
                              final String messageType =
                                  DefinedLocalizations.of(context).warning;
                              if (code != 0) {
                                final String message = response['message'];
                                _displayMessage(messageType, message, context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: DefinedLocalizations.of(context)
                                        .checkNewVersionDes);
                              }
                            });
                          },
                        )),
                  ),
                ),
                Offstage(
                  offstage: isCurtain(uiEntity.contentItem.accessoryIdentifier,
                      uiEntity.contentItem.serviceIdentifier),
                  child: Image(
                    width: 8.0,
                    height: 16.0,
                    image: AssetImage('images/icon_next.png'),
                  ),
                ),
                Offstage(
                  offstage: isCurtainPosition(uiEntity.contentItem.type),
                  child: SwitchButton(
                    activeColor: Color(0xFF7CD0FF),
                    value: valShows(uiEntity.contentItem.value),
                    showIndicator: false,
                    showText: false,
                    onChanged: (bool value) {
                      //可写设置
                      num val;
                      if (value == true) {
                        val = 100;
                      } else if (value == false) {
                        val = 0;
                      }
                      methodChannel
                          .writeValue(
                              uiEntity.contentItem.homeIdentifier,
                              uiEntity.contentItem.accessoryIdentifier,
                              uiEntity.contentItem.serviceIdentifier,
                              uiEntity.contentItem.identifier,
                              val)
                          .then((response) {
                        final int code = response['code'];
                        if (code != 0) {
                          final String messageType =
                              DefinedLocalizations.of(context).warning;
                          final String message = response['message'];
                          _displayMessage(messageType, message, context);
                        } else {
                          _resetData();
                        }
                      });

                      setState(() {}); //开关
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (uiEntity.contentItem.type == C_TRIP_CONFIGURED) {
          _isAdjusting(uiEntity);
        } else if (uiEntity.contentItem.type == C_TYPE) {
          int originType = uiEntity.contentItem.value;
          bool isAdding = false;
          String homeIdentifier = uiEntity.contentItem.homeIdentifier;
          String accessoryIdentifier = uiEntity.contentItem.accessoryIdentifier;
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => HomekitSetCurtainTypePage(
                    originType: originType,
                    isAdding: isAdding,
                    homeIdentifier: homeIdentifier,
                    accessoryIdentifier: accessoryIdentifier,
                  ),
              settings: RouteSettings(name: '/HomekitSetCurtainTypePage')));
        } else if (uiEntity.contentItem.type == C_DIRECTION) {
          int curtainType = uiEntity.contentItem.type;
          int originDirection = uiEntity.contentItem.value;
          bool isAdding = false;
          String homeId = uiEntity.contentItem.homeIdentifier;
          String accID = uiEntity.contentItem.accessoryIdentifier;
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => HomekitSetCurtainDirectionPage(
                  curtainType: curtainType,
                  originDirection: originDirection,
                  isAdding: isAdding,
                  homeIdentifier: homeId,
                  accessoryIdentifier: accID),
              settings:
                  RouteSettings(name: '/HomekitSetCurtainDirectionPage')));
        }
      },
    );
    // uiEntity.is
    // return
  }

  void _isAdjusting(_ContentUiEntity uiEntity) {
    //窗帘是否校验行程
    showCupertinoDialog(
        //模态框
        context: context,
        builder: (BuildContext context) {
          return SystemPadding(
            child: CupertinoAlertDialog(
              title: Text(DefinedLocalizations.of(context).isAdjusting),
              content: Container(
                child: Text(DefinedLocalizations.of(context).isAdjustingText),
              ),
              actions: <Widget>[
                //操作选项
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
                    DefinedLocalizations.of(context).confirm,
                  ),
                  onPressed: () {
                    var acc = HomeManager().primaryHome.findAccessory(
                        uiEntity.contentItem.accessoryIdentifier);
                    final Service service =
                        acc.findServiceByType(S_CURTAIN_SETTNG);
                    if (service == null) return;
                    final Characteristic characteristic =
                        service.findCharacteristicByType(C_TRIP_ADJUSTING);
                    if (characteristic == null) return;
                    Navigator.of(context, rootNavigator: true).pop();
                    methodChannel
                        .writeValue(
                            uiEntity.contentItem.homeIdentifier,
                            uiEntity.contentItem.accessoryIdentifier,
                            uiEntity.contentItem.serviceIdentifier,
                            characteristic.identifier,
                            1)
                        .then((response) {
                      final int code = response['code'];
                      if (code != 0) {
                        final String messageType =
                            DefinedLocalizations.of(context).error;
                        final String message = response['message'];
                        _displayMessage(messageType, message, context);
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
}

class _DeviceDetailGroup {
  final List<_UiEntity> _uiEntities = List<_UiEntity>();

  void addName(int name) {
    //这一步是为了给_uiEntities加东西  其实可以写成 _DeviceDetailGroup._uiEntities.add
    _uiEntities.add(_BtUiEntity(type: name));
  }

  void addCharacteristic(Characteristic characteristic) {
    _uiEntities.add(_ContentUiEntity(contentItem: characteristic));
  }

  _UiEntity getUiEntity(int index) => _uiEntities.elementAt(index);

  int get size => _uiEntities.length;
}

class _UiEntity {}

class _BtUiEntity extends _UiEntity {
  final int type;
  _BtUiEntity({
    this.type,
  });
}

class _ContentUiEntity extends _UiEntity {
  final Characteristic contentItem;
  _ContentUiEntity({
    this.contentItem,
  });
}
