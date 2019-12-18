import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'dart:async';
import 'package:xlive/homekit_page/homekit_aboutus_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xlive/homekit_page/homekit_room_management.dart';
import 'package:xlive/page/home_page.dart';

class HomekitHomePages extends StatefulWidget {
  State<StatefulWidget> createState() => _HomekitHomeState();
}

class _HomekitHomeState extends State<HomekitHomePages> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'HomekitminePage');
  String pageTitle = "";
  final List<_Uimanagements> _uimanagement = List();

  StreamSubscription _subscription;

  TextEditingController _homeNameController = TextEditingController();

  void initState() {
    super.initState();
    _resetData();
    _start();
  }

  void blogUrl() async {
    var url = "https://www." +
        DefinedLocalizations.of(context).officialSiteRoot +
        "/blog";
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _resetData() {
    _uimanagement.clear();
    // _uiEntities.clear();
    List<Home> homes = HomeManager().homes;
    _uimanagement.add(_Uimanagements('', '', true, 0));
    _uimanagement.add(_Uimanagements("", '', false, 1));
    _uimanagement.add(_Uimanagements("", '', false, 3));
    _uimanagement.add(_Uimanagements("", '', false, 4));
    _uimanagement.add(_Uimanagements("", '', false, 5));
    // for (var home in homes) {
    //   _uiEntities.add(_UiEntity(home));
    // }
    setState(() {});
  }

  void _start() {
    final String methodName = 'start';
    _subscription = RxBus()
        .toObservable()
        .where((event) => event is HomekitEvent)
        .listen((event) {
      if (event is HomesUpdatedEvent) {
        log.d('homes updated event', methodName);
        _resetData();
      } else if (event is HomeAddedEvent) {
        _resetData();
      } else if (event is HomeRemovedEvent) {
        _resetData();
      } else if (event is HomeNameUpdatedEvent) {
        _resetData();
      } else if (event is PrimaryHomeUpdatedEvent) {
        _resetData();
      } else if (event is HomekitEntityIncomingCompleteEvent) {
        _resetData();
      }
    });
  }

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true, //输入法框
      navigationBar: CupertinoNavigationBar(
        middle: Text(DefinedLocalizations.of(context).management),
        trailing: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 120,
            height: 40.0,
            alignment: Alignment.center,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      child: Container(
        padding: EdgeInsets.all(0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[_buildManagementListItem()],
        ),
      ),
    );
  }

  Widget _buildManagementListItem() {
    return Container(
        padding: EdgeInsets.only(left: 13, right: 13),
        width: 500,
        height: 500,
        color: Colors.white,
        child: ListView.builder(
            padding: EdgeInsets.only(),
            itemCount: _uimanagement.length,
            itemBuilder: (BuildContext context, int index) {
              final _Uimanagements uimanagements =
                  _uimanagement.elementAt(index);
              return _buildManagementItem(context, uimanagements);
            }));
  }

  Widget _buildManagementItem(
      BuildContext context, _Uimanagements uimanagement) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 100,
        height: 60,
        padding: EdgeInsets.only(),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: const Color(0x33000000),
                  width: 1,
                  style: BorderStyle.solid)),
          // color: Color(0xFF666666)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                ),
                Stack(
                  children: <Widget>[
                    Offstage(
                      offstage: !(uimanagement.number == 0),
                      child: Text(
                        DefinedLocalizations.of(context).userManagement,
                        style: TextStyle(
                          inherit: false,
                          color: const Color(0xFF2D3B46),
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !(uimanagement.number == 1),
                      child: Text(
                        DefinedLocalizations.of(context).aboutUs,
                        style: TextStyle(
                          inherit: false,
                          color: const Color(0xFF2D3B46),
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !(uimanagement.number == 3),
                      child: Text(
                        DefinedLocalizations.of(context).help,
                        style: TextStyle(
                          inherit: false,
                          color: const Color(0xFF2D3B46),
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !(uimanagement.number == 4),
                      child: Text(
                        DefinedLocalizations.of(context).manageRooms,
                        style: TextStyle(
                          inherit: false,
                          color: const Color(0xFF2D3B46),
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !(uimanagement.number == 5),
                      child: Text(
                        DefinedLocalizations.of(context).xiaoyanSystem,
                        style: TextStyle(
                          inherit: false,
                          color: const Color(0xFF2D3B46),
                          fontSize: 18.0,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Offstage(
                  offstage: uimanagement.isNextIcon,
                  child: Image(
                    width: 7.0,
                    height: 11.0,
                    image: AssetImage('images/icon_next.png'),
                  ),
                ),
                Offstage(
                  offstage: uimanagement.managementVer == '',
                  child: Text(
                    uimanagement.managementVer,
                    style: TextStyle(
                      inherit: false,
                      color: const Color(0xFF2D3B46),
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (uimanagement.number == 0) {
          String homeIdentifier = HomeManager().primaryHome.identifier;
          methodChannel.manageUsers(homeIdentifier);
        } else if (uimanagement.number == 1) {
          // pageTitle = DefinedLocalizations.of(context).aboutUs;
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (context) => AboutUs(),
              settings: RouteSettings(
                name: '/HomekitAboutUs',
              ),
            ),
          );
        } else if (uimanagement.number == 2) {
          // pageTitle = DefinedLocalizations.of(context).currentVersion;
        } else if (uimanagement.number == 3) {
          // pageTitle = DefinedLocalizations.of(context).help;
          blogUrl();
        } else if (uimanagement.number == 4) {
          // pageTitle = DefinedLocalizations.of(context).manageRooms;
          Navigator.of(context, rootNavigator: true).push(
            //进入下一个页面
            CupertinoPageRoute(
              builder: (context) => HomekitRoomManagement(),
              settings: RouteSettings(
                name: '/HomekitRoomManagement',
              ),
            ),
          );
        } else if (uimanagement.number == 5) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => HomePage(),
              settings: RouteSettings(
                name: '/Home',
              ),
            ),
            (route) => false,
          );
        }
      },
    );
  }
}

class _Uimanagements {
  String managementName;
  String managementVer;
  bool isNextIcon;
  num number;
  _Uimanagements(
      this.managementName, this.managementVer, this.isNextIcon, this.number);
}
