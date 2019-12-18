part of publish_fun;

class SectionText {
  static String sectionText(
      BuildContext context, int begin, int end, String unit) {
    if (begin <= -21474836) {
      //小于
      return DefinedLocalizations.of(context).under + end.toString() + unit;
    } else if (end >= 21474836) {
      //大于
      return DefinedLocalizations.of(context).greaterThan +
          begin.toString() +
          unit;
    } else {
      return DefinedLocalizations.of(context).locate +
          begin.toString() +
          " - " +
          end.toString() +
          unit +
          DefinedLocalizations.of(context).among;
    }
  }
}
