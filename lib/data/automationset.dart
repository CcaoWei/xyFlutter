part of data_shared;

class AutomationSet extends Entity {
  protobuf.AutomationSet _autoset;
  List<Automation> autoset;

  String name;
  bool get enable => this.getAttributeValue(ATTRIBUTE_ID_AUTO_ENABLED) == 1;
  protobuf.AutomationSet get innerAutoSet => _autoset;
  set enable(bool e) => this.setAttribute(ATTRIBUTE_ID_AUTO_ENABLED, e ? 1 : 0);

  AutomationSet(protobuf.AutomationSet this._autoset, String this.name) {
    autoset = new List<Automation>();
    for (var a in _autoset.set) {
      Automation newauto = new Automation(a, "");
      autoset.add(newauto);
    }
  }

  void resetAutoset() {
    _autoset.set.clear();
    for (var auto in autoset) {
      _autoset.set.add(auto.auto);
    }
  }

  void removeAutomationAt(int index) {
    _autoset.set.removeAt(index);
    autoset.removeAt(index);
  }
}
