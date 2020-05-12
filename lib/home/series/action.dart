import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum SeriesAction { action }

class SeriesActionCreator {
  static Action onAction() {
    return const Action(SeriesAction.action);
  }
}
