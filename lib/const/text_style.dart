part of const_shared; //文字类型

//帐号绑定页面(已绑定,未绑定,待认证)
const TextStyle TEXT_STYLE_BINDING_STATE = const TextStyle(
  inherit: false,
  fontSize: 14.0,
  color: const Color(0xB42D3B46),
);

//帐号绑定页面(手机号,邮箱)
const TextStyle TEXT_STYLE_BINDING_ACCOUNT = const TextStyle(
  inherit: false,
  fontSize: 12.0,
  color: const Color(0xB42D3B46),
);

//帐号绑定页面(接收提醒消息)
const TextStyle TEXT_STYLE_BINDING_MESSAGE_TIP = const TextStyle(
  inherit: false,
  fontSize: 10.0,
  color: const Color(0xB42D3B46),
);

//帐号绑定页面按钮
const TextStyle TEXT_STYLE_BINDING_BUTTON = const TextStyle(
  inherit: false,
  fontSize: 13.0,
  color: const Color(0xFF2D3B46),
);

//帐号绑定页面获取验证码
const TextStyle TEXT_STYLE_BINDING_GET_CODE = const TextStyle(
  inherit: false,
  fontSize: 12.0,
  color: Colors.blue,
);

//手机登录和绑定手机页面获取验证码按钮
const TextStyle TEXT_STYLE_GET_CODE_BUTTON_ENABLED = const TextStyle(
  inherit: false,
  fontSize: 11.0,
  color: const Color(0xFF606972),
);

const TextStyle TEXT_STYLE_GET_CODE_BUTTON_DISABLED = const TextStyle(
  inherit: false,
  fontSize: 11.0,
  color: const Color(0xFFDDDDDD),
);

//大号按钮
const TextStyle TEXT_STYLE_BUTTON_ENABLED = const TextStyle(
  inherit: false,
  fontSize: 16.0,
  color: const Color(0xFF606972),
);

const TextStyle TEXT_STYLE_BUTTON_DISABLED = const TextStyle(
  inherit: false,
  fontSize: 16.0,
  color: const Color(0xFFDDDDDD),
);

//Input Hint
const TextStyle TEXT_STYLE_INPUT_HINT = const TextStyle(
  inherit: false,
  fontSize: 14.0,
  color: const Color(0xFFD9D9D9),
);

//设备详情页离线
const TextStyle TEXT_STYLE_OFFLINE = const TextStyle(
  inherit: false,
  fontSize: 16.0,
  color: Colors.white,
);

//绑定名称
const TextStyle TEXT_STYLE_BINDING_NAME = const TextStyle(
  inherit: false,
  fontSize: 16.0,
  color: const Color(0xFFFFB34D),
);

//绑定描述
const TextStyle TEXT_STYLE_BINDING_DESCRIPTION = const TextStyle(
  inherit: false,
  fontSize: 12.0,
  color: const Color(0x7F899198),
);

//绑定页面字体
const TextStyle TEXT_STYLE_BINDING_DEVICE_NAME = const TextStyle(
  inherit: false,
  fontSize: 15.0,
  color: const Color(0xFF55585A),
);

const TextStyle TEXT_STYLE_ALERT_DIALOG_TITLE = const TextStyle(
  inherit: false,
  fontSize: 18.0,
  color: Colors.black,
);

const TextStyle TEXT_STYLE_DELETE_BUTTON = const TextStyle(
  inherit: false,
  fontSize: 16.0,
  color: Colors.white,
);

//device detail home center detail
const TextStyle TEXT_STYLE_INFORMATION_TYPE = const TextStyle(
  inherit: false,
  fontSize: 15.0,
  color: const Color(0x7D2D3B46),
);

const TextStyle TEXT_STYLE_INFORMATION_CONTENT = const TextStyle(
  inherit: false,
  fontSize: 15.0,
  color: const Color(0xB22D3B46),
);

const TextStyle TEXT_STYLE_SCENE_ANIMATION_TEXT = const TextStyle(
  inherit: false,
  fontSize: 14.0,
  color: const Color(0xFF6E869A),
);

const TextStyle TEXT_STYLE_ROOM_NAME = const TextStyle(
  inherit: false,
  fontSize: 14.0,
  color: const Color(0xFF9B9B9B),
);

//添加场景 添加设备
const TextStyle TEXT_STYLE_ADD_TEXT = const TextStyle(
  inherit: false,
  fontSize: 13.0,
  color: const Color(0xFF7CD0FF),
);

//firmware upgrade page group
const TextStyle TEXT_STYLE_UPGRADE_GROUP = const TextStyle(
  inherit: false,
  fontSize: 14.0,
  color: const Color(0xFF899198),
);

const TextStyle TEXT_STYLE_UPGRADE_BUTTON = const TextStyle(
  inherit: false,
  fontSize: 12.0,
  color: Colors.white,
);

const TextStyle TEXT_STYLE_UPGRADE_NAME = const TextStyle(
  inherit: false,
  fontSize: 16.0,
  color: const Color(0xFF2D3B46),
);

const TextStyle TEXT_STYLE_UPGRADE_DESCRIPTION = const TextStyle(
  inherit: false,
  fontSize: 14.0,
  color: const Color(0xFF899198),
);

const TextStyle TEXT_STYLE_UPGRADE_PROGRESS = const TextStyle(
  inherit: false,
  fontSize: 10.0,
  color: const Color(0xFF788087),
);

const TextStyle TEXT_STYLE_BUTTON = const TextStyle(
  inherit: false,
  fontSize: 16.0,
  color: const Color(0xFF606972),
);

const TextStyle TEXT_STYLE_DIALOG_TITLE = const TextStyle(
  inherit: false,
  fontSize: 18.0,
  color: Colors.black,
);

const TextStyle TEXT_STYLE_CREATE_ROOM = const TextStyle(
  inherit: false,
  fontSize: 16.0,
  color: const Color(0xFFFFB34D),
);

//自动化的标题
const TextStyle TEXT_STYLE_AUTO_BT = const TextStyle(
  inherit: false,
  fontSize: 15,
  color: const Color(0xFF55585a),
);
const TextStyle TEXT_STYLE_AUTOMATION_BT = const TextStyle(
  inherit: false,
  fontSize: 17.0,
  color: const Color(0xFF55585a),
);
const TextStyle TEXT_STYLE_AUTOMATION_DETAILS = const TextStyle(
  inherit: false,
  fontSize: 12.0,
  color: const Color(0x75899198),
);
const TextStyle TEXT_STYLE_AUTOMATION_COND_DEVICE = const TextStyle(
  inherit: false,
  fontSize: 14.0,
  color: const Color(0x80899198),
);
const TextStyle TEXT_STYLE_W600 = const TextStyle(
    color: Color(0xff55585a), fontSize: 18.0, fontWeight: FontWeight.w600);

// new TextStyle
//   下一步
TextStyle TEXT_STYLE_NEXT_STEP =
    TextStyle(fontSize: Adapt.px(42), color: Color(0xff7cd0ff));
// 横线那种   左边字体
TextStyle TEXT_STYLE_LINE_LEFT =
    TextStyle(color: Color(0xff55585a), fontSize: Adapt.px(46));
// 横线那种   右边值
TextStyle TEXT_STYLE_LINE_RIGHT =
    TextStyle(color: Color(0x732D3B46), fontSize: Adapt.px(46));
//  设备页面那种 房间名
TextStyle TEXT_STYLE_DEVICE_ROOM_NAME =
    TextStyle(color: Color(0xff9b9b9b), fontSize: Adapt.px(42));
//  设备页面那种 设备名
TextStyle TEXT_STYLE_DEVICE_DEVICE_NAME =
    TextStyle(color: Color(0xff55585A), fontSize: Adapt.px(45));
//  设备页面那种 设备名下面的介绍
TextStyle TEXT_STYLE_DEVICE_DEVICE_DETAIL =
    TextStyle(color: Color(0x50899198), fontSize: Adapt.px(36));
//  设备页面那种 设备离线
TextStyle TEXT_STYLE_DEVICE_DEVICE_OFFLINE =
    TextStyle(color: Color(0x50899198), fontSize: Adapt.px(36));
//  button  里面的字  添加
TextStyle TEXT_STYLE_BUTTON_ADD =
    TextStyle(color: Color(0xffffffff), fontSize: Adapt.px(39));
//  button  里面的字  不能添加
TextStyle TEXT_STYLE_BUTTON_IS_RUNNING =
    TextStyle(color: Color(0x20333333), fontSize: Adapt.px(39));
//  倒计时里面 button的
TextStyle Text_o = TextStyle(
    inherit: false, fontSize: Adapt.px(46), color: const Color(0xff2d3b46));
TextStyle Text_o2 = TextStyle(
    inherit: false, fontSize: Adapt.px(46), color: const Color(0x202d3b46));
TextStyle Text_o3 = TextStyle(
    inherit: false, fontSize: Adapt.px(46), color: const Color(0xffffffff));
