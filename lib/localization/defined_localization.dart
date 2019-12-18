import 'package:flutter/material.dart';

//注: 要支持更多语言的话在main.dart与defined_localization_delegate.dart中要作相应修改

class DefinedLocalizations {
  final Locale locale;
  static DefinedLocalizations _instance;

  DefinedLocalizations(this.locale);

  static DefinedLocalizations of(BuildContext context) {
    if (context != null) {
      _instance = Localizations.of(context, DefinedLocalizations);
    }
    return _instance;
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'device': 'Device',
      'scene': 'Scene',
      'message': 'Message',
      'automation': 'Automation',
      'my': 'My',
      'home_center': 'Home Center',
      'online': 'Online',
      'offline': 'Offline',
      'add_home_center': 'Add Home Center',
      'undefined_area': 'Default Room',
      'lights': 'Lights',
      'switches': 'Switches',
      'binding': 'Automation',
      'setting': 'Settings',
      'delete': 'Delete',
      'name': 'Name',
      'room': 'Room',
      'curtain_type': 'Curtain Type',
      'curtain_direction': 'Curtain Direction',
      'trip_adjusted': 'Trip adjusted',
      'others': 'Others',
      'notification': 'Notification',
      'notification_state_changed': 'Notification upon status change',
      'alarm_disalarm': 'Arm / Disarm',
      'notification_open_close': 'Notification upon door open',
      'notification_someone_passby': 'Notification upon motion detection',
      'timer': 'Timer',
      'timer_description': 'Turn on/off on schedule',
      'count_down': 'Countdown',
      'count_down_description': 'Turn on/off after a period',
      'key_press': 'Wireless control',
      'key_press_description': 'All devices set with a single press',
      'pir_panel': 'Light control',
      'pir_panel_description': 'Turn lights on when people pass by',
      'open_close': 'Turn lights on when door open or closed',
      'open_close_description': 'Turn lighs on when door open or closed',
      'right_top_button': 'Top right button',
      'right_bottom_button': 'Bottom right button',
      'left_bottom_button': 'Bottom left button',
      'left_top_button': 'Top left button',
      'click_button': 'Single press',
      'double_click_button': 'Double press',
      'double_click_description': 'Contrl device with double press',
      'click_control_window': 'Control curtain with button',
      'click_control_window_description': 'Control curtain with single press',
      'double_click_control_window_description':
          'Control curtain with double press',
      'click_binding': 'Automation with button',
      'sure_to_delete_device': 'Are you sure to delete the device?',
      'sure_to_delete_home_center': 'Are you sure to delete the Home Center?',
      'sure_to_delete_scene': 'Are you sure to delete the scene?',
      'cancel': 'Cancel',
      'change_device_name': 'Change device name',
      'set_area': 'Room setting',
      'choose_area': 'Select room',
      'serial_number': 'Serial number',
      'version': 'Version',
      'rssi': 'Rssi',
      'binding_set_title_1': 'All devices set with a single press',
      'binding_set_title_2': 'Turn light on when door open',
      'binding_set_title_3': 'Turn lights on when people pass by',
      'choose_device': 'Select the devices to control',
      'choose_action': 'Set condition',
      'choose_action_description': 'Act when door is open or closed',
      'choose_luminance': 'Brightness condition',
      'choose_luminance_description':
          'Act when environment brightness is lower than the condition',
      'open': 'Open',
      'close': 'Close',
      'open_or_close': 'Open or close',
      'very_very_light': 'Bright sun shine',
      'light': 'In door light (good for reading)',
      'little_dark': 'Dim road lamp',
      'very_dark': 'Dark moon light',
      'defined': 'Customize',
      'lux_10000': 'About 10000 lux',
      'lux_300': 'About 300 lux',
      'lux_100': 'About 100 lux (recommended)',
      'lux_30': 'About 30 lux',
      'lux': 'Lux',
      'lux_defined': 'Set a customized brightness value',
      'none': '',
      'not_surpport': 'Not supported',
      'add_device': 'Add device',
      'set_permit_join_failed': 'Fail to start device discovery',
      'scan_devices': 'Scanning for new devices',
      'long_press_button': 'Long press the button on device',
      'new_device_1': 'Discovered',
      'new_device_2': 'new device(s)',
      'add': 'Add',
      'no_new_device': 'No new devices found',
      'choose_device_type': 'Select device type',
      'light_socket': 'Smart Light Socket',
      'smart_plug': 'Smart Plug',
      'awareness_switch': 'Awareness Switch',
      'door_contact': 'Door Sensor',
      'smart_curtain': 'Curtain Motor',
      'wall_switch': 'Wall Switch',
      'smart_dial': 'Smart Dial',
      'switch_module': 'Switch Module',
      'smart_door_lock': 'Smart Lock',
      'fast_name': 'Name device',
      'long_press_description':
          'Long press the button for 6 seconds till the led starts flashing',
      'failed': 'Failed',
      'next': 'Next',
      'choose_curtain_type': 'Select curtain type',
      'left_curtain': 'Left side curtain',
      'right_curtain': 'Right side curtain',
      'double_curtain': 'Double side curtain',
      'choose_curtain_direction': 'Select curtain direction',
      'submit': 'Submit',
      'first_description': 'Start easy simple life',
      'use_lan_access': 'Click icon above to access without log in',
      'login_uncomplete': 'Logging in',
      'get_data_uncomplete': 'Loading',
      'my_family': 'My family',
      'about_us': 'About us',
      'account_binding': 'Third party account association',
      'change_password': 'Change password',
      'help': 'Help',
      'log_out': 'Log out',
      'sure_to_log_out': 'Are you sure to log out?',
      'out': 'Yes',
      'login': 'Login',
      'register': 'Register',
      'mobile_login': 'Login with mobile phone',
      'input_mobile': 'Mobile number',
      'get_code': 'Get code',
      'input_code': 'Verification code',
      'account_login': 'Login with password',
      'send_again': 'Get again',
      'input_email': 'Email',
      'input_password': 'Password',
      'register_account': 'Register',
      'email_registed': 'The email has been used',
      'input_origin_password': 'Original password',
      'input_new_password': 'New password',
      'forget_password': 'Forget password',
      'reset_password': 'Reset password',
      'reset_password_des1': "Reset your account's password",
      'reset_password_des2':
          'Verification code will be sent via means below to reset password',
      'get_code_by_mobile': 'With mobile',
      'get_code_by_email': 'With email',
      'not_bind_email_and_mobile': 'No associated mobile or email',
      'bind_now': 'Associate now',
      'mobile_not_bind': 'Mobile not associated',
      'email_not_bind': 'Email not associated',
      'email_not_confirmed': 'Email not verified',
      'code_send': 'Verification code sent',
      'check_new_version': 'Check new version',
      'about_us_des1': 'Terms and conditions',
      'about_us_des2':
          'Shanghai Xiaoyan Technology Co., Ltd. all rights reserved',
      'setup_tip': 'Setup tip',
      'setup_tip1':
          'Make sure the home center is connected to power and network cable. You may add new home center via ',
      'setup_tip2': '',
      'or': ' or ',
      'automatic_found': 'Automatic discovery',
      'automatic_found_des':
          'Make sure your mobile connect to a WiFi on the same router the home center is connecting to, or you can scan the QR code to add it.',
      'found_1': 'Discovered',
      'found_2': 'new home center(s)',
      'found_none': 'No home center found',
      'found_none_des':
          "If you can't see the desired home center, please scan the QR code to add it.",
      'scan_code': 'Scan QR code',
      'scan_code_des':
          'You may add the home center by scanning the QR code on the bottom of the home center',
      'begin_scanning': 'Start scanning',
      'put_code': 'Place the QR code in the frame',
      'login_other_ways': 'Login with other account',
      'not_bind': 'Not associated',
      'binded': 'Associated',
      'to_be_confirmed': 'Waiting for confirm',
      'to_be_authorized': 'Waiting for authorization',
      'to_be_authorized_by_others':
          'Request sent, waiting for authorization of other users.',
      'click_to_bind': 'Associate',
      'click_to_unbind': 'Unassociate',
      'receive_message_by_mobile': 'Receive notification via SMS',
      'receive_message_by_email': 'Receive notification via email',
      'receive_message_by_wechat':
          'Receive notification in wechat\nSubscribe xiaoyan tech wechat\nservice account first',
      'mobile_binded': 'Mobile number has been used',
      'email_binded': 'Email has been used',
      'wechat_binded': 'Wechat account has been used',
      'qq_binded': 'QQ account has been used',
      'bind_mobile': 'Associate mobile',
      'bind_email': 'Associate email',
      'email_send': 'Sent verification mail, please verify',
      'sure_to_delete_mobile': 'Are you sure to un-associate mobile?',
      'sure_to_delete_email': 'Are you sure to un-associate email?',
      'sure_to_delete_wechat': 'Are you sure to un-associate wechat?',
      'sure_to_delete_qq': 'Are you sure to un-associate QQ?',
      'xiaoyan_home_center': 'Home Center',
      'device_name': 'Name',
      'device_type': 'Model',
      'associated_account': 'Associated users',
      'firmware_upgrade': 'Firmware upgrade',
      'system_information': 'System information',
      'on': 'On',
      'off': 'Off',
      'alarm': 'Arm',
      'disalarm': 'Dis',
      'devices_on': ' device(s) on',
      'devices_arming': ' device(s) armed',
      'current_temperature': 'Current temperature ',
      'scene_edit': 'Edit scene',
      'input_scene_name_hint': 'Scene name',
      'scene_name_exist': 'Name already exist',
      'add_scene': 'Add scene',
      'scene_no_actions': "Scene doesn't have any action",
      'ip_address': 'IP address',
      'channel': 'Channel',
      'check_new_version_des': 'Check new firmware for all devices',
      'commond_sent': 'Command sent',
      'confirm': 'OK',
      'can_upgrade_to': 'Firmware available',
      'current_version': 'Current version',
      'upgrading': 'Upgrading ...',
      'prepare_to_upgrade': 'Preparing for upgrading ...',
      'upgrade_complete': 'Upgrading finished',
      'upgrade_error': 'Upgrading error',
      'upgrade': 'Upgrade',
      'cancel_add': 'Cancel',
      'illegal_password_length':
          'The password length must between 6 to 32 digits',
      'qq_not_installed': 'QQ not installed',
      'wechat_not_installed': 'Wechat not installed',
      'request': 'Request',
      'invitation': 'Invitation',
      'request_to_join': 'Request to join',
      'reject': 'Reject',
      'approve': 'Approve',
      'accept': 'Accept',
      'request_to_join_des': 'Request to use home center',
      'invite_to_join_des': 'Invite you to use home center',
      'home_center_message': 'Home center message',
      'new_home_center_found': 'Found new home center',
      'manage_rooms': 'Room management',
      'create_room': 'Create room',
      'input_room_name': 'Room name',
      'already_exist': 'Already exist',
      'config_room': 'Room setting',
      'sure_to_delete_room': 'Are you sure to delete the room?',

      'room_default': 'Default Room',
      'room_living_room': 'Living Room',
      'room_master_bedroom': 'Master Room',
      'room_guest_bedroom': 'Guest Room',
      'room_dinning_room': 'Dining Room',
      'room_kitchen': 'Kitchen',
      'room_balcony': 'Balcony',
      'room_study': 'Study',
      'room_entrance': 'Entrance',
      'room_bathroom': 'Bathroom',
      'scene_home': 'Home',
      'scene_leaving': 'Leaving',
      'scene_wakeup': 'Wakeup',
      'scene_sleep': 'Sleep',

      'led_indicator_configuration': 'LED indicator configuration',
      'led_indicator_off': 'Always off',
      'led_indicator_off_des': 'Reduce light during night',
      'led_indicator_on': 'Always on',
      'led_indicator_dual_on_des': 'Enable green LED, disable yellow LED',
      'led_indicator_single_on_des': 'Enable LED indicator',
      'exclusive_on_enable': 'Interlock enabled',
      'exclusive_on_enable_des':
          'Only one switch is allowed to be on, others are off',
      'exclusive_on_disable': 'All switches can be freely set to on',
      'exclusive_on_disable_des': 'All switches can be freely set to on',
      'sm_input_mode_button': 'Button swtich',
      'sm_input_mode_button_des':
          'Select the input switch type, a button or a rocker',
      'sm_input_mode_rocker': 'Rocker switch',
      'sm_input_mode_rocker_des':
          'Select the input switch type, a button or a rocker',
      'sm_polarity_on': 'Toggle output on change',
      'sm_polarity_on_des':
          'Toggle output state if eiter side of the rocker is pressed',
      'sm_polarity_off': 'Output state follows switch state',
      'sm_polarity_off_des':
          'The output states is always the same as switch state',
      'recover_relay_configuration': 'Preserve on off status',
      'exclusive_on': 'Only one output on',
      'exclusive_on_setting': 'Interlock Setting',
      'sm_input_mode': 'Swith type',
      'sm_polarity': 'Output behavior',
      'recover_relay_off': 'Disable',
      'recover_relay_off_des': 'Set status to off upon power apply',
      'recover_relay_on': 'Enable',
      'recover_relay_on_des': 'Set status to the last state upon power apply',
      'switch_configuration': 'Light control / Programmable switch',
      'sure_to_delete_user': 'Are you sure to delete the user?',

      'select_all_open': 'All open',
      'select_all_closed': 'All close',
      'select_all': 'Select all',
      'cancel_select_all': 'Cancel',
      'start': 'En',
      'stop': 'Dis',
      'follow': 'En',
      'unfollow': 'Dis',
      'open_scan_succeed': 'Scanning started',
      'origin': 'Original',
      'reverse': 'Reverse',
      'yes': 'Yes',
      'no': 'No',
      'adjust_curtain_des':
          'The procedure will take about 45 to 60 seconds. Are you sure to adjust track length now?',
      'try_connecting': 'Try connecting',
      'is_online': 'is online',
      'home_center_offline': 'Home Center is offline',

      'no_access_to_camera':
          'The app does not have permission to use the camera.',

      'sd_rotate': 'Smart Dial',
      'sd_rotate_description': 'Precise control with rotation',
      'binding_set_title_4': 'Precise control with rotation',
      'relay_light': 'Set to control light',
      'relay_light_des': 'Click the button to control connected light',
      'relay_button': 'Set as programmable switch',
      'relay_button_des': 'Programmable switch used for trigger scene',
      'first_button': 'Top Button',
      'second_button': 'Middle Button',
      'third_button': 'Bottom Button',

      'upgrade_policy': 'Upgrade policy',
      'upgrade_policy_alpha': 'Development (To try newest features)',
      'upgrade_policy_beta': 'User Testing (To try stable new features)',
      'upgrade_plicy_stable': 'Stable',
      'change_alpha_des': 'Are you sure to switch to development channel?',
      'change_beta_des': 'Are you sure to switch to user testing channel?',
      'change_stable_des': 'Are you sure to switch to stable channel?',
      'no_device_description':
          'Uh...no devices here\nYou can click the button on the right top to add devices',
      'found_new_version': 'Find new version',
      'ignore_message': 'Ignore this message',
      'xiaoyan_home': 'Xiaoyan Home',
      'download_description': 'Downloading...',
      'current_is_latest': 'The current version is the latest',
      'empty_scene': 'Scene is empty',
      'home_center_removed_des1': 'You are not allowed to use this Home Center',
      'home_center_removed_des2': 'Please associate it to use',
      "create_automation": 'Create Automation',
      "auto_mation_bt": 'Automate your home, in a smart way',

      'home': 'Home',
      'add_home': 'Add home',
      'homes_empty':
          'No home exists, click the button in the top right corner to create',
      'new_home': 'New home',
      'input_name': 'Name',
      'error': 'Error',
      'warning': 'Warning',
      'home_setting': 'Home setting',
      'rename': 'Rename',
      'set_as_primary_home': 'Set as primary home',
      'sure_to_delete_home': 'Are you sure to delete the home?',
      'device_setting': 'Device setting',
      'transfer': 'Select room',
      'choose_a_room': 'Select a room',
      'add_end_device': 'Add end point device',
      'add_end_device_des':
          'Make sure device is powered on and long press the button on it',
      'complete': 'Complete',
      'management': 'Management',
      'add_room': 'Add Room',
      'warn': 'warning', //警告
      'device_information': 'Device Information',
      'lightbult': 'Lightbulb',
      'outlet': 'Outlet',
      'energy': 'Current power',
      'motion_sensor': 'Motion sensor',
      'light_sensor': 'Light sensor',
      'contact_sensor': 'Contact sensor',
      'wall_switch_light': 'Switch',
      'curtain': 'Curtain',
      'curtain_setting': 'Curtain setting',
      "temperature": "temperature",
      "manufacturer": "Manufacturer",
      "plug_being_used": "Plug is being used",
      "lock_current_state": "Lock state",
      "lock_auth_data": "Authrization data",
      "lock_auth_data_allocated": "Authrization data set",
      "generate_lock_auth_data": "Generate data",
      "power_state": "Power state",
      "power_consumption": "Power consumption(w)",
      "firmware_version": "Firmware version",
      "model": "model",
      "latest_firmware_version": "Latest firmware version",
      "contact_sensor_state": "Contact sensor state",
      "motion_detected": "Motion detected",
      "current_state": "Current state",
      "current_position": "Current position",
      "target_position": "Target position",
      "curtain_trip_learned": "Curtain trip learned",
      "light_level": "light level (Lux)",
      'updating': 'updating',
      "device_open": "open",
      "device_close": "close",
      'scene_setting': 'Scene settings',
      'excute': 'Excute',
      'edit': 'Eidt',
      'no_new_version': 'No new firmware available',
      'click_to_config': 'Click to config',
      "is_adjusting": "Calibrate roller length",
      "is_adjusting_text":
          "It takes about 45~60 seconds to calibrate. Are you sure to calibrate now?",
      "user_management": "User management",
      "xiaoyan_system": "Terncy System",

      'view_new_features': 'New features',
      'official_site_root': 'terncy.com',
      'company_name': 'Shanghai Xiaoyan Technology Co., Ltd.',
      'service_phone': 'Telephone:',
      'current_home': ' (current)',
      'milli_watt': 'mW',
      'watt': 'W',
      'change_password_failed': 'Failed. Please check current password.',
      'bad_homekit_room_name': 'Name should start with letter or number',
      'weekday0': 'Sun',
      'weekday1': 'Mon',
      'weekday2': 'Tue',
      'weekday3': 'Wen',
      'weekday4': 'Thu',
      'weekday5': 'Fri',
      'weekday6': 'Sat',
      'everyday': 'Everyday',
      'weekends': 'Weekend',
      'workdays': 'Workday',
      'hourfull': 'Hour',
      'hour': 'H',
      'minutefull': 'Minute',
      'minute': 'M',
      'secondfull': 'Second',
      'second': 'S',
      'time': 'Time',
      'sure_to_delete_automation': 'Delete this automation rule？',
      'sure_to_delete_condition': 'Delete this condition?',
      'sure_to_delete_execution': 'Delete this action?',
      'if': 'If',
      'then': 'Then',
      'repeat': 'Repeat',
      'automation_enable': "Enable",
      'auto_cond_add': 'No condition yet',
      'auto_exec_add': "No action yet",
      'add_auto_name_input': "Set automation name",
      'auto_onoff_cond_type': "Turn on or off",
      'auto_onoff_power_cond_type': "On off status, power consumption",
      'auto_open_close_tem_cond_type': "On, off or temprature",
      'auto_body_tem_cond_type': "Motion, temperature",
      'auto_open_close_exercise_cond_type': "Open, close or move",
      'auto_light_keypress_cond_type': "Light or button",
      'auto_angle_rotate_cond_type': "Rotation angles",
      'auto_select_check_people_time': "Motion detected for ...",
      'auto_select_check_no_people_time': "No motion detected for ...",
      'no_motion_detected_for': "No motion detected for ",
      'motion_detected_for': "Motion detected for ",
      'auto_set_repeat': "Repeat rule",
      'auto_set_time': "Set time",
      'auto_default_repeat': "No repeat",
      'auto_execution_entity': "Control a scene or device",
      'auto_execution_mode': "Execution mode",
      'auto_select_cond_type': "Select condition type",
      'keypress': "Keypress",
      'pir_body': "Motion",
      'pir_detection_body': "Motion",
      'pir_detection_left': "Left",
      'pir_detection_right': "Right",
      'pir_detection_bilateral': "Both sides",
      'low_speed': 'Slow',
      'intermediate_speed': 'Medium',
      'quick_speed': 'Fast',
      'auto_click': "Single press",
      'auto_dblclick': "Double press",
      "long_press": "Long press",
      'traveling_speed': "Speed",
      'no_people_action': "No motion detected",
      'direction_left_to_right': "From left to right",
      'direction_right_to_left': "From right to left",
      'has_people_action': "Motion detected",
      'sunrise': "Sun raise",
      'sunset': "Sunset",
      'special_time': "Specific time",
      'auto_cond_time': "Schedule",
      'auto_cond_if_then': "If ... Then ...",
      'illuminance': "Illuminance",
      'homecenter_doesnt_support_automation1':
          "The home center version doesn't support automation,",
      'homecenter_doesnt_support_automation2': "please upgrade it.",
      'no_automation_rules1': "No automation rules yet",
      'no_automation_rules2': 'Click the "New Automation" button to create one',
      'opening_closing_action': "Open or close",
      'new_timer': "New Timer",
      'timer_continue': "Resume",
      'timer_stop': "Pause",
      'timer_reset': "Reset",
      'timer_over_after': "After timer is due",
      'programmable_switch': "Programmable Switch",
      'programmable_switch_enable': "Programmable Switch Enabled",
      'programmable_switch_disable': "Programmable Switch Disabled",
      'programmable_switch_enable_des':
          "Switch input can be configured to control other devices",
      'programmable_switch_disable_des':
          "Switch input control the associated relay",
      'disable_relay_en': "Relay Disabled",
      'disable_relay_dis': "Relay Enabled",
      'disable_relay_en_des': "Relay is disabled and can't be controlled",
      'disable_relay_dis_des': "Relay is enabled and can be controlled",
      'relay_alwayson_en': "Relay is always on",
      'relay_alwayson_dis': "Relay is always off",
      'relay_alwayson_en_des': "The relay output is always in on state",
      'relay_alwayson_dis_des': "The relay output is always in off state",
      'led_feedback': "LED Feedback",
      'led_feedback_state_pos': "LED Positive State",
      'led_feedback_state_neg': "LED Negative State",
      'led_feedback_state_pos_des': "LED is on when relay is on",
      'led_feedback_state_neg_des': "LED is on when relay is off",
      'please_select_angle': "Please select angle first",
      'input': "Input",
      'device_and_scene': "Device and scene",
      'under': "Below",
      'greater_than': "Above ",
      'locate': "",
      'among': "",
      'arbitrarily': "Arbitary",
      'sinistrogyration_until': "Rotate counter clockwise",
      'dextrorotation_until': " Rotate clockwise ",
      'rotation_any_angle': "Any angle",
      'degree_centigrade': " °C",
      'centigrade': " °C",
      'energy_consumption_values': "Power consumption",
      'open_close_state_values': "State",
      'exercise_state_values': "Moving state",
      'fall_asleep': "Still",
      'opening_closing': "Is opening or closing",
      'left_or_right': "Rotate left or right",
      'total_energy_consumption': "Total power consumption",
      'immediately_power': "Current power consumption",
      'open_close_state': "Open close state",
      'exercise_state': "Move state",
      'rotation': "Rotation",
      'no_brief_introduction_product': "No introduction for this product",
      'add_device_conditions': "Add device condition",
      'rotating_way': "Rotation direction",
      'rotation_angle': "Rotation angle",
      'select_date': "Selete time",
      'date_error': "Invalid time",
      'date_begin': "Begin:",
      'date_end': "End:",
      'immediate': "Immediately",
      'hours': "Hour",
      'minutes': "Minute",
      'zero_minute': " 0 minutes",
      'zero_second': " 0 seconds",
      'hour_zero_minute': "hours 0 minutes",
      'minute_zero_second': "mintues 0 seconds",
      'hour_zero_second': "0 seconds",
      'setting_cond': "Set condition",
      'add_condition_correctly': "Please add valid condition",
      'invalid_power_condition': "Invalid power consumption",
      'power_range': "Power range",
      'numerical_violation': "Invalid number",
      'input_power': "Please input power between 0-2200W",
      'setting_temperature': "Set temperature",
      'time_of_duration': "Duration",
      'set_illumination': "Set illuminance",
      'total_power': "Total power",
      'afternoon': "PM",
      'morning': "AM",
      'any_period_time': "Any time",
      'specific_period_time': "Specific time",
      'lighting_time_setting': "Lighting schedule",
      'select_cond': "Select condition",
      'select_time': " times",
      'opening': "Is opening",
      'closing': "Is closing",
      'left_handed': "Counterclockwise",
      'right_handed': "Clockwise",
      'select_least_device': "Please select at least one device",
      'model_flip': "Toggle",
      'model_set': "Set state",
      'model_angle': "Angle",
      'number': " times",
      'after': " later",
      'lighting_schedule': "Lighting schedule",
      'lamp': "Lamps",
      'brightness': "Brightness ",
      'color_temperature': "Color temperature",
      'select_executive_category': "Select type",
      'decelerator': "Delay",
      'begin': "Begin",
      'incomplete_automation':
          "The automation is incomplete, missing condition or execution",
      'incorrect_time': "Incorrect time",
      'the': "",
      'after_countdown': "After it's due",
      'perform_following_actions': "Execute",
      'pause_countdown': "Pause timer first",
      'time_delay': "Delay",
      'effective_time': "Effective on",
      'delete_success': "Delete successfully",
      'for_no_one': " detects no motion ",
      'for_someone': " detects motion ",
      'open_and_hold': " is open for ",
      'close_and_hold': " is closed for ",
      'hold': " for ",
      'continued_alarm_status': " is in alarm state for ",
      'security_status_continues': " is armed for ",
      'device_removed': "device removed",
      'clike': " clicked ",
      'arbitrarily_rotate': "Roate to any degree",
      'someone_after': "people pass by",
      'date_each': "Every",
      'has_been_discontinued': "is paused",
      'weekly_plan': "Weekly schedule",
      'after_period_time': "After a period of time",
      'conditions_met': "Execute when conditions met",
      'bad_request': "Bad request",
      'device_has_been_deleted': "The device has been deleted",
      'loop': "Repeat",
      's': "'s ",
      'between': "Between",
      'changing_channel': "Changing channel ...",
      'changing_channel_to': "Change to channel ",
      'changing_will_take_5_minutes': ", it may take about 5 minutes.",
      'keep_all_devices_power': "Please keep power applied",
      'keep_all_devices_power_devices': "to all devices",
      'change_channel_may_cause': "After changing channel, ",
      'some_device_may_pair_again': "some devices may need to be paired again",
      'auto_detect': "Auto select",
      'scanning': "Scanning now ...",
      'current_channel': "Current channel is ",
      'channel_can_change_to': ", you may change to channels below",
      'motion_detected_left': "Motion on left",
      'motion_detected_right': "Motion on right",
      'cannot_find_device': "Can't find device",
      'motion_detected_from_left_to_right':
          "Motion detected from left to right ",
      'motion_detected_from_right_to_left':
          "Motion detected from right to left ",
      'homekit_scene_is_empty': "This scene is empty, nothing to run",
      'empty': "Empty",
      "current_ota_status": "Current OTA status",
      'get_upgrade_package': "Get it",
      'target_temperture': "Target temperature",
      'current_temperture': "Current temperature",
      'indoor_unit_on_off': "On/off",
      'wind_speed': "Fan speed",
      'indoor_unit_mode': "Mode",
      'indoor_unit_mode_refrigeration': "Cool",
      'indoor_unit_mode_hot': "Heat",
      'indoor_unit_mode_dehumidification': "Dry",
      'indoor_unit_mode_ventilation': "Ventilation",
      'wind_speed_quick': "Fast",
      'wind_speed_medium': "Medium",
      'wind_speed_low': "Slow",
    },
    'zh': {
      'device': '设备',
      'scene': '场景',
      'message': '消息',
      'automation': '自动化',
      'my': '我的',
      'home_center': '家庭中心',
      'online': '在线',
      'offline': '离线',
      'add_home_center': '添加家庭中心',
      'undefined_area': '默认房间',

      'lights': '灯光',
      'switches': '开关',
      'binding': '绑定',
      'setting': '设置',
      'delete': '删除',

      'name': '名称',
      'room': '房间',
      'curtain_type': '窗帘类型',
      'curtain_direction': '窗帘方向',
      'trip_adjusted': '是否已校准过行程',
      'others': '其他',

      'notification': '通知',
      'notification_state_changed': '状态改变,马上通知您',
      'alarm_disalarm': '布防撤防',
      'notification_open_close': '门窗打开,发送警报',
      'notification_someone_passby': '有人经过,发送警报',
      'timer': '定时',
      'timer_description': '像闹钟一样按计划打开/关闭插座',
      'count_down': '倒计时',
      'count_down_description': '一段时间后打开/关闭插座',
      'key_press': '无线开关',
      'key_press_description': '轻轻一按,全部搞定',
      'pir_panel': '智能灯控',
      'pir_panel_description': '有人经过,自动开灯',
      'open_close': '芝麻开门',
      'open_close_description': '开门关门,自动开关灯',
      'right_top_button': '右上键',
      'right_bottom_button': '右下键',
      'left_bottom_button': '左下键',
      'left_top_button': '左上键',
      'click_button': '单击按键',
      'double_click_button': '双击按键',
      'double_click_description': '快速双击,控制设备',
      'click_control_window': '按键控窗',
      'click_control_window_description': '窗帘开合,一键到位',
      'double_click_control_window_description': '窗帘开合,双击到位',
      'click_binding': '按键绑定',

      'sure_to_delete_device': '您确定要删除此设备吗?',
      'sure_to_delete_home_center': '您确定要删除小燕家庭中心吗?',
      'sure_to_delete_scene': '您确定要删除此场景吗?',
      'cancel': '取消',

      'change_device_name': '修改设备名称',
      'set_area': '房间设置',
      'choose_area': '选择房间',

      'serial_number': '序列号',
      'version': '版本号',
      'rssi': 'Rssi',

      'binding_set_title_1': '所有事情 一键搞定',
      'binding_set_title_2': '门开 灯亮',
      'binding_set_title_3': '有人经过 自动亮灯',
      'choose_device': '请选择想要打开的设备',
      'choose_action': '请设置门窗动作',
      'choose_action_description': '当门窗打开或关闭时触发',
      'choose_luminance': '请设置照度的条件',
      'choose_luminance_description': '当环境照度低于此值才可以触发',
      'open': '打开',
      'close': '关闭',
      'open_or_close': '打开或关闭',
      'very_very_light': '室外阳光照射',
      'light': '室内适合阅读',
      'little_dark': '远处昏黄的路灯',
      'very_dark': '弦月夜空般的暗淡',
      'defined': '自定义',
      'lux_10000': '约10000勒克斯',
      'lux_300': '约300勒克斯',
      'lux_100': '约100勒克斯(推荐设置)',
      'lux_30': '约30勒克斯',
      'lux': '勒克斯',
      'lux_defined': '可自由设置光照度勒克斯阈值',
      'none': '',
      'not_surpport': '暂不支持',

      'add_device': '添加设备',
      'set_permit_join_failed': '启动设备发现失败',
      'scan_devices': '正在扫描新设备',
      'long_press_button': '请长按设备的按键',
      'new_device_1': '发现',
      'new_device_2': '个设备',
      'add': '添加',
      'no_new_device': '没有发现新设备',
      'choose_device_type': '请选择设备类型',
      'light_socket': '智能灯座',
      'smart_plug': '智能插座',
      'awareness_switch': '感应开关',
      'door_contact': '无线门磁',
      'smart_curtain': '智能窗帘',
      'wall_switch': '墙壁开关',
      'smart_dial': '旋钮开关',
      'switch_module': '开关模块',
      'smart_door_lock': '智能门锁',
      'fast_name': '快速命名',
      'long_press_description': '请长按键6秒至绿色指示灯闪烁',
      'failed': '失败',
      'next': '下一步',
      'choose_curtain_type': '请选择窗帘类型',
      'left_curtain': '左侧窗帘',
      'right_curtain': '右侧窗帘',
      'double_curtain': '双开窗帘',
      'choose_curtain_direction': '请选择窗帘的运动方向',
      'submit': '提交',

      'first_description': '开启简单智能生活',
      'use_lan_access': '点击上方图标，无需登录',
      'login_uncomplete': '正在登录...',
      'get_data_uncomplete': '正在获取数据',
      'login': '登录',
      'register': '注册',
      'mobile_login': '手机快速登录',
      'input_mobile': '请输入手机号',
      'get_code': '获取验证码',
      'input_code': '请输入验证码',
      'account_login': '帐号密码登录',
      'input_email': '请输入邮箱',
      'input_password': '请输入密码',
      'register_account': '注册帐号',
      'send_again': '重新获取',
      'email_registed': '该邮箱已被注册',

      'my_family': '我的家人',
      'about_us': '关于我们',
      'account_binding': '帐号绑定',
      'change_password': '修改密码',
      'help': '帮助',
      'log_out': '退出登录',
      'sure_to_log_out': '您确定要退出当前帐号吗?',
      'out': '退出',

      'input_origin_password': '请输入原密码',
      'input_new_password': '请输入新密码',
      'forget_password': '忘记密码',
      'reset_password': '重置密码',
      'reset_password_des1': '为了您的账号安全, 请重置您的小燕账户密码',
      'reset_password_des2': '我们将通过以下方式向您发送验证码, 验证码用来重置您的小燕账户密码',
      'get_code_by_mobile': '手机获取验证码',
      'get_code_by_email': '邮箱获取验证码',
      'not_bind_email_and_mobile': '没有绑定手机或邮箱',
      'bind_now': '现在绑定<<',
      'mobile_not_bind': '未绑定手机',
      'email_not_bind': '未绑定邮箱',
      'email_not_confirmed': '邮箱未验证',
      'code_send': '验证码已发送',

      'check_new_version': '检测新版本',
      'about_us_des1': '使用条款和隐私政策',
      'about_us_des2': '小燕科技版权所有',

      'setup_tip': '安装提示',
      'setup_tip1': '请确保家庭中心已经接通电源线和网线, 您可以用',
      'setup_tip2': ' 的方式添加',
      'or': ' 或 ',
      'automatic_found': '自动发现',
      'automatic_found_des': '请确保开启手机Wifi并且和家庭中心处于同一局域网内, 否则请用扫描二维码的方式添加。',
      'found_1': '发现',
      'found_2': '个家庭中心',
      'found_none': '没有发现家庭中心',
      'found_none_des': '如果没有您想要添加的家庭中心, 建议您通过扫描二维码的方式添加',
      'scan_code': '扫描二维码',
      'scan_code_des': '您可以通过扫描家庭中心底部的二维码直接添加,',
      'begin_scanning': '开始扫描二维码...',
      'put_code': '请将家庭中心底部的二维码放入框内',

      'login_other_ways': '第三方登录',
      'not_bind': '未绑定',
      'binded': '已绑定',
      'to_be_confirmed': '待认证',
      'to_be_authorized': '等待授权',
      'to_be_authorized_by_others': '已请求使用设备，等待其他用户授权中...',
      'click_to_bind': '绑定',
      'click_to_unbind': '解除',
      'receive_message_by_mobile': '通过手机接收报警消息',
      'receive_message_by_email': '通过邮件接收报警消息',
      'receive_message_by_wechat': '在微信中接收报警消息\n需关注小燕科技微信服务号',
      'mobile_binded': '手机号已被绑定',
      'email_binded': '邮箱已被绑定',
      'wechat_binded': '微信已被绑定',
      'qq_binded': 'QQ已被绑定',
      'bind_mobile': '绑定手机号',
      'bind_email': '绑定',
      'email_send': '已向您的邮箱中发送了验证邮件,请前往验证',
      'sure_to_delete_mobile': '您确定要删除绑定的手机号吗?',
      'sure_to_delete_email': '您确定要删除绑定的邮箱吗?',
      'sure_to_delete_wechat': '您确定要删除绑定的微信吗?',
      'sure_to_delete_qq': '您确定要删除绑定的QQ吗?',

      'xiaoyan_home_center': '小燕家庭中心',
      'device_name': '设备名称',
      'device_type': '设备型号',
      'associated_account': '主人帐号',
      'firmware_upgrade': '固件升级',
      'system_information': '系统信息',

      'on': '打开',
      'off': '关闭',
      'alarm': '布防',
      'disalarm': '撤防',
      'devices_on': '盏灯开着',
      'devices_arming': '个设备布防',
      'current_temperature': '当前温度',
      'scene_edit': '场景编辑',
      'input_scene_name_hint': '请输入场景名称',
      'scene_name_exist': '场景名称已存在',
      'add_scene': '添加场景',
      'scene_no_actions': '场景设备为空',

      'ip_address': '网络地址',
      'channel': '无线信道',
      'check_new_version_des': '检测所可用的版本，请稍后查看本页',
      'commond_sent': '命令已发送',
      'confirm': '确定',

      'can_upgrade_to': '可升级到版本',
      'current_version': '当前版本',
      'upgrading': '正在升级...',
      'prepare_to_upgrade': '准备升级...',
      'upgrade_complete': '升级完成',
      'upgrade_error': '错误!',
      'upgrade': '升级',

      'cancel_add': '取消添加',

      'illegal_password_length': '密码长度应在6~32之间',
      'qq_not_installed': 'QQ未安装',
      'wechat_not_installed': '微信未安装',
      'request': '请求函',
      'invitation': '邀请函',
      'request_to_join': '请求加入',
      'reject': '拒绝',
      'approve': '同意',
      'accept': '接受',
      'request_to_join_des': '请求加入家庭中心',
      'invite_to_join_des': '邀请您加入家庭中心',
      'home_center_message': '家庭中心消息',
      'new_home_center_found': '发现新的家庭中心',
      'manage_rooms': '房间管理',
      'create_room': '新建',
      'input_room_name': '请输入房间名称',
      'already_exist': '已存在',
      'config_room': '房间设置',

      'room_default': '默认房间',
      'room_living_room': '客厅',
      'room_master_bedroom': '主卧',
      'room_guest_bedroom': '次卧',
      'room_dinning_room': '餐厅',
      'room_kitchen': '厨房',
      'room_balcony': '阳台',
      'room_study': '书房',
      'room_entrance': '玄关',
      'room_bathroom': '洗手间',
      'scene_home': '回家',
      'scene_leaving': '离家',
      'scene_wakeup': '起床',
      'scene_sleep': '睡觉',

      'led_indicator_configuration': '按键指示灯配置',
      'led_indicator_off': '按键指示灯长灭',
      'led_indicator_off_des': '可减少对夜间睡眠的干扰',
      'led_indicator_on': '按键指示灯开启',
      'led_indicator_dual_on_des': '绿色打开，黄色关闭',
      'led_indicator_single_on_des': '启用指示灯',
      'exclusive_on_enable': '开关互锁已启用',
      'exclusive_on_enable_des': '仅允许一路开关处于打开状态',
      'exclusive_on_disable': '开关互锁已禁用',
      'exclusive_on_disable_des': '所有开关可以自由独立控制',
      'sm_input_mode_button': '按钮式开关',
      'sm_input_mode_button_des': '按下后自动弹回原位的按钮型开关',
      'sm_input_mode_rocker': '跷板式开关',
      'sm_input_mode_rocker_des': '传统的跷板式开关',
      'sm_polarity_on': '按键切换',
      'sm_polarity_on_des': '每次开关按键状态变化，即切换输出状态',
      'sm_polarity_off': '按键状态',
      'sm_polarity_off_des': '输出状态与按键状态保持一致',
      'recover_relay_configuration': '自动恢复开关设置',
      'exclusive_on': '开关互锁',
      'exclusive_on_setting': '互锁设置',
      'sm_input_mode': '开关类型',
      'sm_polarity': '输出状态控制',
      'recover_relay_off': '禁用自动恢复功能',
      'recover_relay_off_des': '上电时开关设置为关闭的状态',
      'recover_relay_on': '启用自动恢复功能',
      'recover_relay_on_des': '上电时开关设置为以前的状态',
      'switch_configuration': '灯光按键切换可编程按键',
      'sure_to_delete_user': '您确定要删除该用户吗?',

      'select_all_open': '选择全开',
      'select_all_closed': '选择全关',
      'select_all': '选择全部',
      'cancel_select_all': '取消全选',
      'start': '启用',
      'stop': '停用',
      'follow': '关注',
      'unfollow': '取关',
      'open_scan_succeed': '开启扫描成功',
      'origin': '正向',
      'reverse': '反向',
      'yes': '是',
      'no': '否',
      'adjust_curtain_des': '此过程大约需要45~60s, 您确定要校准窗帘行程吗?',
      'try_connecting': '正在尝试连接',
      'is_online': '上线了',
      'home_center_offline': '家庭中心离线',

      'no_access_to_camera': '此应用无访问相机权限',

      'sd_rotate': '无线旋钮',
      'sd_rotate_description': '左旋右旋，精确控制',
      'binding_set_title_4': '左旋右旋，精确控制',
      'relay_light': '已设为控灯光按键',
      'relay_light_des': '单击按键控制本地的灯光',
      'relay_button': '已设为可编程按键',
      'relay_button_des': '可编程按键，可用于双联双控',
      'first_button': '上键',
      'second_button': '中键',
      'third_button': '下键',

      'upgrade_policy': '固件升级版本选择',
      'upgrade_policy_alpha': '开发版（最新功能尝试）',
      'upgrade_policy_beta': '用户测试版（比较稳定的新功能体验）',
      'upgrade_plicy_stable': '稳定版',
      'change_alpha_des': '您确定要切换至开发版吗?',
      'change_beta_des': '您确定要切换至用户测试版吗?',
      'change_stable_des': '您确定要切换至稳定版吗?',
      'no_device_description': '当前没有设备\n您可以点击右上角来添加新设备',
      'found_new_version': '检测到新的版本',
      'ignore_message': '忽略此条消息，不再提示',
      'xiaoyan_home': '小燕在家',
      'download_description': '正在下载...',
      'current_is_latest': '当前已是最新版本',
      'empty_scene': '场景为空',
      'home_center_removed_des1': '您已被禁止使用家庭中心',
      'home_center_removed_des2': '若要继续使用，请前往添加',
      "create_automation": '新建自动化',
      "auto_mation_bt": '让配件在家居环境变化时作出响应',

      //Homekit
      'home': '家庭',
      'add_home': '添加家庭',
      'homes_empty': '当前无家庭,请点击右上角按钮添加家庭',
      'new_home': '新家庭',
      'input_name': '请输入一个名称',
      'error': '错误',
      'warning': '提示',
      'home_setting': '家庭设置',
      'rename': '重命名',
      'set_as_primary_home': '设为当前家庭',
      'sure_to_delete_home': '您确定要移除此家庭吗',
      'device_setting': '设备设置',
      'transfer': '房间设置',
      'choose_a_room': '请选择一个房间',
      'add_end_device': '添加终端设备',
      'add_end_device_des': '请确定配件已开启并在附近,长按设备上的按键',
      'complete': '完成',
      'management': '管理',
      'add_room': '添加房间',
      'warn': '警告',
      'sure_to_delete_room': '您确定要移除此房间吗？',
      'device_information': '设备信息',
      'lightbult': '灯泡',
      'outlet': '插座',
      'energy': '当前功耗',
      'motion_sensor': '动作传感器',
      'light_sensor': '照度传感器',
      'contact_sensor': '接触式传感器',
      'wall_switch_light': '开关',
      'curtain': '窗帘',
      'curtain_setting': '窗帘配置',
      "temperature": "温度",
      "manufacturer": "生产厂商",
      "plug_being_used": "插座当前是否正在被使用",
      "lock_current_state": "锁状态",
      "lock_auth_data": "控制授权码",
      "lock_auth_data_allocated": "控制授权码设置完成",
      "generate_lock_auth_data": "重新生成授权码",
      "power_state": "开关状态",
      "power_consumption": "负载功率（w)",
      "firmware_version": "固件版本",
      "model": "产品类型",
      "latest_firmware_version": "最新版本",
      "contact_sensor_state": "是否检测到动作",
      "motion_detected": "是否检测到有人",
      "current_state": "当前状态",
      "current_position": "当前位置",
      "target_position": "目标位置",
      "curtain_trip_learned": "是否已校准行程",
      "light_level": "亮度（Lux)",
      'updating': '正在更新',
      "device_open": "开",
      "device_close": "关",
      'scene_setting': '场景设置',
      'excute': '执行',
      'edit': '编辑',
      'no_new_version': '无新版本可用',
      'click_to_config': '点击配置',
      "is_adjusting": "行程校准",
      "is_adjusting_text": "此过程大约需要45~60秒，您确定要进行行程校准吗？",
      "user_management": "用户管理",
      "xiaoyan_system": "小燕系统",

      'view_new_features': '查看新功能',
      'official_site_root': 'xiaoyan.io',
      'company_name': '上海小燕科技有限公司',
      'service_phone': '联系电话:',
      'current_home': ' (当前家庭)',
      'milli_watt': '毫瓦',
      'watt': '瓦',
      'change_password_failed': '失败，请确认当前密码正确',
      'bad_homekit_room_name': '名称不能用特殊字符开头',
      'weekday0': '周日',
      'weekday1': '周一',
      'weekday2': '周二',
      'weekday3': '周三',
      'weekday4': '周四',
      'weekday5': '周五',
      'weekday6': '周六',
      'everyday': '每天',
      'weekends': '周末',
      'workdays': '工作日',
      'hourfull': '小时',
      'hour': '时',
      'minutefull': '分钟',
      'minute': '分',
      'secondfull': '秒',
      'second': '秒',
      'time': '时间',
      'sure_to_delete_automation': '确定删除该条自动化？',
      'sure_to_delete_condition': '确认删除该条触发条件?',
      'sure_to_delete_execution': '确认删除该条动作?',
      'if': '当',
      'then': '就',
      'repeat': '重复',
      'automation_enable': "启用此自动化",
      'auto_cond_add': "条件为空，请点击右上方“添加”",
      'auto_exec_add': "动作为空，请点击右上方“添加”",
      'add_auto_name_input': "添加自动化名称",
      'auto_onoff_cond_type': "可设置打开、关闭",
      'auto_onoff_power_cond_type': "可设置开关状态、即时功率",
      'auto_open_close_tem_cond_type': "可设置开合动作、温度",
      'auto_body_tem_cond_type': "可设置人体、温度",
      'auto_open_close_exercise_cond_type': "可设置开合状态、运动状态",
      'auto_light_keypress_cond_type': "可设置灯、按键",
      'auto_angle_rotate_cond_type': "可设置旋转角度、按键",
      'auto_select_check_people_time': "持续有人动作",
      'auto_select_check_no_people_time': "持续无人动作",
      'no_motion_detected_for': "保持无人动作",
      'motion_detected_for': "保持有人动作",
      'auto_set_repeat': "设定重复规则",
      'auto_set_time': "设定时间",
      'auto_default_repeat': "不重复",
      'auto_execution_entity': "执行场景与设备",
      'auto_execution_mode': "执行方式",
      'auto_select_cond_type': "选择条件分类",
      'keypress': "按键",
      'pir_detection_body': "人体",
      'pir_detection_left': "左侧",
      'pir_detection_right': "右侧",
      'pir_detection_bilateral': "双侧",
      'low_speed': '慢速',
      'intermediate_speed': '中速',
      'quick_speed': '快速',
      'auto_click': "单击",
      'auto_dblclick': "多击",
      "long_press": "长按",
      'traveling_speed': "行走速度",
      'no_people_action': "无人动作",
      'direction_left_to_right': "从左到右",
      'direction_right_to_left': "从右到左",
      'has_people_action': "有人动作",
      'sunrise': "日出",
      'sunset': "日落",
      'special_time': "特定时间",
      'auto_cond_time': "时间表",
      'auto_cond_if_then': "如果...就...",
      'illuminance': "照度",
      'homecenter_doesnt_support_automation1': "当前家庭中心版本不支持自动化功能",
      'homecenter_doesnt_support_automation2': "请先升级固件",
      'no_automation_rules1': "自动化内容为空",
      'no_automation_rules2': "请点击右上角“新建自动化”添加",
      'opening_closing_action': "开合动作",
      'timer_continue': "继续",
      'timer_stop': "暂停",
      'timer_reset': "启动",
      'timer_over_after': "定时器结束后",
      'new_timer': "新建定时器",
      'programmable_switch': "可编程开关",
      'programmable_switch_enable': "可编程开关已启用",
      'programmable_switch_disable': "可编程开关已禁用",
      'programmable_switch_enable_des': "",
      'programmable_switch_disable_des': "",
      'disable_relay_en': "继电器已禁用",
      'disable_relay_dis': "继电器已启用",
      'disable_relay_en_des': "",
      'disable_relay_dis_des': "",
      'relay_alwayson_en': "继电器保持接通",
      'relay_alwayson_dis': "继电器保持断开",
      'relay_alwayson_en_des': "",
      'relay_alwayson_dis_des': "",
      'led_feedback': "LED 反馈",
      'led_feedback_state_pos': "已设置为正反馈",
      'led_feedback_state_neg': "已设置为负反馈",
      'led_feedback_state_pos_des': "接通时指示灯亮",
      'led_feedback_state_neg_des': "断开时指示灯亮",
      'please_select_angle': "请先选择角度",
      'input': "输入",
      'device_and_scene': "设备和场景",
      'under': "低于",
      'greater_than': "高于",
      'locate': "位于",
      'among': "之间",
      'arbitrarily': "任意",
      'sinistrogyration_until': "左旋到",
      'dextrorotation_until': "右旋到",
      'rotation_any_angle': "旋转任意角度",
      'degree_centigrade': "°C",
      'centigrade': "°C",
      'energy_consumption_values': "能耗值",
      'open_close_state_values': "开合状态值",
      'exercise_state_values': "运动状态值",
      'fall_asleep': "静止不动",
      'opening_closing': "正在打开或关闭",
      'left_or_right': "左旋或右旋",
      'total_energy_consumption': "总能耗",
      'immediately_power': "即时功率",
      'open_close_state': "开合状态",
      'exercise_state': "运动状态",
      'rotation': "旋转",
      'no_brief_introduction_product': "暂无该产品简介",
      'add_device_conditions': "添加设备条件",
      'rotating_way': "旋转方式",
      'rotation_angle': "旋转角度",
      'select_date': "时间选择",
      'date_error': "时间段有误，请确认",
      'date_begin': "开始:",
      'date_end': "结束:",
      'immediate': "即刻",
      'hours': "小时",
      'minutes': "分钟",
      'zero_minute': " 0分钟",
      'zero_second': " 0秒",
      'hour_zero_minute': "小时0分钟",
      'minute_zero_second': "分钟0秒",
      'hour_zero_second': "小时0秒",
      'setting_cond': "设置条件",
      'add_condition_correctly': "请正确添加条件",
      'invalid_power_condition': "功率条件不合法，请重置",
      'power_range': "功率区间",
      'numerical_violation': "数值不合法",
      'input_power': "请输入 0-2200W 范围内的功率值",
      'setting_temperature': "设置温度",
      'time_of_duration': "持续时间",
      'set_illumination': "设置照度",
      'total_power': "总功率",
      'afternoon': "下午 ",
      'morning': "上午 ",
      'any_period_time': "任何时段",
      'specific_period_time': "特定时段",
      'lighting_time_setting': "照明时间设置",
      'select_cond': "请选择条件",
      'select_time': "次",
      'opening': "正在打开",
      'closing': "正在关闭",
      'left_handed': "左旋",
      'right_handed': "右旋",
      'select_least_device': "请至少选择一个设备",
      'model_flip': "翻转",
      'model_set': "设定",
      'model_angle': "角度",
      'number': "次数",
      'after': "后",
      'lighting_schedule': "照明时间表",
      'lamp': "盏灯",
      'brightness': "亮度 ",
      'color_temperature': "色温",
      'select_executive_category': "选择执行分类",
      'decelerator': "延时器",
      'begin': "开始",
      'incomplete_automation': "自动化不完整，缺少条件或执行信息",
      'incorrect_time': "时间不正确",
      'the': "的",
      'after_countdown': "倒计时结束后",
      'perform_following_actions': "执行下列动作",
      'pause_countdown': "请先暂停倒计时",
      'time_delay': "延时",
      'effective_time': "有效时段",
      'delete_success': "删除成功",
      'for_no_one': "持续没人",
      'for_someone': "持续有人",
      'open_and_hold': "打开并持续",
      'close_and_hold': "关闭并持续",
      'hold': "并持续",
      'continued_alarm_status': "报警状态持续",
      'security_status_continues': "安防状态持续",
      'device_removed': "设备已移除",
      'clike': "点击",
      'arbitrarily_rotate': "任意旋转到",
      'someone_after': "有人经过",
      'date_each': "每",
      'has_been_discontinued': "已停用",
      'weekly_plan': "按周计划执行",
      'after_period_time': "一段时间后执行",
      'conditions_met': "满足条件时执行",
      'bad_request': "错误的请求",
      'device_has_been_deleted': "该设备已经被删除",
      'loop': "循环",
      's': "的",
      'between': "位于",
      'changing_channel': "切换中 ...",
      'changing_channel_to': "切换至无线信道",
      'changing_will_take_5_minutes': "，该过程可能需要持续5分钟左右。",
      'keep_all_devices_power': "请保持所有设备电源开启。",
      'keep_all_devices_power_devices': "",
      'change_channel_may_cause': "信道切换可能会造成部分设",
      'some_device_may_pair_again': "备需要重新添加",
      'auto_detect': "自动选择",
      'scanning': "正在扫描...",
      'current_channel': "当前无线信道",
      'channel_can_change_to': "，可切换至下列信道",
      'motion_detected_left': "左侧有人动作",
      'motion_detected_right': "右侧有人动作",
      'cannot_find_device': "未找到设备",
      'motion_detected_from_left_to_right': "从左向右有人经过",
      'motion_detected_from_right_to_left': "从左向右有人经过",
      'homekit_scene_is_empty': "场景为空，无动作执行",
      'empty': "空",
      "current_ota_status": "当前升级状态",
      'get_upgrade_package': "获取升级",
      'target_temperture': "设定温度",
      'current_temperture': "当前温度",
      'indoor_unit_on_off': "开关",
      'wind_speed': "风速",
      'indoor_unit_mode': "模式",
      'indoor_unit_mode_refrigeration': "制冷",
      'indoor_unit_mode_hot': "制热",
      'indoor_unit_mode_dehumidification': "除湿",
      'indoor_unit_mode_ventilation': "通风",
      'wind_speed_quick': "快",
      'wind_speed_medium': "中",
      'wind_speed_low': "慢",
    }
  };

  String definedString(String description) =>
      _localizedValues[locale.languageCode][description];
  get windSpeedQuick =>
      _localizedValues[locale.languageCode]['wind_speed_quick'];
  get windSpeedMedium =>
      _localizedValues[locale.languageCode]['wind_speed_medium'];
  get windSpeedLow => _localizedValues[locale.languageCode]['wind_speed_low'];
  get indoorUnitModeVentilation =>
      _localizedValues[locale.languageCode]['indoor_unit_mode_ventilation'];
  get indoorUnitModeDehumidification => _localizedValues[locale.languageCode]
      ['indoor_unit_mode_dehumidification'];

  get indoorUnitModeHot =>
      _localizedValues[locale.languageCode]['indoor_unit_mode_hot'];
  get indoorUnitModeRefrigeration =>
      _localizedValues[locale.languageCode]['indoor_unit_mode_refrigeration'];

  get indoorUnitMode =>
      _localizedValues[locale.languageCode]['indoor_unit_mode'];
  get windSpeed => _localizedValues[locale.languageCode]['wind_speed'];
  get indoorUnitOnOff =>
      _localizedValues[locale.languageCode]['indoor_unit_on_off'];

  get currentTemperture =>
      _localizedValues[locale.languageCode]['current_temperture'];

  get targetTemperture =>
      _localizedValues[locale.languageCode]['target_temperture'];

  get weeklyPlan => _localizedValues[locale.languageCode]['weekly_plan'];
  get afterPeriodTime =>
      _localizedValues[locale.languageCode]['after_period_time'];
  get conditionsMet => _localizedValues[locale.languageCode]['conditions_met'];
  get hasBeenDiscontinued =>
      _localizedValues[locale.languageCode]['has_been_discontinued'];
  get dateEach => _localizedValues[locale.languageCode]['date_each'];
  get someoneAfter => _localizedValues[locale.languageCode]['someone_after'];
  get arbitrarilyRotate =>
      _localizedValues[locale.languageCode]['arbitrarily_rotate'];
  get clike => _localizedValues[locale.languageCode]['clike'];
  get deviceRemoved => _localizedValues[locale.languageCode]['device_removed'];
  get securityStatusContinues =>
      _localizedValues[locale.languageCode]['security_status_continues'];
  get continuedAlarmStatus =>
      _localizedValues[locale.languageCode]['continued_alarm_status'];
  get hold => _localizedValues[locale.languageCode]['hold'];
  get openAndHold => _localizedValues[locale.languageCode]['open_and_hold'];
  get closeAndHold => _localizedValues[locale.languageCode]['close_and_hold'];
  get forNoOne => _localizedValues[locale.languageCode]['for_no_one'];
  get forSomeone => _localizedValues[locale.languageCode]['for_someone'];
  get deleteSuccess => _localizedValues[locale.languageCode]['delete_success'];
  get effectiveTime => _localizedValues[locale.languageCode]['effective_time'];
  get timeDelay => _localizedValues[locale.languageCode]['time_delay'];
  get pauseCountdown =>
      _localizedValues[locale.languageCode]['pause_countdown'];
  get performFollowingActions =>
      _localizedValues[locale.languageCode]['perform_following_actions'];
  get afterCountdown =>
      _localizedValues[locale.languageCode]['after_countdown'];
  get the => _localizedValues[locale.languageCode]['the'];
  get incorrectTime => _localizedValues[locale.languageCode]['incorrect_time'];
  get incompleteAutomation =>
      _localizedValues[locale.languageCode]['incomplete_automation'];
  get begin => _localizedValues[locale.languageCode]['begin'];
  get decelerator => _localizedValues[locale.languageCode]['decelerator'];
  get selectExecutiveCategory =>
      _localizedValues[locale.languageCode]['select_executive_category'];
  get colorTemperature =>
      _localizedValues[locale.languageCode]['color_temperature'];
  get brightness => _localizedValues[locale.languageCode]['brightness'];
  get lamp => _localizedValues[locale.languageCode]['lamp'];
  get lightingSchedule =>
      _localizedValues[locale.languageCode]['lighting_schedule'];
  get after => _localizedValues[locale.languageCode]['after'];
  get number => _localizedValues[locale.languageCode]['number'];
  get modelFlip => _localizedValues[locale.languageCode]['model_flip'];
  get modelSet => _localizedValues[locale.languageCode]['model_set'];
  get modelAngle => _localizedValues[locale.languageCode]['model_angle'];
  get selectLeastDevice =>
      _localizedValues[locale.languageCode]['select_least_device'];
  get leftHanded => _localizedValues[locale.languageCode]['left_handed'];
  get rightHanded => _localizedValues[locale.languageCode]['right_handed'];
  get closing => _localizedValues[locale.languageCode]['closing'];
  get opening => _localizedValues[locale.languageCode]['opening'];
  get selectTime => _localizedValues[locale.languageCode]['select_time'];
  get selectCond => _localizedValues[locale.languageCode]['select_cond'];
  get lightingTimeSetting =>
      _localizedValues[locale.languageCode]['lighting_time_setting'];
  get anyPeriodTime => _localizedValues[locale.languageCode]['any_period_time'];
  get specificPeriodTime =>
      _localizedValues[locale.languageCode]['specific_period_time'];
  get afternoon => _localizedValues[locale.languageCode]['afternoon'];
  get morning => _localizedValues[locale.languageCode]['morning'];
  get totalPower => _localizedValues[locale.languageCode]['total_power'];
  get setIllumination =>
      _localizedValues[locale.languageCode]['set_illumination'];
  get timeOfDuration =>
      _localizedValues[locale.languageCode]['time_of_duration'];
  get settingTemperature =>
      _localizedValues[locale.languageCode]['setting_temperature'];
  get inputPower => _localizedValues[locale.languageCode]['input_power'];
  get numericalViolation =>
      _localizedValues[locale.languageCode]['numerical_violation'];
  get powerRange => _localizedValues[locale.languageCode]['power_range'];
  get invalidPowerCondition =>
      _localizedValues[locale.languageCode]['invalid_power_condition'];
  get addConditionCorrectly =>
      _localizedValues[locale.languageCode]['add_condition_correctly'];
  get settingCond => _localizedValues[locale.languageCode]['setting_cond'];
  get hourZeroMinute =>
      _localizedValues[locale.languageCode]['hour_zero_minute'];
  get minuteZeroSecond =>
      _localizedValues[locale.languageCode]['minute_zero_second'];
  get hourZeroSecond =>
      _localizedValues[locale.languageCode]['hour_zero_second'];
  get zeroSecond => _localizedValues[locale.languageCode]['zero_second'];
  get hours => _localizedValues[locale.languageCode]['hours'];
  get minutes => _localizedValues[locale.languageCode]['minutes'];
  get immediate => _localizedValues[locale.languageCode]['immediate'];
  get dateEnd => _localizedValues[locale.languageCode]['date_end'];
  get dateBegin => _localizedValues[locale.languageCode]['date_begin'];
  get dateError => _localizedValues[locale.languageCode]['date_error'];
  get selectDate => _localizedValues[locale.languageCode]['select_date'];
  get rotationAngle => _localizedValues[locale.languageCode]['rotation_angle'];
  get rotatingWay => _localizedValues[locale.languageCode]['rotating_way'];
  get addDeviceConditions =>
      _localizedValues[locale.languageCode]['add_device_conditions'];
  get noBriefIntroductionProduct =>
      _localizedValues[locale.languageCode]['no_brief_introduction_product'];
  get rotation => _localizedValues[locale.languageCode]['rotation'];
  get exerciseState => _localizedValues[locale.languageCode]['exercise_state'];
  get openCloseState =>
      _localizedValues[locale.languageCode]['open_close_state'];
  get immediatelyPower =>
      _localizedValues[locale.languageCode]['immediately_power'];
  get totalEnergyConsumption =>
      _localizedValues[locale.languageCode]['total_energy_consumption'];
  get openingClosing =>
      _localizedValues[locale.languageCode]['opening_closing'];
  get leftOrRight => _localizedValues[locale.languageCode]['left_or_right'];
  get fallAsleep => _localizedValues[locale.languageCode]['fall_asleep'];
  get exerciseStateValues =>
      _localizedValues[locale.languageCode]['exercise_state_values'];
  get openCloseStateValues =>
      _localizedValues[locale.languageCode]['open_close_state_values'];
  get energyConsumptionValues =>
      _localizedValues[locale.languageCode]['energy_consumption_values'];
  get degreeCentigrade =>
      _localizedValues[locale.languageCode]['degree_centigrade'];
  get centigrade => _localizedValues[locale.languageCode]['centigrade'];
  get rotationAnyAngle =>
      _localizedValues[locale.languageCode]['rotation_any_angle'];
  get dextrorotationUntil =>
      _localizedValues[locale.languageCode]['dextrorotation_until'];
  get sinistrogyrationUntil =>
      _localizedValues[locale.languageCode]['sinistrogyration_until'];
  get arbitrarily => _localizedValues[locale.languageCode]['arbitrarily'];
  get among => _localizedValues[locale.languageCode]['among'];
  get newTimer => _localizedValues[locale.languageCode]['new_timer'];
  get under => _localizedValues[locale.languageCode]['under'];
  get greaterThan => _localizedValues[locale.languageCode]['greater_than'];
  get locate => _localizedValues[locale.languageCode]['locate'];
  get deviceAndScene =>
      _localizedValues[locale.languageCode]['device_and_scene'];
  get timerOverAfter =>
      _localizedValues[locale.languageCode]['timer_over_after'];
  get timerReset => _localizedValues[locale.languageCode]['timer_reset'];
  get timerStop => _localizedValues[locale.languageCode]['timer_stop'];
  get timerContinue => _localizedValues[locale.languageCode]['timer_continue'];
  get openingClosingAction =>
      _localizedValues[locale.languageCode]['opening_closing_action'];
  get illuminance => _localizedValues[locale.languageCode]['illuminance'];
  get autoCondTime => _localizedValues[locale.languageCode]['auto_cond_time'];
  get autoCondIfThen =>
      _localizedValues[locale.languageCode]['auto_cond_if_then'];
  get sunrise => _localizedValues[locale.languageCode]['sunrise'];
  get sunset => _localizedValues[locale.languageCode]['sunset'];
  get specialTime => _localizedValues[locale.languageCode]['special_time'];
  get travelingSpeed =>
      _localizedValues[locale.languageCode]['traveling_speed'];
  get noPeopleAction =>
      _localizedValues[locale.languageCode]['no_people_action'];
  get directionLeftToRight =>
      _localizedValues[locale.languageCode]['direction_left_to_right'];
  get directionRightToLeft =>
      _localizedValues[locale.languageCode]['direction_right_to_left'];
  get hasPeopleAction =>
      _localizedValues[locale.languageCode]['has_people_action'];
  get autoClick => _localizedValues[locale.languageCode]['auto_click'];
  get autoDblclick => _localizedValues[locale.languageCode]['auto_dblclick'];
  get longPress => _localizedValues[locale.languageCode]['long_press'];
  get lowSpeed => _localizedValues[locale.languageCode]['low_speed'];
  get intermediateSpeed =>
      _localizedValues[locale.languageCode]['intermediate_speed'];
  get quickSpeed => _localizedValues[locale.languageCode]['quick_speed'];
  get pirDetectionLeft =>
      _localizedValues[locale.languageCode]['pir_detection_left'];
  get pirDetectionRight =>
      _localizedValues[locale.languageCode]['pir_detection_right'];
  get pirDetectionBilateral =>
      _localizedValues[locale.languageCode]['pir_detection_bilateral'];
  get keypress => _localizedValues[locale.languageCode]['keypress'];
  get pirDetectionBody =>
      _localizedValues[locale.languageCode]['pir_detection_body'];
  get autoSelectCondType =>
      _localizedValues[locale.languageCode]['auto_select_cond_type'];
  get autoExecutionMode =>
      _localizedValues[locale.languageCode]['auto_execution_mode'];
  get autoExecutionEntity =>
      _localizedValues[locale.languageCode]['auto_execution_entity'];
  get autoDefaultRepeat =>
      _localizedValues[locale.languageCode]['auto_default_repeat'];
  get autoSetTime => _localizedValues[locale.languageCode]['auto_set_time'];
  get autoSetRepeat => _localizedValues[locale.languageCode]['auto_set_repeat'];
  get autoSelectCheckPeopleTime =>
      _localizedValues[locale.languageCode]['auto_select_check_people_time'];
  get autoSelectCheckNoPeopleTime =>
      _localizedValues[locale.languageCode]['auto_select_check_no_people_time'];
  get noMotionDetectedFor =>
      _localizedValues[locale.languageCode]['no_motion_detected_for'];
  get motionDetectedFor =>
      _localizedValues[locale.languageCode]['motion_detected_for'];
  get autoOnoffCondType =>
      _localizedValues[locale.languageCode]['auto_onoff_cond_type'];
  get autoOnoffPowerCondType =>
      _localizedValues[locale.languageCode]['auto_onoff_power_cond_type'];
  get autoOpenCloseTemCondType =>
      _localizedValues[locale.languageCode]['auto_open_close_tem_cond_type'];
  get autoBodyTemCondType =>
      _localizedValues[locale.languageCode]['auto_body_tem_cond_type'];

  get autoOpenCloseExerciseCondType => _localizedValues[locale.languageCode]
      ['auto_open_close_exercise_cond_type'];
  get autoLightKeypressCondType =>
      _localizedValues[locale.languageCode]['auto_light_keypress_cond_type'];
  get autoAngleRotateCondType =>
      _localizedValues[locale.languageCode]['auto_angle_rotate_cond_type'];

  get addAutoNameInput =>
      _localizedValues[locale.languageCode]['add_auto_name_input'];
  get autoCondAdd => _localizedValues[locale.languageCode]['auto_cond_add'];
  get autoExecAdd => _localizedValues[locale.languageCode]['auto_exec_add'];
  get viewNewFeatures =>
      _localizedValues[locale.languageCode]['view_new_features'];
  get automation => _localizedValues[locale.languageCode]['automation'];
  get xiaoyan => _localizedValues[locale.languageCode]['xiaoyan'];
  get autoMationBt => _localizedValues[locale.languageCode]['auto_mation_bt'];
  get xiaoyanSystem => _localizedValues[locale.languageCode]['xiaoyan_system'];
  get userManagement =>
      _localizedValues[locale.languageCode]['user_management'];
  get isAdjustingText =>
      _localizedValues[locale.languageCode]['is_adjusting_text'];
  get isAdjusting => _localizedValues[locale.languageCode]['is_adjusting'];
  get noNewVersion => _localizedValues[locale.languageCode]['no_new_version'];
  get deviceOpen => _localizedValues[locale.languageCode]['device_open'];
  get deviceClose => _localizedValues[locale.languageCode]['device_close'];
  get temperature => _localizedValues[locale.languageCode]['temperature'];
  get lightLevel => _localizedValues[locale.languageCode]['light_level'];
  get manufacture => _localizedValues[locale.languageCode]['manufacturer'];
  get plugBeingUsed => _localizedValues[locale.languageCode]['plug_being_used'];
  get lockCurrentState =>
      _localizedValues[locale.languageCode]['lock_current_state'];
  get lockAuthData => _localizedValues[locale.languageCode]['lock_auth_data'];
  get lockAuthDataAllocated =>
      _localizedValues[locale.languageCode]['lock_auth_data_allocated'];
  get generateLockAuthData =>
      _localizedValues[locale.languageCode]['generate_lock_auth_data'];
  get powerState => _localizedValues[locale.languageCode]['power_state'];
  get powerConsumption =>
      _localizedValues[locale.languageCode]['power_consumption'];
  get firmwareVersion =>
      _localizedValues[locale.languageCode]['firmware_version'];
  get model => _localizedValues[locale.languageCode]['model'];
  get latestFirmwareVersion =>
      _localizedValues[locale.languageCode]['latest_firmware_version'];
  get contactSensorState =>
      _localizedValues[locale.languageCode]['contact_sensor_state'];
  get motionDetected =>
      _localizedValues[locale.languageCode]['motion_detected'];
  get currentState => _localizedValues[locale.languageCode]['current_state'];
  get currentPosition =>
      _localizedValues[locale.languageCode]['current_position'];
  get targetPosition =>
      _localizedValues[locale.languageCode]['target_position'];
  get curtainTripLearned =>
      _localizedValues[locale.languageCode]['curtain_trip_learned'];
  get updating => _localizedValues[locale.languageCode]['updating'];
  get sceneSetting => _localizedValues[locale.languageCode]['scene_setting'];
  get excute => _localizedValues[locale.languageCode]['excute'];
  get edit => _localizedValues[locale.languageCode]['edit'];
  get clickToConfig => _localizedValues[locale.languageCode]['click_to_config'];
  get automationEnable =>
      _localizedValues[locale.languageCode]['automation_enable'];

  get deviceInformation =>
      _localizedValues[locale.languageCode]['device_information'];
  get lightbult => _localizedValues[locale.languageCode]['lightbult'];
  get outlet => _localizedValues[locale.languageCode]['outlet'];
  get energy => _localizedValues[locale.languageCode]['energy'];
  get motionSensor => _localizedValues[locale.languageCode]['motion_sensor'];
  get lightSensor => _localizedValues[locale.languageCode]['light_sensor'];
  get contactSensor => _localizedValues[locale.languageCode]['contact_sensor'];
  get wallSwitchLight =>
      _localizedValues[locale.languageCode]['wall_switch_light'];
  get curtain => _localizedValues[locale.languageCode]['curtain'];
  get curtainSetting =>
      _localizedValues[locale.languageCode]['curtain_setting'];
  get upgradePolicy => _localizedValues[locale.languageCode]['upgrade_policy'];
  get upgradePolicyAlpha =>
      _localizedValues[locale.languageCode]['upgrade_policy_alpha'];
  get upgradePolicyBeta =>
      _localizedValues[locale.languageCode]['upgrade_policy_beta'];
  get upgradePolicyStable =>
      _localizedValues[locale.languageCode]['upgrade_plicy_stable'];
  get changeAlphaDes =>
      _localizedValues[locale.languageCode]['change_alpha_des'];
  get changeBetaDes => _localizedValues[locale.languageCode]['change_beta_des'];
  get changeStableDes =>
      _localizedValues[locale.languageCode]['change_stable_des'];
  get noDeviceDescription =>
      _localizedValues[locale.languageCode]['no_device_description'];
  get foundNewVersion =>
      _localizedValues[locale.languageCode]['found_new_version'];
  get ignoreMessage => _localizedValues[locale.languageCode]['ignore_message'];
  get xiaoyanHome => _localizedValues[locale.languageCode]['xiaoyan_home'];
  get downloadDescription =>
      _localizedValues[locale.languageCode]['download_description'];
  get currentIsLatest =>
      _localizedValues[locale.languageCode]['current_is_latest'];
  get sceneEmpty => _localizedValues[locale.languageCode]['empty_scene'];
  get homeCenterRemovedDes1 =>
      _localizedValues[locale.languageCode]['home_center_removed_des1'];
  get homeCenterRemovedDes2 =>
      _localizedValues[locale.languageCode]['home_center_removed_des2'];
  get createAutoMation =>
      _localizedValues[locale.languageCode]['create_automation'];

  get noAccessToCamera =>
      _localizedValues[locale.languageCode]['no_access_to_camera'];
  get sdRotate => _localizedValues[locale.languageCode]['sd_rotate'];
  get sdRotateDescription =>
      _localizedValues[locale.languageCode]['sd_rotate_description'];
  get bindingSetTitle4 =>
      _localizedValues[locale.languageCode]['binding_set_title_4'];
  get relayLight => _localizedValues[locale.languageCode]['relay_light'];
  get relayLightDes => _localizedValues[locale.languageCode]['relay_light_des'];
  get relayButton => _localizedValues[locale.languageCode]['relay_button'];
  get relayButtonDes =>
      _localizedValues[locale.languageCode]['relay_button_des'];
  get firstButton => _localizedValues[locale.languageCode]['first_button'];
  get secondButton => _localizedValues[locale.languageCode]['second_button'];
  get thirdButton => _localizedValues[locale.languageCode]['third_button'];

  get selectAllOpen => _localizedValues[locale.languageCode]['select_all_open'];
  get selectAllClosed =>
      _localizedValues[locale.languageCode]['select_all_closed'];
  get selectAll => _localizedValues[locale.languageCode]['select_all'];
  get cancelSelectAll =>
      _localizedValues[locale.languageCode]['cancel_select_all'];
  get start => _localizedValues[locale.languageCode]['start'];
  get stop => _localizedValues[locale.languageCode]['stop'];
  get follow => _localizedValues[locale.languageCode]['follow'];
  get unfollow => _localizedValues[locale.languageCode]['unfollow'];
  get openScanSucceed =>
      _localizedValues[locale.languageCode]['open_scan_succeed'];
  get origin => _localizedValues[locale.languageCode]['origin'];
  get reverse => _localizedValues[locale.languageCode]['reverse'];
  get yes => _localizedValues[locale.languageCode]['yes'];
  get no => _localizedValues[locale.languageCode]['no'];
  get adjustCurtainDes =>
      _localizedValues[locale.languageCode]['adjust_curtain_des'];
  get tryConnecting => _localizedValues[locale.languageCode]['try_connecting'];
  get isOnline => _localizedValues[locale.languageCode]['is_online'];
  get homeCenterOffline =>
      _localizedValues[locale.languageCode]['home_center_offline'];

  get ledIndicatorConfiguration =>
      _localizedValues[locale.languageCode]['led_indicator_configuration'];
  get ledIndicatorOff =>
      _localizedValues[locale.languageCode]['led_indicator_off'];
  get ledIndicatorOffDes =>
      _localizedValues[locale.languageCode]['led_indicator_off_des'];
  get ledIndicatorOn =>
      _localizedValues[locale.languageCode]['led_indicator_on'];
  get ledIndicatorDualOnDes =>
      _localizedValues[locale.languageCode]['led_indicator_dual_on_des'];
  get ledIndicatorSingleOnDes =>
      _localizedValues[locale.languageCode]['led_indicator_single_on_des'];
  get exclusiveOnEnable =>
      _localizedValues[locale.languageCode]['exclusive_on_enable'];
  get exclusiveOnEnableDes =>
      _localizedValues[locale.languageCode]['exclusive_on_enable_des'];
  get exclusiveOnDisable =>
      _localizedValues[locale.languageCode]['exclusive_on_disable'];
  get exclusiveOnDisableDes =>
      _localizedValues[locale.languageCode]['exclusive_on_disable_des'];
  get smInputModeButton =>
      _localizedValues[locale.languageCode]['sm_input_mode_button'];
  get smInputModeButtonDes =>
      _localizedValues[locale.languageCode]['sm_input_mode_button_des'];
  get smInputModeRocker =>
      _localizedValues[locale.languageCode]['sm_input_mode_rocker'];
  get smInputModeRockerDes =>
      _localizedValues[locale.languageCode]['sm_input_mode_rocker_des'];
  get smPolarityOn => _localizedValues[locale.languageCode]['sm_polarity_on'];
  get smPolarityOnDes =>
      _localizedValues[locale.languageCode]['sm_polarity_on_des'];
  get smPolarityOff => _localizedValues[locale.languageCode]['sm_polarity_off'];
  get smPolarityOffDes =>
      _localizedValues[locale.languageCode]['sm_polarity_off_des'];
  get recoverRelayConfiguration =>
      _localizedValues[locale.languageCode]['recover_relay_configuration'];
  get exclusiveOn => _localizedValues[locale.languageCode]['exclusive_on'];
  get interlockSetting =>
      _localizedValues[locale.languageCode]['exclusive_on_setting'];
  get smInputMode => _localizedValues[locale.languageCode]['sm_input_mode'];
  get smPolarity => _localizedValues[locale.languageCode]['sm_polarity'];
  get recoverRelayOff =>
      _localizedValues[locale.languageCode]['recover_relay_off'];
  get recoverRelayOffDes =>
      _localizedValues[locale.languageCode]['recover_relay_off_des'];
  get recoverRelayOn =>
      _localizedValues[locale.languageCode]['recover_relay_on'];
  get recoverRelayOnDes =>
      _localizedValues[locale.languageCode]['recover_relay_on_des'];
  get switchConfiguration =>
      _localizedValues[locale.languageCode]['switch_configuration'];
  get sureToDeleteUser =>
      _localizedValues[locale.languageCode]['sure_to_delete_user'];

  get roomDefault => _localizedValues[locale.languageCode]['room_default'];
  get roomLivingRoom =>
      _localizedValues[locale.languageCode]['room_living_room'];
  get roomMasterBedroom =>
      _localizedValues[locale.languageCode]['room_master_bedroom'];
  get roomGuestBedroom =>
      _localizedValues[locale.languageCode]['room_guest_bedroom'];
  get roomDiningRoom =>
      _localizedValues[locale.languageCode]['room_dinning_room'];
  get roomKitchen => _localizedValues[locale.languageCode]['room_kitchen'];
  get roomBalcony => _localizedValues[locale.languageCode]['room_balcony'];
  get roomStudy => _localizedValues[locale.languageCode]['room_study'];
  get roomEntrance => _localizedValues[locale.languageCode]['room_entrance'];
  get roomBathroom => _localizedValues[locale.languageCode]['room_bathroom'];
  get sceneHome => _localizedValues[locale.languageCode]['scene_home'];
  get sceneLeaving => _localizedValues[locale.languageCode]['scene_leaving'];
  get sceneWakeup => _localizedValues[locale.languageCode]['scene_wakeup'];
  get sceneSleep => _localizedValues[locale.languageCode]['scene_sleep'];

  get home => _localizedValues[locale.languageCode]['home'];
  get addHome => _localizedValues[locale.languageCode]['add_home'];
  get homesEmpty => _localizedValues[locale.languageCode]['homes_empty'];
  get newHome => _localizedValues[locale.languageCode]['new_home'];
  get inputName => _localizedValues[locale.languageCode]['input_name'];
  get error => _localizedValues[locale.languageCode]['error'];
  get warning => _localizedValues[locale.languageCode]['warning'];
  get homeSetting => _localizedValues[locale.languageCode]['home_setting'];
  get rename => _localizedValues[locale.languageCode]['rename'];
  get setAsPrimaryHome =>
      _localizedValues[locale.languageCode]['set_as_primary_home'];
  get sureToDeleteHome =>
      _localizedValues[locale.languageCode]['sure_to_delete_home'];
  get transfer => _localizedValues[locale.languageCode]['transfer'];
  get deviceSetting => _localizedValues[locale.languageCode]['device_setting'];
  get chooseARoom => _localizedValues[locale.languageCode]['choose_a_room'];
  get addEndDevice => _localizedValues[locale.languageCode]['add_end_device'];
  get addEndDeviceDes =>
      _localizedValues[locale.languageCode]['add_end_device_des'];
  get complete => _localizedValues[locale.languageCode]['complete'];
  get management => _localizedValues[locale.languageCode]['management'];

  get illegalPasswordLength =>
      _localizedValues[locale.languageCode]['illegal_password_length'];
  get qqNotInstalled =>
      _localizedValues[locale.languageCode]['qq_not_installed'];
  get wechatNotInstalled =>
      _localizedValues[locale.languageCode]['wechat_not_installed'];
  get request => _localizedValues[locale.languageCode]['request'];
  get invitation => _localizedValues[locale.languageCode]['invitation'];
  get requestToJoin => _localizedValues[locale.languageCode]['request_to_join'];
  get reject => _localizedValues[locale.languageCode]['reject'];
  get approve => _localizedValues[locale.languageCode]['approve'];
  get accept => _localizedValues[locale.languageCode]['accept'];
  get requestToJoinDes =>
      _localizedValues[locale.languageCode]['request_to_join_des'];
  get inviteToJoinDes =>
      _localizedValues[locale.languageCode]['invite_to_join_des'];
  get homeCenterMessage =>
      _localizedValues[locale.languageCode]['home_center_message'];
  get newHomeCenterFound =>
      _localizedValues[locale.languageCode]['new_home_center_found'];
  get manageRooms => _localizedValues[locale.languageCode]['manage_rooms'];
  get createRoom => _localizedValues[locale.languageCode]['create_room'];
  get inputRoomName => _localizedValues[locale.languageCode]['input_room_name'];
  get alreadyExist => _localizedValues[locale.languageCode]['already_exist'];
  get configRoom => _localizedValues[locale.languageCode]['config_room'];
  get sureToDeleteRoom =>
      _localizedValues[locale.languageCode]['sure_to_delete_room'];
  get sureToDeleteAutomation =>
      _localizedValues[locale.languageCode]['sure_to_delete_automation'];
  get sureToDeleteCondition =>
      _localizedValues[locale.languageCode]['sure_to_delete_condition'];
  get sureToDeleteExecution =>
      _localizedValues[locale.languageCode]['sure_to_delete_execution'];
  get cancelAdd => _localizedValues[locale.languageCode]['cancel_add'];

  get canUpgradeTo => _localizedValues[locale.languageCode]['can_upgrade_to'];
  get currentVersion =>
      _localizedValues[locale.languageCode]['current_version'];
  get upgrading => _localizedValues[locale.languageCode]['upgrading'];
  get prepareToUpgrade =>
      _localizedValues[locale.languageCode]['prepare_to_upgrade'];
  get upgradeComplete =>
      _localizedValues[locale.languageCode]['upgrade_complete'];
  get upgradeError => _localizedValues[locale.languageCode]['upgrade_error'];
  get upgrade => _localizedValues[locale.languageCode]['upgrade'];

  get on => _localizedValues[locale.languageCode]['on'];
  get off => _localizedValues[locale.languageCode]['off'];
  get alarm => _localizedValues[locale.languageCode]['alarm'];
  get disalarm => _localizedValues[locale.languageCode]['disalarm'];
  get devicesOn => _localizedValues[locale.languageCode]['devices_on'];
  get devicesArming => _localizedValues[locale.languageCode]['devices_arming'];
  get currentTemperature =>
      _localizedValues[locale.languageCode]['current_temperature'];
  get sceneEdit => _localizedValues[locale.languageCode]['scene_edit'];
  get inputSceneNameHint =>
      _localizedValues[locale.languageCode]['input_scene_name_hint'];
  get sceneNameExist =>
      _localizedValues[locale.languageCode]['scene_name_exist'];
  get addScene => _localizedValues[locale.languageCode]['add_scene'];
  get sceneNoActions =>
      _localizedValues[locale.languageCode]['scene_no_actions'];

  get xiaoyanHomeCenter =>
      _localizedValues[locale.languageCode]['xiaoyan_home_center'];
  get deviceName => _localizedValues[locale.languageCode]['device_name'];
  get deviceType => _localizedValues[locale.languageCode]['device_type'];
  get associatedAccount =>
      _localizedValues[locale.languageCode]['associated_account'];
  get firmwareUpgrade =>
      _localizedValues[locale.languageCode]['firmware_upgrade'];
  get systemInformation =>
      _localizedValues[locale.languageCode]['system_information'];
  get ipAddress => _localizedValues[locale.languageCode]['ip_address'];
  get channel => _localizedValues[locale.languageCode]['channel'];
  get checkNewVersionDes =>
      _localizedValues[locale.languageCode]['check_new_version_des'];
  get commondSent => _localizedValues[locale.languageCode]['commond_sent'];
  get confirm => _localizedValues[locale.languageCode]['confirm'];

  get loginOtherWays =>
      _localizedValues[locale.languageCode]['login_other_ways'];
  get notBind => _localizedValues[locale.languageCode]['not_bind'];
  get binded => _localizedValues[locale.languageCode]['binded'];
  get toBeConfirmed => _localizedValues[locale.languageCode]['to_be_confirmed'];
  get toBeAuthorized =>
      _localizedValues[locale.languageCode]['to_be_authorized'];
  get toBeAuthorizedByOthers =>
      _localizedValues[locale.languageCode]['to_be_authorized_by_others'];
  get clickToBind => _localizedValues[locale.languageCode]['click_to_bind'];
  get clickToUnbind => _localizedValues[locale.languageCode]['click_to_unbind'];
  get receiveMessageByMobile =>
      _localizedValues[locale.languageCode]['receive_message_by_mobile'];
  get receiveMessageByEmail =>
      _localizedValues[locale.languageCode]['receive_message_by_email'];
  get receiveMessageByWechat =>
      _localizedValues[locale.languageCode]['receive_message_by_wechat'];
  get mobileBinded => _localizedValues[locale.languageCode]['mobile_binded'];
  get emailBinded => _localizedValues[locale.languageCode]['email_binded'];
  get wechatBinded => _localizedValues[locale.languageCode]['wechat_binded'];
  get qqBinded => _localizedValues[locale.languageCode]['qq_binded'];
  get bindMobile => _localizedValues[locale.languageCode]['bind_mobile'];
  get bindEmail => _localizedValues[locale.languageCode]['bind_email'];
  get emailSend => _localizedValues[locale.languageCode]['email_send'];
  get sureToDeleteMobile =>
      _localizedValues[locale.languageCode]['sure_to_delete_mobile'];
  get sureToDeleteEmail =>
      _localizedValues[locale.languageCode]['sure_to_delete_email'];
  get sureToDeleteWechat =>
      _localizedValues[locale.languageCode]['sure_to_delete_wechat'];
  get sureToDeleteQQ =>
      _localizedValues[locale.languageCode]['sure_to_delete_qq'];

  get setupTip => _localizedValues[locale.languageCode]['setup_tip'];
  get setupTip1 => _localizedValues[locale.languageCode]['setup_tip1'];
  get setupTip2 => _localizedValues[locale.languageCode]['setup_tip2'];
  get or => _localizedValues[locale.languageCode]['or'];
  get automaticFound =>
      _localizedValues[locale.languageCode]['automatic_found'];
  get automaticFoundDes =>
      _localizedValues[locale.languageCode]['automatic_found_des'];
  get found1 => _localizedValues[locale.languageCode]['found_1'];
  get found2 => _localizedValues[locale.languageCode]['found_2'];
  get foundNone => _localizedValues[locale.languageCode]['found_none'];
  get foundNoneDes => _localizedValues[locale.languageCode]['found_none_des'];
  get scanCode => _localizedValues[locale.languageCode]['scan_code'];
  get scanCodeDes => _localizedValues[locale.languageCode]['scan_code_des'];
  get beginScanning => _localizedValues[locale.languageCode]['begin_scanning'];
  get putCode => _localizedValues[locale.languageCode]['put_code'];

  get checkNewVersion =>
      _localizedValues[locale.languageCode]['check_new_version'];
  get aboutUsDes1 => _localizedValues[locale.languageCode]['about_us_des1'];
  get aboutUsDes2 => _localizedValues[locale.languageCode]['about_us_des2'];

  get inputOriginPassword =>
      _localizedValues[locale.languageCode]['input_origin_password'];
  get inputNewPassword =>
      _localizedValues[locale.languageCode]['input_new_password'];
  get forgetPassword =>
      _localizedValues[locale.languageCode]['forget_password'];
  get resetPassword => _localizedValues[locale.languageCode]['reset_password'];
  get resetPasswordDes1 =>
      _localizedValues[locale.languageCode]['reset_password_des1'];
  get resetPasswordDes2 =>
      _localizedValues[locale.languageCode]['reset_password_des2'];
  get getCodeByMobile =>
      _localizedValues[locale.languageCode]['get_code_by_mobile'];
  get getCodeByEmail =>
      _localizedValues[locale.languageCode]['get_code_by_email'];
  get notBindEmailAndMobile =>
      _localizedValues[locale.languageCode]['not_bind_email_and_mobile'];
  get bindNow => _localizedValues[locale.languageCode]['bind_now'];
  get mobileNotBind => _localizedValues[locale.languageCode]['mobile_not_bind'];
  get emailNotBind => _localizedValues[locale.languageCode]['email_not_bind'];
  get emailNotConfirmed =>
      _localizedValues[locale.languageCode]['email_not_confirmed'];
  get codeSend => _localizedValues[locale.languageCode]['code_send'];

  get myFamily => _localizedValues[locale.languageCode]['my_family'];
  get aboutUs => _localizedValues[locale.languageCode]['about_us'];
  get accountBinding =>
      _localizedValues[locale.languageCode]['account_binding'];
  get changePassword =>
      _localizedValues[locale.languageCode]['change_password'];
  get help => _localizedValues[locale.languageCode]['help'];
  get logOut => _localizedValues[locale.languageCode]['log_out'];
  get sureToLogOut => _localizedValues[locale.languageCode]['sure_to_log_out'];
  get out => _localizedValues[locale.languageCode]['out'];

  get firstDescription =>
      _localizedValues[locale.languageCode]['first_description'];
  get useLanAccess => _localizedValues[locale.languageCode]['use_lan_access'];
  get loginUncomplete =>
      _localizedValues[locale.languageCode]['login_uncomplete'];
  get getDataUncomplete =>
      _localizedValues[locale.languageCode]['get_data_uncomplete'];
  get login => _localizedValues[locale.languageCode]['login'];
  get register => _localizedValues[locale.languageCode]['register'];
  get mobileLogin => _localizedValues[locale.languageCode]['mobile_login'];
  get inputCode => _localizedValues[locale.languageCode]['input_code'];
  get getCode => _localizedValues[locale.languageCode]['get_code'];
  get inputMobile => _localizedValues[locale.languageCode]['input_mobile'];
  get accountLogin => _localizedValues[locale.languageCode]['account_login'];
  get sendAgain => _localizedValues[locale.languageCode]['send_again'];
  get inputEmail => _localizedValues[locale.languageCode]['input_email'];
  get inputPassword => _localizedValues[locale.languageCode]['input_password'];
  get resisterAccount =>
      _localizedValues[locale.languageCode]['register_account'];
  get emailRegisted => _localizedValues[locale.languageCode]['email_registed'];

  get addDevice => _localizedValues[locale.languageCode]['add_device'];
  get setPermitJoinFailed =>
      _localizedValues[locale.languageCode]['set_permit_join_failed'];
  get scanDevices => _localizedValues[locale.languageCode]['scan_devices'];
  get longPressButton =>
      _localizedValues[locale.languageCode]['long_press_button'];
  get newDevice1 => _localizedValues[locale.languageCode]['new_device_1'];
  get newDevice2 => _localizedValues[locale.languageCode]['new_device_2'];
  get add => _localizedValues[locale.languageCode]['add'];
  get noNewDevice => _localizedValues[locale.languageCode]['no_new_device'];
  get chooseDeviceType =>
      _localizedValues[locale.languageCode]['choose_device_type'];
  get lightSocket => _localizedValues[locale.languageCode]['light_socket'];
  get smartPlug => _localizedValues[locale.languageCode]['smart_plug'];
  get awarenessSwitch =>
      _localizedValues[locale.languageCode]['awareness_switch'];
  get doorContact => _localizedValues[locale.languageCode]['door_contact'];
  get smartCurtain => _localizedValues[locale.languageCode]['smart_curtain'];
  get wallSwitch => _localizedValues[locale.languageCode]['wall_switch'];
  get smartDial => _localizedValues[locale.languageCode]['smart_dial'];
  get switchModule => _localizedValues[locale.languageCode]['switch_module'];
  get smartDoorLock => _localizedValues[locale.languageCode]['smart_door_lock'];
  get fastName => _localizedValues[locale.languageCode]['fast_name'];
  get longPressDescription =>
      _localizedValues[locale.languageCode]['long_press_description'];
  get failed => _localizedValues[locale.languageCode]['failed'];
  get next => _localizedValues[locale.languageCode]['next'];
  get chooseCurtainType =>
      _localizedValues[locale.languageCode]['choose_curtain_type'];
  get leftCurtain => _localizedValues[locale.languageCode]['left_curtain'];
  get rightCurtain => _localizedValues[locale.languageCode]['right_curtain'];
  get doubleCurtain => _localizedValues[locale.languageCode]['double_curtain'];
  get chooseCurtainDirection =>
      _localizedValues[locale.languageCode]['choose_curtain_direction'];
  get submit => _localizedValues[locale.languageCode]['submit'];

  get bindingSetTitle1 =>
      _localizedValues[locale.languageCode]['binding_set_title_1'];
  get bindingSetTitle2 =>
      _localizedValues[locale.languageCode]['binding_set_title_2'];
  get bindingSetTitle3 =>
      _localizedValues[locale.languageCode]['binding_set_title_3'];
  get chooseDevice => _localizedValues[locale.languageCode]['choose_device'];
  get chooseAction => _localizedValues[locale.languageCode]['choose_action'];
  get chooseActionDescription =>
      _localizedValues[locale.languageCode]['choose_action_description'];
  get chooseLuminance =>
      _localizedValues[locale.languageCode]['choose_luminance'];
  get chooseLuminanceDescription =>
      _localizedValues[locale.languageCode]['choose_luminance_description'];
  get open => _localizedValues[locale.languageCode]['open'];
  get close => _localizedValues[locale.languageCode]['close'];
  get openOrClose => _localizedValues[locale.languageCode]['open_or_close'];
  get veryVeryLight => _localizedValues[locale.languageCode]['very_very_light'];
  get light => _localizedValues[locale.languageCode]['light'];
  get littleDark => _localizedValues[locale.languageCode]['little_dark'];
  get veryDark => _localizedValues[locale.languageCode]['very_dark'];
  get defined => _localizedValues[locale.languageCode]['defined'];
  get lux10000 => _localizedValues[locale.languageCode]['lux_10000'];
  get lux300 => _localizedValues[locale.languageCode]['lux_300'];
  get lux100 => _localizedValues[locale.languageCode]['lux_100'];
  get lux30 => _localizedValues[locale.languageCode]['lux_30'];
  get lux => _localizedValues[locale.languageCode]['lux'];
  get luxDefined => _localizedValues[locale.languageCode]['lux_defined'];
  get none => _localizedValues[locale.languageCode]['none'];
  get notSurpport => _localizedValues[locale.languageCode]['not_surpport'];

  get serialNumber => _localizedValues[locale.languageCode]['serial_number'];
  get version => _localizedValues[locale.languageCode]['version'];
  get rssi => _localizedValues[locale.languageCode]['rssi'];

  get changeDeviceName =>
      _localizedValues[locale.languageCode]['change_device_name'];
  get setArea => _localizedValues[locale.languageCode]['set_area'];
  get chooseArea => _localizedValues[locale.languageCode]['choose_area'];

  get sureToDeleteDevice =>
      _localizedValues[locale.languageCode]['sure_to_delete_device'];
  get sureToDeleteHomeCenter =>
      _localizedValues[locale.languageCode]['sure_to_delete_home_center'];
  get sureToDeleteScene =>
      _localizedValues[locale.languageCode]['sure_to_delete_scene'];
  get cancel => _localizedValues[locale.languageCode]['cancel'];

  get notification => _localizedValues[locale.languageCode]['notification'];
  get notificationStateChanged =>
      _localizedValues[locale.languageCode]['notification_state_changed'];
  get alarmDisalarm => _localizedValues[locale.languageCode]['alarm_disalarm'];
  get notificationOpenClosed =>
      _localizedValues[locale.languageCode]['notification_open_close'];
  get notificationSomeonePassby =>
      _localizedValues[locale.languageCode]['notification_someone_passby'];
  get timer => _localizedValues[locale.languageCode]['timer'];
  get timerDescription =>
      _localizedValues[locale.languageCode]['timer_description'];
  get countDown => _localizedValues[locale.languageCode]['count_down'];
  get countDownDescription =>
      _localizedValues[locale.languageCode]['count_down_description'];
  get keyPress => _localizedValues[locale.languageCode]['key_press'];
  get keyPressDescription =>
      _localizedValues[locale.languageCode]['key_press_description'];
  get pirPanel => _localizedValues[locale.languageCode]['pir_panel'];
  get pirPanelDescirption =>
      _localizedValues[locale.languageCode]['pir_panel_description'];
  get openClose => _localizedValues[locale.languageCode]['open_close'];
  get openCloseDescription =>
      _localizedValues[locale.languageCode]['open_close_description'];
  get rightTopButton =>
      _localizedValues[locale.languageCode]['right_top_button'];
  get rightBottomButton =>
      _localizedValues[locale.languageCode]['right_bottom_button'];
  get leftBottomButton =>
      _localizedValues[locale.languageCode]['left_bottom_button'];
  get leftTopButton => _localizedValues[locale.languageCode]['left_top_button'];
  get clickButton => _localizedValues[locale.languageCode]['click_button'];
  get doubleClickButton =>
      _localizedValues[locale.languageCode]['double_click_button'];
  get doubleClickDescription =>
      _localizedValues[locale.languageCode]['double_click_description'];
  get clickControlWindow =>
      _localizedValues[locale.languageCode]['click_control_window'];
  get clickControlWindowDescription =>
      _localizedValues[locale.languageCode]['click_control_window_description'];
  get doubleClickControlWindowDescription =>
      _localizedValues[locale.languageCode]
          ['double_click_control_window_description'];
  get clickBinding => _localizedValues[locale.languageCode]['click_binding'];

  get device => _localizedValues[locale.languageCode]['device'];
  get scene => _localizedValues[locale.languageCode]['scene'];
  get message => _localizedValues[locale.languageCode]['message'];
  get my => _localizedValues[locale.languageCode]['my'];
  get homeCenter => _localizedValues[locale.languageCode]['home_center'];
  get online => _localizedValues[locale.languageCode]['online'];
  get offline => _localizedValues[locale.languageCode]['offline'];
  get addHomeCenter => _localizedValues[locale.languageCode]['add_home_center'];
  get undefinedArea => _localizedValues[locale.languageCode]['undefined_area'];
  get lights => _localizedValues[locale.languageCode]['lights'];
  get input => _localizedValues[locale.languageCode]['input'];
  get switches => _localizedValues[locale.languageCode]['switches'];
  get binding => _localizedValues[locale.languageCode]['binding'];
  get setting => _localizedValues[locale.languageCode]['setting'];
  get delete => _localizedValues[locale.languageCode]['delete'];
  get name => _localizedValues[locale.languageCode]['name'];
  get room => _localizedValues[locale.languageCode]['room'];
  get curtainType => _localizedValues[locale.languageCode]['curtain_type'];
  get curtainDirection =>
      _localizedValues[locale.languageCode]['curtain_direction'];
  get tripAdjusted => _localizedValues[locale.languageCode]['trip_adjusted'];
  get others => _localizedValues[locale.languageCode]['others'];
  get addRoom => _localizedValues[locale.languageCode]['add_room'];
  get warn => _localizedValues[locale.languageCode]['warn'];
  get officialSiteRoot =>
      _localizedValues[locale.languageCode]['official_site_root'];
  get companyName => _localizedValues[locale.languageCode]['company_name'];
  get servicePhone => _localizedValues[locale.languageCode]['service_phone'];
  get currentHome => _localizedValues[locale.languageCode]['current_home'];
  get milliWatt => _localizedValues[locale.languageCode]['milli_watt'];
  get watt => _localizedValues[locale.languageCode]['watt'];
  get changePasswordFailed =>
      _localizedValues[locale.languageCode]['change_password_failed'];
  get badHomeKitRoomName =>
      _localizedValues[locale.languageCode]['bad_homekit_room_name'];
  get weekday0 => _localizedValues[locale.languageCode]['weekday0'];
  get weekday1 => _localizedValues[locale.languageCode]['weekday1'];
  get weekday2 => _localizedValues[locale.languageCode]['weekday2'];
  get weekday3 => _localizedValues[locale.languageCode]['weekday3'];
  get weekday4 => _localizedValues[locale.languageCode]['weekday4'];
  get weekday5 => _localizedValues[locale.languageCode]['weekday5'];
  get weekday6 => _localizedValues[locale.languageCode]['weekday6'];
  get everyday => _localizedValues[locale.languageCode]['everyday'];
  get weekend => _localizedValues[locale.languageCode]['weekends'];
  get workday => _localizedValues[locale.languageCode]['workdays'];
  get hour => _localizedValues[locale.languageCode]['hour'];
  get hourFull => _localizedValues[locale.languageCode]['hourfull'];
  get minute => _localizedValues[locale.languageCode]['minute'];
  get minuteFull => _localizedValues[locale.languageCode]['minutefull'];
  get second => _localizedValues[locale.languageCode]['second'];
  get secondFull => _localizedValues[locale.languageCode]['secondfull'];
  get time => _localizedValues[locale.languageCode]['time'];
  get iF => _localizedValues[locale.languageCode]['if'];
  get then => _localizedValues[locale.languageCode]['then'];
  get repeat => _localizedValues[locale.languageCode]['repeat'];
  get homecenterDoesntSupportAutomation1 =>
      _localizedValues[locale.languageCode]
          ['homecenter_doesnt_support_automation1'];
  get homecenterDoesntSupportAutomation2 =>
      _localizedValues[locale.languageCode]
          ['homecenter_doesnt_support_automation2'];
  get noAutomaionRules1 =>
      _localizedValues[locale.languageCode]['no_automation_rules1'];
  get noAutomaionRules2 =>
      _localizedValues[locale.languageCode]['no_automation_rules2'];
  get programmableSwitch =>
      _localizedValues[locale.languageCode]['programmable_switch'];
  get programmableSwitchEnable =>
      _localizedValues[locale.languageCode]['programmable_switch_enable'];
  get programmableSwitchDisable =>
      _localizedValues[locale.languageCode]['programmable_switch_disable'];
  get programmableSwitchEnableDes =>
      _localizedValues[locale.languageCode]['programmable_switch_enable_des'];
  get programmableSwitchDisableDes =>
      _localizedValues[locale.languageCode]['programmable_switch_disable_des'];
  get disableRelayEn =>
      _localizedValues[locale.languageCode]['disable_relay_en'];
  get disableRelayDis =>
      _localizedValues[locale.languageCode]['disable_relay_dis'];
  get disableRelayEnDes =>
      _localizedValues[locale.languageCode]['disable_relay_en_des'];
  get disableRelayDisDes =>
      _localizedValues[locale.languageCode]['disable_relay_dis_des'];
  get relayAlwaysonEn =>
      _localizedValues[locale.languageCode]['relay_alwayson_en'];
  get relayAlwaysonDis =>
      _localizedValues[locale.languageCode]['relay_alwayson_dis'];
  get relayAlwaysonEnDes =>
      _localizedValues[locale.languageCode]['relay_alwayson_en_des'];
  get relayAlwaysonDisDes =>
      _localizedValues[locale.languageCode]['relay_alwayson_dis_des'];
  get ledFeedback => _localizedValues[locale.languageCode]['led_feedback'];
  get ledFeedbackStatePos =>
      _localizedValues[locale.languageCode]['led_feedback_state_pos'];
  get ledFeedbackStateNeg =>
      _localizedValues[locale.languageCode]['led_feedback_state_neg'];
  get ledFeedbackStatePosDes =>
      _localizedValues[locale.languageCode]['led_feedback_state_pos_des'];
  get ledFeedbackStateNegDes =>
      _localizedValues[locale.languageCode]['led_feedback_state_neg_des'];
  get pleaseSelectAngle =>
      _localizedValues[locale.languageCode]['please_select_angle'];
  get badRequest => _localizedValues[locale.languageCode]['bad_request'];
  get deviceHasBeenDeleted =>
      _localizedValues[locale.languageCode]['device_has_been_deleted'];
  get loop => _localizedValues[locale.languageCode]['loop'];
  get s => _localizedValues[locale.languageCode]['s'];
  get between => _localizedValues[locale.languageCode]['between'];
  get changingChannel =>
      _localizedValues[locale.languageCode]['changing_channel'];
  get changingChannelTo =>
      _localizedValues[locale.languageCode]['changing_channel_to'];
  get changingWillTake5Minutes =>
      _localizedValues[locale.languageCode]['changing_will_take_5_minutes'];
  get keepAllDevicesPower =>
      _localizedValues[locale.languageCode]['keep_all_devices_power'];
  get keepAllDevicesPowerDevices =>
      _localizedValues[locale.languageCode]['keep_all_devices_power_devices'];
  get changeChannelMayCause =>
      _localizedValues[locale.languageCode]['change_channel_may_cause'];
  get someDeviceMayPairAgain =>
      _localizedValues[locale.languageCode]['some_device_may_pair_again'];
  get autoDetect => _localizedValues[locale.languageCode]['auto_detect'];
  get scanning => _localizedValues[locale.languageCode]['scanning'];
  get currentChannel =>
      _localizedValues[locale.languageCode]['current_channel'];
  get channelCanChangeTo =>
      _localizedValues[locale.languageCode]['channel_can_change_to'];
  get motionDetectedLeft =>
      _localizedValues[locale.languageCode]['motion_detected_left'];
  get motionDetectedRight =>
      _localizedValues[locale.languageCode]['motion_detected_right'];
  get cannotFindDevice =>
      _localizedValues[locale.languageCode]['cannot_find_device'];
  get motionDetectedFromLeftToRight => _localizedValues[locale.languageCode]
      ['motion_detected_from_left_to_right'];
  get motionDetectedFromRightToLeft => _localizedValues[locale.languageCode]
      ['motion_detected_from_right_to_left'];
  get homekitSceneIsEmpty =>
      _localizedValues[locale.languageCode]['homekit_scene_is_empty'];
  get empty => _localizedValues[locale.languageCode]['empty'];
  get currentOTAStatus =>
      _localizedValues[locale.languageCode]['current_ota_status'];
  get getUpgradePackage =>
      _localizedValues[locale.languageCode]['get_upgrade_package'];
}
