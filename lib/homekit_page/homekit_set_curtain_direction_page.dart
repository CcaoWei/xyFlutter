import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/homekit/homekit_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/page/common_page.dart';
import 'package:xlive/channel/event_channel.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'package:xlive/const/const_shared.dart';

import 'dart:async';

class HomekitSetCurtainDirectionPage extends StatefulWidget {
  final int curtainType;
  final int originDirection;
  final bool isAdding;
  final String homeIdentifier;
  final String accessoryIdentifier;

  HomekitSetCurtainDirectionPage({
    @required this.curtainType,
    @required this.originDirection,
    @required this.isAdding,
    @required this.homeIdentifier,
    @required this.accessoryIdentifier,
  });

  State<StatefulWidget> createState() => _HomekitSetCurtainDirectionState();
}

class _HomekitSetCurtainDirectionState
    extends State<HomekitSetCurtainDirectionPage> {
  int currentDirection;

  bool adjustCompleted = false;

  StreamSubscription _subscription;

  Timer timer;

  void initState() {
    super.initState();
    currentDirection = widget.originDirection;

    _start();

    timer = Timer(const Duration(seconds: 40), () {
      adjustCompleted = true;
      setState(() {});
    });
  }

  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) => event is HomekitEvent)
        .where((event) => event is CharacteristicVaulueUpdatedEvent) // &&
        // event.homeIdentifier == widget.homeIdentifier &&
        // event.accessoryIdentifier == widget.accessoryIdentifier)
        .listen((event) {
      print(
          'CharacteristicVaulueUpdatedEvent in curtain direction page: ${event} 22');
      if (event is CharacteristicVaulueUpdatedEvent) {
        print(
            'CharacteristicVaulueUpdatedEvent in curtain direction page: ${event}');
        final Home home = HomeManager().findHome(event.homeIdentifier);
        if (home != null) {
          final Accessory accessory =
              home.findAccessory(event.accessoryIdentifier);
          if (accessory != null) {
            final Service service =
                accessory.findService(event.serviceIdentifier);
            if (service != null) {
              final Characteristic characteristic =
                  service.findCharacteristic(event.characteristicIdentifier);
              print('characteristic type : ${characteristic.type}');
              if (characteristic.type == C_TRIP_ADJUSTING) {
                adjustCompleted = true;
                setState(() {});
              }
            }
          }
        }
      }
    });
  }

  void setCurtainDirection() {
    final Home home = HomeManager().findHome(widget.homeIdentifier);
    if (home == null) return;
    final Accessory accessory = home.findAccessory(widget.accessoryIdentifier);
    if (accessory == null) return;
    final Service service = accessory.findServiceByType(S_CURTAIN_SETTNG);
    if (service == null) return;
    final Characteristic characteristic =
        service.findCharacteristicByType(C_DIRECTION);
    if (characteristic == null) return;
    final String homeIdentifier = home.identifier;
    final String accessoryIdentifier = accessory.identifier;
    final String serviceIdentifier = service.identifier;
    final String characteristicIdentifier = characteristic.identifier;
    final int value = currentDirection;
    methodChannel
        .writeValue(homeIdentifier, accessoryIdentifier, serviceIdentifier,
            characteristicIdentifier, value)
        .then((response) {
      final int code = response['code'];
      if (code == 0) {
        if (widget.isAdding) {
          print(Navigator.of(context).history);
          Navigator.of(context).popUntil(
            ModalRoute.withName('/HomekitAddDevice'),
          );
        } else {
          Navigator.of(context).pop();
        }
      } else {
        final String messageType = DefinedLocalizations.of(context).error;
        final String message = response['message'];
        displayMessage(messageType, message);
      }
    });
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
        });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).smartCurtain,
      barBackgroundColor: const Color(0xFF91D2F9),
      trailing: Offstage(
        offstage: !widget.isAdding || adjustCompleted,
        child: CupertinoActivityIndicator(),
      ),
      titleColor: Colors.white,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 15.0),
      color: const Color(0xFF91D2F9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                    DefinedLocalizations.of(context).chooseCurtainDirection,
                    style: TextStyle(
                      inherit: false,
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              _buildSingle(context),
              _buildDouble(context),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 55.0),
            child: Offstage(
              offstage: widget.isAdding && !adjustCompleted,
              child: CupertinoButton(
                padding: EdgeInsets.only(),
                borderRadius: BorderRadius.all(Radius.circular(22.0)),
                color: Colors.transparent,
                disabledColor: Colors.transparent,
                child: Container(
                  width: 200.0,
                  height: 44.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                  child: Text(
                    DefinedLocalizations.of(context).submit,
                    style: TextStyle(
                      inherit: false,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                onPressed: () {
                  setCurtainDirection();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingle(BuildContext context) {
    return Offstage(
      offstage: widget.curtainType == CURTAIN_TYPE_DOUBLE,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
              width: (MediaQuery.of(context).size.width - 13.0 * 3) / 2.0,
              height: 165.0,
              decoration: BoxDecoration(
                color: currentDirection == CURTAIN_DIRECTION_ORIGIN
                    ? Color(0xFF7DCBF4)
                    : Color(0xFFB4DEF9),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              margin: EdgeInsets.only(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 14.0),
                    child: Image(
                      width: 116.0,
                      height: 107.0,
                      image: AssetImage(widget.curtainType == CURTAIN_TYPE_LEFT
                          ? 'images/left_closed.png'
                          : 'images/right_closed.png'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(bottom: 12.0, right: 12.0),
                    child: Offstage(
                      offstage: currentDirection == CURTAIN_DIRECTION_REVERSE,
                      child: Image(
                        width: 21.0,
                        height: 21.0,
                        image: AssetImage(
                            'images/icon_curtain_setting_select.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              currentDirection = CURTAIN_DIRECTION_ORIGIN;
              setState(() {});
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: 13.0),
          ),
          GestureDetector(
            child: Container(
              width: (MediaQuery.of(context).size.width - 13.0 * 3) / 2.0,
              height: 165.0,
              decoration: BoxDecoration(
                color: currentDirection == CURTAIN_DIRECTION_REVERSE
                    ? Color(0xFF7DCBF4)
                    : Color(0xFFB4DEF9),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              margin: EdgeInsets.only(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 14.0),
                    child: Image(
                      width: 116.0,
                      height: 107.0,
                      image: AssetImage(widget.curtainType == CURTAIN_TYPE_LEFT
                          ? 'images/left_open.png'
                          : 'images/right_open.png'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(bottom: 12.0, right: 12.0),
                    child: Offstage(
                      offstage: currentDirection == CURTAIN_DIRECTION_ORIGIN,
                      child: Image(
                        width: 21.0,
                        height: 21.0,
                        image: AssetImage(
                            'images/icon_curtain_setting_select.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              currentDirection = CURTAIN_DIRECTION_REVERSE;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDouble(BuildContext context) {
    return Offstage(
      offstage: widget.curtainType != CURTAIN_TYPE_DOUBLE,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            child: Container(
              height: 165.0,
              decoration: BoxDecoration(
                color: currentDirection == CURTAIN_DIRECTION_ORIGIN
                    ? Color(0xFF7DCBF4)
                    : Color(0xFFB4DEF9),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              margin: EdgeInsets.only(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 14.0),
                    child: Image(
                      width: 262.0,
                      height: 107.0,
                      image: AssetImage('images/double_closed.png'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
                    child: Offstage(
                      offstage: currentDirection != CURTAIN_DIRECTION_ORIGIN,
                      child: Image(
                        width: 21.0,
                        height: 21.0,
                        image: AssetImage(
                            'images/icon_curtain_setting_select.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              currentDirection = CURTAIN_DIRECTION_ORIGIN;
              setState(() {});
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          GestureDetector(
            child: Container(
              height: 165.0,
              decoration: BoxDecoration(
                color: currentDirection == CURTAIN_DIRECTION_REVERSE
                    ? Color(0xFF7DCBF4)
                    : Color(0xFFB4DEF9),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              margin: EdgeInsets.only(),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 14.0),
                    child: Image(
                      width: 262.0,
                      height: 107.0,
                      image: AssetImage('images/double_open.png'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
                    child: Offstage(
                      offstage: currentDirection != CURTAIN_DIRECTION_REVERSE,
                      child: Image(
                        width: 21.0,
                        height: 21.0,
                        image: AssetImage(
                            'images/icon_curtain_setting_select.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              currentDirection = CURTAIN_DIRECTION_REVERSE;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
