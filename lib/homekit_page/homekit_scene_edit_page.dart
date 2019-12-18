import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/const_shared.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/widget/switch_button.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;

class HomekitSceneEditPage extends StatefulWidget {
  final String actionSetIdentifier;

  HomekitSceneEditPage({
    @required this.actionSetIdentifier,
  });

  State<StatefulWidget> createState() => _HomekitSceneEditState();
}

class _HomekitSceneEditState extends State<HomekitSceneEditPage> {
  final List<_UiEntity> uiEntities = List();

  void initState() {
    super.initState();
    resetData();
  }

  void dispose() {
    super.dispose();
  }

  void resetData() {
    final Home home = HomeManager().primaryHome;
    if (home == null) return;
    uiEntities.clear();

    final List<Accessory> accessories = home.accessories;
    for (Accessory accessory in accessories) {
      if (accessory.isLightSocket) {
        final Service service = accessory.findServiceByType(S_LIGHT_SOCKET);
        final _UiEntity uiEntity = _UiEntity(
          accessory: accessory,
          service: service,
        );
        uiEntities.add(uiEntity);
      } else if (accessory.isSmartPlug) {
        final Service service = accessory.findServiceByType(S_PLUG);
        final _UiEntity uiEntity = _UiEntity(
          accessory: accessory,
          service: service,
        );
        uiEntities.add(uiEntity);
      } else if (accessory.isWallSwitch ||
          accessory.isWallSwitchUS ||
          accessory.isSwitchModule) {
        for (Service service in accessory.services) {
          if (service.type == S_WALL_SWITCH_LIGHT) {
            final _UiEntity uiEntity = _UiEntity(
              accessory: accessory,
              service: service,
            );
            uiEntities.add(uiEntity);
          }
        }
      } else if (accessory.isCurtain) {
        final Service service = accessory.findServiceByType(S_CURTAIN);
        final _UiEntity uiEntity = _UiEntity(
          accessory: accessory,
          service: service,
        );
        uiEntities.add(uiEntity);
      }
    }

    final ActionSet actionSet = home.findActionSet(widget.actionSetIdentifier);
    if (actionSet != null) {
      for (xyAction action in actionSet.actions) {
        if (action.characteristic == null) continue;
        for (_UiEntity uiEntity in uiEntities) {
          if (uiEntity.characteristic == null) continue;
          if (action.characteristic.identifier ==
              uiEntity.characteristic.identifier) {
            uiEntity.selected = true;
            uiEntity.isButtonChecked = action.isButtonChecked;
          }
        }
      }
    }
    setState(() {});
  }

  void checkActionSet() {
    final Home home = HomeManager().primaryHome;
    if (home == null) return;
    final ActionSet actionSet = home.findActionSet(widget.actionSetIdentifier);
    if (actionSet == null) return;
    for (_UiEntity uiEntity in uiEntities) {
      if (!uiEntity.selected) {
        final xyAction action = actionSet.findActionByCharacteristicIdentifier(
            uiEntity.characteristisIdentifier);
        if (action != null) {
          final String homeIdentifier = home.identifier;
          final String actionSetIdentifier = actionSet.identifier;
          final String actionIdentifier = action.identifier;
          methodChannel.removeAction(
              homeIdentifier, actionSetIdentifier, actionIdentifier);
          // methodChannel.removeAction(homeIdentifier, actionSetIdentifier, actionIdentifier)
          //     .then((response) {
          //       final int code = response['code'];
          //       print('remove action code: $code');
          //     });
        }
      } else {
        final xyAction action = actionSet.findActionByCharacteristicIdentifier(
            uiEntity.characteristisIdentifier);
        if (action == null) {
          final String homeIdentifier = home.identifier;
          final String actionSetIdentifier = actionSet.identifier;
          final String accessoryIdentifier = uiEntity.accessory.identifier;
          final String serviceIdentifier = uiEntity.service.identifier;
          final String characteristicIdentifier =
              uiEntity.characteristisIdentifier;
          final int targetValue = uiEntity.targetValue;
          print('target value -> $targetValue');
          methodChannel.addAction(
              homeIdentifier,
              actionSetIdentifier,
              accessoryIdentifier,
              serviceIdentifier,
              characteristicIdentifier,
              targetValue);
          // methodChannel.addAction(homeIdentifier, actionSetIdentifier, accessoryIdentifier, serviceIdentifier, characteristicIdentifier, targetValue)
          //     .then((response) {
          //       final int code = response['code'];
          //       print('add action code $code');
          //     });
        } else {
          if (action.targetValue != uiEntity.targetValue) {
            final String homeIdentifier = home.identifier;
            final String actionSetIdentifier = actionSet.identifier;
            final String actionIdentifier = action.identifier;
            final int targetValue = uiEntity.targetValue;
            methodChannel.updateTargetValue(homeIdentifier, actionSetIdentifier,
                actionIdentifier, targetValue);
            // methodChannel.updateTargetValue(homeIdentifier, actionSetIdentifier, actionIdentifier, targetValue)
            //     .then((response) {
            //       final int code = response['code'];
            //       print('update action target value code $code');
            //     });
          }
        }
      }
    }
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).sceneEdit,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: kToolbarHeight,
          height: kToolbarHeight,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.only(left: OK_BUTTON_LEFT_PADDING),
            child: Image.asset(
              'images/edit_done.png',
              width: 21.0,
              height: 20.0,
              gaplessPlayback: true,
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          checkActionSet();
        },
      ),
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return ListView.builder(
      padding:
          EdgeInsets.only(left: 13.0, right: 13.0, top: 13.0, bottom: 13.0),
      itemCount: uiEntities.length,
      itemBuilder: (BuildContext context, int index) {
        return buildItem(context, uiEntities[index]);
      },
    );
  }

  Widget buildItem(BuildContext context, _UiEntity uiEntity) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.only(left: 13.0, right: 13.0),
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                  child: Image.asset(
                    uiEntity.selected
                        ? 'images/icon_check.png'
                        : 'images/icon_uncheck.png',
                    width: uiEntity.selected ? 21.0 : 10.5,
                    height: uiEntity.selected ? 21.0 : 10.5,
                    gaplessPlayback: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                Container(
                  width: 50.0,
                  height: 50.0,
                  alignment: Alignment.center,
                  child: buildDeviceIcon(context, uiEntity),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      uiEntity.accessory.name,
                      style: TextStyle(
                        inherit: false,
                        fontSize: 14.0,
                        color: const Color(0xFF2D3B46),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Text(
                      uiEntity.getAccessoryType(context),
                      style: TextStyle(
                        inherit: false,
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SwitchButton(
              activeColor: const Color(0xFF7CD0FF),
              value: uiEntity.isButtonChecked,
              showIndicator: false,
              showText: false,
              onChanged: (bool value) {
                uiEntity.isButtonChecked = value;
                if (value) {
                  uiEntity.selected = true;
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
      onTap: () {
        uiEntity.selected = !uiEntity.selected;
        if (!uiEntity.selected) {
          uiEntity.isButtonChecked = false;
        }
        setState(() {});
      },
    );
  }

  Widget buildDeviceIcon(BuildContext context, _UiEntity uiEntity) {
    if (uiEntity.accessory.isLightSocket || uiEntity.accessory.isWallSwitch) {
      return Image.asset(
        uiEntity.isButtonChecked
            ? 'images/icon_light_on.png'
            : 'images/icon_light_off.png',
        width: 35.0,
        height: 36.0,
        gaplessPlayback: true,
      );
    } else if (uiEntity.accessory.isSmartPlug) {
      return Image.asset(
        uiEntity.isButtonChecked
            ? 'images/icon_plug_on.png'
            : 'images/icon_plug_off.png',
        width: 25.0,
        height: 25.0,
        gaplessPlayback: true,
      );
    } else if (uiEntity.accessory.isSwitchModule) {
      return Image.asset(
        'images/icon_switch_module.png',
        width: 35.0,
        height: 35.0,
        gaplessPlayback: true,
      );
    } else if (uiEntity.accessory.isCurtain) {
      return Image.asset(
        'images/icon_curtain.png',
        width: 25.0,
        height: 22.0,
        gaplessPlayback: true,
      );
    } else {
      print("no icon for ${uiEntity.accessory.model}");
      return Container();
    }
  }
}

class _UiEntity {
  final Accessory accessory;
  final Service service;
  bool selected = false;
  bool isButtonChecked = false;

  _UiEntity({
    @required this.accessory,
    @required this.service,
  });

  Characteristic get characteristic {
    if (service == null) return null;
    if (accessory.isCurtain) {
      return service.findCharacteristicByType(C_CURRENT_POSITION);
    }
    return service.findCharacteristicByType(C_ON_OFF);
  }

  String get characteristisIdentifier {
    if (characteristic == null) return '';
    return characteristic.identifier;
  }

  int get targetValue {
    if (characteristic == null) return 0;
    if (characteristic.type == C_TARGET_POSITION) {
      return isButtonChecked ? 100 : 0;
    }
    return isButtonChecked ? 1 : 0;
  }

  String getAccessoryType(BuildContext context) {
    if (accessory.isLightSocket) {
      return DefinedLocalizations.of(context).lightSocket;
    } else if (accessory.isSmartPlug) {
      return DefinedLocalizations.of(context).smartPlug;
    } else if (accessory.isWallSwitch || accessory.isWallSwitchUS) {
      return DefinedLocalizations.of(context).wallSwitchLight;
    } else if (accessory.isCurtain) {
      return DefinedLocalizations.of(context).curtain;
    } else {
      return '';
    }
  }
}
