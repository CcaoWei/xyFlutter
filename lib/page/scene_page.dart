import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/widget/scene_view.dart';
import 'package:xlive/widget/notification_view.dart';
import 'package:xlive/widget/scene_device_view.dart';
import 'package:xlive/widget/scene_text_view.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/session/session.dart';
import 'package:xlive/firmware/firmware_manager.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'dart:async';

import 'scene_edit_page.dart';
import 'common_page.dart';

const int ON = 0;
const int OFF = 1;
const int ALARM = 2;
const int DISALARM = 3;

const int LIGHT = 0;
const int PLUG = 1;
const int PIR = 2;
const int DOOR_CONTACT = 3;

const double DEVICE_PADDING_BOTTOM = 35.0;
const int POSITION_DURATION = 300;
const int OPACITY_DURATION = 300;

class ScenePage extends StatefulWidget {
  State<StatefulWidget> createState() => _SceneState();
}

class _SceneState extends State<ScenePage> with TickerProviderStateMixin {
  static const String className = 'ScenePage';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  final List<_UiEntity> uiEntities = List();
  List<_UiEntity> get sortedUiEntities {
    uiEntities.sort((a, b) {
      return a.scene.uuid.compareTo(b.scene.uuid);
    });
    return uiEntities;
  }

  StreamSubscription subscription;
  Timer timer;

  final List<DeviceAttributeReportEvent> eventList = List();

  int deviceIndex = 0;

  void initState() {
    super.initState();
    resetData();
    start();
    startTimer();
  }

  void resetData() {
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    uiEntities.clear();

    final List<Scene> scenes = cache.scenes;
    for (var scene in scenes) {
      uiEntities.add(_UiEntity(scene: scene));
    }

    setState(() {});
  }

  void start() {
    subscription = RxBus().toObservable().where((event) {
      if (event is HomeCenterCacheEvent) {
        return event.homeCenterUuid ==
            HomeCenterManager().defaultHomeCenterUuid;
      } else {
        return true;
      }
    }).listen((event) {
      if (event is HomeCenterEvent) {
        if (event.type == HOME_CENTER_CHANGED) {
          resetData();
        }
      } else if (event is DeviceAttributeReportEvent) {
        processDeviceAttributeReportEvent(event);
      } else if (event is SceneOnOffStatusChangedEvent) {
        resetData();
      } else if (event is SceneDeleteEvent) {
        resetData();
      } else if (event is SceneCreateEvent) {
        resetData();
      } else if (event is SessionStateChangedEvent) {
        resetData();
      } else if (event is GetEntityCompletedEvent) {
        resetData();
      }
      // else if (event is AssociationMessage) {
      //   if (event.isDefaultHomeCenterRemoved) {

      //     if (Navigator.of(context).history.last.settings.name != '/HomeCenterDetail') {
      //       displayMessage(event.deviceUuid, event.deviceName);
      //     }
      //   }
      // }
    });
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  void processDeviceAttributeReportEvent(DeviceAttributeReportEvent event) {
    final String methodName = 'processDeviceAttributeReportEvent';
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    final Entity entity = cache.findEntity(event.uuid);
    if (entity is LogicDevice) {
      if (event.attrId == ATTRIBUTE_ID_ON_OFF_STATUS) {
        if (entity.profile == PROFILE_ON_OFF_LIGHT ||
            entity.profile == PROFILE_SMART_PLUG) {
          eventList.add(event);
        }
      } else if (event.attrId == ATTRIBUTE_ID_ALERT_LEVEL) {
        if (entity.profile == PROFILE_PIR ||
            entity.profile == PROFILE_DOOR_CONTACT) {
          eventList.add(event);
        }
      }
    }
  }

  void startTimer() {
    final String methodName = 'startTimer';
    if (timer == null) {
      timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        if (eventList.isEmpty) {
          RxBus().post(
            SceneDeviceAnimationEvent(deviceType: -1, state: -1),
          );
          return;
        }
        final HomeCenterCache cache =
            HomeCenterManager().defaultHomeCenterCache;
        if (cache == null) return;
        if (deviceIndex < 4) {
          final DeviceAttributeReportEvent event = eventList[0];
          final Entity entity = cache.findEntity(event.uuid);
          if (entity is LogicDevice) {
            if (entity.profile == PROFILE_ON_OFF_LIGHT) {
              RxBus().post(SceneTextAnimationEvent(
                name: entity.getName(),
                state: event.attrValue == 1 ? ON : OFF,
              ));
              RxBus().post(
                SceneDeviceAnimationEvent(
                  deviceType: LIGHT,
                  state: event.attrValue,
                ),
              );
            } else if (entity.profile == PROFILE_SMART_PLUG) {
              RxBus().post(SceneTextAnimationEvent(
                name: entity.getName(),
                state: event.attrValue == 1 ? ON : OFF,
              ));
              RxBus().post(
                SceneDeviceAnimationEvent(
                  deviceType: PLUG,
                  state: event.attrValue,
                ),
              );
            } else if (entity.profile == PROFILE_PIR) {
              RxBus().post(SceneTextAnimationEvent(
                name: entity.getName(),
                state: event.attrValue == 1 ? ALARM : DISALARM,
              ));
              RxBus().post(
                SceneDeviceAnimationEvent(
                  deviceType: PIR,
                  state: event.attrValue,
                ),
              );
            } else if (entity.profile == PROFILE_DOOR_CONTACT) {
              RxBus().post(SceneTextAnimationEvent(
                name: entity.getName(),
                state: event.attrValue == 1 ? ALARM : DISALARM,
              ));
              RxBus().post(
                SceneDeviceAnimationEvent(
                  deviceType: DOOR_CONTACT,
                  state: event.attrValue,
                ),
              );
            }
          }
          eventList.removeAt(0);
        }
      });
    }
  }

  bool get showIndicatorRedPoint {
    final List<HomeCenter> temp1 = HomeCenterManager().localFoundHomeCenters;
    for (HomeCenter homeCenter in temp1) {
      if (homeCenter.state == ASSOCIATION_TYPE_NONE) return true;
    }
    final Map<String, HomeCenter> temp2 = HomeCenterManager().homeCenters;
    for (String uuid in temp2.keys) {
      final int number = FirmwareManager().numberOfDevicesCanUpgrade(uuid);
      if (number > 0) return true;
    }
    return false;
  }

  void setSceneOnOff(BuildContext context, String sceneUuid) {
    final String methodName = 'setSceneOnOff';
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.setSceneOnOff(homeCenterUuid, sceneUuid, 2).listen((response) {
      if (response is SetSceneOnOffResponse) {
        if (response.isSceneEmpty) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).sceneEmpty,
          );
        }
        log.d('set scene on off response: ${response.code}', methodName);
      }
    });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: HomeCenterManager().defaultHomeCenter == null
          ? DefinedLocalizations.of(context).scene
          : HomeCenterManager().defaultHomeCenter.getName(),
      showBackIcon: false,
      showMenuIcon: true,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: Adapt.px(250),
          alignment: Alignment.centerRight,
          height: kToolbarHeight,
          child: Text(
            DefinedLocalizations.of(context).addScene,
            style: TEXT_STYLE_ADD_TEXT,
          ),
        ),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (BuildContext context) => SceneEditPage(sceneUuid: ''),
              settings: RouteSettings(
                name: '/SceneEdit',
              ),
            ),
          );
        },
      ),
      showRedPoint: showIndicatorRedPoint,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationView(),
          SceneTextView(),
          SceneDeviceView(
            onDeviceIndexChanged: (int index) {
              deviceIndex = index;
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0),
              itemCount: uiEntities.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return buildItem(context, sortedUiEntities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, _UiEntity uiEntity) {
    final String methodName = 'buildItem';
    return SceneView(
        scene: uiEntity.scene,
        //click
        onClick: () {
          setSceneOnOff(context, uiEntity.scene.uuid);
        },
        //longPress
        onLongClick: () {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (context) =>
                  SceneEditPage(sceneUuid: uiEntity.scene.uuid),
              settings: RouteSettings(
                name: '/SceneEdit',
              ),
            ),
          );
        });
  }
}

class _UiEntity {
  final Scene scene;

  _UiEntity({@required this.scene});

  String get imageUrl {
    if (scene.uuid == 'scene-000001') {
      return scene.isOn
          ? 'images/scene_home_on.png'
          : 'images/scene_home_off.png';
    } else if (scene.uuid == 'scene-000002') {
      return scene.isOn
          ? 'images/scene_leave_on.png'
          : 'images/scene_leave_off.png';
    } else if (scene.uuid == 'scene-000003') {
      return scene.isOn ? 'images/scene_up_on.png' : 'images/scene_up_off.png';
    } else if (scene.uuid == 'scene-000004') {
      return scene.isOn
          ? 'images/scene_sleep_on.png'
          : 'images/scene_sleep_off.png';
    } else {
      return scene.isOn
          ? 'images/defined_scene_on.png'
          : 'images/defined_scene.png';
    }
  }
}

class SceneTextAnimationEvent {
  final String name;
  final int state;

  SceneTextAnimationEvent({
    @required this.name,
    @required this.state,
  });
}

class SceneDeviceAnimationEvent {
  final int deviceType;
  final int state;

  SceneDeviceAnimationEvent({
    @required this.deviceType,
    @required this.state,
  });
}
