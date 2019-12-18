part of publish_fun;

class AngularText {
  static String angularText(
      BuildContext context, int begin, int end, String unit) {
    if (begin < 0) {
      //左旋
      if (begin == -2147483648) {
        return DefinedLocalizations.of(context).greaterThan +
            end.abs().toString() +
            unit;
      } else if (end == 0) {
        return DefinedLocalizations.of(context).under +
            begin.abs().toString() +
            unit;
      } else {
        return DefinedLocalizations.of(context).locate +
            begin.abs().toString() +
            "~" +
            end.abs().toString() +
            unit +
            DefinedLocalizations.of(context).among;
      }
    } else if (begin >= 0) {
      if (begin == 0) {
        return DefinedLocalizations.of(context).under +
            end.abs().toString() +
            unit;
      } else if (begin > 0 && end > 720) {
        return DefinedLocalizations.of(context).greaterThan +
            begin.abs().toString() +
            unit;
      } else {
        return DefinedLocalizations.of(context).locate +
            begin.abs().toString() +
            "~" +
            end.abs().toString() +
            unit +
            DefinedLocalizations.of(context).among;
      }
    } else if (begin == 0 && end == 0) {
      return DefinedLocalizations.of(context).arbitrarily;
    }
    return " ";
  }
}
