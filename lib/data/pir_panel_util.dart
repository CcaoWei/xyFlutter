part of data_shared;

class PirPanelUtil {
  static const int OCC_LEFT_INT = (1 << 5);
  static const int OCC_LEFT_DIR = (1 << 4);
  static const int OCC_LEFT_DET = (1 << 3);
  static const int OCC_RIGHT_INT = (1 << 2);
  static const int OCC_RIGHT_DIR = (1 << 1);
  static const int OCC_RIGHT_DET = 1;

  static const int LUM_VERY_DARK = 30;
  static const int LUM_LITTLE_DARK = 100;
  static const int LUM_LIGHT = 300;
  static const int LUM_VERY_LIGHT = 6000;
  static const int LUM_VERY_VERY_LIGHT = 10000;
  static const int LUM_UPPER_LIMIT = 60000;

  static bool isLeftEvent(int occ) => (occ & OCC_LEFT_INT) != 0;

  static bool isRightEvent(int occ) => (occ & OCC_RIGHT_INT) != 0;

  static bool isLeftAlarm(int occ) => (occ & OCC_LEFT_DET) != 0;

  static bool isRightAlarm(int occ) => (occ & OCC_RIGHT_DET) != 0;

  static bool isSafe(int occ) => (!isLeftAlarm(occ) && !isRightAlarm(occ));

  static int getLuminancePercent(int luminance) {
    if (luminance < 0) {
      return 0;
    } else if (luminance < LUM_VERY_DARK) {
      return ((luminance / LUM_VERY_DARK) * 10).round();
    } else if (luminance < LUM_LITTLE_DARK) {
      return (10 + (luminance / LUM_LITTLE_DARK) * 10).round();
    } else if (luminance < LUM_LIGHT) {
      return (20 + (luminance / LUM_LIGHT) * 40).round();
    } else if (luminance < LUM_VERY_LIGHT) {
      return (60 + (luminance / LUM_VERY_LIGHT) * 20).round();
    } else if (luminance < LUMINANCE_VERY_VERY_LIGHT) {
      return (80 + (luminance / LUMINANCE_VERY_VERY_LIGHT) * 10).round();
    } else {
      return 100;
    }
  }
}
