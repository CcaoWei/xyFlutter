import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/widget/system_padding.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'homekit_scene_edit_page.dart';

import 'dart:async';

class HomekitScenePage extends StatefulWidget {
  State<StatefulWidget> createState() => _HomekitSceneState();
}

class _HomekitSceneState extends State<HomekitScenePage> {
  final List<_UiEntity> uiEntities = List();

  List<_UiEntity> get sortedUiEntities {
    uiEntities.sort((a, b) {
      if (a.actionSet.type == SCENE_HOME_ARRIVAL) return -1;
      if (b.actionSet.type == SCENE_HOME_ARRIVAL) return 1;
      if (a.actionSet.type == SCENE_HOME_DEPARTURE) return -1;
      if (b.actionSet.type == SCENE_HOME_DEPARTURE) return 1;
      if (a.actionSet.type == SCENE_WAKE_UP) return -1;
      if (b.actionSet.type == SCENE_WAKE_UP) return 1;
      if (a.actionSet.type == SCENE_SLEEP) return -1;
      if (b.actionSet.type == SCENE_SLEEP) return 1;
      return -1;
    });
    return uiEntities;
  }

  TextEditingController nameController = TextEditingController();

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

  void resetData() {
    final Home home = HomeManager().primaryHome;
    if (home == null) return;
    uiEntities.clear();
    final List<ActionSet> actionSets = home.actionSets;
    for (ActionSet actionSet in actionSets) {
      uiEntities.add(_UiEntity(actionSet: actionSet));
    }
    setState(() {});
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => event is HomekitEvent)
        .where((event) =>
            event is ActionSetActionsUpdatedEvent ||
            event is ActionSetAddedEvent ||
            event is ActionSetRemovedEvent ||
            event is ActionSetNameUpdatedEvent ||
            event is CharacteristicValueChangedEvent ||
            event is HomekitEntityIncomingCompleteEvent ||
            event is CharacteristicVaulueUpdatedEvent ||
            event is PrimaryHomeUpdatedEvent ||
            event is ActionSetActionsUpdatedEvent)
        .listen((event) {
      resetData();
    });
  }

  void displayAddScene(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                DefinedLocalizations.of(context).addScene,
                style: TextStyle(
                  color: const Color(0xFF2D3B46),
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                displayAddSceneDialog(context);
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
      },
    );
  }

  void displaySceneSettingDialog(BuildContext context, _UiEntity uiEntity) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            DefinedLocalizations.of(context).sceneSetting,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                DefinedLocalizations.of(context).excute,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                final Home home = HomeManager().primaryHome;
                if (home == null) return;
                final String homeIdentifier = home.identifier;
                final String actionSetIdentifier =
                    uiEntity.actionSet.identifier;
                methodChannel
                    .excuteActionSet(homeIdentifier, actionSetIdentifier)
                    .then((response) {
                  final int code = response['code'];
                  if (code != 0) {
                    final String messageType =
                        DefinedLocalizations.of(context).error;
                    final String message = response['message'];
                    displayMessage(messageType, message);
                  } else {
                    resetData();
                  }
                });
              },
            ),
            CupertinoDialogAction(
              child: Text(
                DefinedLocalizations.of(context).edit,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(
                    builder: (BuildContext context) => HomekitSceneEditPage(
                          actionSetIdentifier: uiEntity.actionSet.identifier,
                        ),
                    settings: RouteSettings(
                      name: '/HomekitSceneEdit',
                    ),
                  ),
                );
              },
            ),
            CupertinoDialogAction(
              child: Text(
                DefinedLocalizations.of(context).rename,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                displayRenameSceneDialog(context, uiEntity);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                DefinedLocalizations.of(context).delete,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                final Home home = HomeManager().primaryHome;
                if (home == null) return;
                final String homeIdentifier = home.identifier;
                final String actionSetIdentifier =
                    uiEntity.actionSet.identifier;
                methodChannel
                    .removeActionSet(homeIdentifier, actionSetIdentifier)
                    .then((response) {
                  final int code = response['code'];
                  if (code != 0) {
                    final String messageType =
                        DefinedLocalizations.of(context).error;
                    final String message = response['message'];
                    displayMessage(messageType, message);
                  } else {
                    resetData();
                  }
                });
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
      },
    );
  }

  void displayRenameSceneDialog(BuildContext context, _UiEntity uiEntity) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return SystemPadding(
          child: CupertinoAlertDialog(
            title: Text(DefinedLocalizations.of(context).rename),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(DefinedLocalizations.of(context).inputName),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                CupertinoTextField(
                  autofocus: true,
                  controller: nameController,
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).cancel),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).rename),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  final Home home = HomeManager().primaryHome;
                  if (home == null) return;
                  final String homeIdentifier = home.identifier;
                  final String actionSetIdentifier =
                      uiEntity.actionSet.identifier;
                  final String name = nameController.text;
                  methodChannel
                      .updateActionSetName(
                          homeIdentifier, actionSetIdentifier, name)
                      .then((response) {
                    final int code = response['code'];
                    if (code != 0) {
                      final String messageType =
                          DefinedLocalizations.of(context).error;
                      final String message = response['message'];
                      displayMessage(messageType, message);
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void displayAddSceneDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return SystemPadding(
          child: CupertinoAlertDialog(
            title: Text(DefinedLocalizations.of(context).addScene),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(DefinedLocalizations.of(context).inputName),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                CupertinoTextField(
                  autofocus: true,
                  controller: nameController,
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).cancel),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text(DefinedLocalizations.of(context).add),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  final Home home = HomeManager().primaryHome;
                  if (home == null) return;
                  final String homeIdentifier = home.identifier;
                  final String name = nameController.text;
                  methodChannel
                      .addActionSet(homeIdentifier, name)
                      .then((response) {
                    final int code = response['code'];
                    if (code != 0) {
                      final String messageType =
                          DefinedLocalizations.of(context).error;
                      final String message = response['message'];
                      displayMessage(messageType, message);
                    } else {
                      print('add action set success');
                      resetData();
                    }
                  });
                },
              ),
            ],
          ),
        );
      },
    );
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

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).scene,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 40.0,
          height: 40.0,
          alignment: Alignment.center,
          child: Image.asset(
            'images/add.png',
            width: 27.0,
            height: 27.0,
            gaplessPlayback: true,
          ),
        ),
        onTap: () {
          displayAddScene(context);
        },
      ),
      showBackIcon: false,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    final double width = (MediaQuery.of(context).size.width - 39.0) / 2.0;
    return GridView.builder(
      padding:
          EdgeInsets.only(left: 13.0, right: 13.0, top: 13.0, bottom: 13.0),
      itemCount: uiEntities.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 13.0,
        crossAxisSpacing: 13.0,
        childAspectRatio: width / 70.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return buildSceneItem(context, sortedUiEntities[index]);
      },
    );
  }

  Widget buildSceneItem(BuildContext context, _UiEntity uiEntity) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color:
              uiEntity.actionSet.isOn ? Colors.blue : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.only(left: 13.0, right: 13.0),
        child: Row(
          children: <Widget>[
            buildSceneIcon(context, uiEntity),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
            ),
            Expanded(
              child: Text(
                uiEntity.actionSet.name,
                style: TextStyle(
                  color: uiEntity.actionSet.isOn ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        final Home home = HomeManager().primaryHome;
        if (home == null) return;
        final String homeIdentifier = home.identifier;
        final String actionSetIdentifier = uiEntity.actionSet.identifier;
        methodChannel
            .excuteActionSet(homeIdentifier, actionSetIdentifier)
            .then((response) {
          final int code = response['code'];
          if (code != 0) {
            if (code == 25) {
              final String messageType =
                  DefinedLocalizations.of(context).warning;
              final String message =
                  DefinedLocalizations.of(context).homekitSceneIsEmpty;
              displayMessage(messageType, message);
            } else {
              final String messageType = DefinedLocalizations.of(context).error;
              final String message = response['message'];
              displayMessage(messageType, message);
            }
          } else {
            resetData();
          }
        });
      },
      onLongPress: () {
        displaySceneSettingDialog(context, uiEntity);
      },
    );
  }

  Widget buildSceneIcon(BuildContext context, _UiEntity uiEntity) {
    return Container(
      width: 30.0,
      height: 30.0,
      alignment: Alignment.center,
      child: Image.asset(
        uiEntity.imageUrl,
        width: uiEntity.imageWidth,
        height: uiEntity.imageHeight,
        gaplessPlayback: true,
      ),
    );
  }
}

class _UiEntity {
  final ActionSet actionSet;

  _UiEntity({
    @required this.actionSet,
  });

  String get imageUrl {
    if (actionSet.type == SCENE_WAKE_UP) {
      return actionSet.isOn
          ? 'images/hk_get_up_white.png'
          : 'images/hk_get_up.png';
    } else if (actionSet.type == SCENE_HOME_DEPARTURE) {
      return actionSet.isOn
          ? 'images/hk_leave_white.png'
          : 'images/hk_leave.png';
    } else if (actionSet.type == SCENE_HOME_ARRIVAL) {
      return actionSet.isOn ? 'images/hk_home_white.png' : 'images/hk_home.png';
    } else if (actionSet.type == SCENE_SLEEP) {
      return actionSet.isOn
          ? 'images/hk_sleep_white.png'
          : 'images/hk_sleep.png';
    } else {
      return actionSet.isOn
          ? 'images/hk_defined_white.png'
          : 'images/hk_defined.png';
    }
  }

  double get imageWidth {
    if (actionSet.type == SCENE_WAKE_UP) {
      return 25.5;
    } else if (actionSet.type == SCENE_HOME_DEPARTURE) {
      return 23.0;
    } else if (actionSet.type == SCENE_HOME_ARRIVAL) {
      return 29.0;
    } else if (actionSet.type == SCENE_SLEEP) {
      return 28.0;
    } else {
      return 25.5;
    }
  }

  double get imageHeight {
    if (actionSet.type == SCENE_WAKE_UP) {
      return 26.0;
    } else if (actionSet.type == SCENE_HOME_DEPARTURE) {
      return 27.0;
    } else if (actionSet.type == SCENE_HOME_ARRIVAL) {
      return 26.0;
    } else if (actionSet.type == SCENE_SLEEP) {
      return 26.0;
    } else {
      return 23.0;
    }
  }
}
