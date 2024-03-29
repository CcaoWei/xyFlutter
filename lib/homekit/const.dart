part of homekit_shared;

const int S_PROPERTY = 0x203E; //设备信息
const int S_LIGHT_SOCKET = 0x2043;
const int S_PLUG = 0x2047; //插座
const int S_LOCK_MECHANISM = 0x2045; //门锁
const int S_PLUG_POWER = 0x3047; //功耗
const int S_WALL_SWITCH_LIGHT = 0x2049; //开关
const int S_TEMPERATURE = 0x208A; //温度
const int S_AWARENESS_SWITCH = 0x2089;
const int S_CONTACT_SENSOR = 0x2080; //接触式传感器
const int S_MOTION = 0x2085; //动作传感器
const int S_NEW_VERSION = 0x3043;
const int S_DEFINED_PERMIT_JOIN = 0x3044;
const int S_DELETE = 0x3045;
const int S_CURTAIN = 0x208C;
const int S_LIGHT_SENSOR = 0x2084; //照度传感器
const int S_CURTAIN_SETTNG = 0x3046;

const int C_NAME = 0x0023; //名称
const int C_MANUFACTURER = 0x0020; //生产厂商
const int C_MODEL = 0x0021; //产品类型
const int C_SERIAL_NUMBER = 0x0030; //序列号
const int C_FIRMWARE_VERSION = 0x0052; //固件版本
const int C_HARDWARE_VERSION = 0x0053; //
const int C_RECOGNITION = 0x0014; //
const int C_ON_OFF = 0x0025; //开关状态
const int C_NEW_VERSION_AVAILABLE = 0x100A; //
const int C_UPGRADE = 0x100B; //
const int C_OTA_STATUS = 0x100C; //
const int C_DEFINED_PERMIT_JOIN = 0x100D; //
const int C_DELETE = 0x100E; //
const int C_MOTION = 0x0022; // pir 是否检测到动作
const int C_LOW_POWER = 0x0079; //
const int C_TEMPERATURE = 0x0011; //温度current_temperature
const int C_SWITCH = 0x0073; //
const int C_CONTACT_SENSOR = 0x006A; //门磁 是否检测到动作
const int C_PLUG_BEING_USED = 0x0026; //插座当前是否正在被使用
const int C_ACTIVE_POWER = 0x1013; //功耗
const int C_TARGET_POSITION = 0x007C; // 窗帘 目标位置
const int C_CURRENT_POSITION = 0x006D; // 窗帘当前位置
const int C_CURRENT_STATE = 0x0072; //窗帘当前状态
const int C_LIGHT_LEVEL = 0x006B; //亮度
const int C_TYPE = 0x100F; //窗帘类型
const int C_DIRECTION = 0x1010; //窗帘防线
const int C_TRIP_CONFIGURED = 0x1011; //
const int C_TRIP_ADJUSTING = 0x1012; //窗帘校准
const int C_CHECK_NEW_VERSION = 0x1014; //
const int C_LOCK_CURRENT_STATE = 0x1D;
const int C_LOCK_TARGET_STATE = 0x1E;
