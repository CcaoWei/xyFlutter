import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/page/wireless_channel_page.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'common_page.dart';

import 'dart:async';

class SystemInformationPage extends StatefulWidget {
  final HomeCenter homeCenter;

  SystemInformationPage({
    @required this.homeCenter,
  });

  State<StatefulWidget> createState() => _SyatemInformationState();
}

class _SyatemInformationState extends State<SystemInformationPage> {
  final List<_UiEntity> _uiEntities = List();

  StreamSubscription _subscription;

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

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is DeviceAttributeReportEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid)
        .listen((event) {
      final DeviceAttributeReportEvent evt =
          event as DeviceAttributeReportEvent;
      if (evt.attrId == ATTRIBUTE_ID_FIRMWARE_VERSION ||
          evt.attrId == ATTRIBUTE_ID_ZB_CHANNEL_UPDATE_STATE) {
        _resetData();
      }
    });
  }

  void _resetData() {
    print("-------------------system——information-page");
    _uiEntities.clear();
    _uiEntities.add(
      _UiEntity(
        type: NETWORK_ADDRESS,
        content: widget.homeCenter.host ?? '',
      ),
    );
    _uiEntities.add(_UiEntity(type: VERSION, content: _versionString));
    _uiEntities.add(_UiEntity(type: WIRELESS_CHANNEL, content: _chanel));
    setState(() {});
  }

  String get _versionString {
    //final HomeCenterCache cache = HomeCenterManager().defaultHomeCenterCache;
    if (widget.homeCenter == null) return '';
    if (widget.homeCenter.physicDevice == null)
      return widget.homeCenter.versionString;
    return HomeCenter.getVersionString(
        widget.homeCenter.physicDevice.firmwareVersion);
  }

  String get _chanel {
    final HomeCenterCache cache =
        HomeCenterManager().getHomeCenterCache(widget.homeCenter.uuid);

    if (cache == null) return '0';
    final ZigbeeSystem system = cache.system;
    if (system != null) {
      return system.channel.toString();
    }
    return '0';
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).systemInformation,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0),
      child: ListView.builder(
        padding: EdgeInsets.only(),
        itemCount: _uiEntities.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(context, _uiEntities[index]);
        },
      ),
    );
  }

  bool isCanChangeChannel(int type) {
    if (type != WIRELESS_CHANNEL) return true;
    final HomeCenter homeCenter = HomeCenterManager().defaultHomeCenter;
    if (!homeCenter.online) return true;
    final HomeCenterCache cache =
        HomeCenterManager().getHomeCenterCache(widget.homeCenter.uuid);
    if (cache == null) return true;
    final Entity entity = cache.findEntity(widget.homeCenter.uuid);
    if (entity == null) return true;
    var hcVersion = entity.getAttributeValue(ATTRIBUTE_ID_FIRMWARE_VERSION);
    if (hcVersion >= CAN_CHANGE_CHANNEL) return false;
    return true;
  }

  Widget _buildItem(BuildContext context, _UiEntity uiEntity) {
    print("$uiEntity");
    print("${uiEntity.content}");
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 53.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 51.0,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    uiEntity.getTypeString(context),
                    style: TEXT_STYLE_INFORMATION_TYPE,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        uiEntity.content ?? "",
                        style: TEXT_STYLE_INFORMATION_CONTENT,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Adapt.px(15)),
                      ),
                      Offstage(
                        offstage: isCanChangeChannel(uiEntity.type),
                        child: Image(
                          width: Adapt.px(19),
                          height: Adapt.px(35),
                          image: AssetImage("images/icon_next.png"),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              height: 2.0,
              color: const Color(0x33000000),
            ),
          ],
        ),
      ),
      onTap: () {
        // WIRELESS_CHANNEL
        if (!isCanChangeChannel(uiEntity.type)) {
          Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
              builder: (context) => WirelessChannelPage(
                    homeCenter: widget.homeCenter,
                  ),
              settings: RouteSettings(name: "/WirelessChannelPage")));
        }
      },
    );
  }
}

const int NETWORK_ADDRESS = 0;
const int VERSION = 1;
const int WIRELESS_CHANNEL = 2;
const int SIGNAL_STRENGTH = 3;
const int START_TIME = 4;
const int RUN_TIME = 5;
const int SHARE_HOME_CENTER = 6;
const int QR_CODE = 7;

class _UiEntity {
  final int type;
  final String content;

  _UiEntity({
    @required this.type,
    @required this.content,
  });

  String getTypeString(BuildContext context) {
    switch (type) {
      case NETWORK_ADDRESS:
        return DefinedLocalizations.of(context).ipAddress;
      case VERSION:
        return DefinedLocalizations.of(context).version;
      case WIRELESS_CHANNEL:
        return DefinedLocalizations.of(context).channel;
      default:
        return '';
    }
  }
}
