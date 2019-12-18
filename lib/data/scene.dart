part of data_shared;

const String SCENE_HOME = 'scene-000001';
const String SCENE_LEAVING = 'scene-000002';
const String SCENE_WAKEUP = 'scene-000003';
const String SCENE_SLEEP = 'scene-000004';

class Scene extends Entity {
  List<xyAction> actions;

  Scene({@required String uuid, @required String name})
      : super.initScene(
          uuid: uuid,
          name: name,
        );

  bool get isOn =>
      getAttributeValue(ATTRIBUTE_ID_ON_OFF_STATUS) == ON_OFF_STATUS_ON;

  String getSceneName(BuildContext context) {
    if (name == null || name == '') {
      if (uuid == SCENE_HOME) return DefinedLocalizations.of(context).sceneHome;
      if (uuid == SCENE_LEAVING)
        return DefinedLocalizations.of(context).sceneLeaving;
      if (uuid == SCENE_WAKEUP)
        return DefinedLocalizations.of(context).sceneWakeup;
      if (uuid == SCENE_SLEEP)
        return DefinedLocalizations.of(context).sceneSleep;
    }
    return getName();
  }

  bool get isEmpty => actions.length == 0;

  bool get isDefault =>
      uuid == SCENE_HOME ||
      uuid == SCENE_LEAVING ||
      uuid == SCENE_WAKEUP ||
      uuid == SCENE_SLEEP;
}
