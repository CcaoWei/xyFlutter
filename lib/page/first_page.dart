import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/rxbus/rxbus.dart';

import 'login_page.dart';
import 'home_page.dart';
import 'add_home_center_page.dart';

import 'dart:async';

class FirstPage extends StatefulWidget {
  State<StatefulWidget> createState() => _FirstState();
}

class _FirstState extends State<FirstPage> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<EdgeInsets> _transition1;
  Animation<EdgeInsets> _transition2;
  Animation<double> _opacity;

  StreamSubscription _subscription;

  Timer _timer;

  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    _opacity = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.linear),
      ),
    );
    _transition1 = EdgeInsetsTween(
      begin: EdgeInsets.only(top: 133.0),
      end: EdgeInsets.only(top: 145.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.1, curve: Curves.linear),
      ),
    );
    _transition2 = EdgeInsetsTween(
      begin: EdgeInsets.only(top: 145.0),
      end: EdgeInsets.only(top: 0.0),
    ).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.2, 0.5, curve: Curves.linear))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _onAnimationEnd();
          }
        }),
    );
    Timer(
      const Duration(milliseconds: 700),
      () {
        _controller.forward();
      },
    );

    _start();
  }

  void _onAnimationEnd() {
    final int stage = LoginManager().stage;
    switch (stage) {
      case LoginManager.STAGE_ORIGIN:
      case LoginManager.STAGE_NOT_AUTO_LOGIN:
      case LoginManager.STAGE_TOKEN_VALIDATE_FAILED:
      case LoginManager.STAGE_LOGIN_FAILED:
        _switchToLoginPage();
        break;
      case LoginManager.STAGE_AUTO_LOGIN_START:
      case LoginManager.STAGE_TOKEN_VALIDATE_SUCCEED:
        _displayDialog(
            context, DefinedLocalizations.of(context).loginUncomplete);
        _startTimer();
        break;
      case LoginManager.STAGE_LOGIN_SUCCEED:
        _displayDialog(
            context, DefinedLocalizations.of(context).getDataUncomplete);
        _startTimer();
        break;
      case LoginManager.STAGE_NO_ASSOCIATED_HOME_CENTER:
        _switchToAddHomeCenterPage();
        break;
      case LoginManager.STAGE_GET_ROSTER_SUCCEED:
      case LoginManager.STAGE_GET_DATA_FAILED:
      case LoginManager.STAGE_GET_DATA_SUCCEED:
        _switchToHomePage();
        break;
    }
  }

  void _startTimer() {
    if (_timer == null) {
      _timer = Timer(
        const Duration(seconds: 15),
        () {
          LoginManager().stage = LoginManager.STAGE_GET_DATA_FAILED;
          _onAnimationEnd();
        },
      );
    }
  }

  void _switchToLoginPage() {
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (context) => LoginPage(),
        settings: RouteSettings(
          name: '/Login',
        ),
      ),
      (route) => false,
    );
  }

  void _switchToAddHomeCenterPage() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (context) => AddHomeCenterPage(showBackIcon: false),
        settings: RouteSettings(
          name: '/AddHomeCenter',
        ),
      ),
      (route) => false,
    );
  }

  void _switchToHomePage() {
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

  void _displayDialog(BuildContext context, String string) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return _displayCupertinoDialog(context, string);
      },
    );
  }

  CupertinoDialog _displayCupertinoDialog(BuildContext context, String string) {
    return CupertinoDialog(
      child: Container(
        width: 200.0,
        height: 50.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
            ),
            Text(
              string,
              style: TextStyle(
                inherit: false,
                color: Color(0xFF2D3B46),
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) => event is LoginEvent)
        .listen((event) {
      final LoginEvent evt = event as LoginEvent;
      if (evt.type == LoginEvent.LOGIN_COMPLETE) {
      } else if (evt.type == LoginEvent.GET_DATA_COMPLETE ||
          evt.type == LoginEvent.GET_ROSTER_COMPLETE) {
        if (!_controller.isCompleted) {
          print("first page animation not yet completed");
          return;
        }
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => HomePage(),
            settings: RouteSettings(
              name: '/Home',
            ),
          ),
          (route) => false,
        );
      } else if (evt.type == LoginEvent.NO_HOME_CENTER) {
        if (!_controller.isCompleted) return;
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => HomePage(),
            settings: RouteSettings(
              name: '/Home',
            ),
          ),
          (route) => false,
        );
      }
    });
  }

  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    if (_controller != null) {
      _controller.dispose();
    }
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: AnimatedBuilder(
        builder: _buildAnimation,
        animation: _controller,
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      color: Colors.white,
      alignment: Alignment.topCenter,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: _transition1.value,
            child: Container(
              padding: _transition2.value,
              child: Image(
                width: 84.0,
                height: 138.0,
                image: AssetImage('images/first.png'),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 300.0),
            child: Opacity(
              opacity: _opacity.value,
              child: Text(
                DefinedLocalizations.of(context).firstDescription,
                style: TextStyle(
                  inherit: false,
                  color: Color(0xFF5B666F),
                  fontSize: 11.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
