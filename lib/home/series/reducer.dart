import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SeriesState> buildReducer() {
  return asReducer(
    <Object, Reducer<SeriesState>>{
      SeriesAction.action: _onAction,
    },
  );
}

SeriesState _onAction(SeriesState state, Action action) {
  final SeriesState newState = state.clone();
  return newState;
}
