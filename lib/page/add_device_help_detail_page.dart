import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xlive/localization/defined_localization.dart';

import 'common_page.dart';

import 'dart:async';

class AddDeviceHelpDetailPage extends StatefulWidget {
  final int index;
  AddDeviceHelpDetailPage({
    @required this.index,
  });

  State<StatefulWidget> createState() => _AddDeviceHelpDetail();
}

class _AddDeviceHelpDetail extends State<AddDeviceHelpDetailPage> {
  Timer timer;

  static final int DURATION = 15600;

  int time = 0;

  List<Image> lsImgs = List();
  List<Image> spImgs = List();
  List<Image> asImgs = List();
  List<Image> dcImgs = List();

  void initState() {
    print("------------------------------add_device_help_detail_page.dart");
    super.initState();

    initImages();

    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      time += 200;
      if (time > 15600) {
        time -= 15600;
      }
      setState(() {});
    });
  }

  void dispose() {
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  void initImages() {
    if (widget.index == 0) {
      lsImgs.add(Image.asset(
        'images/add_ls_help_01.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      lsImgs.add(Image.asset(
        'images/add_ls_help_02.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      lsImgs.add(Image.asset(
        'images/add_ls_help_03.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      lsImgs.add(Image.asset(
        'images/add_ls_help_04.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      lsImgs.add(Image.asset(
        'images/add_ls_help_05.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      lsImgs.add(Image.asset(
        'images/add_ls_help_06.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
    } else if (widget.index == 1) {
      spImgs.add(Image.asset(
        'images/add_sp_help_01.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      spImgs.add(Image.asset(
        'images/add_sp_help_02.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      spImgs.add(Image.asset(
        'images/add_sp_help_03.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      spImgs.add(Image.asset(
        'images/add_sp_help_04.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      spImgs.add(Image.asset(
        'images/add_sp_help_05.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
    } else if (widget.index == 2) {
      asImgs.add(Image.asset(
        'images/add_as_help_01.png',
        width: 237.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      asImgs.add(Image.asset(
        'images/add_as_help_02.png',
        width: 237.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      asImgs.add(Image.asset(
        'images/add_as_help_03.png',
        width: 237.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      asImgs.add(Image.asset(
        'images/add_as_help_04.png',
        width: 237.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      asImgs.add(Image.asset(
        'images/add_as_help_05.png',
        width: 237.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      asImgs.add(Image.asset(
        'images/add_as_help_06.png',
        width: 237.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
    } else if (widget.index == 3) {
      dcImgs.add(Image.asset(
        'images/add_dc_help_01.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      dcImgs.add(Image.asset(
        'images/add_dc_help_02.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      dcImgs.add(Image.asset(
        'images/add_dc_help_03.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      dcImgs.add(Image.asset(
        'images/add_dc_help_04.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      dcImgs.add(Image.asset(
        'images/add_dc_help_05.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
      dcImgs.add(Image.asset(
        'images/add_dc_help_06.png',
        width: 200.0,
        height: 192.0,
        gaplessPlayback: true,
      ));
    }
  }

  Image get _imageLight {
    final t = time % 15600;
    if (t < 1000) {
      return lsImgs[0];
    } else if (t < 4000) {
      return lsImgs[1];
    } else if (t < 4200) {
      return lsImgs[4];
    } else if (t < 4400) {
      return lsImgs[5];
    } else if (t < 4600) {
      return lsImgs[4];
    } else if (t < 4800) {
      return lsImgs[5];
    } else if (t < 5000) {
      return lsImgs[4];
    } else if (t < 5200) {
      return lsImgs[5];
    } else if (t < 5400) {
      return lsImgs[4];
    } else if (t < 5600) {
      return lsImgs[5];
    } else if (t < 5800) {
      return lsImgs[3];
    } else if (t < 6000) {
      return lsImgs[2];
    } else if (t < 6200) {
      return lsImgs[3];
    } else if (t < 6400) {
      return lsImgs[2];
    } else if (t < 6600) {
      return lsImgs[3];
    } else if (t < 6800) {
      return lsImgs[2];
    } else if (t < 7000) {
      return lsImgs[3];
    } else if (t < 7200) {
      return lsImgs[2];
    } else if (t < 7400) {
      return lsImgs[3];
    } else if (t < 7600) {
      return lsImgs[2];
    } else if (t < 8400) {
      return lsImgs[3];
    } else if (t < 9200) {
      return lsImgs[2];
    } else if (t < 10000) {
      return lsImgs[3];
    } else if (t < 10800) {
      return lsImgs[2];
    } else if (t < 11600) {
      return lsImgs[3];
    } else if (t < 12400) {
      return lsImgs[2];
    } else if (t < 13200) {
      return lsImgs[3];
    } else if (t < 14000) {
      return lsImgs[2];
    } else if (t < 14800) {
      return lsImgs[3];
    } else if (t <= 15600) {
      return lsImgs[2];
    } else {
      return lsImgs[2];
    }
  }

  Image get _imagePlug {
    final t = time % 15600;
    if (t < 1000) {
      return spImgs[0];
    } else if (t < 4000) {
      return spImgs[1];
    } else if (t < 4200) {
      return spImgs[4];
    } else if (t < 4400) {
      return spImgs[0];
    } else if (t < 4600) {
      return spImgs[4];
    } else if (t < 4800) {
      return spImgs[0];
    } else if (t < 5000) {
      return spImgs[4];
    } else if (t < 5200) {
      return spImgs[0];
    } else if (t < 5400) {
      return spImgs[4];
    } else if (t < 5600) {
      return spImgs[0];
    } else if (t < 5800) {
      return spImgs[3];
    } else if (t < 6000) {
      return spImgs[2];
    } else if (t < 6200) {
      return spImgs[3];
    } else if (t < 6400) {
      return spImgs[2];
    } else if (t < 6600) {
      return spImgs[3];
    } else if (t < 6800) {
      return spImgs[2];
    } else if (t < 7000) {
      return spImgs[3];
    } else if (t < 7200) {
      return spImgs[2];
    } else if (t < 7400) {
      return spImgs[3];
    } else if (t < 7600) {
      return spImgs[2];
    } else if (t < 8400) {
      return spImgs[3];
    } else if (t < 9200) {
      return spImgs[2];
    } else if (t < 10000) {
      return spImgs[3];
    } else if (t < 10800) {
      return spImgs[2];
    } else if (t < 11600) {
      return spImgs[3];
    } else if (t < 12400) {
      return spImgs[2];
    } else if (t < 13200) {
      return spImgs[3];
    } else if (t < 14000) {
      return spImgs[2];
    } else if (t < 14800) {
      return spImgs[3];
    } else if (t <= 15600) {
      return spImgs[2];
    } else {
      return spImgs[2];
    }
  }

  Image get _imageAwarenessSwitch {
    final t = time % 15600;
    if (t < (1000)) {
      return asImgs[0];
    } else if (t < (4000)) {
      return asImgs[1];
    } else if (t < (4200)) {
      return asImgs[4];
    } else if (t < (4400)) {
      return asImgs[5];
    } else if (t < (4600)) {
      return asImgs[4];
    } else if (t < (4800)) {
      return asImgs[5];
    } else if (t < (5000)) {
      return asImgs[4];
    } else if (t < (5200)) {
      return asImgs[5];
    } else if (t < (5400)) {
      return asImgs[4];
    } else if (t < (5600)) {
      return asImgs[5];
    } else if (t < (5800)) {
      return asImgs[3];
    } else if (t < (6000)) {
      return asImgs[2];
    } else if (t < (6200)) {
      return asImgs[3];
    } else if (t < (6400)) {
      return asImgs[2];
    } else if (t < (6600)) {
      return asImgs[3];
    } else if (t < (6800)) {
      return asImgs[2];
    } else if (t < (7000)) {
      return asImgs[3];
    } else if (t < (7200)) {
      return asImgs[2];
    } else if (t < (7400)) {
      return asImgs[3];
    } else if (t < (7600)) {
      return asImgs[2];
    } else if (t < (8400)) {
      return asImgs[3];
    } else if (t < (9200)) {
      return asImgs[2];
    } else if (t < (10000)) {
      return asImgs[3];
    } else if (t < (10800)) {
      return asImgs[2];
    } else if (t < (11600)) {
      return asImgs[3];
    } else if (t < (12400)) {
      return asImgs[2];
    } else if (t < (13200)) {
      return asImgs[3];
    } else if (t < (14000)) {
      return asImgs[2];
    } else if (t < (14800)) {
      return asImgs[3];
    } else if (t <= (15600)) {
      return asImgs[2];
    } else {
      return asImgs[2];
    }
  }

  Image get _imageDoorContact {
    final t = time % 15600;
    if (t < (1000)) {
      return dcImgs[0];
    } else if (t < (4000)) {
      return dcImgs[1];
    } else if (t < (4200)) {
      return dcImgs[4];
    } else if (t < (4400)) {
      return dcImgs[5];
    } else if (t < (4600)) {
      return dcImgs[4];
    } else if (t < (4800)) {
      return dcImgs[5];
    } else if (t < (5000)) {
      return dcImgs[4];
    } else if (t < (5200)) {
      return dcImgs[5];
    } else if (t < (5400)) {
      return dcImgs[4];
    } else if (t < (5600)) {
      return dcImgs[5];
    } else if (t < (5800)) {
      return dcImgs[3];
    } else if (t < (6000)) {
      return dcImgs[2];
    } else if (t < (6200)) {
      return dcImgs[3];
    } else if (t < (6400)) {
      return dcImgs[2];
    } else if (t < (6600)) {
      return dcImgs[3];
    } else if (t < (6800)) {
      return dcImgs[2];
    } else if (t < (7000)) {
      return dcImgs[3];
    } else if (t < (7200)) {
      return dcImgs[2];
    } else if (t < (7400)) {
      return dcImgs[3];
    } else if (t < (7600)) {
      return dcImgs[2];
    } else if (t < (8400)) {
      return dcImgs[3];
    } else if (t < (9200)) {
      return dcImgs[2];
    } else if (t < (10000)) {
      return dcImgs[3];
    } else if (t < (10800)) {
      return dcImgs[2];
    } else if (t < (11600)) {
      return dcImgs[3];
    } else if (t < (12400)) {
      return dcImgs[2];
    } else if (t < (13200)) {
      return dcImgs[3];
    } else if (t < (14000)) {
      return dcImgs[2];
    } else if (t < (14800)) {
      return dcImgs[3];
    } else if (t <= (15600)) {
      return dcImgs[2];
    } else {
      return dcImgs[2];
    }
  }

  Image get _image {
    switch (widget.index) {
      case 0:
        return _imageLight;
      case 1:
        return _imagePlug;
      case 2:
        return _imageAwarenessSwitch;
      case 3:
        return _imageDoorContact;
      default:
        return _imageLight;
    }
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).addDevice,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: _image,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            height: 20.0,
            child: Offstage(
              offstage: time < 1560,
              child: Text(
                DefinedLocalizations.of(context).longPressDescription,
                style: TextStyle(
                  inherit: false,
                  fontSize: 16.0,
                  color: Color(0xFF899198),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
