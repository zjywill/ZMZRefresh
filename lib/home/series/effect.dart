import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<SeriesState> buildEffect() {
  return combineEffects(<Object, Effect<SeriesState>>{
    SeriesAction.action: _onAction,
  });
}

void _onAction(Action action, Context<SeriesState> ctx) {
}
