import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/firmware/firmware_manager.dart';

import 'common_page.dart';

class SetUpgradePolicyPage extends StatefulWidget {
  final String homeCenterUuid;

  SetUpgradePolicyPage({
    @required this.homeCenterUuid,
  });

  State<StatefulWidget> createState() => _SetUpgradePolicyState();
}

class _SetUpgradePolicyState extends State<SetUpgradePolicyPage> {
  final List<_UiEntity> uiEntities = List();
  _UiEntity alphaUiEntity;
  _UiEntity betaUiEntity;
  _UiEntity stableUiEntity;

  void initState() {
    super.initState();
    resetData();
  }

  void dispose() {
    super.dispose();
  }

  void resetData() {
    alphaUiEntity = _UiEntity(type: ALPHA);
    betaUiEntity = _UiEntity(type: BETA);
    stableUiEntity = _UiEntity(type: STABLE, checked: true);
    uiEntities.add(stableUiEntity);
    uiEntities.add(betaUiEntity);
    uiEntities.add(alphaUiEntity);
    setState(() {});

    getUpgradePolicy();
  }

  void getUpgradePolicy() {
    MqttProxy.getUpgradePolicy(widget.homeCenterUuid).listen((response) {
      if (response is GetUpgradePolicyResponse) {
        if (response.success) {
          if (response.channel == UPGRADE_POLICY_BETA) {
            betaUiEntity.checked = true;
            stableUiEntity.checked = false;
            alphaUiEntity.checked = false;
          } else if (response.channel == UPGRADE_POLICY_STABLE) {
            stableUiEntity.checked = true;
            betaUiEntity.checked = false;
            alphaUiEntity.checked = false;
          } else if (response.channel == UPGRADE_POLICY_ALPHA) {
            alphaUiEntity.checked = true;
            stableUiEntity.checked = false;
            betaUiEntity.checked = false;
          }
          setState(() {});
        }
      }
    });
  }

  void setUpgradePolicy(String channel) {
    MqttProxy.setUpgradePolicy(widget.homeCenterUuid, channel)
        .listen((response) {
      if (response is SetUpgradePolicyResponse) {
        if (response.success) {
          betaUiEntity.checked = channel == UPGRADE_POLICY_BETA;
          stableUiEntity.checked = channel == UPGRADE_POLICY_STABLE;
          alphaUiEntity.checked = channel == UPGRADE_POLICY_ALPHA;
          setState(() {});
        }
      }
    });
  }

  void displayDialog(String channel) {
    var desc = '';
    switch (channel) {
      case UPGRADE_POLICY_STABLE:
        desc = DefinedLocalizations.of(context).changeStableDes;
        break;
      case UPGRADE_POLICY_BETA:
        desc = DefinedLocalizations.of(context).changeBetaDes;
        break;
      case UPGRADE_POLICY_ALPHA:
        desc = DefinedLocalizations.of(context).changeAlphaDes;
        break;
      default:
    }

    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(desc),
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
                  DefinedLocalizations.of(context).confirm,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  FirmwareManager().clear(widget.homeCenterUuid);
                  setUpgradePolicy(channel);
                },
              ),
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).upgradePolicy,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
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
        padding: EdgeInsets.only(left: 13.0, right: 13.0),
        height: 53.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 51.0,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    uiEntity.getPolicyName(context),
                    style: TEXT_STYLE_INFORMATION_TYPE,
                  ),
                  Container(
                    width: 21.0,
                    height: 21.0,
                    alignment: Alignment.center,
                    child: Image.asset(
                      uiEntity.checked
                          ? 'images/icon_check.png'
                          : 'images/icon_uncheck.png',
                      width: uiEntity.checked ? 21.0 : 10.5,
                      height: uiEntity.checked ? 21.0 : 10.5,
                      gaplessPlayback: true,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 2.0,
              color: Colors.black38,
            ),
          ],
        ),
      ),
      onTap: () {
        String channel = UPGRADE_POLICY_STABLE;
        if (uiEntity.type == BETA) {
          channel = UPGRADE_POLICY_BETA;
        } else if (uiEntity.type == ALPHA) {
          channel = UPGRADE_POLICY_ALPHA;
        }
        displayDialog(channel);
      },
    );
  }
}

const int ALPHA = 1;
const int BETA = 2;
const int STABLE = 3;

class _UiEntity {
  final int type;
  bool checked;

  _UiEntity({
    this.type,
    this.checked = false,
  });

  String getPolicyName(BuildContext context) {
    switch (type) {
      case ALPHA:
        return DefinedLocalizations.of(context).upgradePolicyAlpha;
      case BETA:
        return DefinedLocalizations.of(context).upgradePolicyBeta;
      case STABLE:
        return DefinedLocalizations.of(context).upgradePolicyStable;
      default:
        return '';
    }
  }
}
