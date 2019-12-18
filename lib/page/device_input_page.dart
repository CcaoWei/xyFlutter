import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/page/input_interlock_page.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/widget/switch_button.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'common_page.dart';

import 'dart:async';

const int SERIAL_NUMBER = 0;
const int VERSION = 1;
const int RSSI = 2;
const int DEVICE_TYPE = 3;

const int GROUP_PROGRAMMABLE_SWITCH = 2;
const int GROUP_LED_FEEDBACK_STATE = 3;
const int GROUP_SM_INPUT_MODE = 5;
const int GROUP_EXCLUSIVE_ON = 6;

//临界版本 不支持
const int PLUG_VERSION_SUPPORT_LED = 84;
const int CURTAIN_VERSION_SUPPORT_LED = 25;
const int S_WALL_SWITCH_VERSION_SUPPORT_LED = 54;
const int D_WALL_SWITCH_VERSION_SUPPORT_LED = 13;
const int SWITCH_MODULE_VERSION_SUPPORT_INPUT_MODE = 18;
const int S_WALL_SWITCH_VERSION_SUPPORT_INTERLOCK_CFG = 255;

class DeviceInputPage extends StatefulWidget {
  final Entity entity;
  final int inputIndex;

  DeviceInputPage({Key key, @required this.entity, @required this.inputIndex})
      : super(key: key);

  State<StatefulWidget> createState() => _DeviceInputState();
}

class _DeviceInputState extends State<DeviceInputPage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'DeviceInputPage');

  Entity entity;

  final List<_Group> groups = List();

  StreamSubscription subscription;

  void initState() {
    super.initState();
    resetData();
    start();
  }

  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    super.dispose();
  }

  void resetData() {
    print("------------------------------device_input_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) {
      entity = widget.entity;
    } else {
      entity = cache.findEntity(widget.entity.uuid);
    }
    groups.clear();

    PhysicDevice pd; // = entity;
    if (entity is LogicDevice) {
      pd = (entity as LogicDevice).parent;
      // pd =
    } else if (entity is PhysicDevice) {
      pd = entity;
    }
    if (pd.isWallSwitch) {
      final LogicDevice first = pd.getLogicDevice(widget.inputIndex);
      final _ProgrammableSwitchGroup pgroup = _ProgrammableSwitchGroup();
      pgroup.add(entity);
      groups.add(pgroup);

      if (pd.isWallSwitchD ||
          (pd.isWallSwitchS &&
              pd.firmwareVersion >=
                  S_WALL_SWITCH_VERSION_SUPPORT_INTERLOCK_CFG)) {
        final _ExclusiveOnGroup egroup = _ExclusiveOnGroup();
        egroup.add(entity);
        groups.add(egroup);
      }

      if (!pd.isWallSwitchS) {
        final _LEDFeedbackStateGroup lgroup = _LEDFeedbackStateGroup();
        lgroup.add(entity);
        groups.add(lgroup);
      }
    } else if (pd.isSwitchModule) {
      final LogicDevice first = pd.getLogicDevice(widget.inputIndex);
      if (first.smInputMode == 1 ||
          first.smInputMode == 0 ||
          first.smInputMode == -1) {
        final _SMInputModeGroup group = _SMInputModeGroup();
        group.add(entity);
        groups.add(group);

        final _ProgrammableSwitchGroup pgroup = _ProgrammableSwitchGroup();
        pgroup.add(entity);
        groups.add(pgroup);

        final _ExclusiveOnGroup egroup = _ExclusiveOnGroup();
        egroup.add(entity);
        groups.add(egroup);

        final _LEDFeedbackStateGroup lgroup = _LEDFeedbackStateGroup();
        lgroup.add(entity);
        groups.add(lgroup);
      }
    }
    setState(() {});
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is HomeCenterCacheEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
        .where((event) => (event is DeviceAttributeReportEvent &&
            (event.attrId == ATTRIBUTE_ID_CFG_BUTTON_LED_POLARITY ||
                event.attrId == ATTRIBUTE_ID_CFG_SW_POLARITY ||
                event.attrId == ATTRIBUTE_ID_CFG_SW_INPUT_MODE ||
                event.attrId == ATTRIBUTE_ID_CFG_MUTEXED_INDEX ||
                event.attrId == ATTRIBUTE_ID_CONFIG_DISABLE_RELAY ||
                event.attrId == ATTRIBUTE_ID_DISABLE_RELAY_STATUS)))
        .listen((event) {
      if (event.attrId == ATTRIBUTE_ID_CFG_SW_INPUT_MODE) {
        resetData();
      } else {
        setState(() {});
      }
    });
  }

  void writeAttribute(
      Entity entity, int attrId, int attrValue, _UiEntity uiEntity) {
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.writeAttribute(homeCenterUuid, entity.uuid, attrId, attrValue)
        .listen((response) {
      if (response is WriteAttributeResponse) {
        if (uiEntity is _LEDFeedbackStateUiEntity) {
          uiEntity.switchShowIndicator = false;
        } else if (uiEntity is _DisableRelayUiEntity) {
          uiEntity.switchShowIndicator = false;
        } else if (uiEntity is _RelayAlwaysOnUiEntity) {
          uiEntity.switchShowIndicator = false;
        } else if (uiEntity is _ProgrammableSwitchUiEntity) {
          uiEntity.switchShowIndicator = false;
        } else if (uiEntity is _SMPolarityUiEntity) {
          uiEntity.switchShowIndicator = false;
        } else if (uiEntity is _SMInputModeUiEntity) {
          uiEntity.switchShowIndicator = false;
        }
        if (!response.success) {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
          //log.e('write attr error: ${response.code}', 'writeAttribute');
        } else {
          entity.setAttribute(attrId, attrValue);
        }
        setState(() {});
      }
    });
  }

  int get itemCount {
    int count = 0;
    for (var group in groups) {
      count += group.size();
    }
    return count;
  }

  _UiEntity getUiEntity(int index) {
    int step = 0;
    for (var group in groups) {
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
      title: entity.getName(),
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(context, getUiEntity(index));
      },
    );
  }

  Widget _buildItem(BuildContext context, _UiEntity uiEntity) {
    if (uiEntity is _GroupUiEntity) {
      return _buildGroupItem(context, uiEntity);
    } else if (uiEntity is _SMInputModeUiEntity) {
      return _buildSMInputModeItem(context, uiEntity);
    } else if (uiEntity is _SMPolarityUiEntity) {
      return _buildSMPolarityItem(context, uiEntity);
    } else if (uiEntity is _DisableRelayUiEntity) {
      return _buildDisableRelayItem(context, uiEntity);
    } else if (uiEntity is _ProgrammableSwitchUiEntity) {
      return _buildProgrammableSwitchItem(context, uiEntity);
    } else if (uiEntity is _RelayAlwaysOnUiEntity) {
      return _buildRelayAlwaysOnItem(context, uiEntity);
    } else if (uiEntity is _LEDFeedbackStateUiEntity) {
      return _buildLEDFeedbackStateItem(context, uiEntity);
    } else if (uiEntity is _ExclusiveOnUiEntity) {
      return _buildExclusiveOnItem(context, uiEntity);
    } else {
      return Container();
    }
  }

  Widget _buildGroupItem(BuildContext context, _GroupUiEntity uiEntity) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0),
      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
      alignment: Alignment.centerLeft,
      child: Text(
        uiEntity.getTitle(context),
        style: TextStyle(
          inherit: false,
          fontSize: 14.0,
          color: const Color(0xFF9B9B9B),
        ),
      ),
    );
  }

  Widget _buildSMInputModeItem(
      BuildContext context, _SMInputModeUiEntity uiEntity) {
    return Container(
      color: const Color(0xFFFAFAFA),
      height: 80.0,
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 13.0, right: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: Adapt.px(101),
                height: Adapt.px(101),
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: Adapt.px(54), right: Adapt.px(50)),
                child: Image(
                  width: Adapt.px(101),
                  height: Adapt.px(101),
                  image: AssetImage(uiEntity.imageUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getTitle(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 15.0,
                          color: const Color(0xFF55585A),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getDescription(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 11.0,
                          color: const Color(0xFF899198),
                        ),
                        //overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: SwitchButton(
              activeColor: const Color(0xFF7CD0FF),
              value: uiEntity.isButtonChecked,
              showIndicator: uiEntity.switchShowIndicator,
              showText: false,
              onChanged: (bool value) {
                setState(() {});
                //final String uuid = uiEntity.entity.uuid;
                final int attrId = ATTRIBUTE_ID_CFG_SW_INPUT_MODE;
                final int attrValue = uiEntity.isButtonChecked ? 0 : 1;
                writeAttribute(
                    uiEntity.logicDevice, attrId, attrValue, uiEntity);
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isSMPolarityEnabled(LogicDevice logicDevice) {
    return logicDevice.smInputMode == 0;
  }

  Widget _buildSMPolarityItem(
      BuildContext context, _SMPolarityUiEntity uiEntity) {
    return Offstage(
      offstage: !isSMPolarityEnabled(uiEntity.logicDevice),
      child: Container(
        color: const Color(0xFFFAFAFA),
        height: 80.0,
        margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 13.0, right: 13.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: Adapt.px(101),
                  height: Adapt.px(101),
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(left: Adapt.px(54), right: Adapt.px(50)),
                  child: Image(
                    width: Adapt.px(101),
                    height: Adapt.px(101),
                    image: AssetImage(uiEntity.imageUrl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 0.45 * MediaQuery.of(context).size.width,
                        child: Text(
                          uiEntity.getTitle(context),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 15.0,
                            color: const Color(0xFF55585A),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0),
                      ),
                      Container(
                        width: 0.45 * MediaQuery.of(context).size.width,
                        child: Text(
                          uiEntity.getDescription(context),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 11.0,
                            color: const Color(0xFF899198),
                          ),
                          //overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: Offstage(
                offstage: !isSMPolarityEnabled(uiEntity.logicDevice),
                child: SwitchButton(
                  activeColor: const Color(0xFF7CD0FF),
                  value: uiEntity.isButtonChecked,
                  showIndicator: uiEntity.switchShowIndicator,
                  showText: false,
                  onChanged: (bool value) {
                    setState(() {});
                    //final String uuid = uiEntity.entity.uuid;
                    final int attrId = ATTRIBUTE_ID_CFG_SW_POLARITY;
                    final int attrValue = uiEntity.isButtonChecked ? 0 : 1;
                    writeAttribute(
                        uiEntity.logicDevice, attrId, attrValue, uiEntity);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExclusiveOnItem(
      BuildContext context, _ExclusiveOnUiEntity uiEntity) {
    return Container(
        color: const Color(0xFFFAFAFA),
        height: 80.0,
        margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 13.0, right: 13.0),
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: Adapt.px(101),
                      height: Adapt.px(101),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: Adapt.px(54), right: Adapt.px(50)),
                      child: Image(
                        width: Adapt.px(101),
                        height: Adapt.px(101),
                        image: AssetImage(uiEntity.imageUrl),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 0.45 * MediaQuery.of(context).size.width,
                            child: Text(
                              uiEntity.getTitle(context),
                              style: TextStyle(
                                inherit: false,
                                fontSize: 15.0,
                                color: const Color(0xFF55585A),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0),
                          ),
                          Container(
                            width: 0.45 * MediaQuery.of(context).size.width,
                            child: Text(
                              uiEntity.getDescription(context),
                              style: TextStyle(
                                inherit: false,
                                fontSize: 11.0,
                                color: const Color(0xFF899198),
                              ),
                              //overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Offstage(
                    offstage: false,
                    child: Image(
                      width: 7.0,
                      height: 11.0,
                      image: AssetImage('images/icon_next.png'),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              // final String triggerAddress = inputChildUiEntity.logicDevice.uuid;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputInterlockPage(uiEntity.entity,
                      uiEntity.mutexedIndex, widget.inputIndex),
                  // entity: inputChildUiEntity.logicDevice,
                  // inputIndex: inputChildUiEntity.inputIndex),
                ),
              );
            }));
  }

  Widget _buildLEDFeedbackStateItem(
      BuildContext context, _LEDFeedbackStateUiEntity uiEntity) {
    return Container(
      color: const Color(0xFFFAFAFA),
      height: 80.0,
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 13.0, right: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: Adapt.px(101),
                height: Adapt.px(101),
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: Adapt.px(54), right: Adapt.px(50)),
                child: Image(
                  width: Adapt.px(101),
                  height: Adapt.px(101),
                  image: AssetImage(uiEntity.imageUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getTitle(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 15.0,
                          color: const Color(0xFF55585A),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getDescription(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 11.0,
                          color: const Color(0xFF899198),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: SwitchButton(
              activeColor: const Color(0xFF7CD0FF),
              value: uiEntity.isButtonChecked,
              showIndicator: uiEntity.switchShowIndicator,
              showText: false,
              onChanged: (bool value) {
                uiEntity.switchShowIndicator = true;
                setState(() {});
                //final String uuid = uiEntity.entity.uuid;
                final int attrId = ATTRIBUTE_ID_CFG_BUTTON_LED_POLARITY;
                final int attrValue = uiEntity.isButtonChecked ? 0 : 1;
                writeAttribute(uiEntity.entity, attrId, attrValue, uiEntity);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisableRelayItem(
      BuildContext context, _DisableRelayUiEntity uiEntity) {
    return Offstage(
      offstage: uiEntity.logicDevice.parent.isWallSwitchS ||
          uiEntity.logicDevice.exclusiveOn > 0 ||
          !(uiEntity.logicDevice.pureInput > 0),
      child: Container(
        color: const Color(0xFFFAFAFA),
        height: 80.0,
        margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 13.0, right: 13.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: Adapt.px(101),
                  height: Adapt.px(101),
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(left: Adapt.px(54), right: Adapt.px(50)),
                  child: Image(
                    width: Adapt.px(101),
                    height: Adapt.px(101),
                    image: AssetImage(uiEntity.imageUrl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 0.45 * MediaQuery.of(context).size.width,
                        child: Text(
                          uiEntity.getTitle(context),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 15.0,
                            color: const Color(0xFF55585A),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0),
                      ),
                      Container(
                        width: 0.45 * MediaQuery.of(context).size.width,
                        child: Text(
                          uiEntity.getDescription(context),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 11.0,
                            color: const Color(0xFF899198),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: SwitchButton(
                activeColor: const Color(0xFF7CD0FF),
                value: uiEntity.isButtonChecked,
                showIndicator: uiEntity.switchShowIndicator,
                showText: false,
                onChanged: (bool value) {
                  uiEntity.switchShowIndicator = true;
                  setState(() {});
                  //final String uuid = uiEntity.logicDevice.uuid;
                  final int attrId = ATTRIBUTE_ID_CONFIG_DISABLE_RELAY;
                  final int attrValue = uiEntity.isButtonChecked ? 0 : 1;
                  writeAttribute(
                      uiEntity.logicDevice, attrId, attrValue, uiEntity);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgrammableSwitchItem(
      BuildContext context, _ProgrammableSwitchUiEntity uiEntity) {
    return Container(
      color: const Color(0xFFFAFAFA),
      height: 80.0,
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 13.0, right: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: Adapt.px(101),
                height: Adapt.px(101),
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(left: Adapt.px(54), right: Adapt.px(50)),
                child: Image(
                  width: Adapt.px(101),
                  height: Adapt.px(101),
                  image: AssetImage(uiEntity.imageUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getTitle(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 15.0,
                          color: const Color(0xFF55585A),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Container(
                      width: 0.45 * MediaQuery.of(context).size.width,
                      child: Text(
                        uiEntity.getDescription(context),
                        style: TextStyle(
                          inherit: false,
                          fontSize: 11.0,
                          color: const Color(0xFF899198),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: SwitchButton(
              activeColor: const Color(0xFF7CD0FF),
              value: uiEntity.isButtonChecked,
              showIndicator: uiEntity.switchShowIndicator,
              showText: false,
              onChanged: (bool value) {
                uiEntity.switchShowIndicator = true;
                setState(() {});
                //final String uuid = uiEntity.logicDevice.uuid;
                final int attrId = uiEntity.logicDevice.parent.isWallSwitchS
                    ? ATTRIBUTE_ID_CONFIG_DISABLE_RELAY
                    : ATTRIBUTE_ID_CFG_SW_PURE_INPUT;
                final int attrValue = uiEntity.isButtonChecked ? 0 : 1;
                writeAttribute(
                    uiEntity.logicDevice, attrId, attrValue, uiEntity);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelayAlwaysOnItem(
      BuildContext context, _RelayAlwaysOnUiEntity uiEntity) {
    return Offstage(
      offstage: uiEntity.logicDevice.exclusiveOn != 0 ||
          uiEntity.logicDevice.pureInput == 0 ||
          uiEntity.logicDevice.disableRelay == 0,
      child: Container(
        color: const Color(0xFFFAFAFA),
        height: 80.0,
        margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 13.0, right: 13.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: Adapt.px(101),
                  height: Adapt.px(101),
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(left: Adapt.px(54), right: Adapt.px(50)),
                  child: Image(
                    width: Adapt.px(101),
                    height: Adapt.px(101),
                    image: AssetImage(uiEntity.imageUrl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 0.45 * MediaQuery.of(context).size.width,
                        child: Text(
                          uiEntity.getTitle(context),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 15.0,
                            color: const Color(0xFF55585A),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0),
                      ),
                      Container(
                        width: 0.45 * MediaQuery.of(context).size.width,
                        child: Text(
                          uiEntity.getDescription(context),
                          style: TextStyle(
                            inherit: false,
                            fontSize: 11.0,
                            color: const Color(0xFF899198),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: SwitchButton(
                activeColor: const Color(0xFF7CD0FF),
                value: uiEntity.isButtonChecked,
                showIndicator: uiEntity.switchShowIndicator,
                showText: false,
                onChanged: (bool value) {
                  uiEntity.switchShowIndicator = true;
                  setState(() {});
                  //final String uuid = uiEntity.logicDevice.uuid;
                  final int attrId = ATTRIBUTE_ID_DISABLE_RELAY_STATUS;
                  final int attrValue = uiEntity.isButtonChecked ? 0 : 1;
                  writeAttribute(
                      uiEntity.logicDevice, attrId, attrValue, uiEntity);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

abstract class _Group {
  int size();
  _UiEntity get(int index);
}

class _ExclusiveOnGroup extends _Group {
  final List<_UiEntity> uiEntities = List();

  _ExclusiveOnGroup() {
    uiEntities.add(_GroupUiEntity(type: GROUP_EXCLUSIVE_ON));
  }

  int size() => uiEntities.length > 1 ? uiEntities.length : 0;

  void add(Entity entity) {
    uiEntities.add(_ExclusiveOnUiEntity(entity: entity));
  }

  _UiEntity get(int index) => uiEntities.elementAt(index);
}

class _LEDFeedbackStateGroup extends _Group {
  final List<_UiEntity> uiEntities = List();

  _LEDFeedbackStateGroup() {
    uiEntities.add(_GroupUiEntity(type: GROUP_LED_FEEDBACK_STATE));
  }

  int size() => uiEntities.length > 1 ? uiEntities.length : 0;

  void add(Entity entity) {
    uiEntities.add(_LEDFeedbackStateUiEntity(entity: entity));
  }

  _UiEntity get(int index) => uiEntities.elementAt(index);
}

class _SMInputModeGroup extends _Group {
  final List<_UiEntity> uiEntities = List();

  _SMInputModeGroup() {
    uiEntities.add(_GroupUiEntity(type: GROUP_SM_INPUT_MODE));
  }

  int size() => uiEntities.length > 1 ? uiEntities.length : 0;

  void add(Entity entity) {
    uiEntities.add(_SMInputModeUiEntity(logicDevice: entity));
    uiEntities.add(_SMPolarityUiEntity(logicDevice: entity));
  }

  _UiEntity get(int index) => uiEntities.elementAt(index);
}

class _ProgrammableSwitchGroup extends _Group {
  final List<Object> uiEntities = List();

  _ProgrammableSwitchGroup() {
    uiEntities.add(_GroupUiEntity(type: GROUP_PROGRAMMABLE_SWITCH));
  }

  int size() => uiEntities.length > 1 ? uiEntities.length : 0;

  void add(LogicDevice logicDevice) {
    uiEntities.add(_ProgrammableSwitchUiEntity(logicDevice: logicDevice));
    uiEntities.add(_DisableRelayUiEntity(logicDevice: logicDevice));
    uiEntities.add(_RelayAlwaysOnUiEntity(logicDevice: logicDevice));
  }

  _UiEntity get(int index) => uiEntities.elementAt(index);
}

abstract class _UiEntity {}

class _GroupUiEntity extends _UiEntity {
  final int type;

  _GroupUiEntity({
    Key key,
    @required this.type,
  });

  String getTitle(BuildContext context) {
    switch (type) {
      case GROUP_PROGRAMMABLE_SWITCH:
        return DefinedLocalizations.of(context).programmableSwitch;
      case GROUP_LED_FEEDBACK_STATE:
        return DefinedLocalizations.of(context).ledFeedback;
      case GROUP_SM_INPUT_MODE:
        return DefinedLocalizations.of(context).smInputMode;
      case GROUP_EXCLUSIVE_ON:
        return DefinedLocalizations.of(context).exclusiveOn;
      default:
        return '';
    }
  }
}

class _ExclusiveOnUiEntity extends _UiEntity {
  final Entity entity;

  bool switchShowIndicator = false;
  int mutexedIndex = 0;

  _ExclusiveOnUiEntity({
    @required this.entity,
  }) {
    mutexedIndex = entity.getAttributeValue(ATTRIBUTE_ID_CFG_MUTEXED_INDEX);
  }

  String get imageUrl {
    if (isButtonChecked) {
      return 'images/exclusiveon_state_enable.png';
    } else {
      return 'images/exclusiveon_state_disable.png';
    }
  }

  String getTitle(BuildContext context) {
    if (isButtonChecked && mutexedIndex != -1) {
      print("mutexedIndex is $mutexedIndex}");
      return DefinedLocalizations.of(context).exclusiveOnEnable;
    } else {
      return DefinedLocalizations.of(context).exclusiveOnDisable;
    }
  }

  String getDescription(BuildContext context) {
    mutexedIndex = entity.getAttributeValue(ATTRIBUTE_ID_CFG_MUTEXED_INDEX);
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).exclusiveOnEnableDes;
    } else {
      return DefinedLocalizations.of(context).exclusiveOnDisableDes;
    }
  }

  bool get isButtonChecked {
    if (entity is PhysicDevice) {
      final PhysicDevice pd = entity as PhysicDevice;
      final LogicDevice ld = pd.getLogicDevice(0);
      return ld.exclusiveOn != 0;
    } else if (entity is LogicDevice) {
      return entity.exclusiveOn != 0;
    }
    return false;
  }
}

class _LEDFeedbackStateUiEntity extends _UiEntity {
  final Entity entity;

  bool switchShowIndicator = false;

  _LEDFeedbackStateUiEntity({
    @required this.entity,
  });

  String get imageUrl {
    if (entity.ledPolarity == 1) {
      return 'images/led_feedback_negative.png';
    } else {
      return 'images/led_feedback_positive.png';
    }
  }

  String getTitle(BuildContext context) {
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).ledFeedbackStateNeg;
    } else {
      return DefinedLocalizations.of(context).ledFeedbackStatePos;
    }
  }

  String getDescription(BuildContext context) {
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).ledFeedbackStateNegDes;
    } else {
      return DefinedLocalizations.of(context).ledFeedbackStatePosDes;
    }
  }

  bool get isButtonChecked {
    return entity.ledPolarity == 1;
  }
}

class _SMInputModeUiEntity extends _UiEntity {
  final LogicDevice logicDevice;

  bool switchShowIndicator = false;

  _SMInputModeUiEntity({
    @required this.logicDevice,
  });

  String get imageUrl {
    if (isButtonChecked) {
      return 'images/switchmodule_input_mode_button.png';
    } else {
      return 'images/switchmodule_input_mode_rocker.png';
    }
  }

  String getTitle(BuildContext context) {
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).smInputModeButton;
    } else {
      return DefinedLocalizations.of(context).smInputModeRocker;
    }
  }

  String getDescription(BuildContext context) {
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).smInputModeButtonDes;
    } else {
      return DefinedLocalizations.of(context).smInputModeRockerDes;
    }
  }

  bool get isButtonChecked {
    return logicDevice.smInputMode == 1;
  }
}

class _SMPolarityUiEntity extends _UiEntity {
  final LogicDevice logicDevice;

  bool switchShowIndicator = false;

  _SMPolarityUiEntity({
    @required this.logicDevice,
  });

  String get imageUrl {
    if (isButtonChecked) {
      return 'images/switchmodule_input_polarity_toggle.png';
    } else {
      return 'images/switchmodule_input_polarity_fixed.png';
    }
  }

  String getTitle(BuildContext context) {
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).smPolarityOn;
    } else {
      return DefinedLocalizations.of(context).smPolarityOff;
    }
  }

  String getDescription(BuildContext context) {
    if (isButtonChecked) {
      return DefinedLocalizations.of(context).smPolarityOnDes;
    } else {
      return DefinedLocalizations.of(context).smPolarityOffDes;
    }
  }

  bool get isButtonChecked {
    return logicDevice.smPolarity == 1;
  }
}

class _DisableRelayUiEntity extends _UiEntity {
  final LogicDevice logicDevice;

  bool switchShowIndicator = false;

  _DisableRelayUiEntity({
    @required this.logicDevice,
  });

  String getTitle(BuildContext context) {
    if (!isButtonChecked) {
      return DefinedLocalizations.of(context).disableRelayDis;
    } else {
      return DefinedLocalizations.of(context).disableRelayEn;
    }
  }

  String getDescription(BuildContext context) {
    if (!isButtonChecked) {
      return DefinedLocalizations.of(context).disableRelayDisDes;
    } else {
      return DefinedLocalizations.of(context).disableRelayEnDes;
    }
  }

  String get imageUrl {
    if (logicDevice.disableRelay == 1) {
      return 'images/relay_disable.png';
    }
    return 'images/relay_enable.png';
  }

  bool get isButtonChecked {
    return logicDevice.disableRelay == 1;
  }
}

class _ProgrammableSwitchUiEntity extends _UiEntity {
  final LogicDevice logicDevice;

  bool switchShowIndicator = false;

  _ProgrammableSwitchUiEntity({
    @required this.logicDevice,
  });

  String getTitle(BuildContext context) {
    if (!isButtonChecked) {
      return DefinedLocalizations.of(context).programmableSwitchDisable;
    } else {
      return DefinedLocalizations.of(context).programmableSwitchEnable;
    }
  }

  String getDescription(BuildContext context) {
    if (!isButtonChecked) {
      return DefinedLocalizations.of(context).programmableSwitchDisableDes;
    } else {
      return DefinedLocalizations.of(context).programmableSwitchEnableDes;
    }
  }

  String get imageUrl {
    if (isButtonChecked) {
      return 'images/programmable_input_en.png';
    }
    return 'images/programmable_input_dis.png';
  }

  bool get isButtonChecked {
    return logicDevice.parent.isWallSwitchS
        ? logicDevice.disableRelay == 1
        : logicDevice.pureInput == 1;
  }
}

class _RelayAlwaysOnUiEntity extends _UiEntity {
  final LogicDevice logicDevice;

  bool switchShowIndicator = false;

  _RelayAlwaysOnUiEntity({
    @required this.logicDevice,
  });

  String getTitle(BuildContext context) {
    if (!isButtonChecked) {
      return DefinedLocalizations.of(context).relayAlwaysonDis;
    } else {
      return DefinedLocalizations.of(context).relayAlwaysonEn;
    }
  }

  String getDescription(BuildContext context) {
    if (!isButtonChecked) {
      return DefinedLocalizations.of(context).relayAlwaysonDisDes;
    } else {
      return DefinedLocalizations.of(context).relayAlwaysonEnDes;
    }
  }

  String get imageUrl {
    if (logicDevice.disabledRelayStatus == 1) {
      return 'images/relay_alwayson_en.png';
    }
    return 'images/relay_alwayson_disable.png';
  }

  bool get isButtonChecked {
    return logicDevice.disabledRelayStatus == 1;
  }
}
