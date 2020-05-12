import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<HomeScreenState> buildReducer() {
  return asReducer(
    <Object, Reducer<HomeScreenState>>{
      HomeScreenAction.refreshing: _refreshing,
      HomeScreenAction.onPopulated: _onPopulated,
    },
  );
}

HomeScreenState _onPopulated(HomeScreenState state, Action action) {
  final HomeScreenState newState = action.payload.clone();
  newState.isLoading = false;
  return newState;
}

HomeScreenState _refreshing(HomeScreenState state, Action action) {
  final HomeScreenState newState = state.clone();
  return newState;
}
