import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/widget/switch_button.dart';

import 'binding_setting_page.dart';
import 'common_page.dart';

import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';

class KeyPressBindingListPage extends StatefulWidget {
  final String triggerAddress;
  final int parameter; // 1-单击 2-双击
  final int keyPressType; //pir 墙壁开关

  KeyPressBindingListPage(
      {@required this.triggerAddress,
      @required this.parameter,
      @required this.keyPressType});

  State<StatefulWidget> createState() => _KeyPressBindingListState();
}

class _KeyPressBindingListState extends State<KeyPressBindingListPage> {
  static const String className = 'KeyPressBindingListPage';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  List<_BindingUiEntity> _uiEntities = List();

  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _uiEntities.add(_BindingUiEntity(type: ON_OFF_DEVICE));
    _uiEntities.add(_BindingUiEntity(type: CURTAIN));
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
    print("------------------------------key_press_binding_list_page.dart");
    final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (cache == null) return;
    final List<Binding> bindings = cache.bindings;
    for (var binding in bindings) {
      if (binding.triggerAddress == widget.triggerAddress &&
          binding.parameter == widget.parameter) {
        if (binding.isCurtainBinding) {
          _uiEntities[1].binding = binding;
        } else {
          _uiEntities[0].binding = binding;
        }
      }
    }
    setState(() {});
  }

  void _start() {
    _subscription = RxBus().toObservable().where((event) {
      if (event is HomeCenterCacheEvent) {
        return event.homeCenterUuid ==
            HomeCenterManager().defaultHomeCenterUuid;
      }
      return true;
    }).listen((event) {
      if (event is BindingCreateEvent) {
        final Binding binding = event.binding;
        if (widget.triggerAddress == binding.triggerAddress &&
            widget.parameter == binding.parameter) {
          _resetData();
        }
      } else if (event is BindingEnableChanegeEvent) {
        if (widget.triggerAddress == event.triggerAddress &&
            widget.parameter == event.parameter) {
          setState(() {});
        }
      }
    });
  }

  void _setBindingEnable(
      String bindingUuid, bool enabled, _BindingUiEntity uiEntity) {
    final String methodName = 'setBindingEnabled';
    final String homeCenterUuid = HomeCenterManager().defaultHomeCenterUuid;
    MqttProxy.setBindingEnable(homeCenterUuid, bindingUuid, enabled)
        .listen((response) {
      if (response is SetBindingEnableResponse) {
        uiEntity.switchShowIndicator = false;
        if (response.success) {
          uiEntity.binding.enabled = enabled;
        } else {
          Fluttertoast.showToast(
            msg: DefinedLocalizations.of(context).failed + ': ${response.code}',
          );
        }
        setState(() {});
      }
    });
  }

  Widget build(BuildContext context) {
    final String methodName = 'build';
    return CommonPage(
      title: DefinedLocalizations.of(context).clickBinding,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(),
      child: ListView.builder(
        itemCount: 2,
        padding: EdgeInsets.only(),
        itemBuilder: (BuildContext conetext, int index) {
          final _BindingUiEntity uiEntity = _uiEntities[index];
          return _buildBindingItem(context, uiEntity);
        },
      ),
    );
  }

  Widget _buildBindingItem(BuildContext context, _BindingUiEntity uiEntity) {
    final double paddingRight = uiEntity.isBindingEmpty ? 13.0 : 0.0;
    return Container(
      margin: EdgeInsets.only(left: 13.0, right: 13.0, top: 5.0, bottom: 5.0),
      padding: EdgeInsets.only(
          left: 13.0, right: paddingRight, top: 5.0, bottom: 5.0),
      height: 85.0,
      color: const Color(0xFFF9F9F9),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image(
                  width: 39.0,
                  height: 39.0,
                  image: AssetImage(uiEntity.getBindingImageLeftUrl(
                      widget.keyPressType, widget.triggerAddress)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.0),
                ),
                Image(
                  width: 7.0,
                  height: 9.0,
                  image: AssetImage('images/binding_arrow.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.0),
                ),
                Image(
                  width: 39.0,
                  height: 39.0,
                  image: AssetImage(
                      uiEntity.getBindingImageRightUrl(widget.keyPressType)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 0.4 * MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DefinedLocalizations.of(context)
                            .definedString(uiEntity.bindingNameDescription),
                        style: TEXT_STYLE_BINDING_NAME,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    Container(
                      width: 0.4 * MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DefinedLocalizations.of(context).definedString(
                            uiEntity.getBindingDescription(widget.parameter)),
                        style: TEXT_STYLE_BINDING_DESCRIPTION,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //SwitchButton
                Offstage(
                  offstage: uiEntity.isBindingEmpty,
                  child: SwitchButton(
                      activeColor: const Color(0xFF7CD0FF),
                      value: uiEntity.isBindingEnabled,
                      showIndicator: uiEntity.switchShowIndicator,
                      showText: true,
                      onText: DefinedLocalizations.of(context).start,
                      offText: DefinedLocalizations.of(context).stop,
                      onChanged: (value) {
                        uiEntity.switchShowIndicator = true;
                        setState(() {});
                        final String bindingUuid = uiEntity.binding.uuid;
                        _setBindingEnable(bindingUuid, value, uiEntity);
                      }),
                ),
                //箭头
                Offstage(
                  offstage: !uiEntity.isBindingEmpty,
                  child: Image(
                    width: 7.0,
                    height: 11.0,
                    image: AssetImage('images/icon_next.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          final Binding binding = uiEntity.binding;
          final bool curtainOnly = (uiEntity.type == CURTAIN);
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (BuildContext context) => BindingSettingPage(
                    binding: binding,
                    bindingType: BINDING_TYPE_KEY_PRESS,
                    triggerAddress: widget.triggerAddress,
                    keyPressType: widget.keyPressType,
                    containsCurtain: uiEntity.type == CURTAIN,
                    containsOnOffDevice: uiEntity.type == ON_OFF_DEVICE,
                    parameter: widget.parameter,
                  ),
              settings: RouteSettings(
                name: '/BindingSetting',
              ),
            ),
          );
        },
      ),
    );
  }
}

const int ON_OFF_DEVICE = 1;
const int CURTAIN = 2;

class _BindingUiEntity {
  Binding binding;
  int type;

  bool switchShowIndicator = false;

  _BindingUiEntity({
    @required this.type,
    this.binding,
  });

  String getBindingImageLeftUrl(int keyPressType, String triggerAddress) {
    if (keyPressType == KEY_PRESS_TYPE_WS) {
      if (triggerAddress.endsWith('-01')) {
        return 'images/binding_wall_switch_left_top.png';
      } else if (triggerAddress.endsWith('-02')) {
        return 'images/binding_wall_switch_top.png';
      } else if (triggerAddress.endsWith('-03')) {
        return 'images/binding_wall_switch_left.png';
      } else {
        return 'images/binding_wall_switch_right.png';
      }
    } else if (keyPressType == KEY_PRESS_TYPE_WS_US) {
      if (triggerAddress.endsWith('-01')) {
        return 'images/binding_ws_us_mid.png';
      } else if (triggerAddress.endsWith('-02')) {
        return 'images/binding_ws_us_top.png';
      } else {
        return 'images/binding_ws_us_bot.png';
      }
    } else if (keyPressType == KEY_PRESS_TYPE_KB) {
      return 'images/binding_rk_press_2.png';
    } else {
      return 'images/binding_press.png';
    }
  }

  String getBindingImageRightUrl(int keyPressType) {
    switch (type) {
      case ON_OFF_DEVICE:
        if (keyPressType == KEY_PRESS_TYPE_WS_US) {
          return 'images/binding_ws_us_light.png';
        }
        return 'images/binding_light.png';
      case CURTAIN:
        return 'images/binding_curtain.png';
      default:
        return 'images/binding_light.png';
    }
  }

  String get bindingNameDescription {
    switch (type) {
      case ON_OFF_DEVICE:
        return 'key_press';
      case CURTAIN:
        return 'click_control_window';
      default:
        return '';
    }
  }

  String getBindingDescription(int parameter) {
    switch (type) {
      case ON_OFF_DEVICE:
        if (parameter == 1) {
          return 'key_press_description';
        } else {
          return 'double_click_description';
        }
        break;
      case CURTAIN:
        if (parameter == 1) {
          return 'click_control_window_description';
        } else {
          return 'double_click_control_window_description';
        }
        break;
      default:
        return '';
    }
  }

  bool get isBindingEmpty {
    return binding == null;
  }

  bool get isBindingEnabled {
    if (binding == null) return false;
    return binding.enabled;
  }
}
