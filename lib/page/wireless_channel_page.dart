import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/mqtt/mqtt_proxy.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/session/session.dart';

import 'common_page.dart';

import 'dart:async';

class WirelessChannelPage extends StatefulWidget {
  final HomeCenter homeCenter;

  WirelessChannelPage({
    @required this.homeCenter,
  });

  State<StatefulWidget> createState() => _WirelessChannelState();
}

const int CHANNEL0 = 0;
const int CHANNEL11 = 11;
const int CHANNEL14 = 14;
const int CHANNEL15 = 15;
const int CHANNEL16 = 16;
const int CHANNEL19 = 19;
const int CHANNEL24 = 24;
const int CHANNEL25 = 25;
const int CHANNEL255 = 255;

class _WirelessChannelState extends State<WirelessChannelPage> {
  final List<_Channel> _uiChannel = List();

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
    final HomeCenterCache cache =
        HomeCenterManager().getHomeCenterCache(widget.homeCenter.uuid);

    if (cache == null) return;
    final ZigbeeSystem system = cache.system;
    _subscription = RxBus()
        .toObservable()
        .where((event) =>
            event is DeviceAttributeReportEvent &&
            event.homeCenterUuid == HomeCenterManager().defaultHomeCenterUuid &&
            event.uuid == system.uuid)
        .listen((event) {
      if (event is DeviceAttributeReportEvent) {
        if (event.attrId == ATTRIBUTE_ID_ZB_CHANNEL_UPDATE_STATE) {
          _resetData();
        }
      } else if (event is SessionStateChangedEvent) {
        _resetData();
      } else if (event is GetEntityCompletedEvent) {
        _resetData();
      }
    });
  }

  void _resetData() {
    print("-------------------wireless——channel-page");
    _uiChannel.clear();
    _uiChannel.add(_Channel(type: CHANNEL0, state: UNSELECTED));
    _uiChannel
        .add(_Channel(type: CHANNEL11, state: setChannelState(CHANNEL11)));
    _uiChannel
        .add(_Channel(type: CHANNEL14, state: setChannelState(CHANNEL14)));
    _uiChannel
        .add(_Channel(type: CHANNEL15, state: setChannelState(CHANNEL15)));
    _uiChannel
        .add(_Channel(type: CHANNEL16, state: setChannelState(CHANNEL16)));
    _uiChannel
        .add(_Channel(type: CHANNEL19, state: setChannelState(CHANNEL19)));
    _uiChannel
        .add(_Channel(type: CHANNEL24, state: setChannelState(CHANNEL24)));
    if (getCurrentChannel() == CHANNEL25) {
      _uiChannel
          .add(_Channel(type: CHANNEL25, state: setChannelState(CHANNEL25)));
    }
    _uiChannel.add(_Channel(type: CHANNEL255, state: UNSELECTED));
    setState(() {});
  }

  int setChannelState(int type) {
    final HomeCenterCache cache =
        HomeCenterManager().getHomeCenterCache(widget.homeCenter.uuid);
    if (cache == null) return UNSELECTED;
    final ZigbeeSystem system = cache.system;
    if (system != null && system.channel == type) {
      if (system.getAttributeValue(ATTRIBUTE_ID_ZB_CHANNEL_UPDATE_STATE) == 2) {
        return IN_SWITCH;
      }
      return SELECTED;
    }
    return UNSELECTED;
  }

  Widget build(BuildContext context) {
    return CommonPage(
        title: DefinedLocalizations.of(context).channel,
        child: buildChild(context));
  }

  int getCurrentChannel() {
    final HomeCenterCache cache =
        HomeCenterManager().getHomeCenterCache(widget.homeCenter.uuid);
    if (cache == null) return UNSELECTED;
    final ZigbeeSystem system = cache.system;
    return system?.channel;
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(30)),
      child: ListView.builder(
        padding: EdgeInsets.only(),
        itemCount: _uiChannel.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Container(
              height: Adapt.px(142),
              alignment: Alignment.centerLeft,
              child: Text(
                DefinedLocalizations.of(context).currentChannel +
                    getCurrentChannel().toString() +
                    DefinedLocalizations.of(context).channelCanChangeTo,
                style:
                    TextStyle(fontSize: Adapt.px(42), color: Color(0xff9b9b9b)),
              ),
            );
          } else if (index == _uiChannel.length - 1) {
            return _buildLast(context, _uiChannel[index], index);
          } else {
            return _buildItem(context, _uiChannel[index], index);
          }
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, _Channel uiChannel, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Adapt.px(240),
        color: Color(0xfff9f9f9),
        margin: EdgeInsets.only(bottom: Adapt.px(15)),
        padding: EdgeInsets.only(left: Adapt.px(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DefinedLocalizations.of(context).channel +
                      uiChannel.type.toString(),
                  style: TextStyle(
                      fontSize: Adapt.px(46), color: Color(0xff55585a)),
                ),
                Offstage(
                  offstage: uiChannel.state != 2,
                  child: Text(
                    DefinedLocalizations.of(context).changingChannel,
                    style: TextStyle(
                        fontSize: Adapt.px(36), color: Color(0xff899198)),
                  ),
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Offstage(
                  offstage: uiChannel.state == 2,
                  child: Container(
                    margin: EdgeInsets.only(right: Adapt.px(45)),
                    width: Adapt.px(63),
                    height: Adapt.px(63),
                    alignment: Alignment.center,
                    child: Image(
                      width: uiChannel.state != 1 ? Adapt.px(63) : Adapt.px(31),
                      height:
                          uiChannel.state != 1 ? Adapt.px(63) : Adapt.px(31),
                      image: AssetImage(uiChannel.state != 1
                          ? "images/icon_check.png"
                          : 'images/icon_uncheck.png'),
                    ),
                  ),
                ),
                Offstage(
                    offstage: uiChannel.state != 2,
                    child: Container(
                      margin: EdgeInsets.only(right: Adapt.px(45)),
                      width: Adapt.px(63),
                      height: Adapt.px(63),
                      child: CupertinoActivityIndicator(),
                    ))
              ],
            )
          ],
        ),
      ),
      onTap: () {
        final HomeCenterCache cache =
            HomeCenterManager().getHomeCenterCache(widget.homeCenter.uuid);
        if (cache == null) return;
        final ZigbeeSystem system = cache.system;
        if (system == null) return;
        if (system.getAttributeValue(ATTRIBUTE_ID_ZB_CHANNEL_UPDATE_STATE) == 2)
          return;
        _channelSelect(context, uiChannel, index);
      },
    );
  }

  void _channelSelect(
      BuildContext context, _Channel uiChannel, int index) async {
    await showCupertinoDialog(
        //模态框
        context: context,
        builder: (BuildContext context) {
          return
              //  SystemPadding(
              //   child:
              CupertinoAlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: Adapt.px(65)),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: Adapt.px(69),
                      right: Adapt.px(90),
                      bottom: Adapt.px(60)),
                  child: Text(
                    DefinedLocalizations.of(context).changingChannelTo +
                        uiChannel.type.toString() +
                        DefinedLocalizations.of(context)
                            .changingWillTake5Minutes,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: Adapt.px(46),
                        color: Color(0xff55585a),
                        letterSpacing: -1),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: Adapt.px(20),
                        right: Adapt.px(36),
                        bottom: Adapt.px(DefinedLocalizations.of(context)
                                    .keepAllDevicesPowerDevices ==
                                ""
                            ? 30
                            : 0)),
                    child: Row(
                      children: <Widget>[
                        Image(
                          height: Adapt.px(42),
                          width: Adapt.px(42),
                          image: AssetImage("images/channel_wraing.png"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(8.6)),
                        ),
                        Text(
                          DefinedLocalizations.of(context).keepAllDevicesPower,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Adapt.px(42.5),
                              color: Color(0xff55585a),
                              letterSpacing: -0.6,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Offstage(
                  offstage: DefinedLocalizations.of(context)
                          .keepAllDevicesPowerDevices ==
                      "",
                  child: Container(
                    margin: EdgeInsets.only(
                        left: Adapt.px(75),
                        right: Adapt.px(36),
                        bottom: Adapt.px(30)),
                    child: Text(
                      DefinedLocalizations.of(context)
                          .keepAllDevicesPowerDevices,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: Adapt.px(42.5),
                          color: Color(0xff55585a),
                          letterSpacing: -0.6,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        left: Adapt.px(20), right: Adapt.px(36)),
                    child: Row(
                      children: <Widget>[
                        Image(
                          height: Adapt.px(42),
                          width: Adapt.px(42),
                          image: AssetImage("images/channel_wraing.png"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(8.6)),
                        ),
                        Text(
                          DefinedLocalizations.of(context)
                              .changeChannelMayCause,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Adapt.px(42.5),
                              color: Color(0xff55585a),
                              letterSpacing: -0.6,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Container(
                  margin:
                      EdgeInsets.only(left: Adapt.px(76), right: Adapt.px(36)),
                  child: Text(
                    DefinedLocalizations.of(context).someDeviceMayPairAgain,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: Adapt.px(42.5),
                        color: Color(0xff55585a),
                        letterSpacing: -0.6,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              //操作选项
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).cancel,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).maybePop();
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  DefinedLocalizations.of(context).confirm,
                ),
                onPressed: () {
                  final HomeCenterCache cache = HomeCenterManager()
                      .getHomeCenterCache(widget.homeCenter.uuid);
                  if (cache == null) return '0';
                  final ZigbeeSystem system = cache.system;
                  var uuid = system.uuid;
                  MqttProxy.writeAttribute(widget.homeCenter.uuid, uuid,
                          ATTRIBUTE_ID_ZB_CHANNEL, _uiChannel[index].type)
                      .listen((response) {
                    if (response is WriteAttributeResponse) {
                      if (response.success) {
                        for (var i = 0; i < _uiChannel.length; i++) {
                          _uiChannel[i].state = UNSELECTED;
                        }
                        _uiChannel[index].state = IN_SWITCH;
                      }
                    }
                  });
                  Navigator.of(context, rootNavigator: true).maybePop();
                  setState(() {});
                  return "";
                },
              ),
            ],
          );
          // );
        });
  }

  Widget _buildLast(BuildContext context, _Channel uiChannel, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: Adapt.px(240),
        color: Color(0xfff9f9f9),
        margin: EdgeInsets.only(bottom: Adapt.px(15)),
        padding: EdgeInsets.only(left: Adapt.px(40)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DefinedLocalizations.of(context).autoDetect,
                  style: TextStyle(
                      fontSize: Adapt.px(46), color: Color(0xffffb34d)),
                ),
                Offstage(
                  offstage: uiChannel.state != 2,
                  child: Text(DefinedLocalizations.of(context).scanning,
                      style: TextStyle(
                          fontSize: Adapt.px(36), color: Color(0xff899198))),
                )
              ],
            ),
            // Stack(
            //   children: <Widget>[
            //     Offstage(
            //       offstage: uiChannel.state == 2,
            //       child: Container(
            //         margin: EdgeInsets.only(right: Adapt.px(45)),
            //         width: Adapt.px(63),
            //         height: Adapt.px(63),
            //         alignment: Alignment.center,
            //         child: Image(
            //           width: uiChannel.state != 1 ? Adapt.px(63) : Adapt.px(31),
            //           height: uiChannel.state != 1 ? Adapt.px(63) : Adapt.px(31),
            //           image: AssetImage(uiChannel.state != 1
            //               ? "images/icon_check.png"
            //               : 'images/icon_uncheck.png'),
            //         ),
            //       ),
            //     ),

            Offstage(
                offstage: uiChannel.state != 2,
                child: Container(
                  margin: EdgeInsets.only(right: Adapt.px(45)),
                  width: Adapt.px(63),
                  height: Adapt.px(63),
                  child: CupertinoActivityIndicator(),
                ))

            //   ],
            // )
          ],
        ),
      ),
      onTap: () {
        final HomeCenterCache cache =
            HomeCenterManager().getHomeCenterCache(widget.homeCenter.uuid);
        if (cache == null) return;
        final ZigbeeSystem system = cache.system;
        if (system == null) return;
        if (system.getAttributeValue(ATTRIBUTE_ID_ZB_CHANNEL_UPDATE_STATE) == 2)
          return;
        _channelSelect(context, uiChannel, index);
      },
    );
  }
}

const int SELECTED = 0;
const int UNSELECTED = 1;
const int IN_SWITCH = 2;

class _Channel {
  final int type;
  int state;
  _Channel({
    @required this.type,
    @required this.state,
  });
}
