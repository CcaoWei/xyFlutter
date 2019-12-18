import 'data_shared.dart';

import 'package:xlive/channel/homekit_entity.dart';
import 'package:xlive/const/const_shared.dart';

PhysicDevice parseHomekitAccessory(HomekitAccessory accessory) {
  final PhysicDevice physicDevice = PhysicDevice(
    uuid: accessory.serialNumber,
    roomUuid: accessory.roomIdentifier,
    model: accessory.model,
    available: accessory.available,
    name: accessory.name,
    identifier: accessory.identifier,
    newVersion: accessory.newVersion,
  );

  final int firmwareVersion = int.parse(accessory.firmwareVersion);
  physicDevice.setAttribute(ATTRIBUTE_ID_FIRMWARE_VERSION, firmwareVersion);

  if (accessory.model == DEVICE_MODEL_LIGHT_SOCKET) {
    final String subSerialNumber =
        accessory.serialNumber.substring(0, accessory.serialNumber.length);
    final String logicDeviceUuid = subSerialNumber + '1';
    final String serviceName = accessory.serviceName;
    final LogicDevice logicDevice = LogicDevice(
        uuid: logicDeviceUuid,
        profile: PROFILE_ON_OFF_LIGHT,
        roomUuid: accessory.roomIdentifier,
        name: serviceName);
    logicDevice.parent = physicDevice;

    final int onOff = accessory.onOff;
    logicDevice.setAttribute(ATTRIBUTE_ID_ON_OFF_STATUS, onOff);

    physicDevice.logicDevices.add(logicDevice);
    return physicDevice;
  } else if (accessory.model == DEVICE_MODEL_SMART_PLUG) {
    final String subSerialNumber =
        accessory.serialNumber.substring(0, accessory.serialNumber.length);
    final String logicDeviceUuid = subSerialNumber + '1';
    final String serviceName = accessory.serviceName;
    final LogicDevice logicDevice = LogicDevice(
        uuid: logicDeviceUuid,
        profile: PROFILE_SMART_PLUG,
        roomUuid: accessory.roomIdentifier,
        name: serviceName);
    logicDevice.parent = physicDevice;

    final int onOff = accessory.onOff;
    logicDevice.setAttribute(ATTRIBUTE_ID_ON_OFF_STATUS, onOff);
    final int activePower = accessory.activePower;
    logicDevice.setAttribute(ATTRIBUTE_ID_ACTIVE_POWER, activePower);
    final int plugBeingUsed = accessory.plugBeingUsed ? 1 : 0;
    logicDevice.setAttribute(ATTRIBUTE_ID_INSERT_EXTRACT_STATUS, plugBeingUsed);

    physicDevice.logicDevices.add(logicDevice);
    return physicDevice;
  } else if (accessory.model == DEVICE_MODEL_AWARENESS_SWITCH) {
    //How to deal with left and right occupancy
    final String subSerialNumber =
        accessory.serialNumber.substring(0, accessory.serialNumber.length);
    final String logicDeviceUuid = subSerialNumber + '1';
    final String serviceName = accessory.serviceName;
    final LogicDevice logicDevice = LogicDevice(
        uuid: logicDeviceUuid,
        profile: PROFILE_PIR,
        roomUuid: accessory.roomIdentifier,
        name: serviceName);
    logicDevice.parent = physicDevice;

    final int temperature = accessory.temperature.round();
    logicDevice.setAttribute(ATTRIBUTE_ID_TEMPERATURE, temperature);
    //Is LIGHT_LEVEL corresponding to LUMINANCE ?
    final int lightLevel = accessory.lightLevel.round();
    logicDevice.setAttribute(ATTRIBUTE_ID_LUMINANCE, lightLevel);

    final int leftOccupancy = accessory.leftOccupancy;
    logicDevice.setAttribute(ATTRIBUTE_ID_OCCUPANCY_LEFT, leftOccupancy);
    final int rightOccupancy = accessory.rightOccupancy;
    logicDevice.setAttribute(ATTRIBUTE_ID_OCCUPANCY_RIGHT, rightOccupancy);

    physicDevice.logicDevices.add(logicDevice);
    return physicDevice;
  } else if (accessory.model == DEVICE_MODEL_DOOR_SENSOR) {
    final String subSerialNumber =
        accessory.serialNumber.substring(0, accessory.serialNumber.length);
    final String logicDeviceUuid = subSerialNumber + '1';
    final String serviceName = accessory.serviceName;
    final LogicDevice logicDevice = LogicDevice(
        uuid: logicDeviceUuid,
        profile: PROFILE_DOOR_CONTACT,
        roomUuid: accessory.roomIdentifier,
        name: serviceName);
    logicDevice.parent = physicDevice;

    final int temperature = accessory.temperature.round();
    logicDevice.setAttribute(ATTRIBUTE_ID_TEMPERATURE, temperature);
    final int openClose = accessory.openClose;
    logicDevice.setAttribute(ATTRIBUTE_ID_BINARY_INPUT_STATUS, openClose);

    physicDevice.logicDevices.add(logicDevice);
    return physicDevice;
  } else if (accessory.model == DEVICE_MODEL_CURTAIN) {
    final String subSerialNumber =
        accessory.serialNumber.substring(0, accessory.serialNumber.length);
    final String logicDeviceUuid = subSerialNumber + '1';
    final String serviceName = accessory.serviceName;
    final LogicDevice logicDevice = LogicDevice(
        uuid: logicDeviceUuid,
        profile: PROFILE_WINDOW_CORVERING,
        roomUuid: accessory.roomIdentifier,
        name: serviceName);
    logicDevice.parent = physicDevice;

    final int type = accessory.type;
    logicDevice.setAttribute(ATTRIBUTE_ID_CURTAIN_TYPE, type);
    final int direction = accessory.direction;
    logicDevice.setAttribute(ATTRIBUTE_ID_CURTAIN_DIRECTION, direction);
    //Maybe changed
    final int tripLearned = accessory.tripLearned;
    logicDevice.setAttribute(ATTRIBUTE_ID_CURTAIN_TRIP_CONFIGURED, tripLearned);
    //Maybe changed
    final int adjustTrip = accessory.adjustTrip;
    logicDevice.setAttribute(ATTRIBUTE_ID_CURTAIN_TRIP_ADJUSTING, adjustTrip);
    final int targetPosition = accessory.targetPosition;
    logicDevice.setAttribute(
        ATTRIBUTE_ID_CURTAIN_TARGET_POSITION, targetPosition);
    final int currentPosition = accessory.currentPosition;
    logicDevice.setAttribute(
        ATTRIBUTE_ID_CURTAIN_CURRENT_POSITION, currentPosition);
    final int currentState = accessory.currentState;
    logicDevice.setAttribute(ATTRIBUTE_ID_CURTAIN_STATUS, currentState);

    physicDevice.logicDevices.add(logicDevice);
    return physicDevice;
  } else if (accessory.model == DEVICE_MODEL_WALL_SWITCH_D1 ||
      accessory.model == DEVICE_MODEL_WALL_SWITCH_S1 ||
      accessory.model == DEVICE_MODEL_WALL_SWITCH_D2 ||
      accessory.model == DEVICE_MODEL_WALL_SWITCH_S2 ||
      accessory.model == DEVICE_MODEL_WALL_SWITCH_D3 ||
      accessory.model == DEVICE_MODEL_WALL_SWITCH_S3 ||
      accessory.model == DEVICE_MODEL_WALL_SWITCH_D4 ||
      accessory.model == DEVICE_MODEL_WALL_SWITCH_S4) {
    final String subSerialNumber =
        accessory.serialNumber.substring(0, accessory.serialNumber.length);

    final String logicDeviceUuid01 = subSerialNumber + '1';
    final String serviceName01 = accessory.serviceName01;
    final int profile01 =
        accessory.type01 == 1 ? PROFILE_ON_OFF_LIGHT : PROFILE_YAN_BUTTON;
    final LogicDevice logicDevice01 = LogicDevice(
        uuid: logicDeviceUuid01,
        profile: profile01,
        roomUuid: accessory.roomIdentifier,
        name: serviceName01);
    if (accessory.type01 == 1) {
      final int onOff01 = accessory.onOff01;
      logicDevice01.setAttribute(ATTRIBUTE_ID_ON_OFF_STATUS, onOff01);
    }

    final String logicDeviceUuid02 = subSerialNumber + '2';
    final String seviceName02 = accessory.serviceName02;
    final int profile02 =
        accessory.type02 == 1 ? PROFILE_ON_OFF_LIGHT : PROFILE_YAN_BUTTON;
    final LogicDevice logicDevice02 = LogicDevice(
        uuid: logicDeviceUuid02,
        profile: profile02,
        roomUuid: accessory.roomIdentifier,
        name: seviceName02);
    if (accessory.type02 == 1) {
      final int onOff02 = accessory.onOff02;
      logicDevice02.setAttribute(ATTRIBUTE_ID_ON_OFF_STATUS, onOff02);
    }

    final String logicDeviceUuid03 = subSerialNumber + '3';
    final String serviceName03 = accessory.serviceName03;
    final int profile03 =
        accessory.type03 == 1 ? PROFILE_ON_OFF_LIGHT : PROFILE_YAN_BUTTON;
    final LogicDevice logicDevice03 = LogicDevice(
        uuid: logicDeviceUuid03,
        profile: profile03,
        roomUuid: accessory.roomIdentifier,
        name: serviceName03);
    if (accessory.type03 == 1) {
      final int onOff03 = accessory.onOff03;
      logicDevice03.setAttribute(ATTRIBUTE_ID_ON_OFF_STATUS, onOff03);
    }

    final String logicDeviceUuid04 = subSerialNumber + '4';
    final String serviceName04 = accessory.serviceName04;
    final int profile04 =
        accessory.type04 == 1 ? PROFILE_ON_OFF_LIGHT : PROFILE_YAN_BUTTON;
    final LogicDevice logicDevice04 = LogicDevice(
        uuid: logicDeviceUuid04,
        profile: profile04,
        roomUuid: accessory.roomIdentifier,
        name: serviceName04);
    if (accessory.type04 == 1) {
      final int onOff04 = accessory.onOff04;
      logicDevice04.setAttribute(ATTRIBUTE_ID_ON_OFF_STATUS, onOff04);
    }

    physicDevice.logicDevices.add(logicDevice01);
    physicDevice.logicDevices.add(logicDevice02);
    physicDevice.logicDevices.add(logicDevice03);
    physicDevice.logicDevices.add(logicDevice04);
    return physicDevice;
  } else if (accessory.model == DEVICE_MODEL_HOME_CENTER) {
    final String uuid = HomeCenter.serialNumberToUuid(accessory.serialNumber);
    final HomeCenter homeCenter = HomeCenter(uuid: uuid, name: accessory.name);
    homeCenter.state = ASSOCIATION_TYPE_BOTH;
    HomeCenterManager().addHomeCenter(homeCenter);
    return physicDevice;
  } else {
    return null;
  }
}

Room parseHomekitRoom(HomekitRoom room) {
  return Room(
      uuid: room.identifier, name: room.name, identifier: room.identifier);
}
