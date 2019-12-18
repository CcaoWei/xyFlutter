import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:xlive/const/adapt.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/widget/switch_button.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

import 'dart:async';

class SceneEditPage extends StatefulWidget {
  final String sceneUuid;

  SceneEditPage({@required this.sceneUuid});

  State<StatefulWidget> createState() => _SceneEditState();
}

class _SceneEditState extends State<SceneEditPage> {
  static const String className = 'SceneEditPage';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  Scene scene;

  final List<_Group> groups = List();

  final TextEditingController nameController = TextEditingController();

  bool editButtonShown = false;
  bool isDeleteButtonShown = false;

  List<_Group> get sortedGroups {
    groups.sort((a, b) {
      if (a is _Footer) return 1;
      if (b is _Footer) return -1;
      final _DeviceGroup deviceGroupA = a as _DeviceGroup;
      final _DeviceGroup deviceGroupB = b as _DeviceGroup;
      if (deviceGroupA.roomUuid == DEFAULT_ROOM) return 1;
      if (deviceGroupB.roomUuid == DEFAULT_ROOM) return -1;
      return deviceGroupA.roomUuid.compareTo(deviceGroupB.roomUuid);
    });
    return groups;
  }

  StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (scene != null &&
        (nameController.text == '' || nameController.text == null)) {
      nameController.text = scene.getSceneName(context);
    }
  }

  void resetData() {
    final String methodName = 'resetData';
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    groups.clear();

    if (widget.sceneUuid == null || widget.sceneUuid == '') {
      scene = null;
      isDeleteButtonShown = false;
    } else {
      final Entity entity = cache.findEntity(widget.sceneUuid);
      if (entity != null && entity is Scene) {
        scene = entity;
        //nameController.text = scene.getSceneName(context);
        if (scene.isDefault) {
          isDeleteButtonShown = false;
        } else {
          isDeleteButtonShown = true;
        }
      } else {
        scene = null;
        isDeleteButtonShown = true;
      }
    }

    final List<Room> rooms = cache.rooms;
    bool hasDefaultRoom = false;
    for (var room in rooms) {
      if (room.uuid == DEFAULT_ROOM) {
        hasDefaultRoom = true;
      }
      groups.add(_DeviceGroup(room));
    }
    if (!hasDefaultRoom) {
      groups.add(_DeviceGroup(Room(uuid: DEFAULT_ROOM, name: '')));
    }
    groups.add(_Footer());

    final List<PhysicDevice> physicDevices = cache.addedDevices;
    for (var pd in physicDevices) {
      if (pd.isWallSwitch || pd.isWallSwitchUS) {
        for (var ld in pd.logicDevices) {
          if (ld.isOnOffLight) {
            _DeviceGroup deviceGroup;
            if (ld.roomUuid == null || ld.roomUuid == '') {
              deviceGroup = findDeviceGroup(pd.roomUuid);
            } else {
              deviceGroup = findDeviceGroup(ld.roomUuid);
            }
            if (deviceGroup != null) {
              deviceGroup.add(ld);
            }
          }
        }
      } else {
        for (var ld in pd.logicDevices) {
          if (ld.isSmartDial) continue;
          if (ld.isZHHVRVGateway) continue;
          if (ld.isIndoorUnit) continue;
          _DeviceGroup deviceGroup;
          if (ld.roomUuid == null || ld.roomUuid == '') {
            deviceGroup = findDeviceGroup(pd.roomUuid);
          } else {
            deviceGroup = findDeviceGroup(ld.roomUuid);
          }
          if (deviceGroup != null) {
            deviceGroup.add(ld);
          }
        }
      }
    }

    if (scene != null) {
      if (scene.isEmpty) {
        if (scene.uuid == SCENE_HOME) {
          for (_Group group in groups) {
            if (group is _DeviceGroup) {
              group.homeSceneDefaultSettings();
            }
          }
        } else if (scene.uuid == SCENE_LEAVING) {
          for (_Group group in groups) {
            if (group is _DeviceGroup) {
              group.leavingSceneDefaultSettings();
            }
          }
        }
      } else {
        final List<xyAction> actions = scene.actions;
        for (var group in groups) {
          if (group is _Footer) continue;
          final _DeviceGroup deviceGroup = group as _DeviceGroup;
          deviceGroup.fillActions(actions);
        }
      }
    }
    //checkEditResult();
    setState(() {});
  }

  void start() {
    final String methodName = 'start';
    subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is PhysicDeviceAvailableEvent || event is DeviceDeleteEvent)
        .where((event) =>
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
        .listen((event) {
      if (event is PhysicDeviceAvailableEvent) {
        final String uuid = event.uuid;
        final HomeCenterCache cache =
            HomeCenterManager().defaultHomeCenterCache;
        if (cache == null) return;
        final Entity entity = cache.findEntity(uuid);
        if (entity is PhysicDevice) {
          if (entity.isWallSwitch) {
            for (var ld in entity.logicDevices) {
              _DeviceGroup deviceGroup;
              if (ld.profile == PROFILE_ON_OFF_LIGHT) {
                if (ld.roomUuid == null || ld.roomUuid == '') {
                  deviceGroup = findDeviceGroup(entity.roomUuid);
                } else {
                  deviceGroup = findDeviceGroup(ld.roomUuid);
                }
                deviceGroup.add(ld);
              }
            }
          } else {
            for (var ld in entity.logicDevices) {
              _DeviceGroup deviceGroup = findDeviceGroup(ld.roomUuid);
              deviceGroup.add(ld);
            }
          }
          setState(() {});
        }
      } else if (event is DeviceDeleteEvent) {
        final Entity entity = event.entity;
        if (entity is PhysicDevice) {
          for (var group in groups) {
            if (group is _Footer) continue;
            final _DeviceGroup deviceGroup = group as _DeviceGroup;
            deviceGroup.removeDevices(entity.logicDevices);
          }
          setState(() {});
        } else if (entity is LogicDevice) {
          final _DeviceGroup deviceGroup = findDeviceGroup(entity.roomUuid);
          deviceGroup.removeDevice(entity);
        }
      } else if (event is SceneDeleteEvent) {
        if (event.uuid == widget.sceneUuid) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    });
  }

  _DeviceGroup findDeviceGroup(String roomUuid) {
    _DeviceGroup defaultGroup;
    for (var group in groups) {
      if (group is _Footer) continue;
      final _DeviceGroup deviceGroup = group as _DeviceGroup;
      if (deviceGroup.roomUuid == roomUuid) return deviceGroup;
      if (deviceGroup.roomUuid == DEFAULT_ROOM) {
        defaultGroup = deviceGroup;
      }
    }
    return defaultGroup;
  }

  _DeviceGroup findDeviceGroupByUiEntity(_UiEntity uiEntity) {
    for (var group in groups) {
      if (group is _DeviceGroup) {
        for (_UiEntity ue in group.uiEntities) {
          if (ue == uiEntity) return group;
        }
      }
    }
    return null;
  }

  // void checkEditResult() {
  //   final List<Action> currentActions = getActions();
  //   if (scene == null) {
  //     editButtonShown = currentActions.length > 0;
  //   } else {
  //     final List<Action> originActions = scene.actions;
  //     if (currentActions.length != originActions.length) {
  //       editButtonShown = true;
  //     } else {
  //       for (var action in currentActions) {
  //         if (!isActionInActions(action, originActions)) {
  //           editButtonShown = true;
  //           return;
  //         }
  //       }
  //       editButtonShown = false;
  //     }
  //   }
  // }

  bool isActionInActions(xyAction action, List<xyAction> actions) {
    for (var temp in actions) {
      if (action.uuid == temp.uuid &&
          action.attrId == temp.attrId &&
          action.attrValue == temp.attrValue) {
        return true;
      }
    }
    return false;
  }

  List<xyAction> getActions() {
    final List<xyAction> actions = List();
    for (var group in groups) {
      if (group is _Footer) continue;
      final _DeviceGroup deviceGroup = group as _DeviceGroup;
      actions.addAll(deviceGroup.actions);
    }
    return actions;
  }

  void createScene(BuildContext context) {
    if (scene != null) return;
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    final Scene newScene = Scene(uuid: '', name: nameController.text);
    newScene.actions = getActions();
    MqttProxy.createScene(homeCenterUuid, newScene).listen((response) {
      if (response is CreateSceneResponse) {
        if (response.success) {
          Navigator.of(context, rootNavigator: true).pop();
        } else if (response.code == 29) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).sceneNameExist,
          );
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        }
      }
    });
  }

  void updateScene(BuildContext context) {
    final String methodName = 'updateScene';
    if (scene == null) return;
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    final Scene newScene = Scene(uuid: scene.uuid, name: nameController.text);
    newScene.actions = getActions();
    MqttProxy.updateScene(homeCenterUuid, newScene).listen((response) {
      if (response is UpdateSceneResponse) {
        if (response.success) {
          Navigator.of(context, rootNavigator: true).pop();
        } else if (response.code == 29) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).sceneNameExist,
          );
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        }
      }
    });
  }

  void deleteScene(BuildContext context) {
    final String methodName = 'deleteScene';
    if (widget.sceneUuid == null || widget.sceneUuid == '') return;
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.deleteScene(homeCenterUuid, widget.sceneUuid).listen((response) {
      if (response is DeleteSceneResponse) {
        if (response.success) {
          Navigator.of(context).pop();
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        }
      }
    });
  }

  int get itemCount {
    int size = 0;
    for (var group in groups) {
      size += group.size();
    }
    return size;
  }

  _UiEntity getItem(int index) {
    int step = 0;
    for (var group in sortedGroups) {
      if (index >= step && index < step + group.size()) {
        return group.get(index - step);
      } else {
        step += group.size();
      }
    }
    return null;
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).sceneEdit,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Offstage(
          offstage: false,
          child: Container(
            width: kToolbarHeight,
            height: kToolbarHeight,
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.only(left: OK_BUTTON_LEFT_PADDING),
              child: Image(
                width: 21.0,
                height: 20.0,
                image: AssetImage('images/edit_done.png'),
              ),
            ),
          ),
        ),
        onTap: () {
          if (nameController.text == null || nameController.text == '') {
            Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).inputSceneNameHint,
            );
          } else if (getActions().length == 0) {
            Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).sceneNoActions,
            );
          } else {
            if (scene == null) {
              createScene(context);
            } else {
              updateScene(context);
            }
          }
        },
      ),
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    final double paddingTop =
        MediaQuery.of(context).padding.top; // + kToolbarHeight + 10.0;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: paddingTop),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText:
                        DefinedLocalizations.of(context).inputSceneNameHint,
                    hintStyle: TEXT_STYLE_INPUT_HINT,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: const Color(0xFFD9D9D9)),
                    ),
                  ),
                  onChanged: (String s) {},
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Image(
                    width: 17.0,
                    height: 14.0,
                    image: AssetImage('images/edit_flag.png'),
                  ),
                  onTap: () {
                    nameController.text = '';
                    setState(() {});
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: itemCount,
                itemBuilder: (BuildContext context, int index) {
                  return buildItem(context, getItem(index));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, _UiEntity uiEntity) {
    if (uiEntity is _GroupUiEntity) {
      return buildGroupItem(context, uiEntity);
    } else if (uiEntity is _DeviceUiEntity) {
      return buildDeviceItem(context, uiEntity);
    } else if (uiEntity is _FooterUiEntity) {
      return buildFooter(context, uiEntity);
    } else {
      return Container();
    }
  }

  Widget buildGroupItem(BuildContext context, _GroupUiEntity uiEntity) {
    final _DeviceGroup group = findDeviceGroupByUiEntity(uiEntity);
    return Container(
      height: 24.0,
      color: const Color(0xFFFFFFFF),
      margin: EdgeInsets.only(top: 5.0, bottom: 2.5),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 100.0,
              child: Text(
                uiEntity.room.getRoomName(context),
                style: TEXT_STYLE_ROOM_NAME,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 150.0,
              child: Offstage(
                offstage: group == null ? true : group.showRightButton,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 24.0,
                        alignment: Alignment.center,
                        child: Text(
                          DefinedLocalizations.of(context).selectAllOpen,
                          style: TextStyle(
                            inherit: false,
                            color: const Color(0xFF7CD0FF),
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (group != null) {
                          group.selectAllOpen();
                          group.showRightButton = true;
                          setState(() {});
                        }
                      },
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 24.0,
                        alignment: Alignment.center,
                        child: Text(
                          DefinedLocalizations.of(context).selectAllClosed,
                          style: TextStyle(
                            inherit: false,
                            color: const Color(0xFF7CD0FF),
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (group != null) {
                          group.selectAllClosed();
                          group.showRightButton = true;
                          setState(() {});
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Container(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Offstage(
                  offstage: group == null ? true : !group.showRightButton,
                  child: Container(
                    height: 24.0,
                    child: Text(
                      group.isAllSelected
                          ? DefinedLocalizations.of(context).cancelSelectAll
                          : DefinedLocalizations.of(context).selectAll,
                      style: TextStyle(
                        inherit: false,
                        fontSize: 14.0,
                        color: const Color(0xFF7CD0FF),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (group != null) {
                    if (group.isAllSelected) {
                      group.cancelSelectAll();
                    } else {
                      group.selectAll();
                    }
                    setState(() {});
                  }
                },
                onLongPress: () {
                  if (group != null) {
                    group.showRightButton = false;
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeviceItem(BuildContext context, _DeviceUiEntity uiEntity) {
    final _DeviceGroup group = findDeviceGroupByUiEntity(uiEntity);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: const Color(0xFFF9F9F9),
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        padding: EdgeInsets.only(left: 13.0, right: 0.0),
        height: 80.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 21.0,
                  height: 21.0,
                  alignment: Alignment.center,
                  child: Image(
                    width: uiEntity.isSelected ? 21.0 : 10.5,
                    height: uiEntity.isSelected ? 21.0 : 10.5,
                    image: AssetImage(uiEntity.checkImageUrl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Container(
                  width: 40.0,
                  height: 40.0,
                  alignment: Alignment.center,
                  child: buildDeviceIcon(context, uiEntity),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Container(
                  width: 0.3 * MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    uiEntity.logicDevice.getName(),
                    style: TEXT_STYLE_BINDING_DEVICE_NAME,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SwitchButton(
              activeColor: uiEntity.showText
                  ? const Color(0xFFFFB34D)
                  : const Color(0xFF7CD0FF),
              value: uiEntity.isButtonChecked,
              showIndicator: false,
              showText: uiEntity.showText,
              onText: DefinedLocalizations.of(context).alarm,
              offText: DefinedLocalizations.of(context).disalarm,
              onChanged: (bool value) {
                uiEntity.isButtonChecked = value;
                if (value) {
                  uiEntity.isSelected = true;
                }
                //checkEditResult();
                setState(() {});
              },
            ),
          ],
        ),
      ),
      onTap: () {
        uiEntity.isSelected = !uiEntity.isSelected;
        if (!uiEntity.isSelected) {
          uiEntity.isButtonChecked = false;
        }
        if (group != null) {
          group.showRightButton = true;
        }
        //checkEditResult();
        setState(() {});
      },
    );
  }

  Image buildDeviceIcon(BuildContext context, _DeviceUiEntity uiEntity) {
    print(uiEntity.logicDevice.profile);
    if (uiEntity.logicDevice.profile == PROFILE_ON_OFF_LIGHT ||
        uiEntity.logicDevice.profile == PROFILE_EXTENDED_COLOR_LIGHT) {
      if (uiEntity.logicDevice.parent.isSwitchModule) {
        return Image(
          width: 35.0,
          height: 36.0,
          image: AssetImage(uiEntity.logicDevice.uuid.contains("-01")
              ? 'images/icon_sm_output1.png'
              : 'images/icon_sm_output2.png'),
        );
      } else {
        return Image(
          width: 35.0,
          height: 36.0,
          image: AssetImage(uiEntity.isButtonChecked
              ? 'images/icon_light_on.png'
              : 'images/icon_light_off.png'),
        );
      }
    } else if (uiEntity.logicDevice.profile == PROFILE_SMART_PLUG) {
      return Image(
        width: 25.0,
        height: 25.0,
        image: AssetImage(uiEntity.isButtonChecked
            ? 'images/icon_plug_on.png'
            : 'images/icon_plug_off.png'),
      );
    } else if (uiEntity.logicDevice.profile == PROFILE_PIR) {
      return Image(
        width: 25.0,
        height: 25.0,
        image: AssetImage('images/icon_pir.png'),
      );
    } else if (uiEntity.logicDevice.profile == PROFILE_DOOR_CONTACT) {
      return Image(
        width: 24.0,
        height: 24.0,
        image: AssetImage('images/icon_dc.png'),
      );
    } else if (uiEntity.logicDevice.profile == PROFILE_WINDOW_CORVERING) {
      return Image(
        width: 25.0,
        height: 22.0,
        image: AssetImage('images/icon_curtain.png'),
      );
    } else {
      return Image(
        image: AssetImage(''),
      );
    }
  }

  Widget buildFooter(BuildContext context, _FooterUiEntity uiEntity) {
    return Offstage(
      offstage: !isDeleteButtonShown,
      child: Container(
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
            showDialog(
              context: context,
              child: CupertinoAlertDialog(
                title: Text(
                  DefinedLocalizations.of(context).sureToDeleteScene,
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
                      deleteScene(context);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

abstract class _Group {
  int size();

  _UiEntity get(int index);
}

class _DeviceGroup extends _Group {
  final List<_UiEntity> _uiEntities = List();

  bool showRightButton = true;

  List<_UiEntity> get uiEntities {
    _uiEntities.sort((a, b) {
      if (a is _GroupUiEntity) return -1;
      if (b is _GroupUiEntity) return 1;
      final _DeviceUiEntity deviceA = a as _DeviceUiEntity;
      final _DeviceUiEntity deviceB = b as _DeviceUiEntity;
      return deviceA.logicDevice.uuid.compareTo(deviceB.logicDevice.uuid);
    });
    return _uiEntities;
  }

  _DeviceGroup(Room room) {
    _uiEntities.add(_GroupUiEntity(room));
  }

  String get roomUuid {
    if (uiEntities[0] is _GroupUiEntity) {
      final _GroupUiEntity groupUiEntity = uiEntities[0] as _GroupUiEntity;
      return groupUiEntity.room.uuid;
    }
    return '';
  }

  void add(LogicDevice logicDevice) {
    _uiEntities.add(_DeviceUiEntity(logicDevice: logicDevice));
  }

  int size() => _uiEntities.length < 2 ? 0 : _uiEntities.length;

  _UiEntity get(index) => uiEntities[index];

  List<xyAction> get actions {
    final List<xyAction> actions = List();
    for (var uiEntity in _uiEntities) {
      if (uiEntity is _GroupUiEntity) continue;
      final _DeviceUiEntity deviceUiEntity = uiEntity as _DeviceUiEntity;
      if (deviceUiEntity.isSelected) {
        final String uuid = deviceUiEntity.logicDevice.uuid;
        if (deviceUiEntity.logicDevice.profile == PROFILE_ON_OFF_LIGHT ||
            deviceUiEntity.logicDevice.profile == PROFILE_SMART_PLUG ||
            deviceUiEntity.logicDevice.profile ==
                PROFILE_EXTENDED_COLOR_LIGHT) {
          final int attrId = ATTRIBUTE_ID_ON_OFF_STATUS;
          final int attrValue = (deviceUiEntity.isButtonChecked ? 1 : 0);
          final xyAction action =
              xyAction(uuid: uuid, attrId: attrId, attrValue: attrValue);
          actions.add(action);
        } else if (deviceUiEntity.logicDevice.profile == PROFILE_PIR ||
            deviceUiEntity.logicDevice.profile == PROFILE_DOOR_CONTACT) {
          final int attrId = ATTRIBUTE_ID_ALERT_LEVEL;
          final int attrValue = (deviceUiEntity.isButtonChecked ? 1 : 0);
          final xyAction action =
              xyAction(uuid: uuid, attrId: attrId, attrValue: attrValue);
          actions.add(action);
        } else if (deviceUiEntity.logicDevice.profile ==
            PROFILE_WINDOW_CORVERING) {
          final int attrId = ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION;
          final int attrValue = (deviceUiEntity.isButtonChecked ? 100 : 0);
          final xyAction action =
              xyAction(uuid: uuid, attrId: attrId, attrValue: attrValue);
          actions.add(action);
        }
      }
    }
    return actions;
  }

  bool get isAllSelected {
    for (_UiEntity uiEntity in _uiEntities) {
      if (uiEntity is _GroupUiEntity) continue;
      final _DeviceUiEntity deviceUiEntity = uiEntity as _DeviceUiEntity;
      if (!deviceUiEntity.isSelected) return false;
    }
    return true;
  }

  void fillActions(List<xyAction> actions) {
    for (var action in actions) {
      for (var uiEntity in _uiEntities) {
        if (uiEntity is _GroupUiEntity) continue;
        final _DeviceUiEntity deviceUiEntity = uiEntity as _DeviceUiEntity;
        if (deviceUiEntity.logicDevice.uuid == action.uuid) {
          if (action.attrId == ATTRIBUTE_ID_ON_OFF_STATUS ||
              action.attrId == ATTRIBUTE_ID_ALERT_LEVEL) {
            deviceUiEntity.isButtonChecked = action.attrValue == 1;
            deviceUiEntity.isSelected = true;
          } else if (action.attrId == ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION) {
            deviceUiEntity.isButtonChecked = action.attrValue == 100;
            deviceUiEntity.isSelected = true;
          }
        }
      }
    }
  }

  void removeDevice(LogicDevice logicDevice) {
    _DeviceUiEntity toBeRemoved;
    for (var uiEntity in _uiEntities) {
      if (uiEntity is _GroupUiEntity) continue;
      final _DeviceUiEntity deviceUiEntity = uiEntity as _DeviceUiEntity;
      if (deviceUiEntity.logicDevice.uuid == logicDevice.uuid) {
        toBeRemoved = deviceUiEntity;
        break;
      }
    }
    if (toBeRemoved != null) {
      _uiEntities.remove(toBeRemoved);
    }
  }

  void removeDevices(List<LogicDevice> logicDevices) {
    for (var ld in logicDevices) {
      _DeviceUiEntity toBeRemoved;
      if (ld.profile == PROFILE_YAN_BUTTON) continue;
      for (var uiEntity in _uiEntities) {
        if (uiEntity is _GroupUiEntity) continue;
        final _DeviceUiEntity deviceUiEntity = uiEntity as _DeviceUiEntity;
        if (deviceUiEntity.logicDevice.uuid == ld.uuid) {
          toBeRemoved = deviceUiEntity;
        }
      }
      if (toBeRemoved != null) {
        _uiEntities.remove(toBeRemoved);
      }
    }
  }

  void selectAll() {
    for (_UiEntity uiEntity in _uiEntities) {
      if (uiEntity is _DeviceUiEntity) {
        uiEntity.isSelected = true;
      }
    }
  }

  void cancelSelectAll() {
    for (_UiEntity uiEntity in _uiEntities) {
      if (uiEntity is _DeviceUiEntity) {
        uiEntity.isSelected = false;
      }
    }
  }

  void selectAllOpen() {
    for (_UiEntity uiEntity in _uiEntities) {
      if (uiEntity is _DeviceUiEntity) {
        uiEntity.isSelected = true;
        uiEntity.isButtonChecked = true;
      }
    }
  }

  void selectAllClosed() {
    for (_UiEntity uiEntity in _uiEntities) {
      if (uiEntity is _DeviceUiEntity) {
        uiEntity.isSelected = true;
        uiEntity.isButtonChecked = false;
      }
    }
  }

  void homeSceneDefaultSettings() {
    for (_UiEntity uiEntity in _uiEntities) {
      if (uiEntity is _DeviceUiEntity) {
        if (uiEntity.logicDevice.isAwarenessSwitch ||
            uiEntity.logicDevice.isDoorContact) {
          uiEntity.isSelected = true;
          uiEntity.isButtonChecked = false;
        } else if (uiEntity.logicDevice.isOnOffLight ||
            uiEntity.logicDevice.isSmartPlug ||
            uiEntity.logicDevice.isCurtain) {
          uiEntity.isSelected = true;
          uiEntity.isButtonChecked = true;
        }
      }
    }
  }

  void leavingSceneDefaultSettings() {
    for (_UiEntity uiEntity in _uiEntities) {
      if (uiEntity is _DeviceUiEntity) {
        if (uiEntity.logicDevice.isAwarenessSwitch ||
            uiEntity.logicDevice.isDoorContact) {
          uiEntity.isSelected = true;
          uiEntity.isButtonChecked = true;
        } else if (uiEntity.logicDevice.isOnOffLight ||
            uiEntity.logicDevice.isSmartPlug ||
            uiEntity.logicDevice.isCurtain) {
          uiEntity.isSelected = true;
          uiEntity.isButtonChecked = false;
        }
      }
    }
  }
}

class _Footer extends _Group {
  final _FooterUiEntity footerUiEntity = _FooterUiEntity();

  int size() => 1;

  _FooterUiEntity get(index) => footerUiEntity;
}

class _UiEntity {}

class _GroupUiEntity extends _UiEntity {
  final Room room;

  _GroupUiEntity(this.room);
}

class _DeviceUiEntity extends _UiEntity {
  final LogicDevice logicDevice;

  bool isSelected = false;
  bool isButtonChecked = false;

  _DeviceUiEntity({@required this.logicDevice});

  bool get showText =>
      logicDevice.isAwarenessSwitch || logicDevice.isDoorContact;

  String get checkImageUrl {
    return isSelected ? 'images/icon_check.png' : 'images/icon_uncheck.png';
  }
}

class _FooterUiEntity extends _UiEntity {}
