import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/const/adapt.dart';
import 'dart:ui';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/session/app_state_manager.dart';

import 'dart:async';

//组件是李涛自己定义的   用来头部 状态栏显示  怎么去用详见 某个页面
class CommonPage extends StatefulWidget {
  final String title;
  final Color titleColor;
  final bool showBackIcon;
  final bool showMenuIcon;
  final Widget trailing;
  final Color barBackgroundColor;
  final bool showRedPoint; //是否显示红点
  final Widget child;
  final bool isHomeCenterDetail;
  final onGoBack;

  CommonPage({
    this.title,
    this.titleColor = const Color(0xFF2D3B46),
    this.showBackIcon = true,
    this.showMenuIcon = false,
    this.trailing = null,
    this.barBackgroundColor = Colors.white,
    this.showRedPoint = false,
    @required this.child,
    this.isHomeCenterDetail = false,
    this.onGoBack = null,
  });

  State<StatefulWidget> createState() => CommonState();
}

class CommonState extends State<CommonPage> {
  StreamSubscription subscription;

  void initState() {
    super.initState();
    start();
    AppStateManager().history = Navigator.of(context).history;
  }

  void dispose() {
    //print('HHHH -> ${Navigator.of(context).history.last.settings.name}');
    super.dispose();
    //print('GGGG -> ${Navigator.of(context).history.last.settings.name}');
    if (subscription != null) {
      subscription.cancel();
    }
  }

  void start() {
    // subscription = RxBus().toObservable()
    //     .where((event) => event is AssociationMessage && event.eventType == REMOVE)
    //     .listen((event) {
    //       final AssociationMessage msg = event as AssociationMessage;
    //       if (msg.isDefaultHomeCenterRemoved && !widget.isHomeCenterDetail) {
    //         displayMessage(msg.deviceUuid, msg.deviceName);
    //       }
    //     });
  }

  double get redPointPaddingTop =>
      LoginManager().platform == PLATFORM_ANDROID ? 20.0 : 14.0;

  Widget build(BuildContext context) {
    if (LoginManager().platform == PLATFORM_ANDROID) {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 2.0,
          centerTitle: true,
          titleSpacing: 0.0,
          title: buildAndroidTitle(context),
          backgroundColor: widget.barBackgroundColor,
          automaticallyImplyLeading: false,
        ),
        body: CupertinoPageScaffold(
          child: widget.child,
        ),
      );
    } else {
      return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        navigationBar: CupertinoNavigationBar(
          border: Border(
              bottom: BorderSide(
                  width: 0.0,
                  color: Color(0x00ffffff),
                  style: BorderStyle.solid)),
          padding:
              EdgeInsetsDirectional.only(start: 0, top: 0, end: 0, bottom: 0),
          leading: buildLeading(context),
          middle: Text(
            widget.title,
            style: TextStyle(
              color: widget.titleColor,
              fontSize: Adapt.px(50),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Offstage(
            offstage: widget.trailing == null,
            child: Padding(
              padding: EdgeInsets.only(right: 13.0),
              child: widget.trailing,
            ),
          ),
          backgroundColor: widget.barBackgroundColor,
        ),
        child: widget.child,
      );
    }
  }

  Widget buildAndroidTitle(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        //leading
        Container(
          width: MediaQuery.of(context).size.width,
          height: kToolbarHeight,
          alignment: Alignment.centerLeft,
          child: buildLeading(context),
        ),
        //middle
        Container(
          width: 200.0,
          height: kToolbarHeight,
          alignment: Alignment.center,
          child: Text(
            widget.title,
            style: TextStyle(
              color: widget.titleColor,
              fontSize: Adapt.px(50),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        //trail
        Container(
          width: MediaQuery.of(context).size.width,
          height: kToolbarHeight,
          alignment: Alignment.centerRight,
          child: Offstage(
            offstage: widget.trailing == null,
            child: widget.trailing,
          ),
        ),
      ],
    );
  }

  Widget buildLeading(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Offstage(
          offstage: !widget.showBackIcon,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: Adapt.px(200),
              padding: EdgeInsets.only(left: Adapt.px(40)),
              height: kToolbarHeight - 16.0,
              alignment: Alignment.centerLeft,
              color: widget.barBackgroundColor,
              child: Image.asset(
                widget.barBackgroundColor == Colors.white
                    ? 'images/icon_back.png'
                    : 'images/icon_back_white.png',
                width: 7.0,
                height: 13.0,
                gaplessPlayback: true, //就是图片路径切换时 解决显示空白的问题
              ),
            ),
            onTap: () {
              if (widget.onGoBack != null) {
                widget.onGoBack();
              }
              Navigator.of(context).maybePop();
            },
          ),
        ),
        Offstage(
          offstage: !widget.showMenuIcon,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Container(
                  width: 47.0,
                  height: kToolbarHeight,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'images/indicator.png',
                    width: 19.0,
                    height: 13.0,
                    gaplessPlayback: true,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: redPointPaddingTop, right: 12.0),
                  child: Offstage(
                    offstage: !widget.showRedPoint,
                    child: Image.asset(
                      'images/red_point.png',
                      width: 5.0,
                      height: 5.0,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ],
    );
  }
}
